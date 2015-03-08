package com.sun.glass.ui.sdl;

import com.sun.glass.events.WindowEvent;
import com.sun.glass.ui.*;
import com.sun.prism.es2.ES2Context;
import com.sun.prism.es2.ES2ResourceFactory;
import com.sun.prism.es2.SDLGLFactory;

public class SDLWindow extends Window
{
    public SDLWindow(Window owner, Screen screen, int styleMask) {
        super(owner, screen, styleMask);
    }

    public SDLWindow(long parent) {
        super(parent);
    }


    //
    native long nCreateWindow(long ownerPtr, long screenPtr, int mask, long pf);

    @Override
    protected long _createWindow(long ownerPtr, long screenPtr, int mask)
    {
        return nCreateWindow(ownerPtr, screenPtr, mask, SDLGLFactory.pf.getNativePFInfo());
    }

    @Override
    protected long _createChildWindow(long parent) {
        return 0;
    }


    //
    @Override
    protected native boolean _close(long ptr);


    //
    native void nSetView(long ptr, View view);

    @Override
    protected boolean _setView(long ptr, View view) {
        if(view == null)
            return false;

        nSetView(ptr, view);

        ((SDLView)view).notifyResize(320, 240);

        return true;
    }

    @Override
    protected boolean _setMenubar(long ptr, long menubarPtr) {
        return false;
    }


    //
    protected void notifyStateChanged(final int state) {
//        if (state == WindowEvent.MINIMIZE) {
//            _showOrHideChildren(getNativeHandle(), false);
//        } else if (state == WindowEvent.RESTORE) {
//            _showOrHideChildren(getNativeHandle(), true);
//        }
        switch (state) {
            case WindowEvent.MINIMIZE:
            case WindowEvent.MAXIMIZE:
            case WindowEvent.RESTORE:
                notifyResize(state, getWidth(), getHeight());
                break;
            default:
                System.err.println("Unknown window state: " + state);
                break;
        }
    }


    //
    @Override
    protected void notifyResize(final int type, final int width, final int height) {
        int ow = getWidth();
        int oh = getHeight();

        super.notifyResize(type, width, height);

        if(width != -1) {
            ((SDLView)getView()).notifyResize(width, height);
            if(ow != width || oh != getHeight() || type == WindowEvent.RESTORE)
                if(getView() != null)
                    ((SDLView)getView()).notifyRepaint(0, 0, width, height);
        }
    }


    //
    protected void notifyRepaint() {
        if(getView() != null)
            ((SDLView)getView()).notifyRepaint(0, 0, getWidth(), getHeight());
    }


    //
    native void nMinimize(long ptr, boolean minimize);

    @Override
    protected boolean _minimize(long ptr, boolean minimize) {
        nMinimize(ptr, minimize);
        notifyStateChanged(WindowEvent.MINIMIZE);

        return minimize;
    }


    //
    native void nMaximize(long ptr, boolean maximize, boolean wasMaximized);

    @Override
    protected boolean _maximize(long ptr, boolean maximize, boolean wasMaximized) {
        nMaximize(ptr, maximize, wasMaximized);
        notifyStateChanged(WindowEvent.MAXIMIZE);

        return maximize;
    }

    @Override
    protected int _getEmbeddedX(long ptr) {
        return 0; // Can be 0.
    }

    @Override
    protected int _getEmbeddedY(long ptr) {
        return 0; // Can be 0.
    }


    //
    native void nSetBounds(long ptr, int x, int y, boolean xSet, boolean ySet, int w, int h, int cw, int ch, float xGravity, float yGravity);

    @Override
    protected void _setBounds(long ptr, int x, int y, boolean xSet, boolean ySet, int w, int h, int cw, int ch, float xGravity, float yGravity) {
        if(xSet || ySet || w != -1 || h != -1 || cw != -1 || ch != -1)
        {
            nSetBounds(ptr, x, y, xSet, ySet, w, h, cw, ch, xGravity, yGravity);

//            w = w != -1 ? w : cw != -1 ? cw : getWidth();
//            h = h != -1 ? h : ch != -1 ? ch : getHeight();
//            notifyResize(WindowEvent.RESIZE, w, h);
        }
    }


    //
    @Override
    protected native boolean _setVisible(long ptr, boolean visible);


    //
    // Always resizable. Sorry.
    @Override
    protected boolean _setResizable(long ptr, boolean resizable) {
        return true;
    }

    public boolean setResizable(final boolean ignored) {
        return super.setResizable(true);
    }


    //
    native void nFocus(long ptr);

    @Override
    protected boolean _requestFocus(long ptr, int event) {
        if(event == WindowEvent.FOCUS_GAINED)
        {
            nFocus(ptr);
            notifyFocus(event);

            return true;
        }

        return false;
    }

    @Override
    protected void _setFocusable(long ptr, boolean isFocusable) {

    }

    @Override
    protected boolean _grabFocus(long ptr) {
        return false;
    }

    @Override
    protected void _ungrabFocus(long ptr) {

    }


    //
    @Override
    protected native boolean _setTitle(long ptr, String title);

    @Override
    protected void _setLevel(long ptr, int level) {

    }

    @Override
    protected void _setAlpha(long ptr, float alpha) {

    }

    @Override
    protected boolean _setBackground(long ptr, float r, float g, float b) {
        return false;
    }

    @Override
    protected void _setEnabled(long ptr, boolean enabled) {

    }


    //
    @Override
    protected native boolean _setMinimumSize(long ptr, int width, int height);


    //
    @Override
    protected native boolean _setMaximumSize(long ptr, int width, int height);

    @Override
    protected void _setIcon(long ptr, Pixels pixels) {

    }

    @Override
    protected void _setCursor(long ptr, Cursor cursor)
    {
        // Empty.
    }

    @Override
    protected void _toFront(long ptr) {

    }

    @Override
    protected void _toBack(long ptr) {

    }

    @Override
    protected void _enterModal(long ptr) {

    }

    @Override
    protected void _enterModalWithWindow(long dialog, long window) {

    }

    @Override
    protected void _exitModal(long ptr) {

    }

    @Override
    protected void _requestInput(long ptr, String text, int type, double width, double height, double Mxx, double Mxy, double Mxz, double Mxt, double Myx, double Myy, double Myz, double Myt, double Mzx, double Mzy, double Mzz, double Mzt) {

    }

    @Override
    protected void _releaseInput(long ptr) {

    }
}
