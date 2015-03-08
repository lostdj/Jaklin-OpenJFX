#include <SDLCommon.h>


//
extern "C"
{


//
extern void initializeDrawableInfo(DrawableInfo *dInfo);


//
JNIEXPORT jlong JNICALL Java_com_sun_prism_es2_SDLGLDrawable_nCreateDrawable
(JNIEnv *env, jclass clazz, jlong nativeWindow, jlong nativePFInfo)
{
  unused(env);
  unused(clazz);

  DrawableInfo *dInfo = NULL;
  PixelFormatInfo *pfInfo = (PixelFormatInfo *) jlong_to_ptr(nativePFInfo);
  if (pfInfo == NULL) {
      return 0;
  }
  /* allocate the structure */
  dInfo = (DrawableInfo *) malloc(sizeof (DrawableInfo));
  if (dInfo == NULL) {
      fprintf(stderr, "nCreateDrawable: Failed in malloc\n");
      return 0;
  }

  /* initialize the structure */
  initializeDrawableInfo(dInfo);

  dInfo->win = (SDL_Window*) jlong_to_ptr(nativeWindow);
  dInfo->onScreen = JNI_TRUE;

  return ptr_to_jlong(dInfo);
}


//
JNIEXPORT jlong JNICALL Java_com_sun_prism_es2_SDLGLDrawable_nGetDummyDrawable
(JNIEnv *env, jclass clazz, jlong nativePFInfo)
{
  unused(env);
  unused(clazz);

  DrawableInfo *dInfo = NULL;
  PixelFormatInfo *pfInfo = (PixelFormatInfo *) jlong_to_ptr(nativePFInfo);
  if (pfInfo == NULL) {
      return 0;
  }

  /* allocate the structure */
  dInfo = (DrawableInfo *) malloc(sizeof (DrawableInfo));
  if (dInfo == NULL) {
      fprintf(stderr, "nGetDummyDrawable: Failed in malloc\n");
      return 0;
  }

  /* initialize the structure */
  initializeDrawableInfo(dInfo);

  // Use the dummyWin that was already created in the pfInfo
  // since this is an non-onscreen drawable.
  dInfo->win = pfInfo->dummyWin;
  dInfo->onScreen = JNI_FALSE;

  return ptr_to_jlong(dInfo);
}


//
JNIEXPORT jboolean JNICALL Java_com_sun_prism_es2_SDLGLDrawable_nSwapBuffers
(JNIEnv *env, jclass clazz, jlong nativeDInfo)
{
  unused(env);
  unused(clazz);

  DrawableInfo *dInfo = (DrawableInfo *) jlong_to_ptr(nativeDInfo);
  if (dInfo == NULL) {
      return JNI_FALSE;
  }
    // if(/*curCtxWin*/SDL_GL_GetCurrentWindow() != dInfo->win)
      // _cph_sprinte("!!!!!!!!!!!!!!.\n");
  SDL_GL_SwapWindow(dInfo->win);

  return JNI_TRUE;
}


//
} // extern "C"

