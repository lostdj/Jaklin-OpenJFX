#include "SDLCommon.h"

#include <com_sun_glass_events_WindowEvent.h>
#include <com_sun_glass_events_MouseEvent.h>
#include <com_sun_glass_events_KeyEvent.h>


//
JNIEnv *mainEnv = null;

_myfx_jenvextern(/**/)


//
namespace
{
  bool terminate = false;
  bool quit = false;
}


//
jint sdl_mousebutton_to_glass(u4 sdlf)
{
  if(sdlf == SDL_BUTTON_LEFT)
    return com_sun_glass_events_MouseEvent_BUTTON_LEFT;
  elif(sdlf == SDL_BUTTON_MIDDLE)
    return com_sun_glass_events_MouseEvent_BUTTON_OTHER;
  elif(sdlf == SDL_BUTTON_RIGHT)
    return com_sun_glass_events_MouseEvent_BUTTON_RIGHT;
  else
    return com_sun_glass_events_MouseEvent_BUTTON_NONE;
}


//
jint sdl_mousemod_to_glass(u4 sdlf)
{
  // TODO: Keyboard modifiers.
  jint gf = 0;
  gf |= sdlf & SDL_BUTTON(SDL_BUTTON_LEFT)
    ? com_sun_glass_events_KeyEvent_MODIFIER_BUTTON_PRIMARY 
    : 0;
  gf |= sdlf & SDL_BUTTON(SDL_BUTTON_MIDDLE)
    ? com_sun_glass_events_KeyEvent_MODIFIER_BUTTON_MIDDLE 
    : 0;
  gf |= sdlf & SDL_BUTTON(SDL_BUTTON_RIGHT)
    ? com_sun_glass_events_KeyEvent_MODIFIER_BUTTON_SECONDARY 
    : 0;

  return gf;
}

jint sdl_mousemod_to_glass()
{
  // TODO: Global or relative?
  return sdl_mousemod_to_glass(SDL_GetMouseState(null, null));
}


//
bool check_and_clear_exception(JNIEnv *env)
{
  jthrowable t = env->ExceptionOccurred();
  if(t)
  {
    env->ExceptionClear();
    env->CallStaticVoidMethod(jApplicationCls, jApplicationReportException, t);

    return true;
  }

  return false;
}


//
extern "C"
{


//
JNIEXPORT jint JNICALL Java_com_sun_glass_ui_sdl_SDLApplication_onload
  (JNIEnv *env, jclass clazzz_, jboolean initTimer)
{
  //
  jclass clazz;

  clazz = env->FindClass("java/lang/String");
  if (env->ExceptionCheck()) return JNI_ERR;
  jStringCls = (jclass) env->NewGlobalRef(clazz);

  clazz = env->FindClass("java/nio/ByteBuffer");
  if (env->ExceptionCheck()) return JNI_ERR;
  jByteBufferCls = (jclass) env->NewGlobalRef(clazz);
  jByteBufferArray = env->GetMethodID(jByteBufferCls, "array", "()[B");
  if (env->ExceptionCheck()) return JNI_ERR;
  jByteBufferWrap = env->GetStaticMethodID(jByteBufferCls, "wrap", "([B)Ljava/nio/ByteBuffer;");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("java/lang/Runnable");
  if (env->ExceptionCheck()) return JNI_ERR;

  jRunnableRun = env->GetMethodID(clazz, "run", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("java/util/ArrayList");
  if (env->ExceptionCheck()) return JNI_ERR;
  jArrayListCls = (jclass) env->NewGlobalRef(clazz);
  jArrayListInit = env->GetMethodID(jArrayListCls, "<init>", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jArrayListAdd = env->GetMethodID(jArrayListCls, "add", "(Ljava/lang/Object;)Z");
  if (env->ExceptionCheck()) return JNI_ERR;
  jArrayListGetIdx = env->GetMethodID(jArrayListCls, "get", "(I)Ljava/lang/Object;");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("com/sun/glass/ui/Pixels");
  if (env->ExceptionCheck()) return JNI_ERR;
  jPixelsAttachData = env->GetMethodID(clazz, "attachData", "(J)V");
  if (env->ExceptionCheck()) return JNI_ERR;

  // clazz = env->FindClass("com/sun/glass/ui/gtk/GtkPixels");
  // if (env->ExceptionCheck()) return JNI_ERR;

  // jGtkPixelsCls = (jclass) env->NewGlobalRef(clazz);
  // jGtkPixelsInit = env->GetMethodID(jGtkPixelsCls, "<init>", "(IILjava/nio/ByteBuffer;)V");
  // if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("com/sun/glass/ui/Screen");
  if (env->ExceptionCheck()) return JNI_ERR;
  jScreenCls = (jclass) env->NewGlobalRef(clazz);
  jScreenInit = env->GetMethodID(jScreenCls, "<init>", "(JIIIIIIIIIIIF)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jScreenNotifySettingsChanged = env->GetStaticMethodID(jScreenCls, "notifySettingsChanged", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("com/sun/glass/ui/View");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewNotifyResize = env->GetMethodID(clazz, "notifyResize", "(II)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewNotifyMouse = env->GetMethodID(clazz, "notifyMouse", "(IIIIIIIZZ)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewNotifyRepaint = env->GetMethodID(clazz, "notifyRepaint", "(IIII)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewNotifyKey = env->GetMethodID(clazz, "notifyKey", "(II[CI)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewNotifyView = env->GetMethodID(clazz, "notifyView", "(I)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewNotifyDragEnter = env->GetMethodID(clazz, "notifyDragEnter", "(IIIII)I");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewNotifyDragOver = env->GetMethodID(clazz, "notifyDragOver", "(IIIII)I");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewNotifyDragDrop = env->GetMethodID(clazz, "notifyDragDrop", "(IIIII)I");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewNotifyDragLeave = env->GetMethodID(clazz, "notifyDragLeave", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewNotifyScroll = env->GetMethodID(clazz, "notifyScroll", "(IIIIDDIIIIIDD)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewNotifyInputMethod = env->GetMethodID(clazz, "notifyInputMethod", "(Ljava/lang/String;[I[I[BIII)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewNotifyMenu = env->GetMethodID(clazz, "notifyMenu", "(IIIIZ)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jViewPtr = env->GetFieldID(clazz, "ptr", "J");
  if (env->ExceptionCheck()) return JNI_ERR;

  // clazz = env->FindClass("com/sun/glass/ui/gtk/GtkView");
  // if (env->ExceptionCheck()) return JNI_ERR;
  // jViewNotifyInputMethodDraw = env->GetMethodID(clazz, "notifyInputMethodDraw", "(Ljava/lang/String;III[B)V");
  // if (env->ExceptionCheck()) return JNI_ERR;
  // jViewNotifyInputMethodCaret = env->GetMethodID(clazz, "notifyInputMethodCaret", "(III)V");
  // if (env->ExceptionCheck()) return JNI_ERR;
  // jViewNotifyPreeditMode = env->GetMethodID(clazz, "notifyPreeditMode", "(Z)V");
  // if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("com/sun/glass/ui/Window");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowNotifyResize = env->GetMethodID(clazz, "notifyResize", "(III)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowNotifyMove = env->GetMethodID(clazz, "notifyMove", "(II)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowNotifyDestroy = env->GetMethodID(clazz, "notifyDestroy", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowNotifyClose = env->GetMethodID(clazz, "notifyClose", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowNotifyFocus = env->GetMethodID(clazz, "notifyFocus", "(I)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowNotifyFocusDisabled = env->GetMethodID(clazz, "notifyFocusDisabled", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowNotifyFocusUngrab = env->GetMethodID(clazz, "notifyFocusUngrab", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowNotifyMoveToAnotherScreen = env->GetMethodID(clazz, "notifyMoveToAnotherScreen", "(Lcom/sun/glass/ui/Screen;)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowNotifyLevelChanged = env->GetMethodID(clazz, "notifyLevelChanged", "(I)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowIsEnabled = env->GetMethodID(clazz, "isEnabled", "()Z");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowNotifyDelegatePtr = env->GetMethodID(clazz, "notifyDelegatePtr", "(J)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowClose = env->GetMethodID(clazz, "close", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jWindowPtr = env->GetFieldID(clazz, "ptr", "J");
  if (env->ExceptionCheck()) return JNI_ERR;

  // clazz = env->FindClass("com/sun/glass/ui/gtk/GtkWindow");
  // if (env->ExceptionCheck()) return JNI_ERR;
  // jGtkWindowNotifyStateChanged =
  //         env->GetMethodID(clazz, "notifyStateChanged", "(I)V");
  // if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("com/sun/glass/ui/sdl/SDLWindow");
  if (env->ExceptionCheck()) return JNI_ERR;
  jSDLWindowNotifyRepaint = env->GetMethodID(clazz, "notifyRepaint", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("com/sun/glass/ui/Clipboard");
  if (env->ExceptionCheck()) return JNI_ERR;
  jClipboardContentChanged = env->GetMethodID(clazz, "contentChanged", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("com/sun/glass/ui/Cursor");
  if (env->ExceptionCheck()) return JNI_ERR;
  jCursorPtr = env->GetFieldID(clazz, "ptr", "J");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("com/sun/glass/ui/Size");
  if (env->ExceptionCheck()) return JNI_ERR;
  jSizeInit = env->GetMethodID(clazz, "<init>", "(II)V");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("java/util/Map");
  if (env->ExceptionCheck()) return JNI_ERR;
  jMapGet = env->GetMethodID(clazz, "get", "(Ljava/lang/Object;)Ljava/lang/Object;");
  if (env->ExceptionCheck()) return JNI_ERR;
  jMapKeySet = env->GetMethodID(clazz, "keySet", "()Ljava/util/Set;");
  if (env->ExceptionCheck()) return JNI_ERR;
  jMapContainsKey = env->GetMethodID(clazz, "containsKey", "(Ljava/lang/Object;)Z");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("java/util/HashSet");
  if (env->ExceptionCheck()) return JNI_ERR;
  jHashSetCls = (jclass) env->NewGlobalRef(clazz);
  jHashSetInit = env->GetMethodID(jHashSetCls, "<init>", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("java/util/Set");
  if (env->ExceptionCheck()) return JNI_ERR;
  jSetAdd = env->GetMethodID(clazz, "add", "(Ljava/lang/Object;)Z");
  if (env->ExceptionCheck()) return JNI_ERR;
  jSetSize = env->GetMethodID(clazz, "size", "()I");
  if (env->ExceptionCheck()) return JNI_ERR;
  jSetToArray = env->GetMethodID(clazz, "toArray", "([Ljava/lang/Object;)[Ljava/lang/Object;");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("java/lang/Iterable");
  if (env->ExceptionCheck()) return JNI_ERR;
  jIterableIterator = env->GetMethodID(clazz, "iterator", "()Ljava/util/Iterator;");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("java/util/Iterator");
  if (env->ExceptionCheck()) return JNI_ERR;
  jIteratorHasNext = env->GetMethodID(clazz, "hasNext", "()Z");
  if (env->ExceptionCheck()) return JNI_ERR;
  jIteratorNext = env->GetMethodID(clazz, "next", "()Ljava/lang/Object;");
  if (env->ExceptionCheck()) return JNI_ERR;

  clazz = env->FindClass("com/sun/glass/ui/sdl/SDLApplication");
  if (env->ExceptionCheck()) return JNI_ERR;
  jApplicationCls = (jclass) env->NewGlobalRef(clazz);
  // jApplicationDisplay = env->GetStaticFieldID(jApplicationCls, "display", "J");
  // if (env->ExceptionCheck()) return JNI_ERR;
  // jApplicationScreen = env->GetStaticFieldID(jApplicationCls, "screen", "I");
  // if (env->ExceptionCheck()) return JNI_ERR;
  // jApplicationVisualID = env->GetStaticFieldID(jApplicationCls, "visualID", "J");
  // if (env->ExceptionCheck()) return JNI_ERR;
  jApplicationReportException = env->GetStaticMethodID(
      jApplicationCls, "reportException", "(Ljava/lang/Throwable;)V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jApplicationGetApplication = env->GetStaticMethodID(
      jApplicationCls, "GetApplication", "()Lcom/sun/glass/ui/Application;");
  if (env->ExceptionCheck()) return JNI_ERR;
  jApplicationGetName = env->GetMethodID(jApplicationCls, "getName", "()Ljava/lang/String;");
  if (env->ExceptionCheck()) return JNI_ERR;
  jApplicationNotifyWillQuit = env->GetMethodID(jApplicationCls, "notifyWillQuit", "()V");
  if (env->ExceptionCheck()) return JNI_ERR;
  jApplicationQuit = env->GetFieldID(clazz, "quit", "Z");
  if (env->ExceptionCheck()) return JNI_ERR;


  //
  // if(!!SDL_Init(SDL_INIT_EVERYTHING ^ (initTimer ? 0 : SDL_INIT_TIMER)))
  if(!!SDL_Init(
      SDL_INIT_VIDEO
    | SDL_INIT_EVENTS
    | (initTimer ? SDL_INIT_TIMER : 0)))
  {
    _cph_sprinte("SDL_Init() failed: '%s'.\n", SDL_GetError());

    return JNI_ERR;
  }


  return JNI_VERSION_1_6;
}


//
JNIEXPORT void JNICALL Java_com_sun_glass_ui_sdl_SDLApplication_nInit
  (JNIEnv *env, jobject obj)
{
    (void)obj;

    mainEnv = env;

    // process_events_prev = (GdkEventFunc) handler;
    // disableGrab = (gboolean) _disableGrab;

    // gdk_event_handler_set(process_events, NULL, NULL);

    // GdkScreen *default_gdk_screen = gdk_screen_get_default();
    // if (default_gdk_screen != NULL) {
    //     g_signal_connect(G_OBJECT(default_gdk_screen), "monitors-changed",
    //                      G_CALLBACK(screen_settings_changed), NULL);
    //     g_signal_connect(G_OBJECT(default_gdk_screen), "size-changed",
    //                      G_CALLBACK(screen_settings_changed), NULL);
    // }

    // GdkWindow *root = gdk_screen_get_root_window(default_gdk_screen);
    // gdk_window_set_events(root, static_cast<GdkEventMask>(gdk_window_get_events(root) | GDK_PROPERTY_CHANGE_MASK));
}


//
JNIEXPORT void JNICALL Java_com_sun_glass_ui_sdl_SDLApplication_nTick
  (JNIEnv *env, jobject obj)
{
  unused(obj);

  #define _defwin(winid) \
    SDL_Window *w = SDL_GetWindowFromID(winid); \
    if(!w) \
    { \
      _cph_sprinte("SDL_WINDOWEVENT: !w.\n"); \
      \
      continue; \
    } \
    \
    jobject jw = (jobject)SDL_GetWindowData(w, mysdl_windowdata_jwindow); \
    if(!jw) \
    { \
      _cph_sprinte("SDL_WINDOWEVENT: !jw.\n"); \
      \
      continue; \
    } \
    elif(mainEnv->CallBooleanMethod(jw, jWindowIsEnabled) == JNI_FALSE) \
      continue; \
    \
    jobject jv = (jobject)SDL_GetWindowData(w, mysdl_windowdata_jview); \
    /**/

  // TODO: README-ios.md
  SDL_Event e;
  // while(SDL_PollEvent(&e))
  // We are using PeepEvents here instead of PollEvent so
  // we won't fall into infinite loop if the event processed here
  // (user events presumably) added another event.
  SDL_PumpEvents();
  int evcnt = SDL_EventCount();
  // int evcnt = 0;//SDL_EventCount();
  while(
      !terminate && !quit
      && evcnt-- > 0
      && SDL_PeepEvents(&e, 1, SDL_GETEVENT, SDL_FIRSTEVENT, SDL_LASTEVENT))
    switch(e.type)
    {
      //
      case SDL_APP_LOWMEMORY:
        _cph_sprinte("SDL_APP_LOWMEMORY.\n");
      case SDL_QUIT:
      {
        _cph_sprinte("SDL_QUIT.\n");

        mainEnv->CallVoidMethod(
          mainEnv->CallStaticObjectMethod(jApplicationCls, jApplicationGetApplication),
          jApplicationNotifyWillQuit);
        LOG_EXCEPTION(mainEnv);

        break;
      } // case SDL_QUIT:


      //
      case SDL_WINDOWEVENT:
      {
        _defwin(e.window.windowID);

        bool repaint = false;

        jint resizeType = 0;
        s4 ww = 0;
        s4 wh = 0;

        switch(e.window.event)
        {
          case SDL_WINDOWEVENT_MOVED:
          {
            mainEnv->CallVoidMethod(jw, jWindowNotifyMove,
              e.window.data1, e.window.data2);
            LOG_EXCEPTION(mainEnv);

            repaint = true;

            break;
            // continue;
          }

          case SDL_WINDOWEVENT_SHOWN:
          case SDL_WINDOWEVENT_EXPOSED:
          {
            repaint = true;

            resizeType = com_sun_glass_events_WindowEvent_RESTORE;
            ww = wh = -1;

            break;
          }

          case SDL_WINDOWEVENT_RESIZED:
          case SDL_WINDOWEVENT_SIZE_CHANGED:
          {
            resizeType = com_sun_glass_events_WindowEvent_RESIZE;

            break;
          }

          case SDL_WINDOWEVENT_HIDDEN:
          case SDL_WINDOWEVENT_MINIMIZED:
          {
            resizeType = com_sun_glass_events_WindowEvent_MINIMIZE;
            ww = wh = -1;

            break;
          }

          case SDL_WINDOWEVENT_MAXIMIZED:
          {
            resizeType = com_sun_glass_events_WindowEvent_MAXIMIZE;

            break;
          }

          case SDL_WINDOWEVENT_RESTORED:
          {
            resizeType = com_sun_glass_events_WindowEvent_RESTORE;
            ww = wh = -1;

            break;
          }

          case SDL_WINDOWEVENT_CLOSE:
          {
            mainEnv->CallVoidMethod(jw, jWindowNotifyClose);
            LOG_EXCEPTION(mainEnv);

            // mainEnv->CallVoidMethod(jw, jWindowClose);
            // LOG_EXCEPTION(mainEnv);

            return;
          }

          case SDL_WINDOWEVENT_ENTER:
          case SDL_WINDOWEVENT_LEAVE:
          {
            if(!jv)
              break;

            if(e.window.event == SDL_WINDOWEVENT_ENTER)
              _cph_sprinte("SDL_WINDOWEVENT_ENTER.\n");
            else
              _cph_sprinte("SDL_WINDOWEVENT_LEAVE.\n");

            jint rx, ry, gx, gy;
            SDL_GetMouseState(&rx, &ry);
            SDL_GetGlobalMouseState(&gx, &gy);

            mainEnv->CallVoidMethod(jv, jViewNotifyMouse,
              e.window.event == SDL_WINDOWEVENT_ENTER
                ? com_sun_glass_events_MouseEvent_ENTER
                : com_sun_glass_events_MouseEvent_EXIT,
              com_sun_glass_events_MouseEvent_BUTTON_NONE,
              rx, ry,
              gx, gy,
              sdl_mousemod_to_glass(),
              JNI_FALSE,
              JNI_FALSE),
            LOG_EXCEPTION(mainEnv);

            break;
          }

          case SDL_WINDOWEVENT_FOCUS_GAINED:
          {
            _cph_sprinte("SDL_WINDOWEVENT_FOCUS_GAINED.\n");

            mainEnv->CallVoidMethod(jw, jWindowNotifyFocus,
              com_sun_glass_events_WindowEvent_FOCUS_GAINED);
            LOG_EXCEPTION(mainEnv);

            // repaint = true;

            break;
          }

          case SDL_WINDOWEVENT_FOCUS_LOST:
          {
            _cph_sprinte("SDL_WINDOWEVENT_FOCUS_LOST.\n");

            mainEnv->CallVoidMethod(jw, jWindowNotifyFocus,
              com_sun_glass_events_WindowEvent_FOCUS_LOST);
            LOG_EXCEPTION(mainEnv);

            // repaint = true;

            break;
          }
        } // switch(e.window.event)


        if(resizeType)
        {
          if(ww != -1)
            ww = e.window.data1,
            wh = e.window.data2;
          else
            SDL_GetWindowSize(w, &ww, &wh);

          _cph_sprint("---%d %d.%d.\n", resizeType, ww, wh);
          mainEnv->CallVoidMethod(jw, jWindowNotifyResize, resizeType, ww, wh);
          LOG_EXCEPTION(mainEnv);
        }


        if(repaint)
        {
          mainEnv->CallVoidMethod(jw, jSDLWindowNotifyRepaint);
          LOG_EXCEPTION(mainEnv);
        }

        continue;
      } // case SDL_WINDOWEVENT:


      case SDL_MOUSEMOTION:
      {
        _defwin(e.motion.windowID);

        if(!jv)
          break;

        // This actually may be wrong, as it gets
        // the _current mouse state, not the one
        // that is represented by the event.
        jint gx, gy;
        SDL_GetGlobalMouseState(&gx, &gy);

        jint mod = sdl_mousemod_to_glass(e.motion.state);
        bool drag = mod &
        (
            com_sun_glass_events_KeyEvent_MODIFIER_BUTTON_PRIMARY
          | com_sun_glass_events_KeyEvent_MODIFIER_BUTTON_MIDDLE
          | com_sun_glass_events_KeyEvent_MODIFIER_BUTTON_SECONDARY
        );

        mainEnv->CallVoidMethod(jv, jViewNotifyMouse,
          // com_sun_glass_events_MouseEvent_MOVE,
          drag
            ? com_sun_glass_events_MouseEvent_DRAG
            : com_sun_glass_events_MouseEvent_MOVE,
          com_sun_glass_events_MouseEvent_BUTTON_NONE,
          e.motion.x, e.motion.y,
          gx, gy,
          mod,
          JNI_FALSE,
          JNI_FALSE),
        LOG_EXCEPTION(mainEnv);

        break;
      } // case SDL_MOUSEMOTION:


      case SDL_MOUSEBUTTONDOWN:
      case SDL_MOUSEBUTTONUP:
      {
        _defwin(e.button.windowID);

        if(!jv)
          break;

        // This actually may be wrong, as it gets
        // the _current_ mouse state, not the one
        // that is represented by the event.
        jint gx, gy;
        SDL_GetGlobalMouseState(&gx, &gy);

        bool press = e.button.state == SDL_PRESSED;
        jint button = sdl_mousebutton_to_glass(e.button.button);
        jint mod = sdl_mousemod_to_glass(e.motion.state);

        // _cph_sprinte("Le click: %d.\n", e.button.clicks);
        // for(int i = 0; i < e.button.clicks; i++)
          mainEnv->CallVoidMethod(jv, jViewNotifyMouse,
            press
              ? com_sun_glass_events_MouseEvent_DOWN
              : com_sun_glass_events_MouseEvent_UP,
            button,
            e.button.x, e.button.y,
            gx, gy,
            mod,
            (press && button == com_sun_glass_events_MouseEvent_BUTTON_RIGHT
              ? JNI_TRUE : JNI_FALSE),
            JNI_FALSE),
          LOG_EXCEPTION(mainEnv);

        if(press && button == com_sun_glass_events_MouseEvent_BUTTON_RIGHT)
          mainEnv->CallVoidMethod(jv, jViewNotifyMenu,
            e.button.x, e.button.y,
            gx, gy,
            JNI_FALSE),
          LOG_EXCEPTION(mainEnv);

        break;
      } // case SDL_MOUSEBUTTON:


      // TODO: SDL_MOUSEWHEEL.


      //
      case SDL_USEREVENT:
      {
        switch(e.user.code)
        {
          case mysdl_usereventcode_runnabletimercontext:
          {
            RunnableContext* context = (RunnableContext*)e.user.data1;
            mainEnv->CallVoidMethod(context->runnable, jRunnableRun, NULL);
            LOG_EXCEPTION(mainEnv);

            continue;
          }

          case mysdl_usereventcode_invokelater:
          {
            RunnableContext* context = (RunnableContext*)e.user.data1;
            mainEnv->CallVoidMethod(context->runnable, jRunnableRun, NULL);
            LOG_EXCEPTION(mainEnv);

            mainEnv->DeleteGlobalRef(context->runnable);
            context->runnable = NULL;
            free(context);

            continue;
          }
        }

        continue;
      } // case SDL_USEREVENT:
    } // switch(e.type)

  if(terminate || quit)
    terminate = quit = true,
    SDL_Quit();
  else
    doifdef(_cph_os_tasked, /**/, SDL_Delay(1));

  #undef _defwin
}


// //
// JNIEXPORT void JNICALL Java_com_sun_glass_ui_sdl_SDLApplication_nRunLoop
//   (JNIEnv *env, jobject obj, jobject launchable)
// {
//   if(launchable)
//   {
//     mainEnv->CallVoidMethod(launchable, jRunnableRun);
//     LOG_EXCEPTION(env);
//   }

//   while(!quit)
//     Java_com_sun_glass_ui_sdl_SDLApplication_nTick(env, obj);
// }


//
JNIEXPORT void JNICALL Java_com_sun_glass_ui_sdl_SDLApplication_nTerminate
  (JNIEnv *env, jobject obj)
{
  unused(env);
  unused(obj);

  terminate = true;

  mainEnv->SetBooleanField(
    mainEnv->CallStaticObjectMethod(jApplicationCls, jApplicationGetApplication),
    jApplicationQuit,
    JNI_TRUE);
  LOG_EXCEPTION(mainEnv);
}


//
JNIEXPORT jobjectArray JNICALL
Java_com_sun_glass_ui_sdl_SDLApplication_nGetScreens
(JNIEnv *env, jobject jApplication)
{
  unused(jApplication);

  SDL_DisplayMode mode = { SDL_PIXELFORMAT_UNKNOWN, 0, 0, 0, 0 };

  int display_count = 0, display_index = 0, mode_index = 0;
  if((display_count = SDL_GetNumVideoDisplays()) < 1)
  {
    _cph_sprinte("SDL_GetNumVideoDisplays() returned: %d", display_count);

    return null;
  }

  jobjectArray jscreens = mainEnv->NewObjectArray(display_count, jScreenCls, NULL);
  for(int i = 0; display_index < display_count; display_index++, i++)
  {
    if(!!SDL_GetCurrentDisplayMode(display_index, &mode))
    {
      _cph_sprinte("SDL_GetCurrentDisplayMode failed: %s", SDL_GetError());

      return null;       
    }

    // TODO: SDL_GetDisplayBounds().
    jobject jScreen = mainEnv->NewObject(jScreenCls, jScreenInit,
      (jlong)display_index,

      24,

      0,
      0,
      mode.w,
      mode.h,

      0,
      0,
      mode.w,
      mode.h,

      -1,
      -1,
      1.0f);

    mainEnv->SetObjectArrayElement(jscreens, i, jScreen);
  }

  return jscreens;
}


//
JNIEXPORT void JNICALL Java_com_sun_glass_ui_sdl_SDLApplication_nSubmitForLaterInvocation
  (JNIEnv *env, jobject obj, jobject runnable)
{
  unused(obj);

  RunnableContext* context = (RunnableContext*)malloc(sizeof(RunnableContext));
  context->runnable = mainEnv->NewGlobalRef(runnable);

  SDL_Event event;
  SDL_UserEvent userevent;

  userevent.type = SDL_USEREVENT;
  userevent.code = mysdl_usereventcode_invokelater;
  userevent.data1 = (void*)context;

  event.type = SDL_USEREVENT;
  event.user = userevent;

  SDL_PushEvent(&event);
}


//
} // extern "C"

