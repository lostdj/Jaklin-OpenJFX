package com.sun.glass.ui.sdl;

import com.sun.glass.ui.Timer;
import com.sun.javafx.runtime.MyProps;
import com.sun.javafx.tk.Toolkit;
import com.sun.javafx.tk.quantum.QuantumToolkit;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

public class SDLTimer extends Timer {
    //
    public static final boolean tick = !MyProps.mt && !MyProps.loop;


    //
    public SDLTimer(Runnable runnable) {
        super(runnable);
    }


    //
    @Override
    protected long _start(Runnable runnable) {
        throw new RuntimeException("vsync timer not supported");
    }


    //
    native long nStart(Runnable r, int period);

    @Override
    protected long _start(Runnable runnable, int period)
    {
        if(!tick)
            return nStart(runnable, period);

        if(Toolkit.getToolkit() instanceof QuantumToolkit
                && ((QuantumToolkit)Toolkit.getToolkit()).pulseTimer == this)
        {
            Lazy.pulse = this;

            return 1;
        }

        started = System.currentTimeMillis();
        Lazy.list.add(this);

        return 1;
    }


    //
    native void nStop(long ptr);

    @Override
    protected void _stop(long ptr)
    {
        if(!tick) {
            nStop(ptr);

            return;
        }

        if(Toolkit.getToolkit() instanceof QuantumToolkit
                && ((QuantumToolkit)Toolkit.getToolkit()).pulseTimer == this)
            Lazy.pulse = null;

        started = 0;
//        Lazy.list.remove(this);
    }


    //
    long started;

    static void tick()
    {
//        if(!MyProps.mt)
//            return;

        if(Lazy.pulse != null)
            // TODO: pulseRunnable.run()?
            Lazy.pulse.runnable.run();

        for(int i = 0, j = Lazy.list.size(); i < j; i++)
        {
            SDLTimer t = Lazy.list.get(i);

            if(t.started == 0 || !t.isRunning())
            {
                t.started = 0;
                Lazy.toRemove.add(t);
            }
            else if(System.currentTimeMillis() >= (t.started + t.period))
                try
                {
                    t.runnable.run();
                }
                catch (Exception ignored) {}
                finally {t.started = System.currentTimeMillis();}
        }

        if(!Lazy.toRemove.isEmpty())
        {
            Iterator<SDLTimer> i = Lazy.toRemove.iterator();

            while (i.hasNext())
            {
                SDLTimer t = i.next();
                i.remove();
                Lazy.list.remove(t);
            }
        }

//        Iterator<SDLTimer> i = Lazy.list.iterator();
//        while(i.hasNext())
//        {
//            SDLTimer t = i.next();
//            if(t.started == 0 || !t.isRunning()) {
//                t.started = 0;
//                i.remove();
//            }
//            else if(System.currentTimeMillis() >= (t.started + t.period))
//                try
//                {
//                    t.runnable.run();
//                }
//                catch (Exception ignored) {}
//                finally {t.started = System.currentTimeMillis();}
//        }
    }

    private static class Lazy
    {
        static List<SDLTimer> list;
        static ArrayList<SDLTimer> toRemove = new ArrayList<>(5);;
        static
        {
            if(!MyProps.mt)
                list = new ArrayList<>(5);
            else
                list = Collections.synchronizedList(new ArrayList<>(5));
        }

        static SDLTimer pulse;
    }
}

