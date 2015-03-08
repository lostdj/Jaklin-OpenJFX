#include "SDLCommon.h"

#include <com_sun_glass_ui_Window.h>
#include <com_sun_glass_events_WindowEvent.h>
#include <com_sun_glass_events_MouseEvent.h>


//
namespace
{
  // SDL_WindowFlags glass_mask_to_sdl(jint mask)
  // {
  //   SDL_WindowFlags f = 0;

  //   if(mask & )
  // }
}


//
extern "C"
{


//
JNIEXPORT jlong JNICALL Java_com_sun_glass_ui_sdl_SDLWindow_nCreateWindow
  (JNIEnv * env, jobject obj, jlong owner, jlong screen, jint mask, jlong pf)
{
  unused(env);
  // unused(obj);
  unused(owner);
  unused(screen);
  unused(mask);

  unused(pf);
  SDL_Window *window = SDL_CreateWindow(
    "Please wait while loading",
    SDL_WINDOWPOS_UNDEFINED,
    SDL_WINDOWPOS_UNDEFINED,
    320,
    240,
    SDL_WINDOW_OPENGL | SDL_WINDOW_SHOWN | SDL_WINDOW_RESIZABLE);

  jobject jwindow = (jobject)mainEnv->NewGlobalRef(obj);
  SDL_SetWindowData(window, mysdl_windowdata_jwindow, jwindow);

  return PTR_TO_JLONG(window);

  // PixelFormatInfo *pfInfo = (PixelFormatInfo *) jlong_to_ptr(pf);
  // if (pfInfo == NULL) {
  //     return 0;
  // }

  // return PTR_TO_JLONG(pfInfo->dummyWin);
}


//
JNIEXPORT jboolean JNICALL Java_com_sun_glass_ui_sdl_SDLWindow__1close
  (JNIEnv * env, jobject obj, jlong ptr)
{
  (void)env;
  (void)obj;

  if(!ptr)
    return false;

  SDL_Window* ctx = JLONG_TO_WINDOW_CTX(ptr);

  jobject jv = (jobject)SDL_GetWindowData(ctx, mysdl_windowdata_jview);
  if(jv)
  {
    SDL_SetWindowData(ctx, mysdl_windowdata_jview, null);

    mainEnv->DeleteGlobalRef(jv);
  }

  jobject jw = (jobject)SDL_GetWindowData(ctx, mysdl_windowdata_jwindow);
  if(jw)
  {
    SDL_SetWindowData(ctx, mysdl_windowdata_jwindow, null);

    // mainEnv->SetLongField(jw, jWindowPtr, 0);
    // LOG_EXCEPTION(mainEnv);

    SDL_DestroyWindow(ctx);

    mainEnv->CallVoidMethod(jw, jWindowNotifyDestroy);
    LOG_EXCEPTION(mainEnv);

    mainEnv->DeleteGlobalRef(jw);
  }

  return JNI_TRUE;
}


//
JNIEXPORT void JNICALL Java_com_sun_glass_ui_sdl_SDLWindow_nSetView
  (JNIEnv * env, jobject obj, jlong ptr, jobject view)
{
  (void)env;
  (void)obj;

  if(!ptr || !view)
    return;

  SDL_Window* ctx = JLONG_TO_WINDOW_CTX(ptr);
  jobject jw = (jobject)SDL_GetWindowData(ctx, mysdl_windowdata_jwindow);
  if(!jw)
    return;

  if((jobject)SDL_GetWindowData(ctx, mysdl_windowdata_jview))
    // ???
    mainEnv->DeleteGlobalRef((jobject)SDL_GetWindowData(ctx, mysdl_windowdata_jview));

  view = (jobject)mainEnv->NewGlobalRef(view);
  SDL_SetWindowData(ctx, mysdl_windowdata_jview, (void*)view);
}


//
JNIEXPORT void JNICALL Java_com_sun_glass_ui_sdl_SDLWindow_nMinimize
  (JNIEnv * env, jobject obj, jlong ptr, jboolean minimize)
{
  (void)env;
  (void)obj;

  if(!ptr)
    return;

  if(!minimize)
    return;

  SDL_Window* ctx = JLONG_TO_WINDOW_CTX(ptr);
  SDL_MinimizeWindow(ctx);

  jobject jv = (jobject)SDL_GetWindowData(ctx, mysdl_windowdata_jview);
  if(jv)
    mainEnv->CallVoidMethod(jv, jViewNotifyMouse,
      com_sun_glass_events_MouseEvent_EXIT,
      com_sun_glass_events_MouseEvent_BUTTON_NONE,
      0, 0,
      0, 0,
      0,
      JNI_FALSE,
      JNI_FALSE),
    LOG_EXCEPTION(mainEnv);
}


//
JNIEXPORT void JNICALL Java_com_sun_glass_ui_sdl_SDLWindow_nMaximize
  (JNIEnv * env, jobject obj, jlong ptr, jboolean maximize, jboolean wasMaximized)
{
  (void)env;
  (void)obj;
  (void)wasMaximized;

  if(!ptr)
    return;

  if(!maximize)
    return;

  SDL_Window* ctx = JLONG_TO_WINDOW_CTX(ptr);
  SDL_MaximizeWindow(ctx);
}


//
JNIEXPORT void JNICALL Java_com_sun_glass_ui_sdl_SDLWindow_nSetBounds
  (JNIEnv * env, jobject obj, jlong ptr, jint x, jint y, jboolean xSet,
    jboolean ySet, jint w, jint h, jint cw, jint ch,
    jfloat xGravity, jfloat yGravity)
{
  (void)env;
  (void)obj;
  unused(xGravity);
  unused(yGravity);

  if(!ptr)
    return;

  SDL_Window* ctx = JLONG_TO_WINDOW_CTX(ptr);

  //
  if(xSet || ySet)
  {
    int cx = 0, cy = 0;
    SDL_GetWindowPosition(ctx, &cx, &cy);

    if(!xSet)
      x = cx;
    if(!ySet)
      y = cy;

    SDL_SetWindowPosition(ctx, x, y);

    mainEnv->CallVoidMethod(obj, jWindowNotifyMove, x, y);
    CHECK_JNI_EXCEPTION(mainEnv);
  }

  //
  if(w != -1 || h != -1 || cw != -1 || ch != -1)
  {
    int curw = 0, curh = 0;
    SDL_GetWindowPosition(ctx, &curw, &curh);

    w = w != -1 ? w : cw != -1 ? cw : curw;
    h = h != -1 ? h : ch != -1 ? ch : curh;

    SDL_SetWindowSize(ctx, w, h);

    mainEnv->CallVoidMethod(obj, jWindowNotifyResize,
      com_sun_glass_events_WindowEvent_RESIZE, w, h);
    CHECK_JNI_EXCEPTION(mainEnv);
  }
}


//
JNIEXPORT jboolean JNICALL Java_com_sun_glass_ui_sdl_SDLWindow__1setVisible
  (JNIEnv * env, jobject obj, jlong ptr, jboolean visible)
{
  (void)env;
  (void)obj;

  if(!ptr)
    return false;

  SDL_Window* ctx = JLONG_TO_WINDOW_CTX(ptr);
  if(visible)
    SDL_ShowWindow(ctx);
  else
  {
    SDL_HideWindow(ctx);

    jobject jv = (jobject)SDL_GetWindowData(ctx, mysdl_windowdata_jview);
    if(jv)
      mainEnv->CallVoidMethod(jv, jViewNotifyMouse,
        com_sun_glass_events_MouseEvent_EXIT,
        com_sun_glass_events_MouseEvent_BUTTON_NONE,
        0, 0,
        0, 0,
        0,
        JNI_FALSE,
        JNI_FALSE),
      LOG_EXCEPTION(mainEnv);
  }

  return visible;
}


//
JNIEXPORT void JNICALL Java_com_sun_glass_ui_sdl_SDLWindow_nFocus
  (JNIEnv * env, jobject obj, jlong ptr)
{
  (void)env;
  (void)obj;

  if(!ptr)
    return;

  SDL_Window* ctx = JLONG_TO_WINDOW_CTX(ptr);
  SDL_RaiseWindow(ctx);
}


//
JNIEXPORT jboolean JNICALL Java_com_sun_glass_ui_sdl_SDLWindow__1setTitle
  (JNIEnv * env, jobject obj, jlong ptr, jstring title)
{
  (void)env;
  (void)obj;

  if(!ptr)
    return false;

  SDL_Window* ctx = JLONG_TO_WINDOW_CTX(ptr);
  const char* ctitle = mainEnv->GetStringUTFChars(title, NULL);
  SDL_SetWindowTitle(ctx, ctitle);
  mainEnv->ReleaseStringUTFChars(title, ctitle);

  return JNI_TRUE;
}


//
JNIEXPORT jboolean JNICALL Java_com_sun_glass_ui_sdl_SDLWindow__1setMinimumSize
  (JNIEnv * env, jobject obj, jlong ptr, jint w, jint h)
{
  (void)env;
  (void)obj;

  if(!ptr)
    return false;

  SDL_Window* ctx = JLONG_TO_WINDOW_CTX(ptr);

  if (w < 0 || h < 0)
    return JNI_FALSE;

  // int aw = 0, ah = 0;
  // SDL_GetWindowMinimumSize(ctx, &aw, &aw);
  SDL_SetWindowMinimumSize(ctx, w, h);

  return JNI_TRUE;
}


//
JNIEXPORT jboolean JNICALL Java_com_sun_glass_ui_sdl_SDLWindow__1setMaximumSize
  (JNIEnv * env, jobject obj, jlong ptr, jint w, jint h)
{
  (void)env;
  (void)obj;

  if(!ptr)
    return false;

  SDL_Window* ctx = JLONG_TO_WINDOW_CTX(ptr);

  if (w < 0 || h < 0)
    return JNI_FALSE;

  // int aw = 0, ah = 0;
  // SDL_GetWindowMaximumSize(ctx, &aw, &aw);
  SDL_SetWindowMaximumSize(ctx, w, h);

  return JNI_TRUE;
}


//
} // extern "C"

