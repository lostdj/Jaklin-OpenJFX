#include "SDLCommon.h"


//
extern "C"
{


//
JNIEXPORT jlong JNICALL Java_com_sun_glass_ui_sdl_SDLView__1create
  (JNIEnv * env, jobject obj, jobject caps)
{
  (void)env;
  (void)obj;
  (void)caps;

  return PTR_TO_JLONG(1);
}


//
} // extern "C"

