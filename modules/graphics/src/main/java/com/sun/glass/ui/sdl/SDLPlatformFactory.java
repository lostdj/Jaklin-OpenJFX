package com.sun.glass.ui.sdl;

import com.sun.glass.ui.*;
import com.sun.glass.ui.delegate.ClipboardDelegate;
import com.sun.glass.ui.delegate.MenuBarDelegate;
import com.sun.glass.ui.delegate.MenuDelegate;
import com.sun.glass.ui.delegate.MenuItemDelegate;

public class SDLPlatformFactory extends PlatformFactory
{
    @Override
    public Application createApplication()
    {
        return new SDLApplication();
    }

    @Override
    public MenuBarDelegate createMenuBarDelegate(MenuBar menubar)
    {
        return null;//return new GtkMenuBarDelegate();
    }

    @Override
    public MenuDelegate createMenuDelegate(Menu menu)
    {
        return null;//return new GtkMenuDelegate();
    }

    @Override
    public MenuItemDelegate createMenuItemDelegate(MenuItem item)
    {
        return null;//return new GtkMenuItemDelegate();
    }

    @Override
    public ClipboardDelegate createClipboardDelegate()
    {
        return null;//return new GtkClipboardDelegate();
    }
}

