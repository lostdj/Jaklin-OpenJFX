package com.sun.javafx.runtime;

public class MyProps
{
    //
    public static final boolean ems = System.getProperty("os.name").equalsIgnoreCase("Web-Emscripten");
    public static final boolean npnacl = System.getProperty("os.name").equalsIgnoreCase("Web-NaCl");
    public static final boolean pnacl = System.getProperty("os.name").equalsIgnoreCase("Web-PNaCl");
    public static final boolean nacl = npnacl || pnacl;
    public static final boolean web = ems || nacl;


    //
    public static final boolean dll = Boolean.parseBoolean(System.getProperty("myfx.dll", "false"));
    public static final String dll_path = System.getProperty("myfx.dll.path", "");


    //
    public static final String propid_glass_platform = "glass.platform";
    public static final String env_glass_platform = System.getenv("GLASS_PLATFORM");

    public static final String propid_myfx_mt = "myfx.mt";
    public static final String env_myfx_mt = System.getenv("MYFX_MT");

    public static final String propid_myfx_loop = "myfx.loop";
    public static final String env_myfxt_loop = System.getenv("MYFX_LOOP");

    static
    {
        if(System.getProperty(MyProps.propid_glass_platform) == null)
            if(MyProps.web)
                System.setProperty(MyProps.propid_glass_platform, "sdl");
            else if(MyProps.env_glass_platform != null)
                System.setProperty(MyProps.propid_glass_platform, MyProps.env_glass_platform);
            else
                System.setProperty(MyProps.propid_glass_platform, "sdl");
//                throw new RuntimeException("Can't determine '" + MyProps.propid_glass_platform + "'.");

        if(System.getProperty(propid_myfx_mt) == null)
            if(web)
                System.setProperty(propid_myfx_mt, "false");
            else if(MyProps.env_myfx_mt != null)
                System.setProperty(MyProps.propid_myfx_mt, MyProps.env_myfx_mt);
            else
                System.setProperty(MyProps.propid_myfx_mt, "false");
//                throw new RuntimeException("Can't determine '" + MyProps.propid_myfx_mt + "'.");

        if(System.getProperty(propid_myfx_loop) == null)
            if(web)
                System.setProperty(propid_myfx_loop, "false");
            else if(MyProps.env_myfxt_loop != null)
                System.setProperty(MyProps.propid_myfx_loop, MyProps.env_myfxt_loop);
            else
                System.setProperty(MyProps.propid_myfx_loop, "false");
//                throw new RuntimeException("Can't determine '" + MyProps.propid_myfx_loop + "'.");
    }


    //
    public static final boolean mt = Boolean.getBoolean(propid_myfx_mt);
    public static final boolean loop = Boolean.getBoolean(propid_myfx_loop);

    static
    {
        if(!mt)
        {
            System.setProperty("quantum.multithreaded", "false");
            System.setProperty("quantum.singlethreaded", "true");
        }
        else
        {
            System.setProperty("quantum.multithreaded", "true");
            System.setProperty("quantum.singlethreaded", "false");
        }
    }


    //
    static
    {
        //
        System.setProperty("javafx.platform", "Linux"); // Nor really useful?


        //
        System.setProperty("prism.order", "es2");
        System.setProperty("prism.noFallback", "true");


        //
        System.setProperty("prism.useFontConfig", "false");
        System.setProperty("prism.embeddedfonts", "true"); // ?


        //
//        System.setProperty("prism.dirtyopts", "false");
//        System.setProperty("prism.threadcheck", "false");
//        System.setProperty("prism.forcerepaint", "true");
//
//        System.setProperty("prism.scrollcacheopt", "false");
//        System.setProperty("prism.cacheshapes", "false");


        //
//        System.setProperty("prism.showdirty", "true");
//        System.setProperty("prism.showoverdraw", "true");
//        System.setProperty("prism.printrendergraph", "true");


        //
//        System.setProperty("javafx.debug", "true");
//        System.setProperty("javafx.verbose", "true");
//        System.setProperty("prism.verbose", "true");
//        System.setProperty("prism.trace", "true");
//        System.setProperty("prism.printStats", "1");
//        System.setProperty("prism.debugfonts", "true");
//        System.setProperty("quantum.debug", "true");
//        System.setProperty("quantum.verbose", "true");
//        System.setProperty("quantum.pulse", "true");
    }


    //
    public static void init() {}
}

