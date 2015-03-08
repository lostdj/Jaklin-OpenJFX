#include <SDLCommon.h>


//
//
// volatile SDL_Window *curCtxWin = null;
// volatile SDL_GLContext curCtxGl = null;


//
extern "C"
{


//
extern void glActiveTexture(GLenum texture);
extern void glAttachShader(GLuint program, GLuint shader);
extern void glBindAttribLocation(GLuint program, GLuint index, const GLchar *name);
extern void glBindFramebuffer(GLenum target, GLuint framebuffer);
extern void glBindRenderbuffer(GLenum target, GLuint renderbuffer);
extern GLenum glCheckFramebufferStatus(GLenum target);
extern GLuint glCreateProgram(void);
extern GLuint glCreateShader(GLenum type);
extern void glCompileShader(GLuint shader);
extern void glDeleteBuffers(GLsizei n, const GLuint *buffers);
extern void glDeleteFramebuffers(GLsizei n, const GLuint *framebuffers);
extern void glDeleteProgram(GLuint program);
extern void glDeleteRenderbuffers(GLsizei n, const GLuint *renderbuffers);
extern void glDeleteShader(GLuint shader);
extern void glDetachShader(GLuint program, GLuint shader);
extern void glDisableVertexAttribArray(GLuint index);
extern void glEnableVertexAttribArray(GLuint index);
extern void glFramebufferRenderbuffer(GLenum target, GLenum attachment, GLenum renderbuffertarget, GLuint renderbuffer);
extern void glFramebufferTexture2D(GLenum target, GLenum attachment, GLenum textarget, GLuint texture, GLint level);
extern void glGenFramebuffers(GLsizei n, GLuint *framebuffers);
extern void glGenRenderbuffers(GLsizei n, GLuint *renderbuffers);
extern void glGetProgramiv(GLuint program, GLenum pname, GLint *params);
extern void glGetShaderiv(GLuint shader, GLenum pname, GLint *params);
extern GLint glGetUniformLocation(GLuint program, const GLchar *name);
extern void glLinkProgram(GLuint program);
extern void glRenderbufferStorage(GLenum target, GLenum internalformat, GLsizei width, GLsizei height);
extern void glShaderSource(GLuint shader, GLsizei count, const GLchar* const *string, const GLint *length);
extern void glUniform1f(GLint location, GLfloat v0);
extern void glUniform2f(GLint location, GLfloat v0, GLfloat v1);
extern void glUniform3f(GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
extern void glUniform4f(GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
extern void glUniform4fv(GLint location, GLsizei count, const GLfloat *value);
extern void glUniform1i(GLint location, GLint v0);
extern void glUniform2i(GLint location, GLint v0, GLint v1);
extern void glUniform3i(GLint location, GLint v0, GLint v1, GLint v2);
extern void glUniform4i(GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
extern void glUniform4iv(GLint location, GLsizei count, const GLint *value);
extern void glUniformMatrix4fv(GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
extern void glUseProgram(GLuint program);
extern void glValidateProgram(GLuint program);
extern void glVertexAttribPointer(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid *pointer);
extern void glGenBuffers(GLsizei n, GLuint *buffers);
extern void glBindBuffer(GLenum target, GLuint buffer);
extern void glBufferData(GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage);
extern void glBufferSubData(GLenum target, GLintptr offset, GLsizeiptr size, const GLvoid *data);
extern void glGetShaderInfoLog(GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
extern void glGetProgramInfoLog(GLuint program, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
// extern void glTexImage2DMultisample(GLenum target, GLsizei samples, doifdef(_cph_os_ems, GLenum, GLint) internalformat, GLsizei width, GLsizei height, GLboolean fixedsamplelocations); // N/a in ems. Not used.
// extern void glRenderbufferStorageMultisample(GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height); // N/a in ems. Used: 1) ifndef IS_EGL 2) if ext GL_ARB_multisample avail use msaa.
// extern void glBlitFramebuffer(GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter); // ???

JNIEXPORT jlong JNICALL Java_com_sun_prism_es2_SDLGLContext_nInitialize
(JNIEnv *env, jclass clazz, jlong nativeDInfo, jlong nativePFInfo,
        jlong nativeshareCtxHandle, jboolean vSyncRequested)
{
  unused(env);
  unused(clazz);

  ContextInfo *ctxInfo = NULL;
  DrawableInfo *dInfo = (DrawableInfo *) jlong_to_ptr(nativeDInfo);
  PixelFormatInfo *pfInfo = (PixelFormatInfo *) jlong_to_ptr(nativePFInfo);

  if ((dInfo == NULL) || (pfInfo == NULL)) {
      return 0;
  }

  SDL_Window *win = dInfo->win;

  SDL_GLContext ctx = SDL_GL_CreateContext(win);
  if(!ctx)
  {
    _cph_sprinte("SDL_GL_CreateContext() failed: '%s'.\n", SDL_GetError());

    return 0;
  }

  if(!!SDL_GL_MakeCurrent(win, ctx))
  {
    _cph_sprinte("SDL_GL_MakeCurrent() failed: '%s'.\n", SDL_GetError());

    return 0;
  }
  // else
  // {
  //   curCtxWin = win;
  //   curCtxGl = ctx;
  // }

  const char *glVersion;
  const char *glVendor;
  const char *glRenderer;
  char *tmpVersionStr;
  int versionNumbers[2];
  const char *glExtensions;

  /* Get the OpenGL version */
  glVersion = (char *) glGetString(GL_VERSION);
  if (glVersion == NULL) {
      SDL_GL_DeleteContext(ctx);
      fprintf(stderr, "glVersion == null");
      return 0;
  }

  /* find out the version, major and minor version number */
  tmpVersionStr = strdup(glVersion);
  extractVersionInfo(tmpVersionStr, versionNumbers);
  free(tmpVersionStr);

/*
    fprintf(stderr, "GL_VERSION string = %s\n", glVersion);
    fprintf(stderr, "GL_VERSION (major.minor) = %d.%d\n",
            versionNumbers[0], versionNumbers[1]);
*/

  /*
   * Targeted Cards: Intel HD Graphics, Intel HD Graphics 2000/3000,
   * Radeon HD 2350, GeForce FX (with newer drivers), GeForce 7 series or higher
   *
   * Check for OpenGL 2.1 or later. 
   */
  if ((versionNumbers[0] < 2) || ((versionNumbers[0] == 2) && (versionNumbers[1] < 1))) {
      SDL_GL_DeleteContext(ctx);
      fprintf(stderr, "Prism-ES2 Error : GL_VERSION (major.minor) = %d.%d\n",
              versionNumbers[0], versionNumbers[1]);
      return 0;
  }

  /* Get the OpenGL vendor and renderer */
  glVendor = (const char *) glGetString(GL_VENDOR);
  if (glVendor == NULL) {
      glVendor = "<UNKNOWN>";
  }
  glRenderer = (const char *) glGetString(GL_RENDERER);
  if (glRenderer == NULL) {
      glRenderer = "<UNKNOWN>";
  }

  glExtensions = (const char *) glGetString(GL_EXTENSIONS);
  if (glExtensions == NULL) {
      SDL_GL_DeleteContext(ctx);
      fprintf(stderr, "glExtensions == null");
      return 0;
  }

  // We use GL_ARB_pixel_buffer_object as an guide to
  // determine PS 3.0 capable.
  if(doifdef(_cph_os_web, 0, 1)
    && !isExtensionSupported(glExtensions, "GL_ARB_pixel_buffer_object"))
  {
      SDL_GL_DeleteContext(ctx);
      fprintf(stderr, "GL profile isn't PS 3.0 capable");
      return 0;
  }

  /*
      fprintf(stderr, "glExtensions: %s\n", glExtensions);
      fprintf(stderr, "glxExtensions: %s\n", glxExtensions);
   */

  /* allocate the structure */
  ctxInfo = (ContextInfo *) malloc(sizeof (ContextInfo));
  if (ctxInfo == NULL) {
      fprintf(stderr, "nInitialize: Failed in malloc\n");
      return 0;
  }

  /* initialize the structure */
  initializeCtxInfo(ctxInfo);
  ctxInfo->versionStr = strdup(glVersion);
  ctxInfo->vendorStr = strdup(glVendor);
  ctxInfo->rendererStr = strdup(glRenderer);
  ctxInfo->glExtensionStr = strdup(glExtensions);
  ctxInfo->versionNumbers[0] = versionNumbers[0];
  ctxInfo->versionNumbers[1] = versionNumbers[1];
  ctxInfo->context = ctx;

  /* set function pointers */
  //mymod
  ctxInfo->glActiveTexture = &glActiveTexture;
  ctxInfo->glAttachShader = &glAttachShader;
  ctxInfo->glBindAttribLocation = &glBindAttribLocation;
  ctxInfo->glBindFramebuffer = &glBindFramebuffer;
  ctxInfo->glBindRenderbuffer = &glBindRenderbuffer;
  ctxInfo->glCheckFramebufferStatus = &glCheckFramebufferStatus;
  ctxInfo->glCreateProgram = &glCreateProgram;
  ctxInfo->glCreateShader = &glCreateShader;
  ctxInfo->glCompileShader = &glCompileShader;
  ctxInfo->glDeleteBuffers = &glDeleteBuffers;
  ctxInfo->glDeleteFramebuffers = &glDeleteFramebuffers;
  ctxInfo->glDeleteProgram = &glDeleteProgram;
  ctxInfo->glDeleteRenderbuffers = &glDeleteRenderbuffers;
  ctxInfo->glDeleteShader = &glDeleteShader;
  ctxInfo->glDetachShader = &glDetachShader;
  ctxInfo->glDisableVertexAttribArray = &glDisableVertexAttribArray;
  ctxInfo->glEnableVertexAttribArray = &glEnableVertexAttribArray;
  ctxInfo->glFramebufferRenderbuffer = &glFramebufferRenderbuffer;
  ctxInfo->glFramebufferTexture2D = &glFramebufferTexture2D;
  ctxInfo->glGenFramebuffers = &glGenFramebuffers;
  ctxInfo->glGenRenderbuffers = &glGenRenderbuffers;
  ctxInfo->glGetProgramiv = &glGetProgramiv;
  ctxInfo->glGetShaderiv = &glGetShaderiv;
  ctxInfo->glGetUniformLocation = &glGetUniformLocation;
  ctxInfo->glLinkProgram = &glLinkProgram;
  ctxInfo->glRenderbufferStorage = &glRenderbufferStorage;
  ctxInfo->glShaderSource = &glShaderSource;
  ctxInfo->glUniform1f = &glUniform1f;
  ctxInfo->glUniform2f = &glUniform2f;
  ctxInfo->glUniform3f = &glUniform3f;
  ctxInfo->glUniform4f = &glUniform4f;
  ctxInfo->glUniform4fv = &glUniform4fv;
  ctxInfo->glUniform1i = &glUniform1i;
  ctxInfo->glUniform2i = &glUniform2i;
  ctxInfo->glUniform3i = &glUniform3i;
  ctxInfo->glUniform4i = &glUniform4i;
  ctxInfo->glUniform4iv = &glUniform4iv;
  ctxInfo->glUniformMatrix4fv = &glUniformMatrix4fv;
  ctxInfo->glUseProgram = &glUseProgram;
  ctxInfo->glValidateProgram = &glValidateProgram;
  ctxInfo->glVertexAttribPointer = &glVertexAttribPointer;
  ctxInfo->glGenBuffers = &glGenBuffers;
  ctxInfo->glBindBuffer = &glBindBuffer;
  ctxInfo->glBufferData = &glBufferData;
  ctxInfo->glBufferSubData = &glBufferSubData;
  ctxInfo->glGetShaderInfoLog = &glGetShaderInfoLog;
  ctxInfo->glGetProgramInfoLog = &glGetProgramInfoLog;
  // ctxInfo->glTexImage2DMultisample = &glTexImage2DMultisample;
  // ctxInfo->glRenderbufferStorageMultisample = &glRenderbufferStorageMultisample;
  // ctxInfo->glBlitFramebuffer = &glBlitFramebuffer;


  // ctxInfo->glActiveTexture = (PFNGLACTIVETEXTUREPROC)
  //         SDL_GL_GetProcAddress("glActiveTexture");
  // ctxInfo->glAttachShader = (PFNGLATTACHSHADERPROC)
  //         SDL_GL_GetProcAddress("glAttachShader");
  // ctxInfo->glBindAttribLocation = (PFNGLBINDATTRIBLOCATIONPROC)
  //         SDL_GL_GetProcAddress("glBindAttribLocation");
  // ctxInfo->glBindFramebuffer = (PFNGLBINDFRAMEBUFFERPROC)
  //         SDL_GL_GetProcAddress("glBindFramebuffer");
  // ctxInfo->glBindRenderbuffer = (PFNGLBINDRENDERBUFFERPROC)
  //         SDL_GL_GetProcAddress("glBindRenderbuffer");
  // ctxInfo->glCheckFramebufferStatus = (PFNGLCHECKFRAMEBUFFERSTATUSPROC)
  //         SDL_GL_GetProcAddress("glCheckFramebufferStatus");
  // ctxInfo->glCreateProgram = (PFNGLCREATEPROGRAMPROC)
  //         SDL_GL_GetProcAddress("glCreateProgram");
  // ctxInfo->glCreateShader = (PFNGLCREATESHADERPROC)
  //         SDL_GL_GetProcAddress("glCreateShader");
  // ctxInfo->glCompileShader = (PFNGLCOMPILESHADERPROC)
  //         SDL_GL_GetProcAddress("glCompileShader");
  // ctxInfo->glDeleteBuffers = (PFNGLDELETEBUFFERSPROC)
  //         SDL_GL_GetProcAddress("glDeleteBuffers");
  // ctxInfo->glDeleteFramebuffers = (PFNGLDELETEFRAMEBUFFERSPROC)
  //         SDL_GL_GetProcAddress("glDeleteFramebuffers");
  // ctxInfo->glDeleteProgram = (PFNGLDELETEPROGRAMPROC)
  //         SDL_GL_GetProcAddress("glDeleteProgram");
  // ctxInfo->glDeleteRenderbuffers = (PFNGLDELETERENDERBUFFERSPROC)
  //         SDL_GL_GetProcAddress("glDeleteRenderbuffers");
  // ctxInfo->glDeleteShader = (PFNGLDELETESHADERPROC)
  //         SDL_GL_GetProcAddress("glDeleteShader");
  // ctxInfo->glDetachShader = (PFNGLDETACHSHADERPROC)
  //         SDL_GL_GetProcAddress("glDetachShader");
  // ctxInfo->glDisableVertexAttribArray = (PFNGLDISABLEVERTEXATTRIBARRAYPROC)
  //         SDL_GL_GetProcAddress("glDisableVertexAttribArray");
  // ctxInfo->glEnableVertexAttribArray = (PFNGLENABLEVERTEXATTRIBARRAYPROC)
  //         SDL_GL_GetProcAddress("glEnableVertexAttribArray");
  // ctxInfo->glFramebufferRenderbuffer = (PFNGLFRAMEBUFFERRENDERBUFFERPROC)
  //         SDL_GL_GetProcAddress("glFramebufferRenderbuffer");
  // ctxInfo->glFramebufferTexture2D = (PFNGLFRAMEBUFFERTEXTURE2DPROC)
  //         SDL_GL_GetProcAddress("glFramebufferTexture2D");
  // ctxInfo->glGenFramebuffers = (PFNGLGENFRAMEBUFFERSPROC)
  //         SDL_GL_GetProcAddress("glGenFramebuffers");
  // ctxInfo->glGenRenderbuffers = (PFNGLGENRENDERBUFFERSPROC)
  //         SDL_GL_GetProcAddress("glGenRenderbuffers");
  // ctxInfo->glGetProgramiv = (PFNGLGETPROGRAMIVPROC)
  //         SDL_GL_GetProcAddress("glGetProgramiv");
  // ctxInfo->glGetShaderiv = (PFNGLGETSHADERIVPROC)
  //         SDL_GL_GetProcAddress("glGetShaderiv");
  // ctxInfo->glGetUniformLocation = (PFNGLGETUNIFORMLOCATIONPROC)
  //         SDL_GL_GetProcAddress("glGetUniformLocation");
  // ctxInfo->glLinkProgram = (PFNGLLINKPROGRAMPROC)
  //         SDL_GL_GetProcAddress("glLinkProgram");
  // ctxInfo->glRenderbufferStorage = (PFNGLRENDERBUFFERSTORAGEPROC)
  //         SDL_GL_GetProcAddress("glRenderbufferStorage");
  // ctxInfo->glShaderSource = (PFNGLSHADERSOURCEPROC)
  //         SDL_GL_GetProcAddress("glShaderSource");
  // ctxInfo->glUniform1f = (PFNGLUNIFORM1FPROC)
  //         SDL_GL_GetProcAddress("glUniform1f");
  // ctxInfo->glUniform2f = (PFNGLUNIFORM2FPROC)
  //         SDL_GL_GetProcAddress("glUniform2f");
  // ctxInfo->glUniform3f = (PFNGLUNIFORM3FPROC)
  //         SDL_GL_GetProcAddress("glUniform3f");
  // ctxInfo->glUniform4f = (PFNGLUNIFORM4FPROC)
  //         SDL_GL_GetProcAddress("glUniform4f");
  // ctxInfo->glUniform4fv = (PFNGLUNIFORM4FVPROC)
  //         SDL_GL_GetProcAddress("glUniform4fv");
  // ctxInfo->glUniform1i = (PFNGLUNIFORM1IPROC)
  //         SDL_GL_GetProcAddress("glUniform1i");
  // ctxInfo->glUniform2i = (PFNGLUNIFORM2IPROC)
  //         SDL_GL_GetProcAddress("glUniform2i");
  // ctxInfo->glUniform3i = (PFNGLUNIFORM3IPROC)
  //         SDL_GL_GetProcAddress("glUniform3i");
  // ctxInfo->glUniform4i = (PFNGLUNIFORM4IPROC)
  //         SDL_GL_GetProcAddress("glUniform4i");
  // ctxInfo->glUniform4iv = (PFNGLUNIFORM4IVPROC)
  //         SDL_GL_GetProcAddress("glUniform4iv");
  // ctxInfo->glUniformMatrix4fv = (PFNGLUNIFORMMATRIX4FVPROC)
  //         SDL_GL_GetProcAddress("glUniformMatrix4fv");
  // ctxInfo->glUseProgram = (PFNGLUSEPROGRAMPROC)
  //         SDL_GL_GetProcAddress("glUseProgram");
  // ctxInfo->glValidateProgram = (PFNGLVALIDATEPROGRAMPROC)
  //         SDL_GL_GetProcAddress("glValidateProgram");
  // ctxInfo->glVertexAttribPointer = (PFNGLVERTEXATTRIBPOINTERPROC)
  //         SDL_GL_GetProcAddress("glVertexAttribPointer");
  // ctxInfo->glGenBuffers = (PFNGLGENBUFFERSPROC)
  //         SDL_GL_GetProcAddress("glGenBuffers");
  // ctxInfo->glBindBuffer = (PFNGLBINDBUFFERPROC)
  //         SDL_GL_GetProcAddress("glBindBuffer");
  // ctxInfo->glBufferData = (PFNGLBUFFERDATAPROC)
  //         SDL_GL_GetProcAddress("glBufferData");
  // ctxInfo->glBufferSubData = (PFNGLBUFFERSUBDATAPROC)
  //         SDL_GL_GetProcAddress("glBufferSubData");
  // ctxInfo->glGetShaderInfoLog = (PFNGLGETSHADERINFOLOGPROC)
  //         SDL_GL_GetProcAddress("glGetShaderInfoLog");
  // ctxInfo->glGetProgramInfoLog = (PFNGLGETPROGRAMINFOLOGPROC)
  //         SDL_GL_GetProcAddress("glGetProgramInfoLog");
  // ctxInfo->glTexImage2DMultisample = (PFNGLTEXIMAGE2DMULTISAMPLEPROC)
  //         SDL_GL_GetProcAddress("glTexImage2DMultisample");
  // ctxInfo->glRenderbufferStorageMultisample = (PFNGLRENDERBUFFERSTORAGEMULTISAMPLEPROC)
  //         SDL_GL_GetProcAddress("glRenderbufferStorageMultisample");
  // ctxInfo->glBlitFramebuffer = (PFNGLBLITFRAMEBUFFERPROC)
  //         SDL_GL_GetProcAddress("glBlitFramebuffer");

  // initialize platform states and properties to match
  // cached states and properties
  if(!!SDL_GL_SetSwapInterval(0))
  {
    _cph_sprinte("SDL_GL_SetSwapInterval() failed: '%s'.\n", SDL_GetError());

    return 0;
  }
  ctxInfo->state.vSyncEnabled = JNI_FALSE;
  ctxInfo->vSyncRequested = vSyncRequested;

  initState(ctxInfo);

  // Release context once we are all done
  // glXMakeCurrent(display, None, NULL);

  return ptr_to_jlong(ctxInfo);
}


//
JNIEXPORT jlong JNICALL Java_com_sun_prism_es2_SDLGLContext_nGetNativeHandle
(JNIEnv *env, jclass clazz, jlong nativeCtxInfo)
{
  unused(env);
  unused(clazz);

    ContextInfo *ctxInfo = (ContextInfo *) jlong_to_ptr(nativeCtxInfo);
    if (ctxInfo == NULL) {
        return 0;
    }

    return ptr_to_jlong(ctxInfo->context);
}


//
JNIEXPORT void JNICALL Java_com_sun_prism_es2_SDLGLContext_nMakeCurrent
(JNIEnv *env, jclass clazz, jlong nativeCtxInfo, jlong nativeDInfo)
{
  unused(env);
  unused(clazz);

  ContextInfo *ctxInfo = (ContextInfo *) jlong_to_ptr(nativeCtxInfo);
  DrawableInfo *dInfo = (DrawableInfo *) jlong_to_ptr(nativeDInfo);
  int interval;
  jboolean vSyncNeeded;

  // if(/*curCtxWin*/SDL_GL_GetCurrentWindow() != dInfo->win
  //     && /*curCtxGl*/SDL_GL_GetCurrentContext() != ctxInfo->context)
    if(!!SDL_GL_MakeCurrent(dInfo->win, ctxInfo->context))
    {
      _cph_sprinte("SDL_GL_MakeCurrent() failed: '%s'.\n", SDL_GetError());

      return;
    }
    // else
    // {
    //   curCtxWin = dInfo->win;
    //   curCtxGl = ctxInfo->context;
    // }
  // else
    // return;

  vSyncNeeded = ctxInfo->vSyncRequested && dInfo->onScreen;
  if (vSyncNeeded == ctxInfo->state.vSyncEnabled) {
      return;
  }
  interval = (vSyncNeeded) ? 1 : 0;
  ctxInfo->state.vSyncEnabled = vSyncNeeded;
  if(!!SDL_GL_SetSwapInterval(interval))
  {
    _cph_sprinte("SDL_GL_SetSwapInterval() failed: '%s'.\n", SDL_GetError());

    return;
  }
}


//
} // extern "C"

