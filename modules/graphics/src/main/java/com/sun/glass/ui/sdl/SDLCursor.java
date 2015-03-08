package com.sun.glass.ui.sdl;

import com.sun.glass.ui.Cursor;
import com.sun.glass.ui.Pixels;

public class SDLCursor extends Cursor
{
    public SDLCursor(int type) {
        super(type);
    }

    public SDLCursor(int x, int y, Pixels pixels) {
        super(x, y, pixels);
    }

    @Override
    protected long _createCursor(int x, int y, Pixels pixels) {
        return 1;
    }
}
