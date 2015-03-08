package com.sun.prism.es2;

public class SDLGLDrawable extends GLDrawable
{
    private static native long nGetDummyDrawable(long nativeCtxInfo);
    private static native long nCreateDrawable(long nativeWindow, long nativeCtxInfo);
    private static native boolean nSwapBuffers(long nativeDInfo);

    SDLGLDrawable(GLPixelFormat pixelFormat)
    {
        super(0L, pixelFormat);

        long nDInfo = nGetDummyDrawable(pixelFormat.getNativePFInfo());
        setNativeDrawableInfo(nDInfo);
    }

    SDLGLDrawable(long nativeWindow, GLPixelFormat pixelFormat) {
        super(nativeWindow, pixelFormat);

        long nDInfo = nCreateDrawable(nativeWindow, pixelFormat.getNativePFInfo());
        setNativeDrawableInfo(nDInfo);
    }

    @Override
    boolean swapBuffers(GLContext glCtx) {
        return nSwapBuffers(getNativeDrawableInfo());
    }
}

