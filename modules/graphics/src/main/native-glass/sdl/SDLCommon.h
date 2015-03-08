#ifndef _h_sdl_common_h
#define _h_sdl_common_h


//
#define _myfx_sdl 1
#define _myfx_gl 1
#define _myfx_gles 0


//
#include <cph/cph.h>

#include <PrismES2Defs.h>

#include <cph/debug_print_simple.h>

#include <com_sun_glass_ui_Application.h>
// #include <com_sun_glass_ui_sdl_SDLApplication.h>
// #include <com_sun_prism_es2_SDLGLFactory.h>


//
using namespace cph;


//
extern "C" JNIEnv *mainEnv;

#define _myfx_jenvextern(extern_) \
  extern_ jclass jStringCls; \
  \
  extern_ jclass jByteBufferCls; \
  extern_ jmethodID jByteBufferArray; \
  extern_ jmethodID jByteBufferWrap; \
  \
  /*extern_ jclass jRunnableCls;*/ \
  extern_ jmethodID jRunnableRun; \
  \
  extern_ jclass jArrayListCls; \
  extern_ jmethodID jArrayListInit; \
  extern_ jmethodID jArrayListAdd; \
  extern_ jmethodID jArrayListGetIdx; \
  \
  extern_ jmethodID jPixelsAttachData; \
  \
  /*extern_ jclass jGtkPixelsCls;*/ \
  /*extern_ jmethodID jGtkPixelsInit;*/ \
  \
  extern_ jclass jScreenCls; \
  extern_ jmethodID jScreenInit; \
  extern_ jmethodID jScreenNotifySettingsChanged; \
  \
  extern_ jmethodID jViewNotifyResize; \
  extern_ jmethodID jViewNotifyMouse; \
  extern_ jmethodID jViewNotifyRepaint; \
  extern_ jmethodID jViewNotifyKey; \
  extern_ jmethodID jViewNotifyView; \
  extern_ jmethodID jViewNotifyDragEnter; \
  extern_ jmethodID jViewNotifyDragOver; \
  extern_ jmethodID jViewNotifyDragDrop; \
  extern_ jmethodID jViewNotifyDragLeave; \
  extern_ jmethodID jViewNotifyScroll; \
  extern_ jmethodID jViewNotifyInputMethod; \
  extern_ jmethodID jViewNotifyMenu; \
  extern_ jfieldID  jViewPtr; \
  \
  /*extern_ jmethodID jViewNotifyInputMethodDraw;*/ \
  /*extern_ jmethodID jViewNotifyInputMethodCaret;*/ \
  /*extern_ jmethodID jViewNotifyPreeditMode;*/ \
  \
  extern_ jmethodID jWindowNotifyResize; \
  extern_ jmethodID jWindowNotifyMove; \
  extern_ jmethodID jWindowNotifyDestroy; \
  extern_ jmethodID jWindowNotifyClose; \
  extern_ jmethodID jWindowNotifyFocus; \
  extern_ jmethodID jWindowNotifyFocusDisabled; \
  extern_ jmethodID jWindowNotifyFocusUngrab; \
  extern_ jmethodID jWindowNotifyMoveToAnotherScreen; \
  extern_ jmethodID jWindowNotifyLevelChanged; \
  extern_ jmethodID jWindowIsEnabled; \
  extern_ jmethodID jWindowNotifyDelegatePtr; \
  extern_ jmethodID jWindowClose; \
  extern_ jfieldID jWindowPtr; \
  \
  /*extern_ jmethodID jGtkWindowNotifyStateChanged;*/ \
  \
  extern_ jmethodID jSDLWindowNotifyRepaint; \
  \
  extern_ jmethodID jClipboardContentChanged; \
  \
  extern_ jfieldID jCursorPtr; \
  \
  extern_ jmethodID jSizeInit; \
  \
  extern_ jmethodID jMapGet; \
  extern_ jmethodID jMapKeySet; \
  extern_ jmethodID jMapContainsKey; \
  \
  extern_ jclass jHashSetCls; \
  extern_ jmethodID jHashSetInit; \
  \
  extern_ jmethodID jSetAdd; \
  extern_ jmethodID jSetSize; \
  extern_ jmethodID jSetToArray; \
  \
  extern_ jmethodID jIterableIterator; \
  extern_ jmethodID jIteratorHasNext; \
  extern_ jmethodID jIteratorNext; \
  \
  extern_ jclass jApplicationCls; \
  /*extern_ jfieldID jApplicationDisplay;*/ \
  /*extern_ jfieldID jApplicationScreen;*/ \
  /*extern_ jfieldID jApplicationVisualID;*/ \
  extern_ jmethodID jApplicationReportException; \
  extern_ jmethodID jApplicationGetApplication; \
  extern_ jmethodID jApplicationGetName; \
  extern_ jmethodID jApplicationNotifyWillQuit; \
  extern_ jfieldID jApplicationQuit; \
  \
  //

_myfx_jenvextern(extern)


//
bool check_and_clear_exception(JNIEnv *env);

#define LOG_EXCEPTION(env) check_and_clear_exception(env);

#define CHECK_JNI_EXCEPTION(env) \
  if(env->ExceptionCheck()) \
  { \
    check_and_clear_exception(env); \
    \
    return; \
  }

#define CHECK_JNI_EXCEPTION_RET(env, ret) \
  if (env->ExceptionCheck()) \
  { \
    check_and_clear_exception(env); \
    \
    return ret; \
  }


//
namespace
{
  char const *const mysdl_windowdata_jwindow = "jwindow";
  char const *const mysdl_windowdata_jview = "jview";

  enum mysdl_usereventcodes
  {
    mysdl_usereventcode_runnabletimercontext = 1,
    mysdl_usereventcode_invokelater,
  };
}


//
// extern volatile SDL_Window *curCtxWin;
// extern volatile SDL_GLContext curCtxGl;


//
typedef struct
{
  jobject runnable;
  SDL_TimerID tid;
} RunnableContext;


//
#define JLONG_TO_WINDOW_CTX(ptr) ((SDL_Window*)JLONG_TO_PTR(ptr))


#endif // #ifndef _h_sdl_common_h

