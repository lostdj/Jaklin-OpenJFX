#include <SDLCommon.h>


//
extern "C"
{


//
JNIEXPORT jlong JNICALL Java_com_sun_prism_es2_SDLGLFactory_nInitialize
(JNIEnv *env, jclass clazz, jintArray attrArr)
{
  unused(clazz);

  if(!attrArr)
    return 0;

  jint *attrs = env->GetIntArrayElements(attrArr, NULL);
  SDL_GL_SetAttribute(SDL_GL_RED_SIZE, attrs[RED_SIZE]);
  SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, attrs[GREEN_SIZE]);
  SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, attrs[BLUE_SIZE]);
  SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, attrs[ALPHA_SIZE]);
  SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, attrs[DEPTH_SIZE]);
  env->ReleaseIntArrayElements(attrArr, attrs, JNI_ABORT);

  //
  SDL_Window *window = SDL_CreateWindow(
    "Please wait while loading",
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    320,
    240,
    SDL_WINDOW_OPENGL /*| SDL_WINDOW_HIDDEN*/);

  if(!window)
  {
    _cph_sprinte("SDL_CreateWindow() failed: '%s'.\n", SDL_GetError());

    return 0;
  }

  //
  // TODO: Vsync.

  //
  SDL_GLContext glContext = SDL_GL_CreateContext(window);

  if(!glContext)
  {
    _cph_sprinte("SDL_GL_CreateContext() failed: '%s'.\n", SDL_GetError());

    return 0;
  }

  if(!!SDL_GL_MakeCurrent(window, glContext))
  {
    _cph_sprinte("SDL_GL_MakeCurrent() failed: '%s'.\n", SDL_GetError());

    return 0;
  }

  //

  const char *glVersion = (char*)glGetString(GL_VERSION);
  if(!glVersion)
  {
    _cph_sprinte("!glVersion: '%d'.\n", glGetError());

    return 0;
  }

  char *tmpVersionStr = strdup(glVersion);
  int versionNumbers[2];
  extractVersionInfo(tmpVersionStr, versionNumbers);
  free(tmpVersionStr);

  // _cph_sprint("---%s\n", glVersion);

  /*
   * Targeted Cards: Intel HD Graphics, Intel HD Graphics 2000/3000,
   * Radeon HD 2350, GeForce FX (with newer drivers), GeForce 7 series or higher
   *
   * Check for OpenGL 2.1 or later. 
   */
  if((versionNumbers[0] < 2) || ((versionNumbers[0] == 2) 
    && (versionNumbers[1] < 1)))
  {
    _cph_sprinte("Prism-ES2 Error : GL_VERSION (major.minor) = %d.%d.\n",
              versionNumbers[0], versionNumbers[1]);

    return 0;
  }

  //
  const char *glVendor = (char*)glGetString(GL_VENDOR);
  if(!glVendor)
      glVendor = "<UNKNOWN>";

  const char *glRenderer = (char*)glGetString(GL_RENDERER);
  if(!glRenderer)
      glRenderer = "<UNKNOWN>";

  const char *glExtensions = (char*)glGetString(GL_EXTENSIONS);
  if(!glExtensions)
  {
    _cph_sprinte("Prism-ES2 Error : glExtensions == null.\n");

    return 0;
  }

  // _cph_sprint("%s\n", glExtensions);

  // We use GL_ARB_pixel_buffer_object as an guide to
  // determine PS 3.0 capable.
  if(doifdef(_cph_os_web, 0, 1)
    && !isExtensionSupported(glExtensions, "GL_ARB_pixel_buffer_object"))
  {
    _cph_sprinte("GL profile isn't PS 3.0 capable.\n");

    SDL_GL_DeleteContext(glContext);

    return 0;
  }

  //
  ContextInfo *ctxInfo = (ContextInfo*)malloc(sizeof(ContextInfo));
  if(!ctxInfo)
  {
    _cph_sprinte("nInitialize: Failed in malloc.\n");

    return 0;
  }

  initializeCtxInfo(ctxInfo);
  ctxInfo->versionStr = strdup(glVersion);
  ctxInfo->vendorStr = strdup(glVendor);
  ctxInfo->rendererStr = strdup(glRenderer);
  ctxInfo->glExtensionStr = strdup(glExtensions);
  ctxInfo->versionNumbers[0] = versionNumbers[0];
  ctxInfo->versionNumbers[1] = versionNumbers[1];
  ctxInfo->gl2 = doifdef(_cph_os_web, JNI_FALSE, JNI_TRUE);

  //
  if(window)
  {
    SDL_Event e;
    while(SDL_PollEvent(&e)) ;
  }

  if(glContext)
    SDL_GL_DeleteContext(glContext);

  if(window)
    SDL_DestroyWindow(window);

  return ptr_to_jlong(ctxInfo);
}


// JNIEXPORT jint JNICALL Java_com_sun_prism_es2_X11GLFactory_nGetAdapterOrdinal
// (JNIEnv *env, jclass class, jlong screen) {
//     //TODO: Needs implementation to handle multi-monitors (RT-27437)
//     return 0;
// }

// /*
//  * Class:     com_sun_prism_es2_X11GLFactory
//  * Method:    nGetAdapterCount
//  * Signature: ()I
//  */
// JNIEXPORT jint JNICALL Java_com_sun_prism_es2_X11GLFactory_nGetAdapterCount
// (JNIEnv *env, jclass class) {
//     //TODO: Needs implementation to handle multi-monitors (RT-27437)
//     return 1;
// }

// /*
//  * Class:     com_sun_prism_es2_X11GLFactory
//  * Method:    nGetDefaultScreen
//  * Signature: (J)I
//  */
// JNIEXPORT jint JNICALL Java_com_sun_prism_es2_X11GLFactory_nGetDefaultScreen
// (JNIEnv *env, jclass class, jlong nativeCtxInfo) {
//     ContextInfo *ctxInfo = (ContextInfo *) jlong_to_ptr(nativeCtxInfo);
//     if (ctxInfo == NULL) {
//         return 0;
//     }
//     return (jint) ctxInfo->screen;
// }


//  * Class:     com_sun_prism_es2_X11GLFactory
//  * Method:    nGetDisplay
//  * Signature: (J)J
 
// JNIEXPORT jlong JNICALL Java_com_sun_prism_es2_X11GLFactory_nGetDisplay
// (JNIEnv *env, jclass class, jlong nativeCtxInfo) {
//     ContextInfo *ctxInfo = (ContextInfo *) jlong_to_ptr(nativeCtxInfo);
//     if (ctxInfo == NULL) {
//         return 0;
//     }
//     return (jlong) ptr_to_jlong(ctxInfo->display);
// }

// /*
//  * Class:     com_sun_prism_es2_X11GLFactory
//  * Method:    nGetVisualID
//  * Signature: (J)J
//  */
// JNIEXPORT jlong JNICALL Java_com_sun_prism_es2_X11GLFactory_nGetVisualID
// (JNIEnv *env, jclass class, jlong nativeCtxInfo) {
//     ContextInfo *ctxInfo = (ContextInfo *) jlong_to_ptr(nativeCtxInfo);
//     if (ctxInfo == NULL) {
//         return 0;
//     }
//     return (jlong) ctxInfo->visualID;
// }


//
JNIEXPORT jboolean JNICALL Java_com_sun_prism_es2_SDLGLFactory_nGetIsGL2
(JNIEnv *env, jclass clazz, jlong nativeCtxInfo)
{
  unused(env);
  unused(clazz);

  return ((ContextInfo*)jlong_to_ptr(nativeCtxInfo))->gl2 == JNI_TRUE;
}


//
} // extern "C"

