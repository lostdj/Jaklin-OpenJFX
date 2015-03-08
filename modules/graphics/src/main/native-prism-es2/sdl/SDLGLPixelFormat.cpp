#include <SDLCommon.h>


//
extern "C"
{


//
JNIEXPORT jlong JNICALL Java_com_sun_prism_es2_SDLGLPixelFormat_nCreatePixelFormat
(JNIEnv *env, jclass clazz, jlong nativeScreen, jintArray attrArr)
{
  unused(env);
  unused(clazz);
  unused(nativeScreen);
  unused(attrArr);

  //
  SDL_Window *window = SDL_CreateWindow(
    "Please wait while loading",
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    320,
    240,
    SDL_WINDOW_OPENGL | SDL_WINDOW_HIDDEN);

  if(!window)
  {
    _cph_sprinte("SDL_CreateWindow() failed: '%s'.\n", SDL_GetError());

    return 0;
  }

  if(window)
  {
    SDL_Event e;
    while(SDL_PollEvent(&e)) ;
  }

  /* allocate the structure */
  PixelFormatInfo *pfInfo = (PixelFormatInfo *) malloc(sizeof (PixelFormatInfo));
  if (pfInfo == NULL) {
      _cph_sprinte("nCreatePixelFormat: Failed in malloc\n");
      return 0;
  }

  /* initialize the structure */
  initializePixelFormatInfo(pfInfo);
  pfInfo->dummyWin = window;

  return ptr_to_jlong(pfInfo);
}


//
} // extern "C"

