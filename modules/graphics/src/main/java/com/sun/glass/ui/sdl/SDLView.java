package com.sun.glass.ui.sdl;

import com.sun.glass.events.ViewEvent;
import com.sun.glass.ui.Pixels;
import com.sun.glass.ui.View;

import java.util.Map;

public class SDLView extends View
{
    @Override
    protected void _enableInputMethodEvents(long ptr, boolean enable) {

    }

    @Override
    protected native long _create(Map capabilities);

    @Override
    protected long _getNativeView(long ptr) {
        return ptr;
    }

    @Override
    public void notifyResize(int width, int height) {
        super.notifyResize(width, height);
    }

    @Override
    protected void notifyRepaint(int x, int y, int width, int height) {
        super.notifyRepaint(x, y, width, height);
    }

    @Override
    protected int _getX(long ptr) {
        return 0;
    }

    @Override
    protected int _getY(long ptr) {
        return 0;
    }

    @Override
    protected void _setParent(long ptr, long parentPtr) {

    }

    @Override
    protected boolean _close(long ptr) {
        return true;
    }

    @Override
    protected void _scheduleRepaint(long ptr) {

    }

    @Override
    protected void _begin(long ptr) {

    }

    @Override
    protected void _end(long ptr) {

    }

    @Override
    protected int _getNativeFrameBuffer(long ptr) {
        return 0;
    }

    @Override
    protected void _uploadPixels(long ptr, Pixels pixels) {

    }

    @Override
    protected boolean _enterFullscreen(long ptr, boolean animate, boolean keepRatio, boolean hideCursor) {
        return false;
    }

    @Override
    protected void _exitFullscreen(long ptr, boolean animate) {

    }
}
