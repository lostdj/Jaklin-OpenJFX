/*
 * Copyright (c) 2014, Oracle and/or its affiliates. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.  Oracle designates this
 * particular file as subject to the "Classpath" exception as provided
 * by Oracle in the LICENSE file that accompanied this code.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 * or visit www.oracle.com if you need additional information or have any
 * questions.
 */

package com.sun.glass.ui.monocle;

/** AcceleratedScreen provides methods necessary to instantiate and intitialize
 * a hardware-accelerated screen for rendering.
 */
public class AcceleratedScreen {

    private static long glesLibraryHandle;
    private static long eglLibraryHandle;
    private static boolean initialized = false;
    private long eglSurface;
    private long eglContext;
    private long eglDisplay;
    protected static final LinuxSystem ls = LinuxSystem.getLinuxSystem();
    private EGL egl;
    private static X xLib = X.getX();

    /** Returns a platform-specific native display handle suitable for use with
     * eglGetDisplay.
     */
    protected long platformGetNativeDisplay() {
        return 0L;
    }

    /** Returns a platform-specific native window handle suitable for use with
     * eglCreateWindowSurface.
     */
    protected long platformGetNativeWindow() {
        return 0L;
    }

    /**
     * Perform basic egl intialization - open the display, create the drawing
     * surface, and create a GL context to that drawing surface.
     * @param attributes - attributes to be used for filtering the EGL
     *                   configurations to choose from
     * @throws GLException
     * @throws UnsatisfiedLinkError
     */
    AcceleratedScreen(int[] attributes) throws GLException, UnsatisfiedLinkError {
        /*mymod*/if(!xLib.XInitThreads())
            //mymod
            throw new RuntimeException("Failed to XInitThreads().");

        egl = EGL.getEGL();
        initPlatformLibraries();

        int major[] = {0}, minor[]={0};
        long nativeDisplay = platformGetNativeDisplay();
        long nativeWindow = platformGetNativeWindow();

        if (nativeDisplay == -1l) { // error condition
            throw new GLException(0, "Could not get native display");
        }
        if (nativeWindow == -1l) { // error condition
            throw new GLException(0, "Could not get native window");
        }

        /*mymod*/xLib.XLockDisplay(nativeDisplay);

        eglDisplay =
                egl.eglGetDisplay(nativeDisplay);
        if (eglDisplay == EGL.EGL_NO_DISPLAY) {
            //mymod
            System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));
            throw new GLException(egl.eglGetError(),
                                 "Could not get EGL display");
        }
        System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));

        if (!egl.eglInitialize(eglDisplay, major, minor)) {
            //mymod
            System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));
            throw new GLException(egl.eglGetError(),
                                  "Error initializing EGL");
        }
        System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));

        //mymod: reordered.
        long eglConfigs[] = {0};
        int configCount[] = {0};
        if (!egl.eglChooseConfig(eglDisplay, attributes, eglConfigs,
                1, configCount)) {
            //mymod
            System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));
            throw new GLException(egl.eglGetError(),
                    "Error choosing EGL config");
        }
        System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));

        //mymod
        if (!egl.eglBindAPI(Boolean.getBoolean("myfx.tux.desktop") ? EGL.EGL_OPENGL_API : EGL.EGL_OPENGL_ES_API)) {
            //mymod
            System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));
            throw new GLException(egl.eglGetError(),
                                  "Error binding OPENGL API");
        }
        System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));

        eglSurface =
                egl.eglCreateWindowSurface(eglDisplay, eglConfigs[0],
                                                   nativeWindow, null);
        if (eglSurface == EGL.EGL_NO_SURFACE) {
            //mymod
            System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));
            throw new GLException(egl.eglGetError(),
                                  "Could not get EGL surface");
        }
        System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));

        int emptyAttrArray [] = {};
        eglContext = egl.eglCreateContext(eglDisplay, eglConfigs[0],
                0, emptyAttrArray);
        if (eglContext == EGL.EGL_NO_CONTEXT) {
            //mymod
            System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));
            throw new GLException(egl.eglGetError(),
                                  "Could not get EGL context");
        }
        System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));

        /*mymod*/xLib.XUnlockDisplay(nativeDisplay);
    }

    /** Make the EGL drawing surface current or not
     *
     * @param flag
     */
    public void enableRendering(boolean flag) {
        //mymod
        try {
            if (flag) {
                //mymod
                if (!egl.eglMakeCurrent(eglDisplay, eglSurface, eglSurface,
                        eglContext)) {
                    System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));
                    throw new GLException(egl.eglGetError(),
                            "Could not enable rendering");
                }
            } else {
                //mymod
                if (!egl.eglMakeCurrent(eglDisplay, 0, 0, eglContext)) {
                    System.err.println("glerr: " + Integer.toHexString(egl.eglGetError()));
                    throw new GLException(egl.eglGetError(),
                            "Could not disable rendering");
                }
            }
        }
        catch(GLException e)
        {
            System.err.println(e);
        }
    }

    /** Load any native libraries needed to instantiate and initialize the
     * native drawing surface and rendering context
     * @return success or failure
     * @throws UnsatisfiedLinkError
     */
    boolean initPlatformLibraries() throws UnsatisfiedLinkError{
        if (!initialized) {
            glesLibraryHandle = ls.dlopen("libGLESv2.so",
                    LinuxSystem.RTLD_LAZY | LinuxSystem.RTLD_GLOBAL);
            if (glesLibraryHandle == 0l) {
                throw new UnsatisfiedLinkError("Error loading libGLESv2.so");
            }
            eglLibraryHandle = ls.dlopen("libEGL.so",
                    LinuxSystem.RTLD_LAZY | LinuxSystem.RTLD_GLOBAL);
            if (eglLibraryHandle == 0l) {
                throw new UnsatisfiedLinkError("Error loading libEGL.so");
            }
            initialized = true;
        }
        return true;
    }

    /** Return the GL library handle - for use in looking up native symbols
     *
     */
    public long getGLHandle() {
        return glesLibraryHandle;
    }

    /** Return the EGL library handle - for use in looking up native symbols
     *
     */
    protected long getEGLHandle() { return eglLibraryHandle; }

    /** Copy the contents of the GL backbuffer to the screen
     *
     * @return success or failure
     */
    public boolean swapBuffers() {
        synchronized(NativeScreen.framebufferSwapLock) {
            egl.eglSwapBuffers(eglDisplay, eglSurface);
        }
        return true;
    }

}
