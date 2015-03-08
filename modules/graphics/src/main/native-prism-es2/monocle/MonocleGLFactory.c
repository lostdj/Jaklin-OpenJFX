/*
 * Copyright (c) 2014, Oracle and/or its affiliates. All rights reserved.
 * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
 *
 * This code is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License version 2 only, as
 * published by the Free Software Foundation.  Oracle designates this
 * particular file as subject to the "Classpath" exception as provided
 * by Oracle in the LICENSE file that accompanied this code.
 *
 * This code is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 * version 2 for more details (a copy is included in the LICENSE file that
 * accompanied this code).
 *
 * You should have received a copy of the GNU General Public License version
 * 2 along with this work; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
 *
 * Please contact Oracle, 500 Oracle Parkway, Redwood Shores, CA 94065 USA
 * or visit www.oracle.com if you need additional information or have any
 * questions.
 */

#include <stdlib.h>
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

#include <EGL/egl.h>
#include "eglUtils.h"

#include "../PrismES2Defs.h"

//mymod
// #include "com_sun_prism_es2_MonocleGLContext.h"

extern void *get_dlsym(void *handle, const char *symbol, int warn);

#define GET_DLSYM(handle,symbol) get_dlsym(handle,symbol, 0);

#define asPtr(x) ((void *) (unsigned long) (x))
#define asJLong(x) ((jlong) (unsigned long) (x))

//mymod
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
extern void glTexImage2DMultisample(GLenum target, GLsizei samples, GLint internalformat, GLsizei width, GLsizei height, GLboolean fixedsamplelocations);
extern void glRenderbufferStorageMultisample(GLenum target, GLsizei samples, GLenum internalformat, GLsizei width, GLsizei height);
extern void glBlitFramebuffer(GLint srcX0, GLint srcY0, GLint srcX1, GLint srcY1, GLint dstX0, GLint dstY0, GLint dstX1, GLint dstY1, GLbitfield mask, GLenum filter);

JNIEXPORT jlong JNICALL Java_com_sun_prism_es2_MonocleGLFactory_nPopulateNativeCtxInfo
(JNIEnv *env, jclass clazz, jlong libraryHandle) {
    ContextInfo *ctxInfo = NULL;

    /* Note: We are only storing the string information of a driver.
     Assuming a system with a single or homogeneous GPUs. For the case
     of heterogeneous GPUs system the string information will need to move to
     GLContext class. */
    /* allocate the structure */
    ctxInfo = (ContextInfo *) malloc(sizeof(ContextInfo));
    if (ctxInfo == NULL) {
        fprintf(stderr, "nInitialize: Failed in malloc\n");
        return 0;
    }
    /* initialize the structure */
    initializeCtxInfo(ctxInfo);

    const char *glVersion = (char *)glGetString(GL_VERSION);
    const char *glVendor = (char *)glGetString(GL_VENDOR);
    const char *glRenderer = (char *)glGetString(GL_RENDERER);
    // Make a copy, at least one platform does not preserve the string beyond the call.
    char *glExtensions = strdup((char *)glGetString(GL_EXTENSIONS));
    //char *eglExtensions = strdup((char *)eglQueryString(asPtr(eglDisplay),
    ///                                                    EGL_EXTENSIONS));

    /* find out the version, major and minor version number */
    char *tmpVersionStr = strdup(glVersion);
    int versionNumbers[2];
    extractVersionInfo(tmpVersionStr, versionNumbers);
    free(tmpVersionStr);

    ctxInfo->versionStr = strdup(glVersion);
    ctxInfo->vendorStr = strdup(glVendor);
    ctxInfo->rendererStr = strdup(glRenderer);
    ctxInfo->glExtensionStr = strdup(glExtensions);
    //ctxInfo->glxExtensionStr = strdup(eglExtensions);
    ctxInfo->versionNumbers[0] = versionNumbers[0];
    ctxInfo->versionNumbers[1] = versionNumbers[1];

    //ctxInfo->display = asPtr(displayType);
    //ctxInfo->context = asPtr(eglContext);
    //ctxInfo->egldisplay = asPtr(eglDisplay);

    // cleanup
    free(glExtensions);
    //free(eglExtensions);

    // from the wrapped_egl.c
    void *handle = asPtr(libraryHandle);

    /* set function pointers */
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
    ctxInfo->glTexImage2DMultisample = &glTexImage2DMultisample;
    ctxInfo->glRenderbufferStorageMultisample = &glRenderbufferStorageMultisample;
    ctxInfo->glBlitFramebuffer = &glBlitFramebuffer;

    initState(ctxInfo);
    return ctxInfo;
}

/*
 * Class:     com_sun_prism_es2_MonocleGLFactory
 * Method:    nGetAdapterOrdinal
 * Signature: (J)I
 */
JNIEXPORT jint JNICALL Java_com_sun_prism_es2_MonocleGLFactory_nGetAdapterOrdinal
(JNIEnv *env, jclass jMonocleGLFactory, jlong nativeScreen) {
    return 0;
}

/*
 * Class:     com_sun_prism_es2_MonocleGLFactory
 * Method:    nGetAdapterCount
 * Signature: ()I
 */
JNIEXPORT jint JNICALL Java_com_sun_prism_es2_MonocleGLFactory_nGetAdapterCount
(JNIEnv *env, jclass jMonocleGLFactory) {
    return 1;
}

/*
 * Class:     com_sun_prism_es2_MonocleGLFactory
 * Method:    nGetDefaultScreen
 * Signature: (J)I
 */
JNIEXPORT jint JNICALL Java_com_sun_prism_es2_MonocleGLFactory_nGetDefaultScreen
(JNIEnv *env, jclass jMonocleGLFactory, jlong nativeCtxInfo) {
    return 0;
}

/*
 * Class:     com_sun_prism_es2_MonocleGLFactory
 * Method:    nGetDisplay
 * Signature: (J)J
 */
JNIEXPORT jlong JNICALL Java_com_sun_prism_es2_MonocleGLFactory_nGetDisplay
(JNIEnv *env, jclass jMonocleGLFactory, jlong nativeCtxInfo) {
    return 0;
}

/*
 * Class:     com_sun_prism_es2_MonocleGLFactory
 * Method:    nGetVisualID
 * Signature: (J)J
 */
JNIEXPORT jlong JNICALL Java_com_sun_prism_es2_MonocleGLFactory_nGetVisualID
(JNIEnv *env, jclass jMonocleGLFactory, jlong nativeCtxInfo) {
    return 0;
}

/*
 * Class:     com_sun_prism_es2_MonocleGLFactory
 * Method:    nGetIsGL2
 * Signature: (J)Z
 */
JNIEXPORT jboolean JNICALL Java_com_sun_prism_es2_MonocleGLFactory_nGetIsGL2
(JNIEnv *env, jclass class, jlong nativeCtxInfo) {
    return ((ContextInfo *)jlong_to_ptr(nativeCtxInfo))->gl2;
}
