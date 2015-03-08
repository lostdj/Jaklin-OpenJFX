#include "SDLCommon.h"


//
extern "C"
{


//
static u4 call_runnable_in_timer(u4 interval, void *data)
{
  RunnableContext* context = (RunnableContext*)data;
  if(!context->runnable)
  {
    // SDL_RemoveTimer(context->tid);
    free(context);

    return 0;
  }
  elif(context->runnable)
  {
    SDL_Event event;
    SDL_UserEvent userevent;

    userevent.type = SDL_USEREVENT;
    userevent.code = mysdl_usereventcode_runnabletimercontext;
    userevent.data1 = (void*)context;

    event.type = SDL_USEREVENT;
    event.user = userevent;

    SDL_PushEvent(&event);
  }

  return interval;
}


//
JNIEXPORT jlong JNICALL Java_com_sun_glass_ui_sdl_SDLTimer_nStart
  (JNIEnv * env, jobject obj, jobject runnable, jint period)
{
  (void)obj;

  RunnableContext* context = (RunnableContext*) malloc(sizeof(RunnableContext));
  context->runnable = env->NewGlobalRef(runnable);
  context->tid = SDL_AddTimer(period, call_runnable_in_timer, (void*)context);

  return PTR_TO_JLONG(context);
}


//
JNIEXPORT void JNICALL Java_com_sun_glass_ui_sdl_SDLTimer_nStop
  (JNIEnv * env, jobject obj, jlong ptr)
{
  (void)obj;

  RunnableContext* context = (RunnableContext*) JLONG_TO_PTR(ptr);
  jobject r = context->runnable;
  context->runnable = null;
  env->DeleteGlobalRef(r);
}


//
} // extern "C"

