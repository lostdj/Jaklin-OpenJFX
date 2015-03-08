package com.sun.prism.es2;

import java.util.HashMap;

public class SDLGLFactory extends GLFactory
{
    // Entries must be in lowercase and null string is a wild card.
//    GLGPUInfo preQualificationFilter[] = null;
    private GLGPUInfo preQualificationFilter[] =
        null;
//    {
//        new GLGPUInfo("advanced micro devices", null),
//        new GLGPUInfo("ati", null),
//        new GLGPUInfo("intel open source technology center", null),
//        new GLGPUInfo("nvidia", null),
//        new GLGPUInfo("nouveau", null),
//        new GLGPUInfo("x.org", null)
//    };

    GLGPUInfo blackList[] = {};

    static native long nInitialize(int[] attrArr);
    static native boolean nGetIsGL2(long nativeCtxInfo);

    @Override
    GLGPUInfo[] getPreQualificationFilter()
    {
        return preQualificationFilter;
    }

    @Override
    GLGPUInfo[] getBlackList()
    {
        return blackList;
    }

    @Override
    GLContext createGLContext(long nativeCtxInfo)
    {
        return new SDLGLContext(nativeCtxInfo);
    }

    @Override
    GLContext createGLContext(GLDrawable drawable, GLPixelFormat pixelFormat, GLContext shareCtx, boolean vSyncRequest)
    {
        return new SDLGLContext(drawable, pixelFormat, shareCtx, vSyncRequest);
    }

    @Override
    GLDrawable createGLDrawable(long nativeWindow, GLPixelFormat pixelFormat)
    {
        return new SDLGLDrawable(nativeWindow, pixelFormat);
    }

    @Override
    GLDrawable createDummyGLDrawable(GLPixelFormat pixelFormat)
    {
        return new SDLGLDrawable(pixelFormat);
    }


    //
    public static GLPixelFormat pf;

    @Override
    GLPixelFormat createGLPixelFormat(long nativeScreen, GLPixelFormat.Attributes attrs)
    {
        return pf = new SDLGLPixelFormat(nativeScreen, attrs);
    }

    @Override
    boolean initialize(Class psClass, GLPixelFormat.Attributes attrs)
    {
        int attrArr[] = new int[GLPixelFormat.Attributes.NUM_ITEMS];

        attrArr[GLPixelFormat.Attributes.RED_SIZE] = attrs.getRedSize();
        attrArr[GLPixelFormat.Attributes.GREEN_SIZE] = attrs.getGreenSize();
        attrArr[GLPixelFormat.Attributes.BLUE_SIZE] = attrs.getBlueSize();
        attrArr[GLPixelFormat.Attributes.ALPHA_SIZE] = attrs.getAlphaSize();
        attrArr[GLPixelFormat.Attributes.DEPTH_SIZE] = attrs.getDepthSize();
        attrArr[GLPixelFormat.Attributes.DOUBLEBUFFER] = attrs.isDoubleBuffer() ? 1 : 0;
        attrArr[GLPixelFormat.Attributes.ONSCREEN] = attrs.isOnScreen() ? 1 : 0;

        nativeCtxInfo = nInitialize(attrArr);

        if(nativeCtxInfo == 0)
            return false;
        else
        {
            gl2 = nGetIsGL2(nativeCtxInfo);

            return true;
        }
    }

    @Override
    int getAdapterCount()
    {
        return 1;
    }

    @Override
    int getAdapterOrdinal(long nativeScreen)
    {
        return 0;
    }

    @Override
    void updateDeviceDetails(HashMap deviceDetails)
    {

    }
}

