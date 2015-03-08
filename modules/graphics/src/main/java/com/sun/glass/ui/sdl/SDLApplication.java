package com.sun.glass.ui.sdl;

import com.sun.glass.ui.*;
import com.sun.javafx.runtime.MyProps;
import com.sun.javafx.tk.Toolkit;
import com.sun.javafx.tk.quantum.QuantumToolkit;

import java.io.File;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import java.security.AccessController;
import java.security.PrivilegedAction;
import java.util.concurrent.CountDownLatch;

public class SDLApplication extends Application implements InvokeLaterDispatcher.InvokeLaterSubmitter
{
    //
    static native int onload(boolean initTimer);
    static
    {
        if(onload(!SDLTimer.tick) == -1)
            throw new RuntimeException("Failed to init SDLApp.");

        AccessController.doPrivileged(
            (PrivilegedAction<Void>) () ->
            {
                Application.loadNativeLibrary();
                return null;
            });
    }


    //
    static native void nInit();

    void init()
    {
        nInit();
    }


    //
    boolean quit;

    native void nTick();

    @Override
    public void tick()
    {
        if(quit)
            return;

        nTick();

        if(SDLTimer.tick)
            SDLTimer.tick();
    }

//    native void nRunLoop(final Runnable launchable);

    @Override
    protected void runLoop(Runnable launchable)
    {
//        // Embedded in SWT, with shared event thread
//        final boolean isEventThread = AccessController
//                .doPrivileged((PrivilegedAction<Boolean>) () -> Boolean.getBoolean("javafx.embed.isEventThread"));
//
//        if (isEventThread) {
//            init();
//            setEventThread(Thread.currentThread());
//            launchable.run();
//            return;
//        }
//
//        final boolean noErrorTrap = AccessController
//                .doPrivileged((PrivilegedAction<Boolean>) () -> Boolean.getBoolean("glass.noErrorTrap"));

        Runnable r =
        () ->
        {
            cginit();
            init();

            launchable.run();

            if(MyProps.loop)
                while(!quit)
                    tick();
        };

        if(MyProps.mt)
        {
            final Thread toolkitThread = AccessController.doPrivileged((PrivilegedAction<Thread>)
                () -> new Thread(r, "SDLNativeMainLoopThread"));
            setEventThread(toolkitThread);
            toolkitThread.start();
        }
        else
        {
            setEventThread(Thread.currentThread());
            r.run();
        }
    }


    //
    native void nTerminate();

    @Override
    protected void finishTerminating() {
        final Thread toolkitThread = getEventThread();
        if (toolkitThread != null) {
            nTerminate();
            setEventThread(null);
        }
        super.finishTerminating();
    }


    @Override
    protected void _invokeAndWait(Runnable runnable)
    {
        if(Toolkit.getToolkit().isFxUserThread() || QuantumToolkit.singleThreaded)
            runnable.run();
        else {
            final CountDownLatch latch = new CountDownLatch(1);
            submitForLaterInvocation(() -> {
                if (runnable != null) runnable.run();
                latch.countDown();
            });
            try {
                latch.await();
            } catch (InterruptedException e) {
                //FAIL SILENTLY
            }
        }
    }

    @Override
    protected void _invokeLater(Runnable runnable)
    {
        submitForLaterInvocation(runnable);
    }

    @Override
    protected Object _enterNestedEventLoop()
    {
        return null; // Can be null.
    }

    @Override
    protected void _leaveNestedEventLoop(Object retValue)
    {
        // Empty.
    }

    @Override
    public Window createWindow(Window owner, Screen screen, int styleMask)
    {
        return new SDLWindow(owner, screen, styleMask);
    }

    @Override
    public Window createWindow(long parent)
    {
        return new SDLWindow(parent);
    }

    @Override
    public View createView()
    {
        return new SDLView();
    }

    @Override
    public Cursor createCursor(int type)
    {
        return new SDLCursor(type);
    }

    @Override
    public Cursor createCursor(int x, int y, Pixels pixels)
    {
        return new SDLCursor(x, y, pixels);
    }

    @Override
    protected void staticCursor_setVisible(boolean visible)
    {
        // Empty.
    }

    @Override
    protected Size staticCursor_getBestSize(int width, int height)
    {
        return null; // Can be null.
    }

    @Override
    public Pixels createPixels(int width, int height, ByteBuffer data)
    {
        return null; // TODO:
    }

    @Override
    public Pixels createPixels(int width, int height, IntBuffer data)
    {
        return null; // TODO:
    }

    @Override
    public Pixels createPixels(int width, int height, IntBuffer data, float scale)
    {
        return null; // TODO:
    }

    @Override
    protected int staticPixels_getNativeFormat()
    {
        return 0; // Can be 0.
    }

    @Override
    public Robot createRobot()
    {
        return null; // Tests.
    }

    @Override
    protected double staticScreen_getVideoRefreshPeriod()
    {
        return 0; //TODO:
    }


    //
    static native Screen[] nGetScreens();

    @Override
    protected Screen[] staticScreen_getScreens()
    {
        return nGetScreens();
    }

    @Override
    public Timer createTimer(Runnable runnable)
    {
        return new SDLTimer(runnable);
    }

    @Override
    protected int staticTimer_getMinPeriod()
    {
        return 0;
    }

    @Override
    protected int staticTimer_getMaxPeriod()
    {
        return 100000000;
    }

    @Override
    protected CommonDialogs.FileChooserResult staticCommonDialogs_showFileChooser(Window owner, String folder, String filename, String title, int type, boolean multipleMode, CommonDialogs.ExtensionFilter[] extensionFilters, int defaultFilterIndex)
    {
        return null;
    }

    @Override
    protected File staticCommonDialogs_showFolderChooser(Window owner, String folder, String title)
    {
        return null; // Can be null.
    }

    @Override
    protected long staticView_getMultiClickTime()
    {
        return 500; // TODO:
    }

    @Override
    protected int staticView_getMultiClickMaxX()
    {
        return 20; // TODO:
    }

    @Override
    protected int staticView_getMultiClickMaxY()
    {
        return 20; // TODO:
    }

    @Override
    protected boolean _supportsTransparentWindows()
    {
        return false;
    }

    @Override
    protected boolean _supportsUnifiedWindows()
    {
        return false;
    }

    @Override
    protected int _getKeyCodeForChar(char c)
    {
        return 0; // TODO:
    }


    //
    native void nSubmitForLaterInvocation(Runnable r);

    @Override
    public void submitForLaterInvocation(Runnable r)
    {
        nSubmitForLaterInvocation(r);
    }
}

