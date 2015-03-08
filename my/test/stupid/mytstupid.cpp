#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <avian/machine.h>

#include <myavn/embeddedres.h>
#include <myavn/jni-args.h>

#include <myjdkjni.gen.inc.cpp>
extern void *myjdkjarres;

#include <myfxjni.gen.inc.cpp>
extern void *myfxjarres;

namespace myfxt_stupid_helloworld
{
	#include <myfxt_stupid/helloworld/mymain.h>
}
myavn::embeddedres myfxtstupidhelloworld(sizeof(myfxt_stupid_helloworld::helloworldarr), myfxt_stupid_helloworld::helloworldarr);

#include <cph/java.h>
using namespace cph;

#if _cph_os_ems
  #include <emscripten/emscripten.h>
#endif

jni::JavaVM* _jvm;
jni::JNIEnv* _env;

const char *const Application_ = "javafx/application/Application";
jni::jclass Application;
jni::jmethodID Application_tick;

// const char *const class_ = "mymain";
// const char *const class_ = "modena/ModenaMain";
// const char *const class_ = "brickbreaker/BrickMain";
const char *const class_ = "ensemble/EnsembleMain";
jni::jclass c;
jni::jmethodID m;

static bool init = false;
static bool err = false;

void tick()
{
  if(likely(init))
  {
    _env->CallStaticVoidMethod(Application, Application_tick);

    if(unlikely(_env->ExceptionCheck()))
      init = false,
      err = true,
      _cph_sprinte("----------------------------------------\n"),
      _env->ExceptionDescribe();
  }
  else
  {
    if(!err && !_env->ExceptionCheck())
    {
      jni::jmethodID m = _env->GetStaticMethodID(c, "main", "([Ljava/lang/String;)V");
      if(!_env->ExceptionCheck())
      {
        jni::jclass stringClass = _env->FindClass("java/lang/String");
        if(!_env->ExceptionCheck())
        {
          jni::jobjectArray a = _env->NewObjectArray(0, stringClass, 0);
          if(!_env->ExceptionCheck())
          {
  //           for(int i = 0; i < argc; ++i)
  //           {
  //             _env->SetObjectArrayElement(a, i, _env->NewStringUTF("the arg"));
  // //            _env->SetObjectArrayElement(a, i, _env->NewStringUTF(argv[i]));
  //           }

            _env->CallStaticVoidMethod(c, m, a);

            if(!_env->ExceptionCheck())
              init = true;
            else
            {
              _cph_sprinte("----------------------------------------\n");
              err = true;
              _env->ExceptionDescribe();
            }
          }
        }
      }
    }
  }
}

// extern "C" int64_t currentTimeMillis(vm::Thread* t, vm::object, uintptr_t*)
// {
// 	return t->m->system->now();
// }

int main(int argc, const char** argv)
{
  unused(argv);

	jni::JavaVMInitArgs vmArgs;
	vmArgs.version = JNI_VERSION_1_2;
	vmArgs.nOptions = 1;
	vmArgs.ignoreUnrecognized = JNI_TRUE;

	argc = 0;

	void *appcp = reinterpret_cast<void*>(&myfxtstupidhelloworld);

	jni::JavaVMOption opts[] =
	{
		//
		{
			.optionString = reinterpret_cast<char*>(&myavn::jniarg::meths),
			.extraInfo = reinterpret_cast<void*>(myavn::meth::myjdkjni::methlib),
		},
		{
			.optionString = reinterpret_cast<char*>(&myavn::jniarg::bootcp),
			.extraInfo = reinterpret_cast<void*>(myjdkjarres),
		},

		//
		{
			.optionString = reinterpret_cast<char*>(&myavn::jniarg::meths),
			.extraInfo = reinterpret_cast<void*>(myavn::meth::myfxjni::methlib),
		},
		{
			.optionString = reinterpret_cast<char*>(&myavn::jniarg::appcp),
			.extraInfo = reinterpret_cast<void*>(myfxjarres),
		},

		//
		{
			.optionString = reinterpret_cast<char*>(&myavn::jniarg::appcp),
			.extraInfo = appcp,
		},
	};
	vmArgs.options = opts;
	vmArgs.nOptions = sizeof(opts) / sizeof(jni::JavaVMOption);

  void* env;
  jni::JNI_CreateJavaVM(&_jvm, &env, &vmArgs);
  _env = static_cast<jni::JNIEnv*>(env);

  // if(!_env->ExceptionCheck())
  // {
  //   jni::jclass System = _env->FindClass("java/lang/System");
  //   jni::jmethodID setProperty = env->GetStaticMethodID(System, "setProperty",
  //     "(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;");

  //   #define setprop(key, val) \
  //     { \
  //       jni::jstring pkey = env->NewStringUTF((key)); \
  //       jni::jstring pval = env->NewStringUTF((val)); \
  //       \
  //       _env->CallStaticObjectMethod(System, setProperty, \
  //         pkey, pval); \
  //       \
  //       if(_env->ExceptionCheck()) \
  //         _env->ExceptionDescribe(); \
  //     }

  //     setprop("javafx.platform", "Linux"); // Not really useful?

  //     setprop("myfx.mt", "false");
  //     // setprop("myfx.mt", "true");

  //     setprop("myfx.loop", "false");
  //     // setprop("myfx.loop", "true");

  //     setprop("quantum.multithreaded", "false");
  //     setprop("quantum.singlethreaded", "true");
      
  //     setprop("glass.platform", "sdl");

  //     #undef setprop
  // }

  if(!_env->ExceptionCheck())
    Application = _env->FindClass(Application_);

  if(!_env->ExceptionCheck())
    Application_tick = _env->GetStaticMethodID(Application, "tick", "()Z");

	if(!_env->ExceptionCheck())
		c = _env->FindClass(class_);

  #if !_cph_os_ems
    if(!_env->ExceptionCheck())
    {
      jni::jmethodID m = _env->GetStaticMethodID(c, "main", "([Ljava/lang/String;)V");
      if(!_env->ExceptionCheck())
      {
        jni::jclass stringClass = _env->FindClass("java/lang/String");
        if(!_env->ExceptionCheck())
        {
          jni::jobjectArray a = _env->NewObjectArray(argc, stringClass, 0);
          if(!_env->ExceptionCheck())
          {
            for(int i = 0; i < argc; ++i)
            {
              _env->SetObjectArrayElement(a, i, _env->NewStringUTF("the arg"));
  //            _env->SetObjectArrayElement(a, i, _env->NewStringUTF(argv[i]));
            }

            _env->CallStaticVoidMethod(c, m, a);
          }
        }
      }
    }

  	int exitCode = 0;
  	if(_env->ExceptionCheck())
  	{
  		exitCode = -1;
  		_env->ExceptionDescribe();
  	}

  	_jvm->DestroyJavaVM();

  	return exitCode;
  #else
  //   if(!_env->ExceptionCheck())
  //   {
  //     jni::jmethodID m = _env->GetStaticMethodID(c, "main", "([Ljava/lang/String;)V");
  //     if(!_env->ExceptionCheck())
  //     {
  //       jni::jclass stringClass = _env->FindClass("java/lang/String");
  //       if(!_env->ExceptionCheck())
  //       {
  //         jni::jobjectArray a = _env->NewObjectArray(0, stringClass, 0);
  //         if(!_env->ExceptionCheck())
  //         {
  // //           for(int i = 0; i < argc; ++i)
  // //           {
  // //             _env->SetObjectArrayElement(a, i, _env->NewStringUTF("the arg"));
  // // //            _env->SetObjectArrayElement(a, i, _env->NewStringUTF(argv[i]));
  // //           }

  //           _env->CallStaticVoidMethod(c, m, a);

  //           if(!_env->ExceptionCheck())
  //             init = true;
  //           else
  //           {
  //             _cph_sprinte("----------------------------------------\n");
  //             err = true;
  //             _env->ExceptionDescribe();
  //           }
  //         }
  //       }
  //     }
  //   }

    // if(/*init && */!_env->ExceptionCheck())
    //   m = _env->GetStaticMethodID(c, "tick", "()V");

    int exitCode = 0;
    if(/*!init || */_env->ExceptionCheck())
    {
      exitCode = -1;
      _env->ExceptionDescribe();

      _jvm->DestroyJavaVM();
    }
    else
      emscripten_set_main_loop(tick, 0, true);

    return exitCode;
  #endif
}

