# nix-build -E 'with import <nixos> { }; with pkgs; runCommand "foo" { buildInputs = [ stdenv stdenv.glibc stdenv.gcc gcc.stdenv oraclejdk8 gradle18 unzip procps ant which zip cpio nettools alsaLib xorg.libX11 xorg.libXt xorg.libXext xorg.libXrender xorg.libXtst xorg.libXi xorg.libXinerama xorg.libXcursor xorg.lndir fontconfig perl file pkgconfig gtk2 ]; shellHook="export JAVA_HOME=${jdk}; LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${gcc.drvAttrs.gcc}/lib"; } ""' --run-env

# env PYTHONPATH=$PYTHONPATH:/nix/store/nsi9a5zaalbbc8d5pz68m9c87yryqk06-mercurial-3.1.2/lib/python2.7/site-packages/ ../fast-export/hg-fast-export.sh -r ../fxhg/


avnp ?= ./../myavn
override avnp := $(shell realpath -m $(avnp))

libmkf ?= $(avnp)/lib.mk
include $(libmkf)

buildp := $(mf_buildp)/fx
$(eval $(call mf_mkout))
$(eval $(shell mkdir -p $(buildp)))

include $(avnp)/avnmko.mk

#
jdkp ?= $(shell realpath -m $(avnp)/../myjdktop/myjdk)
jdkmkf ?= $(jdkp)/makefile
jdkmko ?= \
	noavn=t \
	v=$(v) \
	mf_rootp=$(jdkp) \
	tmpout=$(tmpout) \
	_mf_tmpout=$(_mf_tmpout) \
	arch=$(arch) \
	mode=$(mode)
jdkdomk = (cd $(jdkp) && make -f $(jdkmkf) $(jdkmko) $(1))
jdkdomks = $(shell $(call jdkdomk,$(1)))
jdkmkfdb := $(mf_outp)/jdkmkfdb
$(eval $(shell \
	if   [ ! -f $(jdkmkfdb) ] \
		|| [ $(jdkmkf) -nt $(jdkmkfdb) ] \
		|| [ $(libmkf) -nt $(jdkmkfdb) ] \
		; then \
			$(call jdkdomk,-p$(space)>$(space)$(jdkmkfdb)); \
		fi))
jdkmkfdbprint = $(call mf_mkfdbfind,$(1),$(jdkmkfdb))

jdkcp := $(call jdkmkfdbprint,t_img_r_jar)
jdkcparg := -bootclasspath $(jdkcp) -cp $(jdkcp)
#jdkcparg := -cp $(jdkcp)

#
fxmyp := $(mf_rootp)/my
fxmymodulesp := $(fxmyp)/modules
fxextp := $(fxmyp)/ext
fxtest := $(fxmyp)/test
fxmmy := $(fxmymodulesp)/my
antcp := $(fxextp)/ant/*:$(fxextp)/hamcrest/*:$(fxextp)/*
myftp := $(fxextp)/myft
mysdlp := $(fxextp)/mysdl

bsrcp := $(mf_rootp)/buildSrc

msrcp := $(mf_rootp)/modules

mbasesrcp := $(msrcp)/base/src/main
mmybasesrcp := $(fxmymodulesp)/base/src
mgraphicsp := $(msrcp)/graphics
mgraphicssrcp := $(mgraphicsp)/src
mgraphics_jsl_decorap := $(mgraphicssrcp)/main/jsl-decora
mgraphics_jsl_prismp := $(mgraphicssrcp)/main/jsl-prism
mcontrolsp := $(msrcp)/controls
mcontrolssrcp := $(mcontrolsp)/src
mfxmlp := $(msrcp)/fxml
mfxmlsrcp := $(mfxmlp)/src

mnfont := $(mgraphicssrcp)/main/native-font
mnglass := $(mgraphicssrcp)/main/native-glass
mnglass_lens := $(mnglass)/lens
mnglass_lens_cursor_null := $(mnglass_lens)/cursor/nullCursor
mnglass_lens_input := $(mnglass_lens)/input
mnglass_lens_input_udev := $(mnglass_lens_input)/udev
mnglass_lens_input_x11 := $(mnglass_lens_input)/x11Container
mnglass_lens_rfb := $(mnglass_lens)/lensRFB
mnglass_lens_wm := $(mnglass_lens)/wm
mnglass_lens_wm_screen := $(mnglass_lens_wm)/screen
mnglass_lensport := $(mnglass_lens)/lensport
mnglass_monocle := $(mnglass)/monocle
mnglass_monocle_util := $(mnglass_monocle)/util
mnglass_monocle_x11 := $(mnglass_monocle)/x11
mnglass_monocle_linux := $(mnglass_monocle)/linux
mnglass_sdl := $(mnglass)/sdl
mnglass_gtk := $(mnglass)/gtk
mniio := $(mgraphicssrcp)/main/native-iio
mniio_ljpg := $(mniio)/libjpeg7
mnprism := $(mgraphicssrcp)/main/native-prism
mnprism_es2 := $(mgraphicssrcp)/main/native-prism-es2
mnprism_es2_gl := $(mnprism_es2)/GL
mnprism_es2_monocle := $(mnprism_es2)/monocle
mnprism_es2_sdl := $(mnprism_es2)/sdl
mnprism_es2_x11 := $(mnprism_es2)/x11
mnprism_es2_eglfb := $(mnprism_es2)/eglfb

glass.platform.sdl := $(if $(filter sdl,$(glass.platform)),t)
glass.platform.gtk := $(if $(filter gtk,$(glass.platform)),t)
glass.platform.lens := $(if $(filter lens,$(glass.platform)),t)
glass.platform.monocle := $(if $(filter monocle,$(glass.platform)),t)

jarmodules := base jsl jgraphics controls fxml

$(eval jretrolambda = $(call avnmkfdbprint,jretrolambda))

t_b2h_outo := $(call avnmkfdbprint,t_b2h_outo)
$(eval t_b2h_run_raw = $(call avnmkfdbprint,t_b2h_run_raw))
$(eval t_b2h_run = $(call avnmkfdbprint,t_b2h_run))

t_nama_flags := $(call avnmkfdbprint,t_nama_flags)
t_nama_outo := $(call avnmkfdbprint,t_nama_outo)
$(eval t_nama_run = $(call avnmkfdbprint,t_nama_run))


#----------------------------------------


t_bsrc_outp := $(buildp)/bsrc
t_bsrc_outp_j := $(t_bsrc_outp)/classes
t_bsrc_gengrammar_outp := $(buildp)/bsrc_gengrammar
_t_bsrc_gengrammar_outp_jp := $(t_bsrc_gengrammar_outp)/com/sun/scenario/effect/compiler
_t_bsrc_gengrammar_outf_j := \
	$(_t_bsrc_gengrammar_outp_jp)/JSLLexer.java \
	$(_t_bsrc_gengrammar_outp_jp)/JSLParser.java \
	#
_t_bsrc_gengrammar_outf_r := \
	$(_t_bsrc_gengrammar_outp_jp)/JSL.tokens \
	#
_t_bsrc_gengrammar_outf := \
	$(_t_bsrc_gengrammar_outf_j) \
	$(_t_bsrc_gengrammar_outf_r) \
	#
_t_bsrc_out_jclassesf := $(t_bsrc_outp)/_classes


t_bsrc_srcj := \
	$(shell find $(bsrcp)/src/main/java -name '*.java') \
	$(_t_bsrc_gengrammar_outf_j) \
	#

$(_t_bsrc_gengrammar_outf): $(bsrcp)/src/main/antlr/JSL.g
	@mkdir -p $(_t_bsrc_gengrammar_outp_jp)
	(cd $(bsrcp) && $(mf_default_java) -Dfile.encoding=UTF-8 -cp $(fxextp)/ant/*:$(fxextp)/hamcrest/*:$(fxextp)/* org.antlr.Tool -o $(_t_bsrc_gengrammar_outp_jp) $(<))

$(_t_bsrc_out_jclassesf): $(t_bsrc_srcj)
	rm -f $(@)
	rm -rf $(t_bsrc_outp_j)
	mkdir -p $(t_bsrc_outp_j)
	$(mf_default_javac) -g -d $(t_bsrc_outp_j) $(jdkcparg):$(antcp) $(^)
	cp -r $(bsrcp)/src/main/resources/* $(t_bsrc_outp_j)
	touch $(@)

$(eval $(call mf_echot,bsrc,"Building t_bsrc..."))

.PHONY: t_bsrc
t_bsrc: | $(call mf_echot_dep,bsrc) $(_t_bsrc_gengrammar_outf) $(_t_bsrc_out_jclassesf) \
	;


#----------------------------------------


t_base_outp := $(buildp)/base
t_base_outp_j := $(t_base_outp)/classes
t_base_outp_compat_j := $(t_base_outp)/classes_compat
_t_base_out_jclassesf := $(t_base_outp)/_classes

t_base_srcj := \
	$(shell find $(mbasesrcp)/java -name '*.java') \
	$(shell find $(mbasesrcp)/java8 -name '*.java') \
	$(shell find $(mmybasesrcp) -name '*.java') \
	#

$(_t_base_out_jclassesf): $(t_base_srcj)
	rm -f $(@)
	rm -rf $(t_base_outp_j)
	rm -rf $(t_base_outp_compat_j)
	mkdir -p $(t_base_outp_j)
	mkdir -p $(t_base_outp_compat_j)
	$(mf_default_javac) -g -d $(t_base_outp_j) $(jdkcparg):$(t_bsrc_outp_j) $(^)
	env DEFAULT_METHODS=2 $(call jretrolambda,$(t_base_outp_j) -Dretrolambda.outputDir=$(t_base_outp_compat_j),$(t_base_outp_j):$(jdkcp):$(t_bsrc_outp_j))
	touch $(@)

$(eval $(call mf_echot,base,"Building t_base..."))

.PHONY: t_base
t_base: | t_bsrc $(call mf_echot_dep,base) $(_t_base_out_jclassesf) \
	;


#----------------------------------------


t_jgraphics_outp := $(buildp)/jgraphics
t_jgraphics_outp_classes := $(t_jgraphics_outp)/classes
t_jgraphics_outp_classes_compat := $(t_jgraphics_outp)/classes_compat
t_jgraphics_outp_genh := $(t_jgraphics_outp)/gen-h

t_jgraphics_batchfile := $(t_jgraphics_outp)/javac.batch
$(shell \
	if [ -f $(t_jgraphics_batchfile) ] ; then \
		find $(mgraphicssrcp)/main/java $(mgraphicssrcp)/main/resources -cnewer $(t_jgraphics_batchfile) -exec rm -f $(t_jgraphics_batchfile) \; ; \
	fi; )

$(t_jgraphics_batchfile):
	mkdir -p $(t_jgraphics_outp_classes)
	rm -rf $(t_jgraphics_outp_classes)/*
	mkdir -p $(t_jgraphics_outp_classes_compat)
	rm -rf $(t_jgraphics_outp_classes_compat)/*
	mkdir -p $(t_jgraphics_outp_genh)
	#rm -rf $(t_jgraphics_outp_genh)/*
	rm -f $(@).tmp
	find \
		$(mgraphicssrcp)/main/java \
		-name '*.java' \
		\
		-and -not -path "$(mgraphicssrcp)/main/java/netscape/*" \
		-and -not -path "$(mgraphicssrcp)/main/java/com/sun/glass/ui/swt/*" \
		-and -not -path "$(mgraphicssrcp)/main/java/com/sun/prism/j2d/*" \
		\
		-and -not -path "$(mgraphicssrcp)/main/java/com/sun/javafx/font/AndroidFontFinder.java" \
		\
		>> $(@).tmp
	$(mf_default_javac) -g -d $(t_jgraphics_outp_classes) -h $(t_jgraphics_outp_genh) $(jdkcparg) -Xbootclasspath/a:$(t_bsrc_outp_j):$(t_base_outp_j):$(antcp):$(t_jsl_outp_classes) -Xmaxerrs 100500 -Xmaxwarns 100500 \@$(@).tmp
	env DEFAULT_METHODS=2 $(call jretrolambda,$(t_jgraphics_outp_classes) -Dretrolambda.outputDir=$(t_jgraphics_outp_classes_compat),$(t_jgraphics_outp_classes):$(jdkcp):$(t_bsrc_outp_j):$(t_base_outp_j):$(antcp):$(t_jsl_outp_classes))
	cp -r $(mgraphicssrcp)/main/resources/* $(t_jgraphics_outp_classes)
	cp -r $(mgraphicssrcp)/main/resources/* $(t_jgraphics_outp_classes_compat)
	mv $(@).tmp $(@)

$(eval $(call mf_echot,jgraphics,"Building t_jgraphics..."))

.PHONY: t_jgraphics
t_jgraphics: | $(call mf_echot_dep,jgraphics) $(t_jgraphics_batchfile) \
	;


#----------------------------------------


t_n_libs := \
	$(if ,-lfreetype) \
	$(if $(mf_target_tux),-lXtst -lX11 -lXxf86vm -lGL) \
	$(if $(mf_target_ems), -s FULL_ES2=1) \
	$(if ,$(if $(mf_target_ems), -s FULL_ES3=1)) \
	$(if ,$(if $(mf_target_ems), -s USE_WEBGL2=1)) \
	$(if ,$(if $(mf_target_ems), -s USE_SDL=2)) \
	$(if ,-lEGL) \
	$(if ,-ludev) \
	#

t_n_c_f_opt := $(call avnmkfdbprint,t_vm_flags_opts)
t_n_c_f_def := $(call avnmkfdbprint,t_vm_flags_defs)
t_n_c_f_etc :=
t_n_c_f_inc := $(call avnmkfdbprint,t_vm_flags_inc)

t_n_cpp_f_opt := $(call avnmkfdbprint,t_vm_flags_opts)
t_n_cpp_f_def := $(call avnmkfdbprint,t_vm_flags_defs)
t_n_cpp_f_etc := $(mf_default_cxx_flags)
t_n_cpp_f_inc := $(call avnmkfdbprint,t_vm_flags_inc)


#----------------------------------------


ifeq ($(mf_target_tux)$(glass.platform.lens)$(glass.platform.monocle),tt)

t_myegl_do := t

t_myegl_outp := $(buildp)/eglp

t_myegl_cpp_libs := $(t_n_libs)
t_myegl_cpp_f_opt := $(t_n_cpp_f_opt)
t_myegl_cpp_f_def := $(t_n_cpp_f_def)
t_myegl_cpp_f_etc := $(t_n_cpp_f_etc) -fexceptions
t_myegl_cpp_f_inc := $(t_n_cpp_f_inc)

t_myegl_cpp_f_all := \
	$(t_myegl_cpp_libs) \
	$(t_myegl_cpp_f_opt) \
	$(t_myegl_cpp_f_def) \
	$(t_myegl_cpp_f_etc) \
	$(t_myegl_cpp_f_inc) \
	#

t_myegl_cpp_src := \
	$(shell find $(fxextp)/eglplus/egl/src/EGL/glx -name '*.cpp') \
	#
t_myegl_cpp_objs := \
	$(call mf_cppobjs,$(t_myegl_cpp_src),$(fxextp),$(t_myegl_outp),mf_binname_obj,$(mf_target_platform)) \
	#

$(t_myegl_cpp_objs): $(t_myegl_outp)/$(call mf_binname_obj,$(call mf_binname_plat,$(mf_target_platform)),%): $$(call mf_srcdepends,$(mf_default_cxx),$(t_myegl_cpp_f_def)$(space)$(t_myegl_cpp_f_inc)$(space)$(t_myegl_cpp_f_etc),$(fxextp)/%.cpp)
	mkdir -p $(@D)
	$(call mf_compileobj,$(mf_default_cxx),$(t_myegl_cpp_f_all))

$(eval $(call mf_echot,myegl,"Building t_myegl..."))

.PHONY: t_myegl
t_myegl: | $(call mf_echot_dep,myegl) $(t_myegl_cpp_objs) \
	;

endif


#----------------------------------------


t_myft_outp := $(mf_buildp)/ft

t_myft_c_libs := $(t_n_libs)
t_myft_c_f_opt := $(t_n_cpp_f_opt)
t_myft_c_f_def := $(t_n_cpp_f_def)
t_myft_c_f_etc := $(filter-out -std=c++11,$(t_n_cpp_f_etc))
t_myft_c_f_inc := \
	$(t_n_cpp_f_inc) \
	$(call mf_cc_inco,$(mf_default_cc_nm),$(myftp)/include) \
	#

t_myft_c_f_def += \
	-DFT2_BUILD_LIBRARY \
	\
	-DFT_CONFIG_OPTION_SUBPIXEL_RENDERING \
	-DTT_CONFIG_OPTION_SUBPIXEL_HINTING \
	#

t_myft_c_f_all := \
	$(t_myft_c_libs) \
	$(t_myft_c_f_opt) \
	$(t_myft_c_f_def) \
	$(t_myft_c_f_etc) \
	$(t_myft_c_f_inc) \
	#

t_myft_c_objs := \
	$(call mf_cobjs,$(t_myft_c_src),$(myftp),$(t_myft_outp),mf_binname_obj,$(mf_target_platform)) \
	#

t_myft_c_src := \
	$(myftp)/src/base/ftsystem.c \
	$(myftp)/src/base/ftinit.c \
	$(myftp)/src/base/ftdebug.c \
	\
	$(myftp)/src/base/ftbase.c \
	\
	$(myftp)/src/base/ftbbox.c \
	$(myftp)/src/base/ftglyph.c \
	\
	$(myftp)/src/base/ftbdf.c \
	$(myftp)/src/base/ftbitmap.c \
	$(myftp)/src/base/ftcid.c \
	$(myftp)/src/base/ftfstype.c \
	$(myftp)/src/base/ftgasp.c \
	$(myftp)/src/base/ftgxval.c \
	$(myftp)/src/base/ftlcdfil.c \
	$(myftp)/src/base/ftmm.c \
	$(myftp)/src/base/ftotval.c \
	$(myftp)/src/base/ftpatent.c \
	$(myftp)/src/base/ftpfr.c \
	$(myftp)/src/base/ftstroke.c \
	$(myftp)/src/base/ftsynth.c \
	$(myftp)/src/base/fttype1.c \
	$(myftp)/src/base/ftwinfnt.c \
	$(myftp)/src/base/ftxf86.c \
	\
	$(myftp)/src/cff/cff.c \
	$(myftp)/src/truetype/truetype.c \
	$(myftp)/src/sfnt/sfnt.c \
	$(myftp)/src/pshinter/pshinter.c \
	$(myftp)/src/psnames/psnames.c \
	\
	$(myftp)/src/raster/raster.c \
	$(myftp)/src/smooth/smooth.c \
	\
	$(myftp)/src/autofit/autofit.c \
	$(myftp)/src/gzip/ftgzip.c \
	#

t_myft_c_objs := \
	$(call mf_cobjs,$(t_myft_c_src),$(myftp),$(t_myft_outp),mf_binname_obj,$(mf_target_platform)) \
	#

$(t_myft_c_objs): $(t_myft_outp)/$(call mf_binname_obj,$(call mf_binname_plat,$(mf_target_platform)),%): $$(call mf_srcdepends,$(mf_default_cc),$(t_myft_c_f_def)$(space)$(t_myft_c_f_inc)$(space)$(t_myft_c_f_etc),$(myftp)/%.c)
	mkdir -p $(@D)
	$(call mf_compileobj,$(mf_default_cc),$(t_myft_c_f_all))

$(eval $(call mf_echot,myft,"Building t_myft..."))

.PHONY: t_myft
t_myft: | $(call mf_echot_dep,myft) $(t_myft_c_objs) \
	;


#----------------------------------------


ifeq ($(mf_target_tux)$(mf_target_ems)$(glass.platform.sdl),tt)

# ./configure --host=asmjs-unknown-emscripten --disable-assembly --disable-threads --enable-cpuinfo=false

t_mysdl_do := t

t_mysdl_outp := $(mf_buildp)/sdl

t_mysdl_c_libs := $(t_n_libs)
t_mysdl_c_f_opt := $(t_n_cpp_f_opt)
t_mysdl_c_f_def := $(t_n_cpp_f_def)
t_mysdl_c_f_etc := $(filter-out -std=c++11,$(t_n_cpp_f_etc))
t_mysdl_c_f_inc := $(t_n_cpp_f_inc) $(call mf_cc_inco,$(mf_default_cc_nm),$(mysdlp)/include)

ifeq ($(mf_target_tux),t)
	t_mysdl_c_libs += -lm -ldl -lasound -lpthread -lX11 -lXext -lXcursor -lXinerama -lXi -lXrandr -lXxf86vm -lrt
	t_mysdl_c_f_def += -D_REENTRANT -DHAVE_LINUX_VERSION_H

else ifeq ($(mf_target_ems),t)
	# t_mysdl_c_f_def += -DSDL_TIMER_UNIX=1
	# t_mysdl_c_f_def += -DSDL_TIMERS_DISABLED=1
	# t_mysdl_c_f_def += -DSDL_VIDEO_DRIVER_EMSCRIPTEN=1
	# t_mysdl_c_f_def += -DSDL_AUDIO_DRIVER_EMSCRIPTEN=1
	# t_mysdl_c_f_def += -DSDL_POWER_EMSCRIPTEN=1
	# t_mysdl_c_f_def += -DSDL_FILESYSTEM_EMSCRIPTEN=1

endif

t_mysdl_c_f_all := \
	$(t_mysdl_c_libs) \
	$(t_mysdl_c_f_opt) \
	$(t_mysdl_c_f_def) \
	$(t_mysdl_c_f_etc) \
	$(t_mysdl_c_f_inc) \
	#

t_mysdl_c_src := \
	$(shell find $(mysdlp)/src -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/atomic -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/audio -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/audio/dummy -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/cpuinfo -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/dynapi -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/events -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/file -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/haptic -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/haptic/dummy -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/joystick -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/libm -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/power -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/render -name '*.c') \
	$(shell find $(mysdlp)/src/stdlib -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/thread -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/timer -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/video -maxdepth 1 -name '*.c') \
	$(shell find $(mysdlp)/src/video/dummy -maxdepth 1 -name '*.c') \
	#

ifeq ($(mf_target_ems),t)
	t_mysdl_c_src += \
		$(shell find $(mysdlp)/src/loadso/dlopen -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/thread/generic -maxdepth 1 -name '*.c') \
		\
		$(shell find $(mysdlp)/src/audio/disk -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/audio/emscripten -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/filesystem/emscripten -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/joystick/emscripten -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/main/dummy -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/power/emscripten -maxdepth 1 -name '*.c') \
		$(if ,$(shell find $(mysdlp)/src/render/direct3d -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/render/direct3d11 -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/render/opengl -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/render/opengles -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/render/opengles2 -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/render/psp -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/render/software -maxdepth 1 -name '*.c')) \
		$(shell find $(mysdlp)/src/timer/unix -maxdepth 1 -name '*.c') \
		$(if , $(shell find $(mysdlp)/src/timer/emscripten -maxdepth 1 -name '*.c')) \
		$(shell find $(mysdlp)/src/video/emscripten -maxdepth 1 -name '*.c') \
		#
else ifeq ($(mf_target_tux),t)
	t_mysdl_c_src += \
		$(shell find $(mysdlp)/src/core/linux -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/loadso/dlopen -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/thread/pthread -maxdepth 1 -name '*.c') \
		\
		$(shell find $(mysdlp)/src/audio/alsa -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/audio/disk -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/audio/dsp -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/audio/pulseaudio -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/filesystem/unix -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/haptic/linux -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/joystick/linux -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/power/linux -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/timer/unix -maxdepth 1 -name '*.c') \
		$(shell find $(mysdlp)/src/video/x11 -maxdepth 1 -name '*.c') \
		#
endif

t_mysdl_c_objs := \
	$(call mf_cobjs,$(t_mysdl_c_src),$(mysdlp),$(t_mysdl_outp),mf_binname_obj,$(mf_target_platform)) \
	#

$(t_mysdl_c_objs): $(t_mysdl_outp)/$(call mf_binname_obj,$(call mf_binname_plat,$(mf_target_platform)),%): $$(call mf_srcdepends,$(mf_default_cc),$(t_mysdl_c_f_def)$(space)$(t_mysdl_c_f_inc)$(space)$(t_mysdl_c_f_etc),$(mysdlp)/%.c)
	mkdir -p $(@D)
	$(call mf_compileobj,$(mf_default_cc),$(t_mysdl_c_f_all))

$(eval $(call mf_echot,mysdl,"Building t_mysdl..."))

.PHONY: t_mysdl
t_mysdl: | $(call mf_echot_dep,mysdl) $(t_mysdl_c_objs) \
	;

endif


#----------------------------------------


t_ngraphics_outp := $(buildp)/ngraphics
t_ngraphics_outp_o := $(t_ngraphics_outp)/obj

t_ngraphics_c_libs := $(t_n_libs)
t_ngraphics_c_f_opt := $(t_n_c_f_opt)
t_ngraphics_c_f_def := $(t_n_c_f_def)
t_ngraphics_c_f_etc := $(t_n_c_f_etc)
t_ngraphics_c_f_inc := $(t_n_c_f_inc)

t_ngraphics_c_f_opt += \
	-fno-strict-aliasing \
	-fPIC \
	-fno-omit-frame-pointer \
	#
t_ngraphics_c_f_def += \
	-DINLINE=inline \
	-DJFXFONT_PLUS \
	-D_ENABLE_HARFBUZZ \
	\
	$(if $(glass.platform.sdl),-D_myfx_sdl=1) \
	\
	#
t_ngraphics_c_f_inc += \
	$(call mf_cc_inco,$(mf_default_cc_nm),$(myftp)/include) \
	$(call mf_cc_inco,$(mf_default_cc_nm),$(mysdlp)/include) \
	\
	$(call mf_cc_inco,$(mf_default_cc_nm),$(t_jgraphics_outp_genh)) \
	\
	$(call mf_cc_inco,$(mf_default_cc_nm),$(mnfont)) \
	$(call mf_cc_inco,$(mf_default_cc_nm),$(mnglass)) \
	\
	$(call mf_cc_inco,$(mf_default_cc_nm),$(mniio)) \
	$(call mf_cc_inco,$(mf_default_cc_nm),$(mniio_ljpg)) \
	$(call mf_cc_inco,$(mf_default_cc_nm),$(mnprism)) \
	$(call mf_cc_inco,$(mf_default_cc_nm),$(mnprism_es2)) \
	$(call mf_cc_inco,$(mf_default_cc_nm),$(mnprism_es2_gl)) \
	\
	$(if $(mf_target_tux),$(call mf_cc_inco,$(mf_default_cc_nm),$(mnglass_lensport))) \
	$(if $(mf_target_tux),$(call mf_cc_inco,$(mf_default_cc_nm),$(mnglass_monocle))) \
	\
	$(if $(glass.platform.sdl),$(call mf_cc_inco,$(mf_default_cc_nm),$(mnglass_sdl))) \
	$(if $(glass.platform.sdl),$(call mf_cc_inco,$(mf_default_cc_nm),$(mnprism_es2_sdl))) \
	$(if $(glass.platform.sdl),$(call mf_cc_inco,$(mf_default_cc_nm),$(mysdlp)/include)) \
	\
	$(if $(glass.platform.gtk),$(call mf_cc_inco,$(mf_default_cc_nm),$(mnprism_es2_x11))) \
	\
	$(if $(glass.platform.monocle),$(call mf_cc_inco,$(mf_default_cc_nm),$(mnprism_es2_monocle))) \
	\
	$(if ,$(call mf_cc_inco,$(mf_default_cc_nm),$(mnglass_lens))) \
	$(if ,$(call mf_cc_inco,$(mf_default_cc_nm),$(mnglass_lens_input))) \
	$(if ,$(call mf_cc_inco,$(mf_default_cc_nm),$(mnglass_lens_rfb))) \
	$(if ,$(call mf_cc_inco,$(mf_default_cc_nm),$(mnglass_lens_wm))) \
	$(if ,$(call mf_cc_inco,$(mf_default_cc_nm),$(mnglass_lens_wm_screen))) \
	$(if ,$(if $(mf_target_tux),$(call mf_cc_inco,$(mf_default_cc_nm),$(mnprism_es2_eglfb)))) \
	#

ifeq ($(t_mysdl_do),t)
	t_ngraphics_c_libs += $(t_mysdl_c_libs)
endif

ifeq ($(mf_target_tux)$(mf_target_ems),t)
	t_ngraphics_c_f_def += -DLINUX

	ifneq ($(glass.platform.lens)$(glass.platform.monocle),)
		t_ngraphics_c_f_def += -DIS_EGLX11
	endif

	ifeq ($(glass.platform.gtk),t)
		t_ngraphics_c_libs += $(shell pkg-config --libs gtk+-2.0)
		t_ngraphics_c_f_inc += $(shell pkg-config --cflags gtk+-2.0)
	endif
endif

t_ngraphics_c_f_all := \
	$(t_ngraphics_c_libs) \
	$(t_ngraphics_c_f_opt) \
	$(t_ngraphics_c_f_def) \
	$(t_ngraphics_c_f_etc) \
	$(t_ngraphics_c_f_inc) \
	#

t_ngraphics_cpp_f_opt := \
	$(if $(mf_target_tux),-frtti) \
	$(if $(mf_target_tux),-fexceptions) \
	#$(if $(mf_target_tux),$(filter-out -fno-exceptions,$(t_n_cpp_f_opt))) \
	#$(if $(mf_target_tux),$(filter-out -fno-rtti,$(t_n_cpp_f_opt))) \
	#
t_ngraphics_cpp_f_etc := \
	$(t_n_cpp_f_etc) \
	#

t_ngraphics_c_font_src := $(mnfont)/freetype.c
t_ngraphics_c_iio_src := \
	$(shell find $(mniio) -maxdepth 1 -name '*.c') \
	$(shell find $(mniio_ljpg) -name '*.c') \
	#
t_ngraphics_c_glass_lens_src := \
	$(shell find $(mnglass_lens) -maxdepth 1 -name '*.c') \
	$(shell find $(mnglass_lens_cursor_null) -name '*.c') \
	$(shell find $(mnglass_lens_input_udev) -name '*.c') \
	$(shell find $(mnglass_lens_wm) -maxdepth 1 -name '*.c') \
	$(shell find $(mnglass_lens_wm_screen) -name 'x11ContainerScreen.c') \
	$(shell find $(mnglass_lensport) -name '*.c') \
	$(shell find $(mnglass_monocle_util) -name '*.c') \
	$(shell find $(mnglass_monocle_x11) -name '*.c') \
	#
t_ngraphics_c_glass_monocle_src := \
	$(shell find $(mnglass_monocle_util) -name '*.c') \
	$(shell find $(mnglass_monocle_x11) -name '*.c') \
	$(shell find $(mnglass_lensport) -name '*.c') \
	$(shell find $(mnglass_monocle_linux) -name '*.c') \
	$(shell find $(mnglass_monocle) -maxdepth 1 -name '*.c') \
	#
t_ngraphics_cpp_glass_sdl_src := \
	$(shell find $(mnglass_sdl) -name '*.cpp') \
	#
t_ngraphics_cpp_glass_gtk_src := \
	$(shell find $(mnglass_gtk) -name '*.cpp') \
	#
t_ngraphics_c_prism_src := $(shell find $(mnprism) -name '*.c')
t_ngraphics_c_prism_es2_src := \
	$(shell find $(mnprism_es2) -maxdepth 1 -name '*.c') \
	\
	$(if $(glass.platform.gtk),$(shell find $(mnprism_es2_x11) -name '*.c')) \
	\
	$(if $(glass.platform.monocle),$(shell find $(mnprism_es2_monocle) -name '*.c')) \
	$(if $(glass.platform.monocle),$(mnprism_es2_eglfb)/wrapped_egl.c) \
	#
t_ngraphics_cpp_my_src := \
	$(if $(glass.platform.sdl),$(shell find $(mnprism_es2_sdl) -name '*.cpp')) \
	\
	$(shell find $(fxmmy) -name '*.cpp') \
	\
	#
t_ngraphics_c_allsrc := \
	$(t_ngraphics_c_font_src) \
	$(t_ngraphics_c_iio_src) \
	\
	$(if $(glass.platform.sdl),$(t_ngraphics_cpp_glass_sdl_src)) \
	$(if $(glass.platform.gtk),$(t_ngraphics_cpp_glass_gtk_src)) \
	$(if $(glass.platform.lens),$(t_ngraphics_c_glass_lens_src)) \
	$(if $(glass.platform.monocle),$(t_ngraphics_c_glass_monocle_src)) \
	\
	$(t_ngraphics_c_prism_src) \
	$(t_ngraphics_c_prism_es2_src) \
	\
	$(t_ngraphics_cpp_my_src) \
	#

t_ngraphics_c_objs := \
	$(call mf_cobjs,$(t_ngraphics_c_font_src),$(mgraphicssrcp),$(t_ngraphics_outp_o),mf_binname_obj,$(mf_target_platform)) \
	$(call mf_cobjs,$(t_ngraphics_c_iio_src),$(mgraphicssrcp),$(t_ngraphics_outp_o),mf_binname_obj,$(mf_target_platform)) \
	\
	$(if $(glass.platform.lens),$(call mf_cobjs,$(t_ngraphics_c_glass_lens_src),$(mgraphicssrcp),$(t_ngraphics_outp_o),mf_binname_obj,$(mf_target_platform))) \
	$(if $(glass.platform.monocle),$(call mf_cobjs,$(t_ngraphics_c_glass_monocle_src),$(mgraphicssrcp),$(t_ngraphics_outp_o),mf_binname_obj,$(mf_target_platform))) \
	\
	$(call mf_cobjs,$(t_ngraphics_c_prism_src),$(mgraphicssrcp),$(t_ngraphics_outp_o),mf_binname_obj,$(mf_target_platform)) \
	$(call mf_cobjs,$(t_ngraphics_c_prism_es2_src),$(mgraphicssrcp),$(t_ngraphics_outp_o),mf_binname_obj,$(mf_target_platform)) \
	#
t_ngraphics_cpp_objs := \
	$(if $(glass.platform.sdl),$(call mf_cppobjs,$(t_ngraphics_cpp_glass_sdl_src),$(mf_rootp),$(t_ngraphics_outp_o),mf_binname_obj,$(mf_target_platform))) \
	$(if $(glass.platform.gtk),$(call mf_cppobjs,$(t_ngraphics_cpp_glass_gtk_src),$(mf_rootp),$(t_ngraphics_outp_o),mf_binname_obj,$(mf_target_platform))) \
	\
	$(call mf_cppobjs,$(t_ngraphics_cpp_my_src),$(mf_rootp),$(t_ngraphics_outp_o),mf_binname_obj,$(mf_target_platform)) \
	#
t_ngraphics_objs_all := \
	$(t_ngraphics_c_objs) \
	$(t_ngraphics_cpp_objs) \
	$(if $(t_myegl_do),$(t_myegl_cpp_objs)) \
	$(t_myft_c_objs) \
	$(if $(t_mysdl_do),$(t_mysdl_c_objs)) \
	#

$(t_ngraphics_c_objs): $(t_ngraphics_outp_o)/$(call mf_binname_obj,$(call mf_binname_plat,$(mf_target_platform)),%): $$(call mf_srcdepends,$(mf_default_cc),$(t_ngraphics_c_f_def)$(space)$(t_ngraphics_c_f_inc),$(mgraphicssrcp)/%.c)
	mkdir -p $(@D)
	$(call mf_compileobj,$(mf_default_cc),$(t_ngraphics_c_f_all))

$(t_ngraphics_cpp_objs): $(t_ngraphics_outp_o)/$(call mf_binname_obj,$(call mf_binname_plat,$(mf_target_platform)),%): $$(call mf_srcdepends,$(mf_default_cxx),$(t_ngraphics_c_f_def)$(space)$(t_ngraphics_c_f_inc)$(space)$(t_ngraphics_cpp_f_etc),$(mf_rootp)/%.cpp)
	mkdir -p $(@D)
	$(call mf_compileobj,$(mf_default_cxx),$(t_ngraphics_c_f_all)$(space)$(t_ngraphics_cpp_f_opt)$(space)$(t_ngraphics_cpp_f_etc))

$(eval $(call mf_echot,ngraphics,"Building t_ngraphics..."))

.PHONY: t_ngraphics
t_ngraphics: | t_jsl $(if $(t_myegl_do),t_myegl) t_myft $(if $(t_mysdl_do),t_mysdl) $(call mf_echot_dep,ngraphics) $(t_ngraphics_c_objs) $(t_ngraphics_cpp_objs) \
	;


#----------------------------------------


t_jsl_outp := $(buildp)/jsl
t_jsl_outp_classes := $(t_jsl_outp)/classes
t_jsl_outp_classes_compat := $(t_jsl_outp)/classes_compat

t_jsl_outp_decora := $(t_jsl_outp)/decora
t_jsl_outp_decora_cc := $(t_jsl_outp_decora)/cc
t_jsl_outp_decora_gen := $(t_jsl_outp_decora)/gen
t_jsl_decora_src := $(shell find $(mgraphics_jsl_decorap) -name '*.java')
t_jsl_decora_cc_dep := $(t_jsl_outp_decora)/_cc
t_jsl_decora_jsl_dep := $(t_jsl_outp_decora)/_jsl
t_jsl_decora_jsls := 
define _t_jsl_decora_addjsl =
t_jsl_decora_jsls += $(1)
_t_jsl_decora_jsl_$(1) := $(2)
endef
$(eval $(call _t_jsl_decora_addjsl,ColorAdjust,CompileJSL))
$(eval $(call _t_jsl_decora_addjsl,Brightpass,CompileJSL))
$(eval $(call _t_jsl_decora_addjsl,SepiaTone,CompileJSL))
$(eval $(call _t_jsl_decora_addjsl,PerspectiveTransform,CompileJSL))
$(eval $(call _t_jsl_decora_addjsl,DisplacementMap,CompileJSL))
$(eval $(call _t_jsl_decora_addjsl,InvertMask,CompileJSL))
$(eval $(call _t_jsl_decora_addjsl,Blend,CompileBlend))
$(eval $(call _t_jsl_decora_addjsl,PhongLighting,CompilePhong))
$(eval $(call _t_jsl_decora_addjsl,LinearConvolve,CompileLinearConvolve))
$(eval $(call _t_jsl_decora_addjsl,LinearConvolveShadow,CompileLinearConvolve))

t_jsl_outp_prism := $(t_jsl_outp)/prism
t_jsl_outp_prism_cc := $(t_jsl_outp_prism)/cc
t_jsl_outp_prism_gen := $(t_jsl_outp_prism)/gen
t_jsl_prism_src := $(shell find $(mgraphics_jsl_prismp) -name '*.java')
t_jsl_prism_cc_dep := $(t_jsl_outp_prism)/_cc
t_jsl_prism_jsl_dep := $(t_jsl_outp_prism)/_jsl
t_jsl_prism_jsls := $(shell find $(mgraphics_jsl_prismp) -name '*.jsl')

$(t_jsl_decora_cc_dep): $(t_jsl_decora_src)
	mkdir -p $(t_jsl_outp_decora_cc)
	rm -rf $(t_jsl_outp_decora_cc)/*
	rm -f $(@)
	$(mf_default_javac) -g -d $(t_jsl_outp_decora_cc) $(jdkcparg):$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jgraphics_outp_classes):$(antcp) -Xbootclasspath/a:$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jgraphics_outp_classes) -sourcepath $(mgraphics_jsl_decorap) $(^)
	env DEFAULT_METHODS=2 $(call jretrolambda,$(t_jsl_outp_decora_cc),$(t_jsl_outp_decora_cc):$(jdkcp):$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jgraphics_outp_classes):$(antcp))
	touch $(@)

$(t_jsl_prism_cc_dep): $(t_jsl_prism_src)
	mkdir -p $(t_jsl_outp_prism_cc)
	rm -rf $(t_jsl_outp_prism_cc)/*
	rm -f $(@)
	$(mf_default_javac) -g -d $(t_jsl_outp_prism_cc) $(jdkcparg):$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jgraphics_outp_classes):$(antcp) -Xbootclasspath/a:$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jgraphics_outp_classes) -sourcepath $(mgraphics_jsl_prismp) $(^)
	env DEFAULT_METHODS=2 $(call jretrolambda,$(t_jsl_outp_prism_cc),$(t_jsl_outp_prism_cc):$(jdkcp):$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jgraphics_outp_classes):$(antcp))
	touch $(@)

$(t_jsl_decora_jsl_dep): $(t_jsl_decora_cc_dep) $(shell find $(mgraphics_jsl_decorap) -name '*.jsl')
	mkdir -p $(t_jsl_outp_classes)
	mkdir -p $(t_jsl_outp_decora_gen)
	#rm -rf $(t_jsl_outp_classes)/*
	rm -rf $(t_jsl_outp_decora_gen)/*
	rm -f $(@)
	$(foreach t,$(t_jsl_decora_jsls),(cd $(mgraphicsp) && $(mf_java) -cp $(antcp):$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jsl_outp_decora_cc) $(_t_jsl_decora_jsl_$(t)) -i $(mgraphics_jsl_decorap) -o $(t_jsl_outp_decora_gen) -t -pkg com/sun/scenario/effect -all $(t))$(newline))
	$(mf_default_javac) -g -d $(t_jsl_outp_classes) $(jdkcparg):$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jgraphics_outp_classes):$(antcp) -Xbootclasspath/a:$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jgraphics_outp_classes) -sourcepath $(t_jsl_outp_decora_gen) $$(find $(t_jsl_outp_decora_gen)/com/sun/scenario/effect/impl/prism/ps -name '*.java')
	env DEFAULT_METHODS=2 $(call jretrolambda,$(t_jsl_outp_classes) -Dretrolambda.outputDir=$(t_jsl_outp_classes_compat),$(t_jsl_outp_classes):$(jdkcp):$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jgraphics_outp_classes):$(antcp))
	mkdir -p $(t_jsl_outp_classes)/com/sun/scenario/effect/impl/es2/glsl
	cp $(t_jsl_outp_decora_gen)/com/sun/scenario/effect/impl/es2/glsl/* $(t_jsl_outp_classes)/com/sun/scenario/effect/impl/es2/glsl/
	mkdir -p $(t_jsl_outp_classes_compat)/com/sun/scenario/effect/impl/es2/glsl/ && cp $(t_jsl_outp_decora_gen)/com/sun/scenario/effect/impl/es2/glsl/* $(t_jsl_outp_classes_compat)/com/sun/scenario/effect/impl/es2/glsl/
	touch $(@)

$(t_jsl_prism_jsl_dep): $(t_jsl_prism_cc_dep) $(t_jsl_prism_jsls)
	mkdir -p $(t_jsl_outp_classes)
	mkdir -p $(t_jsl_outp_prism_gen)
	#rm -rf $(t_jsl_outp_classes)/*
	rm -rf $(t_jsl_outp_prism_gen)/*
	rm -f $(@)
	$(foreach t,$(t_jsl_prism_jsls),(cd $(mgraphicsp) && $(mf_java) -cp $(antcp):$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jsl_outp_prism_cc):$(mgraphics_jsl_prismp) CompileJSL -i $(mgraphics_jsl_prismp) -o $(t_jsl_outp_prism_gen) -t -pkg com/sun/prism -es2 -name $(t))$(newline))
	$(mf_default_javac) -g -d $(t_jsl_outp_classes) $(jdkcparg):$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jgraphics_outp_classes):$(antcp) -Xbootclasspath/a:$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jgraphics_outp_classes) -sourcepath $(t_jsl_outp_prism_gen) $$(find $(t_jsl_outp_prism_gen) -name '*.java')
	env DEFAULT_METHODS=2 $(call jretrolambda,$(t_jsl_outp_classes) -Dretrolambda.outputDir=$(t_jsl_outp_classes_compat),$(t_jsl_outp_classes):$(jdkcp):$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jgraphics_outp_classes):$(antcp))
	mkdir -p $(t_jsl_outp_classes)/com/sun/prism/es2/glsl
	cp $(t_jsl_outp_prism_gen)/com/sun/prism/es2/glsl/* $(t_jsl_outp_classes)/com/sun/prism/es2/glsl/
	mkdir -p $(t_jsl_outp_classes_compat)/com/sun/prism/es2/glsl/ && cp $(t_jsl_outp_prism_gen)/com/sun/prism/es2/glsl/* $(t_jsl_outp_classes_compat)/com/sun/prism/es2/glsl/
	touch $(@)

$(eval $(call mf_echot,jsl,"Building t_jsl..."))

.PHONY: t_jsl
t_jsl: | t_jgraphics $(call mf_echot_dep,jsl) $(t_jsl_decora_cc_dep) $(t_jsl_prism_cc_dep) $(t_jsl_decora_jsl_dep) $(t_jsl_prism_jsl_dep) \
	;


#----------------------------------------


t_controls_outp := $(buildp)/controls
t_controls_outp_classes := $(t_controls_outp)/classes
t_controls_outp_classes_compat := $(t_controls_outp)/classes_compat

t_controls_batchfile := $(t_controls_outp)/javac.batch
$(shell \
	if [ -f $(t_controls_batchfile) ] ; then \
		find $(mcontrolssrcp)/main/java -cnewer $(t_controls_batchfile) -exec rm -f $(t_controls_batchfile) \; ; \
	fi; )

$(t_controls_batchfile):
	mkdir -p $(t_controls_outp_classes)
	rm -rf $(t_controls_outp_classes)/*
	rm -f $(@).tmp
	find \
		$(mcontrolssrcp)/main/java \
		-name '*.java' \
		\
		>> $(@).tmp
	$(mf_default_javac) -g -d $(t_controls_outp_classes) $(jdkcparg):$(t_bsrc_outp_j):$(t_base_outp_j):$(antcp):$(t_jsl_outp_classes):$(t_jgraphics_outp_classes) -Xbootclasspath/a:$(t_bsrc_outp_j):$(t_base_outp_j):$(t_jsl_outp_classes):$(t_jgraphics_outp_classes) -Xmaxerrs 100500 -Xmaxwarns 100500 \@$(@).tmp
	$(call jretrolambda,$(t_controls_outp_classes) -Dretrolambda.outputDir=$(t_controls_outp_classes_compat),$(t_controls_outp_classes):$(jdkcp):$(t_bsrc_outp_j):$(t_base_outp_j):$(antcp):$(t_jsl_outp_classes):$(t_jgraphics_outp_classes))
	cp -r $(mcontrolssrcp)/main/resources/* $(t_controls_outp_classes)
	cp -r $(mcontrolssrcp)/main/resources/* $(t_controls_outp_classes_compat)
	mv $(@).tmp $(@)

$(eval $(call mf_echot,controls,"Building t_controls..."))

.PHONY: t_controls
t_controls: | t_jgraphics $(call mf_echot_dep,controls) $(t_controls_batchfile) \
	;


#----------------------------------------


t_fxml_outp := $(buildp)/fxml
t_fxml_outp_classes := $(t_fxml_outp)/classes
t_fxml_outp_classes_compat := $(t_fxml_outp)/classes_compat

t_fxml_batchfile := $(t_fxml_outp)/javac.batch
$(shell \
	if [ -f $(t_fxml_batchfile) ] ; then \
		find $(mfxmlsrcp)/main/java -cnewer $(t_fxml_batchfile) -exec rm -f $(t_fxml_batchfile) \; ; \
	fi; )

$(t_fxml_batchfile):
	mkdir -p $(t_fxml_outp_classes)
	rm -rf $(t_fxml_outp_classes)/*
	rm -f $(@).tmp
	find \
		$(mfxmlsrcp)/main/java \
		-name '*.java' \
		\
		>> $(@).tmp
	$(mf_default_javac) -g -d $(t_fxml_outp_classes) $(jdkcparg):$(t_bsrc_outp_j):$(t_base_outp_j):$(antcp):$(t_jsl_outp_classes):$(t_jgraphics_outp_classes) -Xbootclasspath/a:$(t_bsrc_outp_j):$(t_base_outp_j):$(antcp):$(t_jsl_outp_classes):$(t_jgraphics_outp_classes) -Xmaxerrs 100500 -Xmaxwarns 100500 \@$(@).tmp
	$(call jretrolambda,$(t_fxml_outp_classes) -Dretrolambda.outputDir=$(t_fxml_outp_classes_compat),$(t_fxml_outp_classes):$(jdkcp):$(t_bsrc_outp_j):$(t_base_outp_j):$(antcp):$(t_jsl_outp_classes):$(t_jgraphics_outp_classes))
	mv $(@).tmp $(@)

$(eval $(call mf_echot,fxml,"Building t_fxml..."))

.PHONY: t_fxml
t_fxml: | t_controls $(call mf_echot_dep,fxml) $(t_fxml_batchfile) \
	;


#----------------------------------------


t_img_rp := $(mf_resultp)
t_img_r_dll := $(t_img_rp)/$(call mf_binname_dll,$(call mf_binname_plat,$(mf_target_platform)),myfx)
t_img_r_jar := $(t_img_rp)/myfx.jar
t_img_r_h := $(t_img_rp)/myfxjar.gen.h
t_img_r_m := $(t_img_rp)/myfxjni.gen.inc.cpp
t_img_r_m_src := $(t_ngraphics_c_allsrc)
t_img_r_m_f := $(t_ngraphics_c_f_def) $(t_ngraphics_c_f_inc)
t_img_r_m_stubs := \
	Not found com/sun/pisces/NativeSurface.initialize: (III)V \
	Not found com/sun/pisces/Transform6.initialize: ()V \
	Not found com/sun/pisces/AbstractSurface.getRGBImpl: ([IIIIIII)V \
	Not found com/sun/pisces/AbstractSurface.setRGBImpl: ([IIIIIII)V \
	Not found com/sun/pisces/AbstractSurface.nativeFinalize: ()V \
	Not found com/sun/pisces/JavaSurface.initialize: (III)V \
	Not found com/sun/pisces/PiscesRenderer.initialize: ()V \
	Not found com/sun/pisces/PiscesRenderer.setColorImpl: (IIII)V \
	Not found com/sun/pisces/PiscesRenderer.setCompositeRuleImpl: (I)V \
	Not found com/sun/pisces/PiscesRenderer.setLinearGradientImpl: (IIII[IILcom/sun/pisces/Transform6;)V \
	Not found com/sun/pisces/PiscesRenderer.setRadialGradientImpl: (IIIII[IILcom/sun/pisces/Transform6;)V \
	Not found com/sun/pisces/PiscesRenderer.setTextureImpl: (I[IIIILcom/sun/pisces/Transform6;ZZ)V \
	Not found com/sun/pisces/PiscesRenderer.setClipImpl: (IIII)V \
	Not found com/sun/pisces/PiscesRenderer.clearRectImpl: (IIII)V \
	Not found com/sun/pisces/PiscesRenderer.fillRectImpl: (IIII)V \
	Not found com/sun/pisces/PiscesRenderer.emitAndClearAlphaRowImpl: ([B[IIIII)V \
	Not found com/sun/pisces/PiscesRenderer.fillAlphaMaskImpl: ([BIIIIII)V \
	Not found com/sun/pisces/PiscesRenderer.setLCDGammaCorrectionImpl: (F)V \
	Not found com/sun/pisces/PiscesRenderer.fillLCDAlphaMaskImpl: ([BIIIIII)V \
	Not found com/sun/pisces/PiscesRenderer.drawImageImpl: (II[IIIIILcom/sun/pisces/Transform6;ZIIIIIIIIIIIIZ)V \
	Not found com/sun/pisces/PiscesRenderer.nativeFinalize: ()V \
	Not found com/sun/webkit/dom/JSObject.evalImpl: (JILjava/lang/String;)Ljava/lang/Object; \
	Not found com/sun/webkit/dom/JSObject.getMemberImpl: (JILjava/lang/String;)Ljava/lang/Object; \
	Not found com/sun/webkit/dom/JSObject.setMemberImpl: (JILjava/lang/String;Ljava/lang/Object;Ljava/security/AccessControlContext;)V \
	Not found com/sun/webkit/dom/JSObject.removeMemberImpl: (JILjava/lang/String;)V \
	Not found com/sun/webkit/dom/JSObject.getSlotImpl: (JII)Ljava/lang/Object; \
	Not found com/sun/webkit/dom/JSObject.setSlotImpl: (JIILjava/lang/Object;Ljava/security/AccessControlContext;)V \
	Not found com/sun/webkit/dom/JSObject.callImpl: (JILjava/lang/String;[Ljava/lang/Object;Ljava/security/AccessControlContext;)Ljava/lang/Object; \
	Not found com/sun/webkit/dom/JSObject.toStringImpl: (JI)Ljava/lang/String; \
	\
	Not found com/sun/glass/events/mac/NpapiEvent._dispatchCocoaNpapiDrawEvent: (JIJDDDD)V \
	Not found com/sun/glass/events/mac/NpapiEvent._dispatchCocoaNpapiMouseEvent: (JIIDDIIDDD)V \
	Not found com/sun/glass/events/mac/NpapiEvent._dispatchCocoaNpapiKeyEvent: (JIILjava/lang/String;Ljava/lang/String;ZIZ)V \
	Not found com/sun/glass/events/mac/NpapiEvent._dispatchCocoaNpapiFocusEvent: (JIZ)V \
	Not found com/sun/glass/events/mac/NpapiEvent._dispatchCocoaNpapiTextInputEvent: (JILjava/lang/String;)V \
	\
	__SDL__: \
	$(if $(glass.platform.sdl),, \
	Not found com/sun/prism/es2/SDLGLDrawable.nGetDummyDrawable: (J)J \
	Not found com/sun/prism/es2/SDLGLDrawable.nCreateDrawable: (JJ)J \
	Not found com/sun/prism/es2/SDLGLDrawable.nSwapBuffers: (J)Z \
	Not found com/sun/prism/es2/SDLGLContext.nInitialize: (JJJZ)J \
	Not found com/sun/prism/es2/SDLGLContext.nGetNativeHandle: (J)J \
	Not found com/sun/prism/es2/SDLGLContext.nMakeCurrent: (JJ)V \
	Not found com/sun/prism/es2/SDLGLPixelFormat.nCreatePixelFormat: (J[I)J \
	Not found com/sun/prism/es2/SDLGLFactory.nInitialize: ([I)J \
	Not found com/sun/prism/es2/SDLGLFactory.nGetIsGL2: (J)Z \
	Not found com/sun/glass/ui/sdl/SDLApplication.onload: (Z)I \
	Not found com/sun/glass/ui/sdl/SDLApplication.nInit: ()V \
	Not found com/sun/glass/ui/sdl/SDLApplication.nTick: ()V \
	Not found com/sun/glass/ui/sdl/SDLApplication.nTerminate: ()V \
	Not found com/sun/glass/ui/sdl/SDLApplication.nGetScreens: ()[Lcom/sun/glass/ui/Screen; \
	Not found com/sun/glass/ui/sdl/SDLApplication.nSubmitForLaterInvocation: (Ljava/lang/Runnable;)V \
	Not found com/sun/glass/ui/sdl/SDLTimer.nStart: (Ljava/lang/Runnable;I)J \
	Not found com/sun/glass/ui/sdl/SDLTimer.nStop: (J)V \
	Not found com/sun/glass/ui/sdl/SDLWindow.nCreateWindow: (JJIJ)J \
	Not found com/sun/glass/ui/sdl/SDLWindow._close: (J)Z \
	Not found com/sun/glass/ui/sdl/SDLWindow.nSetView: (JLcom/sun/glass/ui/View;)V \
	Not found com/sun/glass/ui/sdl/SDLWindow.nMinimize: (JZ)V \
	Not found com/sun/glass/ui/sdl/SDLWindow.nMaximize: (JZZ)V \
	Not found com/sun/glass/ui/sdl/SDLWindow.nSetBounds: (JIIZZIIIIFF)V \
	Not found com/sun/glass/ui/sdl/SDLWindow._setVisible: (JZ)Z \
	Not found com/sun/glass/ui/sdl/SDLWindow.nFocus: (J)V \
	Not found com/sun/glass/ui/sdl/SDLWindow._setTitle: (JLjava/lang/String;)Z \
	Not found com/sun/glass/ui/sdl/SDLWindow._setMinimumSize: (JII)Z \
	Not found com/sun/glass/ui/sdl/SDLWindow._setMaximumSize: (JII)Z \
	Not found com/sun/glass/ui/sdl/SDLView._create: (Ljava/util/Map;)J \
	) \
	\
	__GTK__: \
	$(if $(glass.platform.gtk),, \
	Not found com/sun/glass/ui/gtk/GtkApplication.onload: ()I \
	Not found com/sun/glass/ui/gtk/GtkPixels._copyPixels: (Ljava/nio/Buffer;Ljava/nio/Buffer;I)V \
	Not found com/sun/glass/ui/gtk/GtkPixels._attachInt: (JIILjava/nio/IntBuffer;[II)V \
	Not found com/sun/glass/ui/gtk/GtkPixels._attachByte: (JIILjava/nio/ByteBuffer;[BI)V \
	Not found com/sun/glass/ui/gtk/GtkRobot._keyPress: (I)V \
	Not found com/sun/glass/ui/gtk/GtkRobot._keyRelease: (I)V \
	Not found com/sun/glass/ui/gtk/GtkRobot._mouseMove: (II)V \
	Not found com/sun/glass/ui/gtk/GtkRobot._mousePress: (I)V \
	Not found com/sun/glass/ui/gtk/GtkRobot._mouseRelease: (I)V \
	Not found com/sun/glass/ui/gtk/GtkRobot._mouseWheel: (I)V \
	Not found com/sun/glass/ui/gtk/GtkRobot._getMouseX: ()I \
	Not found com/sun/glass/ui/gtk/GtkRobot._getMouseY: ()I \
	Not found com/sun/glass/ui/gtk/GtkRobot._getScreenCapture: (IIII[I)V \
	Not found com/sun/glass/ui/gtk/GtkApplication._isDisplayValid: ()Z \
	Not found com/sun/glass/ui/gtk/GtkApplication._terminateLoop: ()V \
	Not found com/sun/glass/ui/gtk/GtkApplication._init: (JZ)V \
	Not found com/sun/glass/ui/gtk/GtkApplication._runLoop: (Ljava/lang/Runnable;Z)V \
	Not found com/sun/glass/ui/gtk/GtkApplication._submitForLaterInvocation: (Ljava/lang/Runnable;)V \
	Not found com/sun/glass/ui/gtk/GtkApplication.enterNestedEventLoopImpl: ()V \
	Not found com/sun/glass/ui/gtk/GtkApplication.leaveNestedEventLoopImpl: ()V \
	Not found com/sun/glass/ui/gtk/GtkApplication.staticTimer_getMinPeriod: ()I \
	Not found com/sun/glass/ui/gtk/GtkApplication.staticTimer_getMaxPeriod: ()I \
	Not found com/sun/glass/ui/gtk/GtkApplication.staticScreen_getScreens: ()[Lcom/sun/glass/ui/Screen; \
	Not found com/sun/glass/ui/gtk/GtkApplication.staticView_getMultiClickTime: ()J \
	Not found com/sun/glass/ui/gtk/GtkApplication.staticView_getMultiClickMaxX: ()I \
	Not found com/sun/glass/ui/gtk/GtkApplication.staticView_getMultiClickMaxY: ()I \
	Not found com/sun/glass/ui/gtk/GtkApplication._supportsTransparentWindows: ()Z \
	Not found com/sun/glass/ui/gtk/GtkApplication._getKeyCodeForChar: (C)I \
	Not found com/sun/glass/ui/gtk/GtkCursor._createCursor: (IILcom/sun/glass/ui/Pixels;)J \
	Not found com/sun/glass/ui/gtk/GtkCursor._getBestSize: (II)Lcom/sun/glass/ui/Size; \
	Not found com/sun/glass/ui/gtk/GtkSystemClipboard.init: ()V \
	Not found com/sun/glass/ui/gtk/GtkSystemClipboard.dispose: ()V \
	Not found com/sun/glass/ui/gtk/GtkSystemClipboard.isOwner: ()Z \
	Not found com/sun/glass/ui/gtk/GtkSystemClipboard.pushToSystem: (Ljava/util/HashMap;I)V \
	Not found com/sun/glass/ui/gtk/GtkSystemClipboard.pushTargetActionToSystem: (I)V \
	Not found com/sun/glass/ui/gtk/GtkSystemClipboard.popFromSystem: (Ljava/lang/String;)Ljava/lang/Object; \
	Not found com/sun/glass/ui/gtk/GtkSystemClipboard.supportedSourceActionsFromSystem: ()I \
	Not found com/sun/glass/ui/gtk/GtkSystemClipboard.mimesFromSystem: ()[Ljava/lang/String; \
	Not found com/sun/glass/ui/gtk/GtkWindow._createWindow: (JJI)J \
	Not found com/sun/glass/ui/gtk/GtkWindow._createChildWindow: (J)J \
	Not found com/sun/glass/ui/gtk/GtkWindow._close: (J)Z \
	Not found com/sun/glass/ui/gtk/GtkWindow._setView: (JLcom/sun/glass/ui/View;)Z \
	Not found com/sun/glass/ui/gtk/GtkWindow.minimizeImpl: (JZ)V \
	Not found com/sun/glass/ui/gtk/GtkWindow.maximizeImpl: (JZZ)V \
	Not found com/sun/glass/ui/gtk/GtkWindow.setBoundsImpl: (JIIZZIIII)V \
	Not found com/sun/glass/ui/gtk/GtkWindow.setVisibleImpl: (JZ)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._setResizable: (JZ)Z \
	Not found com/sun/glass/ui/gtk/GtkWindow._requestFocus: (JI)Z \
	Not found com/sun/glass/ui/gtk/GtkWindow._setFocusable: (JZ)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._grabFocus: (J)Z \
	Not found com/sun/glass/ui/gtk/GtkWindow._ungrabFocus: (J)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._setTitle: (JLjava/lang/String;)Z \
	Not found com/sun/glass/ui/gtk/GtkWindow._setLevel: (JI)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._setAlpha: (JF)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._setBackground: (JFFF)Z \
	Not found com/sun/glass/ui/gtk/GtkWindow._setEnabled: (JZ)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._setMinimumSize: (JII)Z \
	Not found com/sun/glass/ui/gtk/GtkWindow._setMaximumSize: (JII)Z \
	Not found com/sun/glass/ui/gtk/GtkWindow._setIcon: (JLcom/sun/glass/ui/Pixels;)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._toFront: (J)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._toBack: (J)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._enterModal: (J)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._enterModalWithWindow: (JJ)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._exitModal: (J)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._getNativeWindowImpl: (J)J \
	Not found com/sun/glass/ui/gtk/GtkWindow.isVisible: (J)Z \
	Not found com/sun/glass/ui/gtk/GtkWindow._showOrHideChildren: (JZ)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._setCursorType: (JI)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._setCustomCursor: (JLcom/sun/glass/ui/Cursor;)V \
	Not found com/sun/glass/ui/gtk/GtkWindow._getEmbeddedX: (J)I \
	Not found com/sun/glass/ui/gtk/GtkWindow._getEmbeddedY: (J)I \
	Not found com/sun/glass/ui/gtk/GtkWindow._setGravity: (JFF)V \
	Not found com/sun/glass/ui/gtk/GtkWindow.getFrameExtents: (J[I)V \
	Not found com/sun/glass/ui/gtk/GtkView.enableInputMethodEventsImpl: (JZ)V \
	Not found com/sun/glass/ui/gtk/GtkView._create: (Ljava/util/Map;)J \
	Not found com/sun/glass/ui/gtk/GtkView._getNativeView: (J)J \
	Not found com/sun/glass/ui/gtk/GtkView._getX: (J)I \
	Not found com/sun/glass/ui/gtk/GtkView._getY: (J)I \
	Not found com/sun/glass/ui/gtk/GtkView._setParent: (JJ)V \
	Not found com/sun/glass/ui/gtk/GtkView._close: (J)Z \
	Not found com/sun/glass/ui/gtk/GtkView._scheduleRepaint: (J)V \
	Not found com/sun/glass/ui/gtk/GtkView._uploadPixelsDirect: (JLjava/nio/Buffer;II)V \
	Not found com/sun/glass/ui/gtk/GtkView._uploadPixelsByteArray: (J[BIII)V \
	Not found com/sun/glass/ui/gtk/GtkView._uploadPixelsIntArray: (J[IIII)V \
	Not found com/sun/glass/ui/gtk/GtkView._enterFullscreen: (JZZZ)Z \
	Not found com/sun/glass/ui/gtk/GtkView._exitFullscreen: (JZ)V \
	Not found com/sun/glass/ui/gtk/GtkTimer._start: (Ljava/lang/Runnable;I)J \
	Not found com/sun/glass/ui/gtk/GtkTimer._stop: (J)V \
	Not found com/sun/glass/ui/gtk/GtkCommonDialogs._showFileChooser: (JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;IZ[Lcom/sun/glass/ui/CommonDialogs\$$ExtensionFilter;I)Lcom/sun/glass/ui/CommonDialogs\$$FileChooserResult; \
	Not found com/sun/glass/ui/gtk/GtkCommonDialogs._showFolderChooser: (JLjava/lang/String;Ljava/lang/String;)Ljava/lang/String; \
	Not found com/sun/glass/ui/gtk/GtkDnDClipboard.isOwner: ()Z \
	Not found com/sun/glass/ui/gtk/GtkDnDClipboard.pushToSystemImpl: (Ljava/util/HashMap;I)I \
	Not found com/sun/glass/ui/gtk/GtkDnDClipboard.pushTargetActionToSystem: (I)V \
	Not found com/sun/glass/ui/gtk/GtkDnDClipboard.popFromSystem: (Ljava/lang/String;)Ljava/lang/Object; \
	Not found com/sun/glass/ui/gtk/GtkDnDClipboard.supportedSourceActionsFromSystem: ()I \
	Not found com/sun/glass/ui/gtk/GtkDnDClipboard.mimesFromSystem: ()[Ljava/lang/String; \
	\
	Not found com/sun/prism/es2/X11GLContext.nInitialize: (JJZ)J \
	Not found com/sun/prism/es2/X11GLContext.nGetNativeHandle: (J)J \
	Not found com/sun/prism/es2/X11GLContext.nMakeCurrent: (JJ)V \
	Not found com/sun/prism/es2/X11GLPixelFormat.nCreatePixelFormat: (J[I)J \
	Not found com/sun/prism/es2/X11GLFactory.nInitialize: ([I)J \
	Not found com/sun/prism/es2/X11GLFactory.nGetAdapterOrdinal: (J)I \
	Not found com/sun/prism/es2/X11GLFactory.nGetAdapterCount: ()I \
	Not found com/sun/prism/es2/X11GLFactory.nGetDefaultScreen: (J)I \
	Not found com/sun/prism/es2/X11GLFactory.nGetDisplay: (J)J \
	Not found com/sun/prism/es2/X11GLFactory.nGetVisualID: (J)J \
	Not found com/sun/prism/es2/X11GLDrawable.nCreateDrawable: (JJ)J \
	Not found com/sun/prism/es2/X11GLDrawable.nGetDummyDrawable: (J)J \
	Not found com/sun/prism/es2/X11GLDrawable.nSwapBuffers: (J)Z \
	) \
	\
	Not used: \
	Not found com/sun/glass/ui/lens/LensApplication._notifyRenderingEnd: ()V \
	\
	__Uncomment_for_Lens__: \
	Not found com/sun/glass/ui/lens/LensView._paintInt: (JIILjava/nio/IntBuffer;[II)V \
	Not found com/sun/glass/ui/lens/LensView._paintByte: (JIILjava/nio/ByteBuffer;[BI)V \
	Not found com/sun/glass/ui/lens/LensView._paintIntDirect: (JIILjava/nio/Buffer;)V \
	Not found com/sun/glass/ui/lens/LensView._createNativeView: (Ljava/util/Map;)J \
	Not found com/sun/glass/ui/lens/LensView._begin: (J)V \
	Not found com/sun/glass/ui/lens/LensView._end: (J)V \
	Not found com/sun/glass/ui/lens/LensView._setParent: (JJ)V \
	Not found com/sun/glass/ui/lens/LensView._close: (J)Z \
	Not found com/sun/glass/ui/lens/LensView._enterFullscreen: (JZZZ)Z \
	Not found com/sun/glass/ui/lens/LensView._exitFullscreen: (JZ)V \
	Not found com/sun/glass/ui/lens/LensApplication.onload: ()V \
	Not found com/sun/glass/ui/lens/LensApplication._initIDs: ()V \
	Not found com/sun/glass/ui/lens/LensApplication._initialize: ()Z \
	Not found com/sun/glass/ui/lens/LensApplication._notifyRenderingEnd: ()V \
	Not found com/sun/glass/ui/lens/LensApplication.registerApplication: ()V \
	Not found com/sun/glass/ui/lens/LensApplication.nativeEventLoop: (Lcom/sun/glass/ui/lens/LensApplication;JJ)V \
	Not found com/sun/glass/ui/lens/LensApplication.shutdown: ()V \
	Not found com/sun/glass/ui/lens/LensApplication._notfyPlatformDnDStarted: ()V \
	Not found com/sun/glass/ui/lens/LensApplication._notfyPlatformDnDEnded: ()V \
	Not found com/sun/glass/ui/lens/LensApplication.staticScreen_getScreens: ()[Lcom/sun/glass/ui/Screen; \
	Not found com/sun/glass/ui/lens/LensApplication._getKeyCodeForChar: (C)I \
	Not found com/sun/glass/ui/lens/LensWindow._createWindow: (JJI)J \
	Not found com/sun/glass/ui/lens/LensWindow._createChildWindow: (J)J \
	Not found com/sun/glass/ui/lens/LensWindow._close: (J)Z \
	Not found com/sun/glass/ui/lens/LensWindow.attachViewToWindow: (JJ)Z \
	Not found com/sun/glass/ui/lens/LensWindow._getNativeWindowImpl: (J)J \
	Not found com/sun/glass/ui/lens/LensWindow._minimize: (JZ)Z \
	Not found com/sun/glass/ui/lens/LensWindow._maximize: (JZZ)Z \
	Not found com/sun/glass/ui/lens/LensWindow.setBoundsImpl: (JIIIIZZZ)V \
	Not found com/sun/glass/ui/lens/LensWindow._setVisible: (JZ)Z \
	Not found com/sun/glass/ui/lens/LensWindow._setResizable: (JZ)Z \
	Not found com/sun/glass/ui/lens/LensWindow._requestFocus: (JI)Z \
	Not found com/sun/glass/ui/lens/LensWindow._setFocusable: (JZ)V \
	Not found com/sun/glass/ui/lens/LensWindow._setTitle: (JLjava/lang/String;)Z \
	Not found com/sun/glass/ui/lens/LensWindow._setLevel: (JI)V \
	Not found com/sun/glass/ui/lens/LensWindow._setAlpha: (JF)V \
	Not found com/sun/glass/ui/lens/LensWindow._setBackground: (JFFF)Z \
	Not found com/sun/glass/ui/lens/LensWindow._setEnabled: (JZ)V \
	Not found com/sun/glass/ui/lens/LensWindow._setMinimumSize: (JII)Z \
	Not found com/sun/glass/ui/lens/LensWindow._setMaximumSize: (JII)Z \
	Not found com/sun/glass/ui/lens/LensWindow._setIcon: (JLcom/sun/glass/ui/Pixels;)V \
	Not found com/sun/glass/ui/lens/LensWindow._toFrontImpl: (J)V \
	Not found com/sun/glass/ui/lens/LensWindow._toBackImpl: (J)V \
	Not found com/sun/glass/ui/lens/LensWindow._grabFocus: (J)Z \
	Not found com/sun/glass/ui/lens/LensWindow._ungrabFocus: (J)V \
	Not found com/sun/glass/ui/lens/LensRobot.postScrollEvent: (I)V \
	Not found com/sun/glass/ui/lens/LensRobot.postKeyEvent: (II)V \
	Not found com/sun/glass/ui/lens/LensRobot.postMouseEvent: (IIII)V \
	Not found com/sun/glass/ui/lens/LensRobot.getMouseLocation: (I)I \
	Not found com/sun/glass/ui/lens/LensRobot._getPixelColor: (II)I \
	Not found com/sun/glass/ui/lens/LensRobot._getScreenCapture: (IIII[I)V \
	Not found com/sun/glass/ui/lens/LensPixels._copyPixels: (Ljava/nio/Buffer;Ljava/nio/Buffer;I)V \
	Not found com/sun/glass/ui/lens/LensCursor._setNativeCursor: (J)V \
	Not found com/sun/glass/ui/lens/LensCursor._releaseNativeCursor: (J)V \
	Not found com/sun/glass/ui/lens/LensCursor._createNativeCursorByType: (I)J \
	Not found com/sun/glass/ui/lens/LensCursor._createNativeCursorInts: (II[III)J \
	Not found com/sun/glass/ui/lens/LensCursor._createNativeCursorBytes: (II[BII)J \
	Not found com/sun/glass/ui/lens/LensCursor._createNativeCursorDirect: (IILjava/nio/Buffer;III)J \
	Not found com/sun/glass/ui/lens/LensCursor._setVisible: (Z)V \
	\
	Not found com/sun/glass/ui/monocle/mx6/MX6AcceleratedScreen._platformGetNativeWindow: (JJ)J \
	Not found com/sun/glass/ui/monocle/mx6/MX6AcceleratedScreen._platformGetNativeDisplay: (J)J \
	Not found com/sun/glass/ui/monocle/MX6AcceleratedScreen._platformGetNativeWindow: (JJ)J \
	Not found com/sun/glass/ui/monocle/MX6AcceleratedScreen._platformGetNativeDisplay: (J)J \
	Not found com/sun/glass/ui/monocle/dispman/DispmanScreen.wrapNativeSymbols: ()V \
	Not found com/sun/glass/ui/monocle/DispmanAcceleratedScreen._platformGetNativeWindow: (II)J \
	Not found com/sun/glass/ui/monocle/dispman/DispmanAcceleratedScreen._platformGetNativeWindow: (II)J \
	Not found com/sun/glass/ui/monocle/DispmanScreen.wrapNativeSymbols: ()V \
	Not found com/sun/glass/ui/monocle/DispmanCursor._initDispmanCursor: (II)V \
	Not found com/sun/glass/ui/monocle/DispmanCursor._setVisible: (Z)V \
	Not found com/sun/glass/ui/monocle/DispmanCursor._setLocation: (II)V \
	Not found com/sun/glass/ui/monocle/DispmanCursor._setImage: ([B)V \
	Not found com/sun/glass/ui/monocle/dispman/DispmanCursor._initDispmanCursor: (II)V \
	Not found com/sun/glass/ui/monocle/dispman/DispmanCursor._setVisible: (Z)V \
	Not found com/sun/glass/ui/monocle/dispman/DispmanCursor._setLocation: (II)V \
	Not found com/sun/glass/ui/monocle/dispman/DispmanCursor._setImage: ([B)V \
	\
	__Not_used_anywhere__: \
	Not found com/sun/glass/ui/monocle/EGL.loadFunctions: (J)V \
	Not found com/sun/glass/ui/monocle/EGL.eglContextFromConfig: (JJ)J \
	Not found com/sun/glass/ui/monocle/EGL.eglDestroyContext: (JJ)Z \
	Not found com/sun/glass/ui/monocle/EGL.eglGetConfigAttrib: (JJI[I)Z \
	Not found com/sun/glass/ui/monocle/EGL.eglQueryString: (JI)Ljava/lang/String; \
	Not found com/sun/glass/ui/monocle/EGL.eglQueryVersion: (JI)Ljava/lang/String; \
	\
	__Uncomment_for_$(__EGL)__: \
	$(if $(glass.platform.monocle),, \
	Not found com/sun/glass/ui/monocle/EGL.eglBindAPI: (I)Z \
	Not found com/sun/glass/ui/monocle/EGL.eglChooseConfig: (J[I[JI[I)Z \
	Not found com/sun/glass/ui/monocle/EGL._eglCreateWindowSurface: (JJJ[I)J \
	Not found com/sun/glass/ui/monocle/EGL.eglGetDisplay: (J)J \
	Not found com/sun/glass/ui/monocle/EGL.eglGetError: ()I \
	Not found com/sun/glass/ui/monocle/EGL.eglInitialize: (J[I[I)Z \
	Not found com/sun/glass/ui/monocle/EGL.eglMakeCurrent: (JJJJ)Z \
	Not found com/sun/glass/ui/monocle/EGL.eglCreateContext: (JJJ[I)J \
	Not found com/sun/glass/ui/monocle/EGL.eglSwapBuffers: (JJ)Z \
	) \
	\
	__Not_used_anywhere__: \
	Not found com/sun/prism/es2/MonocleGLFactory.nInitialize: ([I)J \
	\
	__Uncomment_for_$(__EGL)__: \
	$(if $(glass.platform.monocle),, \
	Not found com/sun/prism/es2/MonocleGLFactory.nPopulateNativeCtxInfo: (J)J \
	Not found com/sun/prism/es2/MonocleGLFactory.nGetAdapterOrdinal: (J)I \
	Not found com/sun/prism/es2/MonocleGLFactory.nGetAdapterCount: ()I \
	Not found com/sun/prism/es2/MonocleGLFactory.nGetDefaultScreen: (J)I \
	Not found com/sun/prism/es2/MonocleGLFactory.nGetDisplay: (J)J \
	Not found com/sun/prism/es2/MonocleGLFactory.nGetVisualID: (J)J \
	Not found com/sun/prism/es2/MonocleGLFactory.nGetIsGL2: (J)Z \
	) \
	\
	__Uncomment_for_$(__EGL)__: \
	$(if $(glass.platform.monocle),, \
	Not found com/sun/glass/ui/monocle/Udev._open: ()J \
	Not found com/sun/glass/ui/monocle/Udev._readEvent: (JLjava/nio/ByteBuffer;)I \
	Not found com/sun/glass/ui/monocle/Udev._close: (J)V \
	Not found com/sun/glass/ui/monocle/Udev._getPropertiesOffset: (Ljava/nio/ByteBuffer;)I \
	Not found com/sun/glass/ui/monocle/Udev._getPropertiesLength: (Ljava/nio/ByteBuffer;)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem.setenv: (Ljava/lang/String;Ljava/lang/String;Z)V \
	Not found com/sun/glass/ui/monocle/LinuxSystem.open: (Ljava/lang/String;I)J \
	Not found com/sun/glass/ui/monocle/LinuxSystem.close: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem.lseek: (JJI)J \
	Not found com/sun/glass/ui/monocle/LinuxSystem.write: (JLjava/nio/ByteBuffer;II)J \
	Not found com/sun/glass/ui/monocle/LinuxSystem.read: (JLjava/nio/ByteBuffer;II)J \
	Not found com/sun/glass/ui/monocle/LinuxSystem.sysconf: (I)J \
	Not found com/sun/glass/ui/monocle/LinuxSystem.EVIOCGABS: (I)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem.ioctl: (JIJ)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem.IOW: (III)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem.IOR: (III)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem.IOWR: (III)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem.errno: ()I \
	Not found com/sun/glass/ui/monocle/LinuxSystem.strerror: (I)Ljava/lang/String; \
	Not found com/sun/glass/ui/monocle/LinuxSystem.dlopen: (Ljava/lang/String;I)J \
	Not found com/sun/glass/ui/monocle/LinuxSystem.dlerror: ()Ljava/lang/String; \
	Not found com/sun/glass/ui/monocle/LinuxSystem.dlsym: (JLjava/lang/String;)J \
	Not found com/sun/glass/ui/monocle/LinuxSystem.dlclose: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem.mmap: (JJJJJJ)J \
	Not found com/sun/glass/ui/monocle/LinuxSystem.munmap: (JJ)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem.memcpy: (JJJ)J \
	Not found com/sun/glass/ui/monocle/LinuxSystem.mkfifo: (Ljava/lang/String;I)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.sizeof: ()I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.getBitsPerPixel: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.getXRes: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.getYRes: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.getXResVirtual: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.getYResVirtual: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.getOffsetX: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.getOffsetY: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.setRes: (JII)V \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.setVirtualRes: (JII)V \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.setOffset: (JII)V \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.setActivate: (JI)V \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.setBitsPerPixel: (JI)V \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.setRed: (JII)V \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.setGreen: (JII)V \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.setBlue: (JII)V \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$FbVarScreenInfo.setTransp: (JII)V \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$InputAbsInfo.sizeof: ()I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$InputAbsInfo.getValue: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$InputAbsInfo.getMinimum: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$InputAbsInfo.getMaximum: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$InputAbsInfo.getFuzz: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$InputAbsInfo.getFlat: (J)I \
	Not found com/sun/glass/ui/monocle/LinuxSystem\$$InputAbsInfo.getResolution: (J)I \
	) \
	\
	Not found com/sun/glass/ui/monocle/linux/Udev._open: ()J \
	Not found com/sun/glass/ui/monocle/linux/Udev._readEvent: (JLjava/nio/ByteBuffer;)I \
	Not found com/sun/glass/ui/monocle/linux/Udev._close: (J)V \
	Not found com/sun/glass/ui/monocle/linux/Udev._getPropertiesOffset: (Ljava/nio/ByteBuffer;)I \
	Not found com/sun/glass/ui/monocle/linux/Udev._getPropertiesLength: (Ljava/nio/ByteBuffer;)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.setenv: (Ljava/lang/String;Ljava/lang/String;Z)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.open: (Ljava/lang/String;I)J \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.close: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.lseek: (JJI)J \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.write: (JLjava/nio/ByteBuffer;II)J \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.read: (JLjava/nio/ByteBuffer;II)J \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.EVIOCGABS: (I)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.ioctl: (JIJ)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.IOW: (III)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.IOR: (III)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.IOWR: (III)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.errno: ()I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.strerror: (I)Ljava/lang/String; \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.dlopen: (Ljava/lang/String;I)J \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.dlerror: ()Ljava/lang/String; \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.dlsym: (JLjava/lang/String;)J \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.dlclose: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.mmap: (JJJJJJ)J \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.munmap: (JJ)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.memcpy: (JJJ)J \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem.mkfifo: (Ljava/lang/String;I)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.sizeof: ()I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getBitsPerPixel: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getXRes: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getYRes: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getXResVirtual: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getYResVirtual: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getOffsetX: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getOffsetY: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setRes: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setVirtualRes: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setOffset: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setActivate: (JI)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setBitsPerPixel: (JI)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setRed: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setGreen: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setBlue: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setTransp: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.sizeof: ()I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.getValue: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.getMinimum: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.getMaximum: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.getFuzz: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.getFlat: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.getResolution: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.sizeof: ()I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getBitsPerPixel: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getXRes: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getYRes: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getXResVirtual: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getYResVirtual: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getOffsetX: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.getOffsetY: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setRes: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setVirtualRes: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setOffset: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setActivate: (JI)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setBitsPerPixel: (JI)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setRed: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setGreen: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setBlue: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$FbVarScreenInfo.setTransp: (JII)V \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.sizeof: ()I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.getValue: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.getMinimum: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.getMaximum: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.getFuzz: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.getFlat: (J)I \
	Not found com/sun/glass/ui/monocle/linux/LinuxSystem\$$InputAbsInfo.getResolution: (J)I \
	\
	__Uncomment_for_Monocle_and_Lens__: \
	$(if $(glass.platform.lens)$(glass.platform.monocle),, \
	Not found com/sun/glass/ui/monocle/C.NewDirectByteBuffer: (JI)Ljava/nio/ByteBuffer; \
	Not found com/sun/glass/ui/monocle/C.GetDirectBufferAddress: (Ljava/nio/ByteBuffer;)J \
	Not found com/sun/glass/ui/monocle/X.XInitThreads: ()Z \
	Not found com/sun/glass/ui/monocle/X.XLockDisplay: (J)V \
	Not found com/sun/glass/ui/monocle/X.XUnlockDisplay: (J)V \
	Not found com/sun/glass/ui/monocle/X.XOpenDisplay: (Ljava/lang/String;)J \
	Not found com/sun/glass/ui/monocle/X.DefaultScreenOfDisplay: (J)J \
	Not found com/sun/glass/ui/monocle/X.RootWindowOfScreen: (JJ)J \
	Not found com/sun/glass/ui/monocle/X.WidthOfScreen: (J)I \
	Not found com/sun/glass/ui/monocle/X.HeightOfScreen: (J)I \
	Not found com/sun/glass/ui/monocle/X.XCreateWindow: (JJIIIIIIIJJJ)J \
	Not found com/sun/glass/ui/monocle/X.XMapWindow: (JJ)V \
	Not found com/sun/glass/ui/monocle/X.XStoreName: (JJLjava/lang/String;)V \
	Not found com/sun/glass/ui/monocle/X.XSync: (JZ)V \
	Not found com/sun/glass/ui/monocle/X.XGetGeometry: (JJ[J[I[I[I[I[I[I)V \
	Not found com/sun/glass/ui/monocle/X.XNextEvent: (JJ)V \
	Not found com/sun/glass/ui/monocle/X.XInternAtom: (JLjava/lang/String;Z)J \
	Not found com/sun/glass/ui/monocle/X.XSendEvent: (JJZJJ)V \
	Not found com/sun/glass/ui/monocle/X.XGrabKeyboard: (JJZJJJ)V \
	Not found com/sun/glass/ui/monocle/X.XWarpPointer: (JJJIIIIII)V \
	Not found com/sun/glass/ui/monocle/X.XFlush: (J)V \
	Not found com/sun/glass/ui/monocle/X.XQueryPointer: (JJ[I)V \
	Not found com/sun/glass/ui/monocle/X.XCreateBitmapFromData: (JJLjava/nio/ByteBuffer;II)J \
	Not found com/sun/glass/ui/monocle/X.XCreatePixmapCursor: (JJJJJII)J \
	Not found com/sun/glass/ui/monocle/X.XFreePixmap: (JJ)V \
	Not found com/sun/glass/ui/monocle/X.XDefineCursor: (JJJ)V \
	Not found com/sun/glass/ui/monocle/X.XUndefineCursor: (JJ)V \
	Not found com/sun/glass/ui/monocle/X\$$XColor.setRed: (JI)V \
	Not found com/sun/glass/ui/monocle/X\$$XColor.setGreen: (JI)V \
	Not found com/sun/glass/ui/monocle/X\$$XColor.setBlue: (JI)V \
	Not found com/sun/glass/ui/monocle/X\$$XColor.sizeof: ()I \
	Not found com/sun/glass/ui/monocle/X\$$XDisplay.sizeof: ()I \
	Not found com/sun/glass/ui/monocle/X\$$XClientMessageEvent.setMessageType: (JJ)V \
	Not found com/sun/glass/ui/monocle/X\$$XClientMessageEvent.setFormat: (JJ)V \
	Not found com/sun/glass/ui/monocle/X\$$XClientMessageEvent.setDataLong: (JIJ)V \
	Not found com/sun/glass/ui/monocle/X\$$XMotionEvent.getX: (J)I \
	Not found com/sun/glass/ui/monocle/X\$$XMotionEvent.getY: (J)I \
	Not found com/sun/glass/ui/monocle/X\$$XButtonEvent.getButton: (J)I \
	Not found com/sun/glass/ui/monocle/X\$$XEvent.sizeof: ()I \
	Not found com/sun/glass/ui/monocle/X\$$XEvent.getType: (J)I \
	Not found com/sun/glass/ui/monocle/X\$$XEvent.getWindow: (J)J \
	Not found com/sun/glass/ui/monocle/X\$$XEvent.setWindow: (JJ)V \
	Not found com/sun/glass/ui/monocle/X\$$XSetWindowAttributes.sizeof: ()I \
	Not found com/sun/glass/ui/monocle/X\$$XSetWindowAttributes.setEventMask: (JJ)V \
	Not found com/sun/glass/ui/monocle/X\$$XSetWindowAttributes.setCursor: (JJ)V \
	Not found com/sun/glass/ui/monocle/X\$$XSetWindowAttributes.setOverrideRedirect: (JZ)V \
	) \
	\
	Not found com/sun/prism/es2/EGLFBGLContext.nInitialize: (JJZ)J \
	Not found com/sun/prism/es2/EGLFBGLContext.nGetNativeHandle: (J)J \
	Not found com/sun/prism/es2/EGLFBGLContext.nMakeCurrent: (JJ)V \
	Not found com/sun/prism/es2/EGLX11GLDrawable.nCreateDrawable: (JJ)J \
	Not found com/sun/prism/es2/EGLX11GLDrawable.nGetDummyDrawable: (J)J \
	Not found com/sun/prism/es2/EGLX11GLDrawable.nSwapBuffers: (J)Z \
	Not found com/sun/prism/es2/EGLX11GLContext.nInitialize: (JJZ)J \
	Not found com/sun/prism/es2/EGLX11GLContext.nGetNativeHandle: (J)J \
	Not found com/sun/prism/es2/EGLX11GLContext.nMakeCurrent: (JJ)V \
	Not found com/sun/prism/es2/EGLX11GLPixelFormat.nCreatePixelFormat: (J[I)J \
	Not found com/sun/prism/es2/EGLFBGLFactory.nInitialize: ([I)J \
	Not found com/sun/prism/es2/EGLFBGLFactory.nGetAdapterOrdinal: (J)I \
	Not found com/sun/prism/es2/EGLFBGLFactory.nGetAdapterCount: ()I \
	Not found com/sun/prism/es2/EGLFBGLFactory.nGetDefaultScreen: (J)I \
	Not found com/sun/prism/es2/EGLFBGLFactory.nGetDisplay: (J)J \
	Not found com/sun/prism/es2/EGLFBGLFactory.nGetVisualID: (J)J \
	Not found com/sun/prism/es2/EGLFBGLFactory.nGetIsGL2: (J)Z \
	Not found com/sun/prism/es2/EGLFBGLPixelFormat.nCreatePixelFormat: (J[I)J \
	Not found com/sun/prism/es2/EGLX11GLFactory.nInitialize: ([I)J \
	Not found com/sun/prism/es2/EGLX11GLFactory.nGetAdapterOrdinal: (J)I \
	Not found com/sun/prism/es2/EGLX11GLFactory.nGetAdapterCount: ()I \
	Not found com/sun/prism/es2/EGLX11GLFactory.nGetDefaultScreen: (J)I \
	Not found com/sun/prism/es2/EGLX11GLFactory.nGetDisplay: (J)J \
	Not found com/sun/prism/es2/EGLX11GLFactory.nGetVisualID: (J)J \
	Not found com/sun/prism/es2/EGLX11GLFactory.nGetIsGL2: (J)Z \
	Not found com/sun/prism/es2/EGLX11GLFactory.nSetDebug: (Z)V \
	Not found com/sun/prism/es2/EGLFBGLDrawable.nCreateDrawable: (JJ)J \
	Not found com/sun/prism/es2/EGLFBGLDrawable.nGetDummyDrawable: (J)J \
	Not found com/sun/prism/es2/EGLFBGLDrawable.nSwapBuffers: (J)Z \
	\
	Not found com/sun/prism/d3d/D3DPipeline.nInit: (Ljava/lang/Class;)Z \
	Not found com/sun/prism/d3d/D3DPipeline.nGetErrorMessage: ()Ljava/lang/String; \
	Not found com/sun/prism/d3d/D3DPipeline.nDispose: ()V \
	Not found com/sun/prism/d3d/D3DPipeline.nGetAdapterOrdinal: (J)I \
	Not found com/sun/prism/d3d/D3DPipeline.nGetAdapterCount: ()I \
	Not found com/sun/prism/d3d/D3DPipeline.nGetDriverInformation: (ILcom/sun/prism/d3d/D3DDriverInformation;)Lcom/sun/prism/d3d/D3DDriverInformation; \
	Not found com/sun/prism/d3d/D3DPipeline.nGetMaxSampleSupport: (I)I \
	Not found com/sun/prism/d3d/D3DShader.init: (JLjava/nio/ByteBuffer;IZZ)J \
	Not found com/sun/prism/d3d/D3DShader.enable: (JJ)I \
	Not found com/sun/prism/d3d/D3DShader.disable: (JJ)I \
	Not found com/sun/prism/d3d/D3DShader.setConstantsF: (JJILjava/nio/FloatBuffer;II)I \
	Not found com/sun/prism/d3d/D3DShader.setConstantsI: (JJILjava/nio/IntBuffer;II)I \
	Not found com/sun/prism/d3d/D3DShader.nGetRegister: (JJLjava/lang/String;)I \
	Not found com/sun/prism/d3d/D3DSwapChain.nPresent: (JJ)I \
	Not found com/sun/prism/d3d/D3DGraphics.nClear: (JIZZ)I \
	Not found com/sun/prism/d3d/D3DVertexBuffer.nDrawIndexedQuads: (J[F[BI)I \
	Not found com/sun/prism/d3d/D3DVertexBuffer.nDrawTriangleList: (J[F[BI)I \
	Not found com/sun/prism/d3d/D3DResourceFactory.nCreateTexture: (JIIZIIIZ)J \
	Not found com/sun/prism/d3d/D3DResourceFactory.nGetContext: (I)J \
	Not found com/sun/prism/d3d/D3DResourceFactory.nIsDefaultPool: (J)Z \
	Not found com/sun/prism/d3d/D3DResourceFactory.nTestCooperativeLevel: (J)I \
	Not found com/sun/prism/d3d/D3DResourceFactory.nResetDevice: (J)I \
	Not found com/sun/prism/d3d/D3DResourceFactory.nCreateTexture: (JIIZIII)J \
	Not found com/sun/prism/d3d/D3DResourceFactory.nCreateSwapChain: (JJZ)J \
	Not found com/sun/prism/d3d/D3DResourceFactory.nReleaseResource: (JJ)I \
	Not found com/sun/prism/d3d/D3DResourceFactory.nGetMaximumTextureSize: (J)I \
	Not found com/sun/prism/d3d/D3DResourceFactory.nGetTextureWidth: (J)I \
	Not found com/sun/prism/d3d/D3DResourceFactory.nGetTextureHeight: (J)I \
	Not found com/sun/prism/d3d/D3DResourceFactory.nReadPixelsI: (JJJLjava/nio/Buffer;[III)I \
	Not found com/sun/prism/d3d/D3DResourceFactory.nReadPixelsB: (JJJLjava/nio/Buffer;[BII)I \
	Not found com/sun/prism/d3d/D3DResourceFactory.nUpdateTextureI: (JJLjava/nio/IntBuffer;[IIIIIIII)I \
	Not found com/sun/prism/d3d/D3DResourceFactory.nUpdateTextureF: (JJLjava/nio/FloatBuffer;[FIIIIIII)I \
	Not found com/sun/prism/d3d/D3DResourceFactory.nUpdateTextureB: (JJLjava/nio/ByteBuffer;[BIIIIIIII)I \
	Not found com/sun/prism/d3d/D3DResourceFactory.nGetDevice: (J)J \
	Not found com/sun/prism/d3d/D3DResourceFactory.nGetNativeTextureObject: (J)J \
	Not found com/sun/prism/d3d/D3DContext.nSetRenderTarget: (JJZZ)I \
	Not found com/sun/prism/d3d/D3DContext.nSetTexture: (JJIZI)I \
	Not found com/sun/prism/d3d/D3DContext.nResetTransform: (J)I \
	Not found com/sun/prism/d3d/D3DContext.nSetTransform: (JDDDDDDDDDDDDDDDD)I \
	Not found com/sun/prism/d3d/D3DContext.nSetWorldTransformToIdentity: (J)V \
	Not found com/sun/prism/d3d/D3DContext.nSetWorldTransform: (JDDDDDDDDDDDDDDDD)V \
	Not found com/sun/prism/d3d/D3DContext.nSetCameraPosition: (JDDD)I \
	Not found com/sun/prism/d3d/D3DContext.nSetProjViewMatrix: (JZDDDDDDDDDDDDDDDD)I \
	Not found com/sun/prism/d3d/D3DContext.nResetClipRect: (J)I \
	Not found com/sun/prism/d3d/D3DContext.nSetClipRect: (JIIII)I \
	Not found com/sun/prism/d3d/D3DContext.nSetBlendEnabled: (JI)I \
	Not found com/sun/prism/d3d/D3DContext.nSetDeviceParametersFor2D: (J)I \
	Not found com/sun/prism/d3d/D3DContext.nSetDeviceParametersFor3D: (J)I \
	Not found com/sun/prism/d3d/D3DContext.nCreateD3DMesh: (J)J \
	Not found com/sun/prism/d3d/D3DContext.nReleaseD3DMesh: (JJ)V \
	Not found com/sun/prism/d3d/D3DContext.nBuildNativeGeometryShort: (JJ[FI[SI)Z \
	Not found com/sun/prism/d3d/D3DContext.nBuildNativeGeometryInt: (JJ[FI[II)Z \
	Not found com/sun/prism/d3d/D3DContext.nCreateD3DPhongMaterial: (J)J \
	Not found com/sun/prism/d3d/D3DContext.nReleaseD3DPhongMaterial: (JJ)V \
	Not found com/sun/prism/d3d/D3DContext.nSetDiffuseColor: (JJFFFF)V \
	Not found com/sun/prism/d3d/D3DContext.nSetSpecularColor: (JJZFFFF)V \
	Not found com/sun/prism/d3d/D3DContext.nSetMap: (JJIJ)V \
	Not found com/sun/prism/d3d/D3DContext.nCreateD3DMeshView: (JJ)J \
	Not found com/sun/prism/d3d/D3DContext.nReleaseD3DMeshView: (JJ)V \
	Not found com/sun/prism/d3d/D3DContext.nSetCullingMode: (JJI)V \
	Not found com/sun/prism/d3d/D3DContext.nSetMaterial: (JJJ)V \
	Not found com/sun/prism/d3d/D3DContext.nSetWireframe: (JJZ)V \
	Not found com/sun/prism/d3d/D3DContext.nSetAmbientLight: (JJFFF)V \
	Not found com/sun/prism/d3d/D3DContext.nSetPointLight: (JJIFFFFFFF)V \
	Not found com/sun/prism/d3d/D3DContext.nRenderMeshView: (JJ)V \
	Not found com/sun/prism/d3d/D3DContext.nBlit: (JJJIIIIIIII)V \
	Not found com/sun/prism/d3d/D3DContext.nGetFrameStats: (JLcom/sun/prism/d3d/D3DFrameStats;Z)Z \
	Not found com/sun/prism/d3d/D3DContext.nIsRTTVolatile: (J)Z \
	\
	Not found com/sun/javafx/font/coretext/OS.CGBitmapContextGetData: (JIII)[B \
	Not found com/sun/javafx/font/coretext/OS.CGRectApplyAffineTransform: (Lcom/sun/javafx/font/coretext/CGRect;Lcom/sun/javafx/font/coretext/CGAffineTransform;)V \
	Not found com/sun/javafx/font/coretext/OS.CGPathApply: (J)Lcom/sun/javafx/geom/Path2D; \
	Not found com/sun/javafx/font/coretext/OS.CGPathGetPathBoundingBox: (J)Lcom/sun/javafx/font/coretext/CGRect; \
	Not found com/sun/javafx/font/coretext/OS.CFStringCreateWithCharacters: (J[CJJ)J \
	Not found com/sun/javafx/font/coretext/OS.CTFontCopyAttributeDisplayName: (J)Ljava/lang/String; \
	Not found com/sun/javafx/font/coretext/OS.CTFontDrawGlyphs: (JSDDJ)V \
	Not found com/sun/javafx/font/coretext/OS.CTFontGetAdvancesForGlyphs: (JISLcom/sun/javafx/font/coretext/CGSize;)D \
	Not found com/sun/javafx/font/coretext/OS.CTFontGetBoundingRectForGlyphUsingTables: (JSS[I)Z \
	Not found com/sun/javafx/font/coretext/OS.CTRunGetGlyphs: (JII[I)I \
	Not found com/sun/javafx/font/coretext/OS.CTRunGetStringIndices: (JI[I)I \
	Not found com/sun/javafx/font/coretext/OS.CTRunGetPositions: (JI[F)I \
	Not found com/sun/javafx/font/coretext/OS.kCFAllocatorDefault: ()J \
	Not found com/sun/javafx/font/coretext/OS.kCFTypeDictionaryKeyCallBacks: ()J \
	Not found com/sun/javafx/font/coretext/OS.kCFTypeDictionaryValueCallBacks: ()J \
	Not found com/sun/javafx/font/coretext/OS.kCTFontAttributeName: ()J \
	Not found com/sun/javafx/font/coretext/OS.kCTParagraphStyleAttributeName: ()J \
	Not found com/sun/javafx/font/coretext/OS.CFArrayGetCount: (J)J \
	Not found com/sun/javafx/font/coretext/OS.CFArrayGetValueAtIndex: (JJ)J \
	Not found com/sun/javafx/font/coretext/OS.CFAttributedStringCreate: (JJJ)J \
	Not found com/sun/javafx/font/coretext/OS.CFDictionaryAddValue: (JJJ)V \
	Not found com/sun/javafx/font/coretext/OS.CFDictionaryCreateMutable: (JJJJ)J \
	Not found com/sun/javafx/font/coretext/OS.CFDictionaryGetValue: (JJ)J \
	Not found com/sun/javafx/font/coretext/OS.CFRelease: (J)V \
	Not found com/sun/javafx/font/coretext/OS.CFStringCreateWithCharacters: (J[CJ)J \
	Not found com/sun/javafx/font/coretext/OS.CFURLCreateWithFileSystemPath: (JJJZ)J \
	Not found com/sun/javafx/font/coretext/OS.CGBitmapContextCreate: (JJJJJJI)J \
	Not found com/sun/javafx/font/coretext/OS.CGContextFillRect: (JLcom/sun/javafx/font/coretext/CGRect;)V \
	Not found com/sun/javafx/font/coretext/OS.CGContextRelease: (J)V \
	Not found com/sun/javafx/font/coretext/OS.CGContextSetAllowsFontSmoothing: (JZ)V \
	Not found com/sun/javafx/font/coretext/OS.CGContextSetAllowsAntialiasing: (JZ)V \
	Not found com/sun/javafx/font/coretext/OS.CGContextSetAllowsFontSubpixelPositioning: (JZ)V \
	Not found com/sun/javafx/font/coretext/OS.CGContextSetAllowsFontSubpixelQuantization: (JZ)V \
	Not found com/sun/javafx/font/coretext/OS.CGContextSetRGBFillColor: (JDDDD)V \
	Not found com/sun/javafx/font/coretext/OS.CGContextTranslateCTM: (JDD)V \
	Not found com/sun/javafx/font/coretext/OS.CGColorSpaceCreateDeviceGray: ()J \
	Not found com/sun/javafx/font/coretext/OS.CGColorSpaceCreateDeviceRGB: ()J \
	Not found com/sun/javafx/font/coretext/OS.CGColorSpaceRelease: (J)V \
	Not found com/sun/javafx/font/coretext/OS.CGPathRelease: (J)V \
	Not found com/sun/javafx/font/coretext/OS.CTFontCreateWithName: (JDLcom/sun/javafx/font/coretext/CGAffineTransform;)J \
	Not found com/sun/javafx/font/coretext/OS.CTFontCreatePathForGlyph: (JSLcom/sun/javafx/font/coretext/CGAffineTransform;)J \
	Not found com/sun/javafx/font/coretext/OS.CTFontManagerRegisterFontsForURL: (JIJ)Z \
	Not found com/sun/javafx/font/coretext/OS.CTLineCreateWithAttributedString: (J)J \
	Not found com/sun/javafx/font/coretext/OS.CTLineGetGlyphRuns: (J)J \
	Not found com/sun/javafx/font/coretext/OS.CTLineGetGlyphCount: (J)J \
	Not found com/sun/javafx/font/coretext/OS.CTLineGetTypographicBounds: (J)D \
	Not found com/sun/javafx/font/coretext/OS.CTRunGetGlyphCount: (J)J \
	Not found com/sun/javafx/font/coretext/OS.CTRunGetAttributes: (J)J \
	Not found com/sun/javafx/font/coretext/OS.CTParagraphStyleCreate: (I)J \
	Not found com/sun/javafx/font/FontConfigManager.getFontConfig: (Ljava/lang/String;[Lcom/sun/javafx/font/FontConfigManager\$$FcCompFont;Z)Z \
	Not found com/sun/javafx/font/FontConfigManager.populateMapsNative: (Ljava/util/HashMap;Ljava/util/HashMap;Ljava/util/HashMap;Ljava/util/Locale;)Z \
	Not found com/sun/javafx/font/directwrite/OS._DWriteCreateFactory: (I)J \
	Not found com/sun/javafx/font/directwrite/OS._D2D1CreateFactory: (I)J \
	Not found com/sun/javafx/font/directwrite/OS._WICCreateImagingFactory: ()J \
	Not found com/sun/javafx/font/directwrite/OS._NewJFXTextAnalysisSink: ([CII[CIJ)J \
	Not found com/sun/javafx/font/directwrite/OS._NewJFXTextRenderer: ()J \
	Not found com/sun/javafx/font/directwrite/OS.Next: (J)Z \
	Not found com/sun/javafx/font/directwrite/OS.GetStart: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.GetLength: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.GetAnalysis: (J)Lcom/sun/javafx/font/directwrite/DWRITE_SCRIPT_ANALYSIS; \
	Not found com/sun/javafx/font/directwrite/OS.JFXTextRendererNext: (J)Z \
	Not found com/sun/javafx/font/directwrite/OS.JFXTextRendererGetStart: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.JFXTextRendererGetLength: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.JFXTextRendererGetGlyphCount: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.JFXTextRendererGetTotalGlyphCount: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.JFXTextRendererGetFontFace: (J)J \
	Not found com/sun/javafx/font/directwrite/OS.JFXTextRendererGetGlyphIndices: (J[III)I \
	Not found com/sun/javafx/font/directwrite/OS.JFXTextRendererGetGlyphAdvances: (J[FI)I \
	Not found com/sun/javafx/font/directwrite/OS.JFXTextRendererGetGlyphOffsets: (J[FI)I \
	Not found com/sun/javafx/font/directwrite/OS.JFXTextRendererGetClusterMap: (J[SII)I \
	Not found com/sun/javafx/font/directwrite/OS.GetDesignGlyphMetrics: (JSZ)Lcom/sun/javafx/font/directwrite/DWRITE_GLYPH_METRICS; \
	Not found com/sun/javafx/font/directwrite/OS.GetGlyphRunOutline: (JFSZ)Lcom/sun/javafx/geom/Path2D; \
	Not found com/sun/javafx/font/directwrite/OS.CreateFontFace: (J)J \
	Not found com/sun/javafx/font/directwrite/OS.GetFaceNames: (J)J \
	Not found com/sun/javafx/font/directwrite/OS.GetFontFamily: (J)J \
	Not found com/sun/javafx/font/directwrite/OS.GetStretch: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.GetStyle: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.GetWeight: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.GetInformationalStrings: (JI)J \
	Not found com/sun/javafx/font/directwrite/OS.GetSimulations: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.GetFontCount: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.GetFont: (JI)J \
	Not found com/sun/javafx/font/directwrite/OS.Analyze: (J[Z[I[I[I)I \
	Not found com/sun/javafx/font/directwrite/OS.GetString: (JII)[C \
	Not found com/sun/javafx/font/directwrite/OS.GetStringLength: (JI)I \
	Not found com/sun/javafx/font/directwrite/OS.FindLocaleName: (J[C)I \
	Not found com/sun/javafx/font/directwrite/OS.GetFamilyNames: (J)J \
	Not found com/sun/javafx/font/directwrite/OS.GetFirstMatchingFont: (JIII)J \
	Not found com/sun/javafx/font/directwrite/OS.GetFontFamilyCount: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.GetFontFamily: (JI)J \
	Not found com/sun/javafx/font/directwrite/OS.FindFamilyName: (J[C)I \
	Not found com/sun/javafx/font/directwrite/OS.GetFontFromFontFace: (JJ)J \
	Not found com/sun/javafx/font/directwrite/OS.CreateAlphaTexture: (JILcom/sun/javafx/font/directwrite/RECT;)[B \
	Not found com/sun/javafx/font/directwrite/OS.GetAlphaTextureBounds: (JI)Lcom/sun/javafx/font/directwrite/RECT; \
	Not found com/sun/javafx/font/directwrite/OS.GetSystemFontCollection: (JZ)J \
	Not found com/sun/javafx/font/directwrite/OS.CreateGlyphRunAnalysis: (JLcom/sun/javafx/font/directwrite/DWRITE_GLYPH_RUN;FLcom/sun/javafx/font/directwrite/DWRITE_MATRIX;IIFF)J \
	Not found com/sun/javafx/font/directwrite/OS.CreateTextAnalyzer: (J)J \
	Not found com/sun/javafx/font/directwrite/OS.CreateTextFormat: (J[CJIIIF[C)J \
	Not found com/sun/javafx/font/directwrite/OS.CreateTextLayout: (J[CIIJFF)J \
	Not found com/sun/javafx/font/directwrite/OS.CreateFontFileReference: (J[C)J \
	Not found com/sun/javafx/font/directwrite/OS.CreateFontFace: (JIJII)J \
	Not found com/sun/javafx/font/directwrite/OS.AddRef: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.Release: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.AnalyzeScript: (JJIIJ)I \
	Not found com/sun/javafx/font/directwrite/OS.GetGlyphs: (J[CIIJZZLcom/sun/javafx/font/directwrite/DWRITE_SCRIPT_ANALYSIS;[CJ[J[III[S[S[S[S[I)I \
	Not found com/sun/javafx/font/directwrite/OS.GetGlyphPlacements: (J[C[S[SII[S[SIJFZZLcom/sun/javafx/font/directwrite/DWRITE_SCRIPT_ANALYSIS;[C[J[II[F[F)I \
	Not found com/sun/javafx/font/directwrite/OS.Draw: (JJJFF)I \
	Not found com/sun/javafx/font/directwrite/OS.CreateBitmap: (JIIII)J \
	Not found com/sun/javafx/font/directwrite/OS.Lock: (JIIIII)J \
	Not found com/sun/javafx/font/directwrite/OS.GetDataPointer: (J)[B \
	Not found com/sun/javafx/font/directwrite/OS.GetStride: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.CreateWicBitmapRenderTarget: (JJLcom/sun/javafx/font/directwrite/D2D1_RENDER_TARGET_PROPERTIES;)J \
	Not found com/sun/javafx/font/directwrite/OS.BeginDraw: (J)V \
	Not found com/sun/javafx/font/directwrite/OS.EndDraw: (J)I \
	Not found com/sun/javafx/font/directwrite/OS.Clear: (JLcom/sun/javafx/font/directwrite/D2D1_COLOR_F;)V \
	Not found com/sun/javafx/font/directwrite/OS.SetTextAntialiasMode: (JI)V \
	Not found com/sun/javafx/font/directwrite/OS.SetTransform: (JLcom/sun/javafx/font/directwrite/D2D1_MATRIX_3X2_F;)V \
	Not found com/sun/javafx/font/directwrite/OS.DrawGlyphRun: (JLcom/sun/javafx/font/directwrite/D2D1_POINT_2F;Lcom/sun/javafx/font/directwrite/DWRITE_GLYPH_RUN;JI)V \
	Not found com/sun/javafx/font/directwrite/OS.CreateSolidColorBrush: (JLcom/sun/javafx/font/directwrite/D2D1_COLOR_F;)J \
	Not found com/sun/javafx/font/PrismFontFactory.getFontPath: ()[B \
	Not found com/sun/javafx/font/PrismFontFactory.regReadFontLink: (Ljava/lang/String;)Ljava/lang/String; \
	Not found com/sun/javafx/font/PrismFontFactory.getEUDCFontFile: ()Ljava/lang/String; \
	Not found com/sun/javafx/font/PrismFontFactory.populateFontFileNameMap: (Ljava/util/HashMap;Ljava/util/HashMap;Ljava/util/HashMap;Ljava/util/Locale;)V \
	Not found com/sun/javafx/font/PrismFontFactory.getLCDContrastWin32: ()I \
	Not found com/sun/javafx/font/PrismFontFactory.getSystemFontSizeNative: ()I \
	Not found com/sun/javafx/font/PrismFontFactory.getSystemFontNative: ()Ljava/lang/String; \
	Not found com/sun/javafx/font/PrismFontFactory.getSystemLCID: ()S \
	Not found com/sun/javafx/font/MacFontFinder.getFont: (I)Ljava/lang/String; \
	Not found com/sun/javafx/font/MacFontFinder.getSystemFontSize: ()F \
	Not found com/sun/javafx/font/MacFontFinder.getFontData: ()[Ljava/lang/String; \
	Not found com/sun/javafx/font/DFontDecoder.createCTFont: (Ljava/lang/String;)J \
	Not found com/sun/javafx/font/DFontDecoder.releaseCTFont: (J)V \
	Not found com/sun/javafx/font/DFontDecoder.getCTFontFormat: (J)I \
	Not found com/sun/javafx/font/DFontDecoder.getCTFontTags: (J)[I \
	Not found com/sun/javafx/font/DFontDecoder.getCTFontTable: (JI)[B \
	Not found com/sun/javafx/font/freetype/OSPango.pango_context_set_base_dir: (JI)V \
	Not found com/sun/javafx/font/freetype/OSPango.pango_ft2_font_map_new: ()J \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_map_create_context: (J)J \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_describe: (J)J \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_description_new: ()J \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_description_free: (J)V \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_description_get_family: (J)Ljava/lang/String; \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_description_get_stretch: (J)I \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_description_get_style: (J)I \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_description_get_weight: (J)I \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_description_set_family: (JLjava/lang/String;)V \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_description_set_absolute_size: (JD)V \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_description_set_stretch: (JI)V \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_description_set_style: (JI)V \
	Not found com/sun/javafx/font/freetype/OSPango.pango_font_description_set_weight: (JI)V \
	Not found com/sun/javafx/font/freetype/OSPango.pango_attr_list_new: ()J \
	Not found com/sun/javafx/font/freetype/OSPango.pango_attr_font_desc_new: (J)J \
	Not found com/sun/javafx/font/freetype/OSPango.pango_attr_fallback_new: (Z)J \
	Not found com/sun/javafx/font/freetype/OSPango.pango_attr_list_unref: (J)V \
	Not found com/sun/javafx/font/freetype/OSPango.pango_attr_list_insert: (JJ)V \
	Not found com/sun/javafx/font/freetype/OSPango.pango_itemize: (JJIIJJ)J \
	Not found com/sun/javafx/font/freetype/OSPango.pango_shape: (JJ)Lcom/sun/javafx/font/freetype/PangoGlyphString; \
	Not found com/sun/javafx/font/freetype/OSPango.pango_item_free: (J)V \
	Not found com/sun/javafx/font/freetype/OSPango.g_utf8_offset_to_pointer: (JJ)J \
	Not found com/sun/javafx/font/freetype/OSPango.g_utf8_pointer_to_offset: (JJ)J \
	Not found com/sun/javafx/font/freetype/OSPango.g_utf16_to_utf8: ([C)J \
	Not found com/sun/javafx/font/freetype/OSPango.g_free: (J)V \
	Not found com/sun/javafx/font/freetype/OSPango.g_list_length: (J)I \
	Not found com/sun/javafx/font/freetype/OSPango.g_list_nth_data: (JI)J \
	Not found com/sun/javafx/font/freetype/OSPango.g_list_free: (J)V \
	Not found com/sun/javafx/font/freetype/OSPango.g_object_unref: (J)V \
	Not found com/sun/javafx/font/freetype/OSPango.FcConfigAppFontAddFile: (JLjava/lang/String;)Z \
	\
	Not found com/sun/scenario/effect/impl/sw/sse/SSELinearConvolveShadowPeer.filterVector: ([IIII[IIII[FIFFFFFF[FFFFF)V \
	Not found com/sun/scenario/effect/impl/sw/sse/SSELinearConvolveShadowPeer.filterHV: ([IIIII[IIIII[F[F)V \
	Not found com/sun/scenario/effect/impl/sw/sse/SSELinearConvolvePeer.filterVector: ([IIII[IIII[FIFFFFFFFFFF)V \
	Not found com/sun/scenario/effect/impl/sw/sse/SSELinearConvolvePeer.filterHV: ([IIIII[IIIII[F)V \
	Not found com/sun/scenario/effect/impl/sw/sse/SSEBoxBlurPeer.filterHorizontal: ([IIII[IIII)V \
	Not found com/sun/scenario/effect/impl/sw/sse/SSEBoxBlurPeer.filterVertical: ([IIII[IIII)V \
	Not found com/sun/scenario/effect/impl/sw/sse/SSERendererDelegate.isSupported: ()Z \
	Not found com/sun/scenario/effect/impl/sw/sse/SSEBoxShadowPeer.filterHorizontalBlack: ([IIII[IIIIF)V \
	Not found com/sun/scenario/effect/impl/sw/sse/SSEBoxShadowPeer.filterVerticalBlack: ([IIII[IIIIF)V \
	Not found com/sun/scenario/effect/impl/sw/sse/SSEBoxShadowPeer.filterVertical: ([IIII[IIIIF[F)V \
	#
ifneq ($(mf_target_osx),t)
t_img_r_m_stubs += \
	Not found com/sun/glass/ui/mac/MacTimer._getMinPeriod: ()I \
	Not found com/sun/glass/ui/mac/MacTimer._getMaxPeriod: ()I \
	Not found com/sun/glass/ui/mac/MacTimer._start: (Ljava/lang/Runnable;)J \
	Not found com/sun/glass/ui/mac/MacTimer._start: (Ljava/lang/Runnable;I)J \
	Not found com/sun/glass/ui/mac/MacTimer._stop: (J)V \
	Not found com/sun/glass/ui/mac/MacTimer._initIDs: ()V \
	Not found com/sun/glass/ui/mac/MacWindow._initIDs: ()V \
	Not found com/sun/glass/ui/mac/MacWindow._createWindow: (JJI)J \
	Not found com/sun/glass/ui/mac/MacWindow._createChildWindow: (J)J \
	Not found com/sun/glass/ui/mac/MacWindow._close: (J)Z \
	Not found com/sun/glass/ui/mac/MacWindow._setView: (JLcom/sun/glass/ui/View;)Z \
	Not found com/sun/glass/ui/mac/MacWindow._setMenubar: (JJ)Z \
	Not found com/sun/glass/ui/mac/MacWindow._minimize: (JZ)Z \
	Not found com/sun/glass/ui/mac/MacWindow._maximize: (JZZ)Z \
	Not found com/sun/glass/ui/mac/MacWindow._setBounds: (JIIZZIIIIFF)V \
	Not found com/sun/glass/ui/mac/MacWindow._setVisible: (JZ)Z \
	Not found com/sun/glass/ui/mac/MacWindow._setResizable: (JZ)Z \
	Not found com/sun/glass/ui/mac/MacWindow._requestFocus: (J)Z \
	Not found com/sun/glass/ui/mac/MacWindow._setFocusable: (JZ)V \
	Not found com/sun/glass/ui/mac/MacWindow._setTitle: (JLjava/lang/String;)Z \
	Not found com/sun/glass/ui/mac/MacWindow._setLevel: (JI)V \
	Not found com/sun/glass/ui/mac/MacWindow._setAlpha: (JF)V \
	Not found com/sun/glass/ui/mac/MacWindow._setBackground: (JFFF)Z \
	Not found com/sun/glass/ui/mac/MacWindow._setEnabled: (JZ)V \
	Not found com/sun/glass/ui/mac/MacWindow._setMinimumSize: (JII)Z \
	Not found com/sun/glass/ui/mac/MacWindow._setMaximumSize: (JII)Z \
	Not found com/sun/glass/ui/mac/MacWindow._setIcon: (JLcom/sun/glass/ui/Pixels;)V \
	Not found com/sun/glass/ui/mac/MacWindow._toFront: (J)V \
	Not found com/sun/glass/ui/mac/MacWindow._toBack: (J)V \
	Not found com/sun/glass/ui/mac/MacWindow._enterModal: (J)V \
	Not found com/sun/glass/ui/mac/MacWindow._enterModalWithWindow: (JJ)V \
	Not found com/sun/glass/ui/mac/MacWindow._exitModal: (J)V \
	Not found com/sun/glass/ui/mac/MacWindow._grabFocus: (J)Z \
	Not found com/sun/glass/ui/mac/MacWindow._ungrabFocus: (J)V \
	Not found com/sun/glass/ui/mac/MacWindow._getEmbeddedX: (J)I \
	Not found com/sun/glass/ui/mac/MacWindow._getEmbeddedY: (J)I \
	Not found com/sun/glass/ui/mac/MacCommonDialogs._initIDs: ()V \
	Not found com/sun/glass/ui/mac/MacCommonDialogs._showFileOpenChooser: (JLjava/lang/String;Ljava/lang/String;Z[Lcom/sun/glass/ui/CommonDialogs\$$ExtensionFilter;I)Lcom/sun/glass/ui/CommonDialogs\$$FileChooserResult; \
	Not found com/sun/glass/ui/mac/MacCommonDialogs._showFileSaveChooser: (JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;[Lcom/sun/glass/ui/CommonDialogs\$$ExtensionFilter;I)Lcom/sun/glass/ui/CommonDialogs\$$FileChooserResult; \
	Not found com/sun/glass/ui/mac/MacCommonDialogs._showFolderChooser: (JLjava/lang/String;Ljava/lang/String;)Ljava/io/File; \
	Not found com/sun/glass/ui/mac/MacPixels._initIDs: ()I \
	Not found com/sun/glass/ui/mac/MacPixels._copyPixels: (Ljava/nio/Buffer;Ljava/nio/Buffer;I)V \
	Not found com/sun/glass/ui/mac/MacPixels._attachInt: (JIILjava/nio/IntBuffer;[II)V \
	Not found com/sun/glass/ui/mac/MacPixels._attachByte: (JIILjava/nio/ByteBuffer;[BI)V \
	Not found com/sun/glass/ui/mac/MacMenuBarDelegate._createMenuBar: ()J \
	Not found com/sun/glass/ui/mac/MacMenuBarDelegate._insert: (JJI)V \
	Not found com/sun/glass/ui/mac/MacMenuBarDelegate._remove: (JJI)V \
	Not found com/sun/glass/ui/mac/MacCursor._initIDs: ()V \
	Not found com/sun/glass/ui/mac/MacCursor._createCursor: (IILcom/sun/glass/ui/Pixels;)J \
	Not found com/sun/glass/ui/mac/MacCursor._set: (I)V \
	Not found com/sun/glass/ui/mac/MacCursor._setCustom: (J)V \
	Not found com/sun/glass/ui/mac/MacCursor._setVisible: (Z)V \
	Not found com/sun/glass/ui/mac/MacCursor._getBestSize: (II)Lcom/sun/glass/ui/Size; \
	Not found com/sun/glass/ui/mac/MacAccessible._initIDs: ()V \
	Not found com/sun/glass/ui/mac/MacAccessible._initEnum: (Ljava/lang/String;)Z \
	Not found com/sun/glass/ui/mac/MacAccessible._createGlassAccessible: ()J \
	Not found com/sun/glass/ui/mac/MacAccessible._destroyGlassAccessible: (J)V \
	Not found com/sun/glass/ui/mac/MacAccessible.getString: (J)Ljava/lang/String; \
	Not found com/sun/glass/ui/mac/MacAccessible.isEqualToString: (JJ)Z \
	Not found com/sun/glass/ui/mac/MacAccessible.NSAccessibilityUnignoredAncestor: (J)J \
	Not found com/sun/glass/ui/mac/MacAccessible.NSAccessibilityUnignoredChildren: ([J)[J \
	Not found com/sun/glass/ui/mac/MacAccessible.NSAccessibilityPostNotification: (JJ)V \
	Not found com/sun/glass/ui/mac/MacAccessible.NSAccessibilityActionDescription: (J)Ljava/lang/String; \
	Not found com/sun/glass/ui/mac/MacAccessible.NSAccessibilityRoleDescription: (JJ)Ljava/lang/String; \
	Not found com/sun/glass/ui/mac/MacAccessible.idToMacVariant: (JI)Lcom/sun/glass/ui/mac/MacVariant; \
	Not found com/sun/glass/ui/mac/MacAccessible.GlassAccessibleToMacAccessible: (J)Lcom/sun/glass/ui/mac/MacAccessible; \
	Not found com/sun/glass/ui/mac/MacRobot._init: ()J \
	Not found com/sun/glass/ui/mac/MacRobot._destroy: (J)V \
	Not found com/sun/glass/ui/mac/MacRobot._keyPress: (I)V \
	Not found com/sun/glass/ui/mac/MacRobot._keyRelease: (I)V \
	Not found com/sun/glass/ui/mac/MacRobot._mouseMove: (JII)V \
	Not found com/sun/glass/ui/mac/MacRobot._mousePress: (JI)V \
	Not found com/sun/glass/ui/mac/MacRobot._mouseRelease: (JI)V \
	Not found com/sun/glass/ui/mac/MacRobot._mouseWheel: (I)V \
	Not found com/sun/glass/ui/mac/MacRobot._getMouseX: (J)I \
	Not found com/sun/glass/ui/mac/MacRobot._getMouseY: (J)I \
	Not found com/sun/glass/ui/mac/MacRobot._getPixelColor: (II)I \
	Not found com/sun/glass/ui/mac/MacRobot._getScreenCapture: (IIIIZ)Lcom/sun/glass/ui/Pixels; \
	Not found com/sun/glass/ui/mac/MacView._initIDs: ()V \
	Not found com/sun/glass/ui/mac/MacView._getMultiClickTime_impl: ()J \
	Not found com/sun/glass/ui/mac/MacView._getMultiClickMaxX_impl: ()I \
	Not found com/sun/glass/ui/mac/MacView._getMultiClickMaxY_impl: ()I \
	Not found com/sun/glass/ui/mac/MacView._create: (Ljava/util/Map;)J \
	Not found com/sun/glass/ui/mac/MacView._getX: (J)I \
	Not found com/sun/glass/ui/mac/MacView._getY: (J)I \
	Not found com/sun/glass/ui/mac/MacView._setParent: (JJ)V \
	Not found com/sun/glass/ui/mac/MacView._close: (J)Z \
	Not found com/sun/glass/ui/mac/MacView._scheduleRepaint: (J)V \
	Not found com/sun/glass/ui/mac/MacView._begin: (J)V \
	Not found com/sun/glass/ui/mac/MacView._end: (J)V \
	Not found com/sun/glass/ui/mac/MacView._enterFullscreen: (JZZZ)Z \
	Not found com/sun/glass/ui/mac/MacView._exitFullscreen: (JZ)V \
	Not found com/sun/glass/ui/mac/MacView._enableInputMethodEvents: (JZ)V \
	Not found com/sun/glass/ui/mac/MacView._uploadPixelsDirect: (JLjava/nio/Buffer;II)V \
	Not found com/sun/glass/ui/mac/MacView._uploadPixelsByteArray: (J[BIII)V \
	Not found com/sun/glass/ui/mac/MacView._uploadPixelsIntArray: (J[IIII)V \
	Not found com/sun/glass/ui/mac/MacView._getNativeLayer: (J)J \
	Not found com/sun/glass/ui/mac/MacView._getNativeRemoteLayerId: (JLjava/lang/String;)I \
	Not found com/sun/glass/ui/mac/MacView._hostRemoteLayerId: (JI)V \
	Not found com/sun/glass/ui/mac/MacView._getNativeFrameBuffer: (J)I \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._initIDs: ()V \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._createMenu: (Ljava/lang/String;Z)J \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._createMenuItem: (Ljava/lang/String;CILcom/sun/glass/ui/Pixels;ZZLcom/sun/glass/ui/MenuItem\$$Callback;)J \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._insert: (JJI)V \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._remove: (JJI)V \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._setTitle: (JLjava/lang/String;)V \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._setShortcut: (JCI)V \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._setPixels: (JLcom/sun/glass/ui/Pixels;)V \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._setEnabled: (JZ)V \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._setChecked: (JZ)V \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._setCallback: (JLcom/sun/glass/ui/MenuItem\$$Callback;)V \
	Not found com/sun/glass/ui/mac/MacPasteboard._initIDs: ()V \
	Not found com/sun/glass/ui/mac/MacPasteboard._createSystemPasteboard: (I)J \
	Not found com/sun/glass/ui/mac/MacPasteboard._createUserPasteboard: (Ljava/lang/String;)J \
	Not found com/sun/glass/ui/mac/MacPasteboard._getName: (J)Ljava/lang/String; \
	Not found com/sun/glass/ui/mac/MacPasteboard._getUTFs: (J)[[Ljava/lang/String; \
	Not found com/sun/glass/ui/mac/MacPasteboard._getItemAsRawImage: (JI)[B \
	Not found com/sun/glass/ui/mac/MacPasteboard._getItemStringForUTF: (JILjava/lang/String;)Ljava/lang/String; \
	Not found com/sun/glass/ui/mac/MacPasteboard._getItemBytesForUTF: (JILjava/lang/String;)[B \
	Not found com/sun/glass/ui/mac/MacPasteboard._putItemsFromArray: (J[Ljava/lang/Object;I)J \
	Not found com/sun/glass/ui/mac/MacPasteboard._clear: (J)J \
	Not found com/sun/glass/ui/mac/MacPasteboard._getSeed: (J)J \
	Not found com/sun/glass/ui/mac/MacPasteboard._getAllowedOperation: (J)I \
	Not found com/sun/glass/ui/mac/MacPasteboard._release: (J)V \
	Not found com/sun/glass/ui/mac/MacSystemClipboard._convertFileReferencePath: (Ljava/lang/String;)Ljava/lang/String; \
	Not found com/sun/glass/ui/mac/MacSystemClipboard\$$FormatEncoder._convertMIMEtoUTI: (Ljava/lang/String;)Ljava/lang/String; \
	Not found com/sun/glass/ui/mac/MacSystemClipboard\$$FormatEncoder._convertUTItoMIME: (Ljava/lang/String;)Ljava/lang/String; \
	Not found com/sun/glass/ui/mac/MacFileNSURL._initIDs: ()V \
	Not found com/sun/glass/ui/mac/MacFileNSURL._dispose: (J)V \
	Not found com/sun/glass/ui/mac/MacFileNSURL._startAccessingSecurityScopedResource: (J)Z \
	Not found com/sun/glass/ui/mac/MacFileNSURL._stopAccessingSecurityScopedResource: (J)V \
	Not found com/sun/glass/ui/mac/MacFileNSURL._getBookmark: (JJ)[B \
	Not found com/sun/glass/ui/mac/MacFileNSURL._createFromBookmark: ([BJ)Lcom/sun/glass/ui/mac/MacFileNSURL; \
	Not found com/sun/glass/ui/mac/MacGestureSupport._initIDs: ()V \
	Not found com/sun/glass/ui/mac/MacApplication._initIDs: (Z)V \
	Not found com/sun/glass/ui/mac/MacApplication._getMacKey: (I)I \
	Not found com/sun/glass/ui/mac/MacApplication._runLoop: (Ljava/lang/ClassLoader;Ljava/lang/Runnable;Z)V \
	Not found com/sun/glass/ui/mac/MacApplication._finishTerminating: ()V \
	Not found com/sun/glass/ui/mac/MacApplication._enterNestedEventLoopImpl: ()Ljava/lang/Object; \
	Not found com/sun/glass/ui/mac/MacApplication._leaveNestedEventLoopImpl: (Ljava/lang/Object;)V \
	Not found com/sun/glass/ui/mac/MacApplication._hide: ()V \
	Not found com/sun/glass/ui/mac/MacApplication._hideOtherApplications: ()V \
	Not found com/sun/glass/ui/mac/MacApplication._unhideAllApplications: ()V \
	Not found com/sun/glass/ui/mac/MacApplication.staticScreen_getVideoRefreshPeriod: ()D \
	Not found com/sun/glass/ui/mac/MacApplication.staticScreen_getScreens: ()[Lcom/sun/glass/ui/Screen; \
	Not found com/sun/glass/ui/mac/MacApplication._invokeAndWait: (Ljava/lang/Runnable;)V \
	Not found com/sun/glass/ui/mac/MacApplication._submitForLaterInvocation: (Ljava/lang/Runnable;)V \
	Not found com/sun/glass/ui/mac/MacApplication._supportsSystemMenu: ()Z \
	Not found com/sun/glass/ui/mac/MacApplication._getRemoteLayerServerName: ()Ljava/lang/String; \
	Not found com/sun/glass/ui/mac/MacApplication._getDataDirectory: ()Ljava/lang/String; \
	Not found com/sun/glass/ui/mac/MacApplication._getKeyCodeForChar: (C)I \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._createMenuItem: (Ljava/lang/String;CILcom/sun/glass/ui/Pixels;ZZLcom/sun/glass/ui/MenuItem$Callback;)J \
	Not found com/sun/glass/ui/mac/MacMenuDelegate._setCallback: (JLcom/sun/glass/ui/MenuItem$Callback;)V \
	Not found com/sun/glass/ui/mac/MacSystemClipboard$FormatEncoder._convertMIMEtoUTI: (Ljava/lang/String;)Ljava/lang/String; \
	Not found com/sun/glass/ui/mac/MacSystemClipboard$FormatEncoder._convertUTItoMIME: (Ljava/lang/String;)Ljava/lang/String; \
	\
	Not found com/sun/prism/es2/MacGLContext.nInitialize: (JJJZ)J \
	Not found com/sun/prism/es2/MacGLContext.nGetNativeHandle: (J)J \
	Not found com/sun/prism/es2/MacGLContext.nMakeCurrent: (JJ)V \
	Not found com/sun/prism/es2/MacGLPixelFormat.nCreatePixelFormat: (J[I)J \
	Not found com/sun/prism/es2/MacGLDrawable.nCreateDrawable: (JJ)J \
	Not found com/sun/prism/es2/MacGLDrawable.nGetDummyDrawable: (J)J \
	Not found com/sun/prism/es2/MacGLDrawable.nSwapBuffers: (JJ)Z \
	Not found com/sun/prism/es2/MacGLFactory.nInitialize: ([I)J \
	Not found com/sun/prism/es2/MacGLFactory.nGetAdapterOrdinal: (J)I \
	Not found com/sun/prism/es2/MacGLFactory.nGetAdapterCount: ()I \
	Not found com/sun/prism/es2/MacGLFactory.nGetIsGL2: (J)Z \
	#
endif
ifneq ($(mf_target_ios),t)
t_img_r_m_stubs += \
	Not found com/sun/glass/ui/ios/IosView.getFrameBufferImpl: (J)J \
	Not found com/sun/glass/ui/ios/IosView._create: (Ljava/util/Map;)J \
	Not found com/sun/glass/ui/ios/IosView._getNativeView: (J)J \
	Not found com/sun/glass/ui/ios/IosView._getX: (J)I \
	Not found com/sun/glass/ui/ios/IosView._getY: (J)I \
	Not found com/sun/glass/ui/ios/IosView._close: (J)Z \
	Not found com/sun/glass/ui/ios/IosView._scheduleRepaint: (J)V \
	Not found com/sun/glass/ui/ios/IosView._begin: (J)V \
	Not found com/sun/glass/ui/ios/IosView._end: (J)V \
	Not found com/sun/glass/ui/ios/IosView._enterFullscreen: (JZZZ)Z \
	Not found com/sun/glass/ui/ios/IosView._exitFullscreen: (JZ)V \
	Not found com/sun/glass/ui/ios/IosView._setParent: (JJ)V \
	Not found com/sun/glass/ui/ios/IosView._getNativeFrameBuffer: (J)I \
	Not found com/sun/glass/ui/ios/IosRobot._init: ()J \
	Not found com/sun/glass/ui/ios/IosRobot._destroy: (J)V \
	Not found com/sun/glass/ui/ios/IosRobot._keyPress: (JI)V \
	Not found com/sun/glass/ui/ios/IosRobot._keyRelease: (JI)V \
	Not found com/sun/glass/ui/ios/IosRobot._mouseMove: (JII)V \
	Not found com/sun/glass/ui/ios/IosRobot._mousePress: (JI)V \
	Not found com/sun/glass/ui/ios/IosRobot._mouseRelease: (JI)V \
	Not found com/sun/glass/ui/ios/IosRobot._mouseWheel: (JI)V \
	Not found com/sun/glass/ui/ios/IosRobot._getMouseX: (J)I \
	Not found com/sun/glass/ui/ios/IosRobot._getMouseY: (J)I \
	Not found com/sun/glass/ui/ios/IosRobot._getPixelColor: (JII)I \
	Not found com/sun/glass/ui/ios/IosRobot._getScreenCapture: (JIIII[I)V \
	Not found com/sun/glass/ui/ios/IosGestureSupport._initIDs: ()V \
	Not found com/sun/glass/ui/ios/IosWindow._createWindow: (JJI)J \
	Not found com/sun/glass/ui/ios/IosWindow._createChildWindow: (J)J \
	Not found com/sun/glass/ui/ios/IosWindow._close: (J)Z \
	Not found com/sun/glass/ui/ios/IosWindow._setView: (JLcom/sun/glass/ui/View;)Z \
	Not found com/sun/glass/ui/ios/IosWindow._setBounds: (JIIZZIIIIFF)V \
	Not found com/sun/glass/ui/ios/IosWindow._setMenubar: (JJ)Z \
	Not found com/sun/glass/ui/ios/IosWindow._minimize: (JZ)Z \
	Not found com/sun/glass/ui/ios/IosWindow._maximize: (JZZ)Z \
	Not found com/sun/glass/ui/ios/IosWindow._setVisible: (JZ)Z \
	Not found com/sun/glass/ui/ios/IosWindow._setResizable: (JZ)Z \
	Not found com/sun/glass/ui/ios/IosWindow._requestFocus: (JI)Z \
	Not found com/sun/glass/ui/ios/IosWindow._setFocusable: (JZ)V \
	Not found com/sun/glass/ui/ios/IosWindow._setTitle: (JLjava/lang/String;)Z \
	Not found com/sun/glass/ui/ios/IosWindow._setLevel: (JI)V \
	Not found com/sun/glass/ui/ios/IosWindow._setAlpha: (JF)V \
	Not found com/sun/glass/ui/ios/IosWindow._setBackground: (JFFF)Z \
	Not found com/sun/glass/ui/ios/IosWindow._setEnabled: (JZ)V \
	Not found com/sun/glass/ui/ios/IosWindow._setMinimumSize: (JII)Z \
	Not found com/sun/glass/ui/ios/IosWindow._setMaximumSize: (JII)Z \
	Not found com/sun/glass/ui/ios/IosWindow._setIcon: (JLcom/sun/glass/ui/Pixels;)V \
	Not found com/sun/glass/ui/ios/IosWindow._toFront: (J)V \
	Not found com/sun/glass/ui/ios/IosWindow._toBack: (J)V \
	Not found com/sun/glass/ui/ios/IosWindow._enterModal: (J)V \
	Not found com/sun/glass/ui/ios/IosWindow._enterModalWithWindow: (JJ)V \
	Not found com/sun/glass/ui/ios/IosWindow._exitModal: (J)V \
	Not found com/sun/glass/ui/ios/IosWindow._grabFocus: (J)Z \
	Not found com/sun/glass/ui/ios/IosWindow._ungrabFocus: (J)V \
	Not found com/sun/glass/ui/ios/IosWindow._requestInput: (JLjava/lang/String;IDDDDDDDDDDDDDD)V \
	Not found com/sun/glass/ui/ios/IosWindow._releaseInput: (J)V \
	Not found com/sun/glass/ui/ios/IosCursor._createCursor: (IILcom/sun/glass/ui/Pixels;)J \
	Not found com/sun/glass/ui/ios/IosCursor._set: (I)V \
	Not found com/sun/glass/ui/ios/IosCursor._setCustom: (J)V \
	Not found com/sun/glass/ui/ios/IosApplication._initIDs: ()V \
	Not found com/sun/glass/ui/ios/IosApplication._runLoop: (Ljava/lang/Runnable;Ljava/lang/ClassLoader;)V \
	Not found com/sun/glass/ui/ios/IosApplication.staticScreen_getVideoRefreshPeriod: ()D \
	Not found com/sun/glass/ui/ios/IosApplication.staticScreen_getScreens: ()[Lcom/sun/glass/ui/Screen; \
	Not found com/sun/glass/ui/ios/IosApplication._invokeAndWait: (Ljava/lang/Runnable;)V \
	Not found com/sun/glass/ui/ios/IosApplication._invokeLater: (Ljava/lang/Runnable;)V \
	Not found com/sun/glass/ui/ios/IosApplication._setStatusBarHidden: (Z)V \
	Not found com/sun/glass/ui/ios/IosApplication._setStatusBarHiddenWithAnimation: (ZI)V \
	Not found com/sun/glass/ui/ios/IosApplication._setStatusBarOrientationAnimated: (IZ)V \
	Not found com/sun/glass/ui/ios/IosApplication._setStatusBarStyleAnimated: (IZ)V \
	Not found com/sun/glass/ui/ios/IosApplication._getStatusBarHidden: ()Z \
	Not found com/sun/glass/ui/ios/IosApplication._getStatusBarStyle: ()I \
	Not found com/sun/glass/ui/ios/IosApplication._getStatusBarOrientation: ()I \
	Not found com/sun/glass/ui/ios/IosApplication._getKeyCodeForChar: (C)I \
	Not found com/sun/glass/ui/ios/IosTimer._start: (Ljava/lang/Runnable;)J \
	Not found com/sun/glass/ui/ios/IosTimer._stopVsyncTimer: (J)V \
	Not found com/sun/glass/ui/ios/IosPasteboard._createSystemPasteboard: (I)J \
	Not found com/sun/glass/ui/ios/IosPasteboard._createUserPasteboard: (Ljava/lang/String;)J \
	Not found com/sun/glass/ui/ios/IosPasteboard._getName: (J)Ljava/lang/String; \
	Not found com/sun/glass/ui/ios/IosPasteboard._getUTFs: (J)[[Ljava/lang/String; \
	Not found com/sun/glass/ui/ios/IosPasteboard._getItemAsRawImage: (JI)[B \
	Not found com/sun/glass/ui/ios/IosPasteboard._getItemAsString: (JI)Ljava/lang/String; \
	Not found com/sun/glass/ui/ios/IosPasteboard._getItemStringForUTF: (JILjava/lang/String;)Ljava/lang/String; \
	Not found com/sun/glass/ui/ios/IosPasteboard._getItemBytesForUTF: (JILjava/lang/String;)[B \
	Not found com/sun/glass/ui/ios/IosPasteboard._getItemForUTF: (JILjava/lang/String;)J \
	Not found com/sun/glass/ui/ios/IosPasteboard._putItemsFromArray: (J[Ljava/lang/Object;I)J \
	Not found com/sun/glass/ui/ios/IosPasteboard._clear: (J)J \
	Not found com/sun/glass/ui/ios/IosPasteboard._getSeed: (J)J \
	Not found com/sun/glass/ui/ios/IosPasteboard._getAllowedOperation: (J)I \
	Not found com/sun/glass/ui/ios/IosPasteboard._release: (J)V \
	\
	Not found com/sun/prism/es2/IOSGLFactory.nInitialize: ([I)J \
	Not found com/sun/prism/es2/IOSGLFactory.nGetAdapterOrdinal: (J)I \
	Not found com/sun/prism/es2/IOSGLFactory.nGetAdapterCount: ()I \
	Not found com/sun/prism/es2/IOSGLFactory.nGetIsGL2: (J)Z \
	Not found com/sun/prism/es2/IOSGLDrawable.nCreateDrawable: (JJ)J \
	Not found com/sun/prism/es2/IOSGLDrawable.nGetDummyDrawable: (J)J \
	Not found com/sun/prism/es2/IOSGLDrawable.nSwapBuffers: (JJ)Z \
	Not found com/sun/prism/es2/IOSGLContext.nInitialize: (JJJZ)J \
	Not found com/sun/prism/es2/IOSGLContext.nGetNativeHandle: (J)J \
	Not found com/sun/prism/es2/IOSGLContext.nMakeCurrent: (JJ)V \
	\
	Not found com/sun/javafx/iio/ios/IosImageLoader.initNativeLoading: ()V \
	Not found com/sun/javafx/iio/ios/IosImageLoader.loadImage: (Ljava/io/InputStream;Z)J \
	Not found com/sun/javafx/iio/ios/IosImageLoader.loadImageFromURL: (Ljava/lang/String;Z)J \
	Not found com/sun/javafx/iio/ios/IosImageLoader.resizeImage: (JII)V \
	Not found com/sun/javafx/iio/ios/IosImageLoader.getImageBuffer: (JI)[B \
	Not found com/sun/javafx/iio/ios/IosImageLoader.getNumberOfComponents: (J)I \
	Not found com/sun/javafx/iio/ios/IosImageLoader.getColorSpaceCode: (J)I \
	Not found com/sun/javafx/iio/ios/IosImageLoader.getDelayTime: (J)I \
	Not found com/sun/javafx/iio/ios/IosImageLoader.disposeLoader: (J)V \
	#
endif
ifneq ($(mf_target_rob),t)
t_img_r_m_stubs += \
	Not found com/sun/glass/ui/android/Activity._shutdown: ()V \
	Not found com/sun/glass/ui/android/DalvikInput.onMultiTouchEventNative: (I[I[I[I[I)V \
	Not found com/sun/glass/ui/android/DalvikInput.onKeyEventNative: (IILjava/lang/String;)V \
	Not found com/sun/glass/ui/android/DalvikInput.onSurfaceChangedNative: ()V \
	Not found com/sun/glass/ui/android/DalvikInput.onSurfaceChangedNative: (III)V \
	Not found com/sun/glass/ui/android/DalvikInput.onSurfaceRedrawNeededNative: ()V \
	Not found com/sun/glass/ui/android/DalvikInput.onConfigurationChangedNative: (I)V \
	Not found com/sun/glass/ui/android/SoftwareKeyboard._show: ()V \
	Not found com/sun/glass/ui/android/SoftwareKeyboard._hide: ()V \
	#
endif
ifneq ($(mf_target_win),t)
t_img_r_m_stubs += \
	Not found com/sun/glass/ui/win/WinDnDClipboard.dispose: ()V \
	Not found com/sun/glass/ui/win/WinDnDClipboard.push: ([Ljava/lang/Object;I)V \
	Not found com/sun/glass/ui/win/WinView._initIDs: ()V \
	Not found com/sun/glass/ui/win/WinView._getMultiClickTime_impl: ()J \
	Not found com/sun/glass/ui/win/WinView._getMultiClickMaxX_impl: ()I \
	Not found com/sun/glass/ui/win/WinView._getMultiClickMaxY_impl: ()I \
	Not found com/sun/glass/ui/win/WinView._enableInputMethodEvents: (JZ)V \
	Not found com/sun/glass/ui/win/WinView._finishInputMethodComposition: (J)V \
	Not found com/sun/glass/ui/win/WinView._create: (Ljava/util/Map;)J \
	Not found com/sun/glass/ui/win/WinView._getNativeView: (J)J \
	Not found com/sun/glass/ui/win/WinView._getX: (J)I \
	Not found com/sun/glass/ui/win/WinView._getY: (J)I \
	Not found com/sun/glass/ui/win/WinView._setParent: (JJ)V \
	Not found com/sun/glass/ui/win/WinView._close: (J)Z \
	Not found com/sun/glass/ui/win/WinView._scheduleRepaint: (J)V \
	Not found com/sun/glass/ui/win/WinView._begin: (J)V \
	Not found com/sun/glass/ui/win/WinView._end: (J)V \
	Not found com/sun/glass/ui/win/WinView._uploadPixels: (JLcom/sun/glass/ui/Pixels;)V \
	Not found com/sun/glass/ui/win/WinView._enterFullscreen: (JZZZ)Z \
	Not found com/sun/glass/ui/win/WinView._exitFullscreen: (JZ)V \
	Not found com/sun/glass/ui/win/WinSystemClipboard.initIDs: ()V \
	Not found com/sun/glass/ui/win/WinSystemClipboard.isOwner: ()Z \
	Not found com/sun/glass/ui/win/WinSystemClipboard.create: ()V \
	Not found com/sun/glass/ui/win/WinSystemClipboard.dispose: ()V \
	Not found com/sun/glass/ui/win/WinSystemClipboard.push: ([Ljava/lang/Object;I)V \
	Not found com/sun/glass/ui/win/WinSystemClipboard.pop: ()Z \
	Not found com/sun/glass/ui/win/WinSystemClipboard.popBytes: (Ljava/lang/String;J)[B \
	Not found com/sun/glass/ui/win/WinSystemClipboard.popMimesFromSystem: ()[Ljava/lang/String; \
	Not found com/sun/glass/ui/win/WinSystemClipboard.pushTargetActionToSystem: (I)V \
	Not found com/sun/glass/ui/win/WinSystemClipboard.popSupportedSourceActions: ()I \
	Not found com/sun/glass/ui/win/WinRobot._keyPress: (I)V \
	Not found com/sun/glass/ui/win/WinRobot._keyRelease: (I)V \
	Not found com/sun/glass/ui/win/WinRobot._mouseMove: (II)V \
	Not found com/sun/glass/ui/win/WinRobot._mousePress: (I)V \
	Not found com/sun/glass/ui/win/WinRobot._mouseRelease: (I)V \
	Not found com/sun/glass/ui/win/WinRobot._mouseWheel: (I)V \
	Not found com/sun/glass/ui/win/WinRobot._getMouseX: ()I \
	Not found com/sun/glass/ui/win/WinRobot._getMouseY: ()I \
	Not found com/sun/glass/ui/win/WinRobot._getPixelColor: (II)I \
	Not found com/sun/glass/ui/win/WinRobot._getScreenCapture: (IIII[I)V \
	Not found com/sun/glass/ui/win/WinApplication.initIDs: ()V \
	Not found com/sun/glass/ui/win/WinApplication._init: ()J \
	Not found com/sun/glass/ui/win/WinApplication._setClassLoader: (Ljava/lang/ClassLoader;)V \
	Not found com/sun/glass/ui/win/WinApplication._runLoop: (Ljava/lang/Runnable;)V \
	Not found com/sun/glass/ui/win/WinApplication._terminateLoop: ()V \
	Not found com/sun/glass/ui/win/WinApplication._enterNestedEventLoopImpl: ()Ljava/lang/Object; \
	Not found com/sun/glass/ui/win/WinApplication._leaveNestedEventLoopImpl: (Ljava/lang/Object;)V \
	Not found com/sun/glass/ui/win/WinApplication.staticScreen_getScreens: ()[Lcom/sun/glass/ui/Screen; \
	Not found com/sun/glass/ui/win/WinApplication._invokeAndWait: (Ljava/lang/Runnable;)V \
	Not found com/sun/glass/ui/win/WinApplication._submitForLaterInvocation: (Ljava/lang/Runnable;)V \
	Not found com/sun/glass/ui/win/WinApplication._getHighContrastTheme: ()Ljava/lang/String; \
	Not found com/sun/glass/ui/win/WinApplication._supportsUnifiedWindows: ()Z \
	Not found com/sun/glass/ui/win/WinApplication._getKeyCodeForChar: (C)I \
	Not found com/sun/glass/ui/win/WinCursor._initIDs: ()V \
	Not found com/sun/glass/ui/win/WinCursor._createCursor: (IILcom/sun/glass/ui/Pixels;)J \
	Not found com/sun/glass/ui/win/WinCursor._setVisible: (Z)V \
	Not found com/sun/glass/ui/win/WinCursor._getBestSize: (II)Lcom/sun/glass/ui/Size; \
	Not found com/sun/glass/ui/win/WinPixels._initIDs: ()I \
	Not found com/sun/glass/ui/win/WinPixels._fillDirectByteBuffer: (Ljava/nio/ByteBuffer;)V \
	Not found com/sun/glass/ui/win/WinPixels._attachInt: (JIILjava/nio/IntBuffer;[II)V \
	Not found com/sun/glass/ui/win/WinPixels._attachByte: (JIILjava/nio/ByteBuffer;[BI)V \
	Not found com/sun/glass/ui/win/WinMenuImpl._initIDs: ()V \
	Not found com/sun/glass/ui/win/WinMenuImpl._create: ()J \
	Not found com/sun/glass/ui/win/WinMenuImpl._destroy: (J)V \
	Not found com/sun/glass/ui/win/WinMenuImpl._insertItem: (JIILjava/lang/String;ZZLcom/sun/glass/ui/MenuItem\$$Callback;II)Z \
	Not found com/sun/glass/ui/win/WinMenuImpl._insertSubmenu: (JIJLjava/lang/String;Z)Z \
	Not found com/sun/glass/ui/win/WinMenuImpl._insertSeparator: (JI)Z \
	Not found com/sun/glass/ui/win/WinMenuImpl._removeAtPos: (JI)Z \
	Not found com/sun/glass/ui/win/WinMenuImpl._setItemTitle: (JILjava/lang/String;)Z \
	Not found com/sun/glass/ui/win/WinMenuImpl._setSubmenuTitle: (JJLjava/lang/String;)Z \
	Not found com/sun/glass/ui/win/WinMenuImpl._enableItem: (JIZ)Z \
	Not found com/sun/glass/ui/win/WinMenuImpl._enableSubmenu: (JJZ)Z \
	Not found com/sun/glass/ui/win/WinMenuImpl._checkItem: (JIZ)Z \
	Not found com/sun/glass/ui/win/WinTimer._getMinPeriod: ()I \
	Not found com/sun/glass/ui/win/WinTimer._getMaxPeriod: ()I \
	Not found com/sun/glass/ui/win/WinTimer._start: (Ljava/lang/Runnable;I)J \
	Not found com/sun/glass/ui/win/WinTimer._stop: (J)V \
	Not found com/sun/glass/ui/win/WinWindow._initIDs: ()V \
	Not found com/sun/glass/ui/win/WinWindow._createWindow: (JJI)J \
	Not found com/sun/glass/ui/win/WinWindow._createChildWindow: (J)J \
	Not found com/sun/glass/ui/win/WinWindow._close: (J)Z \
	Not found com/sun/glass/ui/win/WinWindow._setView: (JLcom/sun/glass/ui/View;)Z \
	Not found com/sun/glass/ui/win/WinWindow._setMenubar: (JJ)Z \
	Not found com/sun/glass/ui/win/WinWindow._minimize: (JZ)Z \
	Not found com/sun/glass/ui/win/WinWindow._maximize: (JZZ)Z \
	Not found com/sun/glass/ui/win/WinWindow._setBounds: (JIIZZIIIIFF)V \
	Not found com/sun/glass/ui/win/WinWindow._setVisible: (JZ)Z \
	Not found com/sun/glass/ui/win/WinWindow._setResizable: (JZ)Z \
	Not found com/sun/glass/ui/win/WinWindow._requestFocus: (JI)Z \
	Not found com/sun/glass/ui/win/WinWindow._setFocusable: (JZ)V \
	Not found com/sun/glass/ui/win/WinWindow._setTitle: (JLjava/lang/String;)Z \
	Not found com/sun/glass/ui/win/WinWindow._setLevel: (JI)V \
	Not found com/sun/glass/ui/win/WinWindow._setAlpha: (JF)V \
	Not found com/sun/glass/ui/win/WinWindow._setBackground: (JFFF)Z \
	Not found com/sun/glass/ui/win/WinWindow._setEnabled: (JZ)V \
	Not found com/sun/glass/ui/win/WinWindow._setMinimumSize: (JII)Z \
	Not found com/sun/glass/ui/win/WinWindow._setMaximumSize: (JII)Z \
	Not found com/sun/glass/ui/win/WinWindow._setIcon: (JLcom/sun/glass/ui/Pixels;)V \
	Not found com/sun/glass/ui/win/WinWindow._toFront: (J)V \
	Not found com/sun/glass/ui/win/WinWindow._toBack: (J)V \
	Not found com/sun/glass/ui/win/WinWindow._enterModal: (J)V \
	Not found com/sun/glass/ui/win/WinWindow._enterModalWithWindow: (JJ)V \
	Not found com/sun/glass/ui/win/WinWindow._exitModal: (J)V \
	Not found com/sun/glass/ui/win/WinWindow._grabFocus: (J)Z \
	Not found com/sun/glass/ui/win/WinWindow._ungrabFocus: (J)V \
	Not found com/sun/glass/ui/win/WinWindow._getEmbeddedX: (J)I \
	Not found com/sun/glass/ui/win/WinWindow._getEmbeddedY: (J)I \
	Not found com/sun/glass/ui/win/WinWindow._setCursor: (JLcom/sun/glass/ui/Cursor;)V \
	Not found com/sun/glass/ui/win/WinGestureSupport._initIDs: ()V \
	Not found com/sun/glass/ui/win/WinCommonDialogs._initIDs: ()V \
	Not found com/sun/glass/ui/win/WinCommonDialogs._showFileChooser: (JLjava/lang/String;Ljava/lang/String;Ljava/lang/String;IZ[Lcom/sun/glass/ui/CommonDialogs\$$ExtensionFilter;I)Lcom/sun/glass/ui/CommonDialogs\$$FileChooserResult; \
	Not found com/sun/glass/ui/win/WinCommonDialogs._showFolderChooser: (JLjava/lang/String;Ljava/lang/String;)Ljava/lang/String; \
	Not found com/sun/glass/ui/win/WinAccessible._initIDs: ()V \
	Not found com/sun/glass/ui/win/WinAccessible._createGlassAccessible: ()J \
	Not found com/sun/glass/ui/win/WinAccessible._destroyGlassAccessible: (J)V \
	Not found com/sun/glass/ui/win/WinAccessible.UiaRaiseAutomationEvent: (JI)J \
	Not found com/sun/glass/ui/win/WinAccessible.UiaRaiseAutomationPropertyChangedEvent: (JILcom/sun/glass/ui/win/WinVariant;Lcom/sun/glass/ui/win/WinVariant;)J \
	Not found com/sun/glass/ui/win/WinAccessible.UiaClientsAreListening: ()Z \
	Not found com/sun/glass/ui/win/WinTextRangeProvider._initIDs: ()V \
	Not found com/sun/glass/ui/win/WinTextRangeProvider._createTextRangeProvider: (J)J \
	Not found com/sun/glass/ui/win/WinTextRangeProvider._destroyTextRangeProvider: (J)V \
	Not found com/sun/glass/ui/win/WinMenuImpl._insertItem: (JIILjava/lang/String;ZZLcom/sun/glass/ui/MenuItem$Callback;II)Z \
	\
	Not found com/sun/prism/es2/WinGLPixelFormat.nCreatePixelFormat: (J[I)J \
	Not found com/sun/prism/es2/WinGLDrawable.nCreateDrawable: (JJ)J \
	Not found com/sun/prism/es2/WinGLDrawable.nGetDummyDrawable: (J)J \
	Not found com/sun/prism/es2/WinGLDrawable.nSwapBuffers: (J)Z \
	Not found com/sun/prism/es2/WinGLContext.nInitialize: (JJZ)J \
	Not found com/sun/prism/es2/WinGLContext.nGetNativeHandle: (J)J \
	Not found com/sun/prism/es2/WinGLContext.nMakeCurrent: (JJ)V \
	Not found com/sun/prism/es2/WinGLFactory.nInitialize: ([I)J \
	Not found com/sun/prism/es2/WinGLFactory.nGetAdapterOrdinal: (J)I \
	Not found com/sun/prism/es2/WinGLFactory.nGetAdapterCount: ()I \
	Not found com/sun/prism/es2/WinGLFactory.nGetIsGL2: (J)Z \
	#
endif

$(t_img_r_dll): $(t_ngraphics_objs_all)
	$(call mf_linkobj,$(mf_default_ld_cxx),-shared $(t_ngraphics_c_libs))

$(t_img_r_jar): $(_t_bsrc_out_jclassesf) $(_t_base_out_jclassesf) $(t_jsl_decora_cc_dep) $(t_jsl_prism_cc_dep) $(t_jsl_decora_jsl_dep) $(t_jsl_prism_jsl_dep) $(t_jgraphics_batchfile) $(t_controls_batchfile) $(t_fxml_batchfile)
	echo "Creating $(@F)..."
	mkdir -p $(@D)
	rm -f $(@)
	rm -f $(@).tmp
	JM=c $(foreach m,$(jarmodules),&& (cd $(buildp) && $(mf_default_jar) $${JM}f0 $(@).tmp -C $(m)/classes_compat .;) && JM=u)
	mv $(@).tmp $(@)

$(t_img_r_h): $(t_img_r_jar)
	@echo "Generating $(@F)..."
	@mkdir -p $(@D)
	@rm -f $(@)
	@rm -f $(@).tmp
	$(call t_b2h_run,$(t_img_r_jar),myfxjar,$(@).tmp)
	mv $(@).tmp $(@)

$(t_img_r_m): $(if ,$(t_img_r_jar) $(t_img_r_m_src))
	@echo "Generating $(@F)..."
	@mkdir -p $(@D)
	@rm -f $(@)
	@rm -f $(@).tmp
	$(call t_nama_run,myfxjni,$(t_img_r_jar),$(t_img_r_m_f),$(t_img_r_m_src),$(t_img_r_m_stubs)) > $(@).tmp
	mv $(@).tmp $(@)

$(eval $(call mf_echot,img,"Building t_img..."))

.PHONY: t_img
t_img: | $(call mf_echot_dep,img) $(t_img_r_jar) $(t_img_r_h) $(t_img_r_m) $(if $(mf_target_ems), , $(t_img_r_dll)) \
	;
#t_img: | $(call mf_echot_dep,img) $(t_img_r_jar) $(t_img_r_h) $(if ,$(t_img_r_m)) $(t_img_r_dll) \
	;


#----------------------------------------


ifeq ($(mytests),t)


t_myt_stupid_outp = $(mf_resultp)
t_myt_stupid_buildp = $(mf_buildp)/myfxt_stupid
t_myt_stupid_outo = $(t_myt_stupid_outp)/$(call mf_binname_exe,$(call mf_binname_plat,$(mf_target_platform)),myfxt_stupid)

_t_myt_stupid_bd = $(fxtest)/stupid
_t_myt_stupid_nm = mymain

t_myt_stupid_tests = \
	helloworld \
	#

#$(if ,$(foreach t_,$(t_myt_stupid_tests),$(shell rm -rf $(t_))))

t_myt_stupid_javac = $(mf_default_javac)
t_myt_stupid_jar = $(mf_default_jar)

t_myt_stupid_src = $(foreach dir,$(t_myt_stupid_tests),$(_t_myt_stupid_bd)/$(dir)/$(_t_myt_stupid_nm).java)

t_myt_stupid_h = $(call mf_anyobjs,$(t_myt_stupid_src),$(_t_myt_stupid_bd),java,$(t_myt_stupid_buildp),h)

t_myt_stupid_cxx = $(mf_default_cxx)
t_myt_stupid_c_f_opt := $(t_ngraphics_c_f_opt)
t_myt_stupid_c_f_def := $(t_ngraphics_c_f_def)
t_myt_stupid_c_f_etc := $(mf_default_cxx_flags)
t_myt_stupid_c_f_inc := \
	$(t_ngraphics_c_f_inc) \
	-I$(t_myt_stupid_buildp)/../ \
	#

t_myt_stupid_c_f_all := \
	$(t_myt_stupid_c_f_opt) \
	$(t_myt_stupid_c_f_def) \
	$(t_myt_stupid_c_f_etc) \
	$(t_myt_stupid_c_f_inc) \
	#

t_myt_stupid_ld = $(mf_default_ld_cxx)
t_myt_stupid_ld_flags = \
	$(call avnmkfdbprint,t_vm_libs) \
	$(mf_default_ld_cxx_flags) \
	$(t_ngraphics_c_libs) \
	$(t_myt_stupid_c_f_all) \
	#

t_myt_stupid_main_src = $(_t_myt_stupid_bd)/mytstupid.cpp

t_myt_stupid_main_objs = $(call mf_cppobjs,$(t_myt_stupid_main_src),$(_t_myt_stupid_bd),$(t_myt_stupid_buildp),mf_binname_obj,$(mf_target_platform))

define _t_my_stupid_tgen =
$(t_myt_stupid_buildp)/$(1)/$(_t_myt_stupid_nm).class: $(_t_myt_stupid_bd)/$(1)/$(_t_myt_stupid_nm).java
	@mkdir -p $(t_myt_stupid_buildp)/$(1)
	$(t_myt_stupid_javac) -g -d $(t_myt_stupid_buildp)/$(1) -bootclasspath $(jdkcp):$(t_jgraphics_outp_classes) -cp $(jdkcp):$(t_base_outp_j):$(t_jsl_outp_classes):$(t_jgraphics_outp_classes):$(t_controls_outp_classes):$(t_fxml_outp_classes) $$(<)
	$(call jretrolambda,$(t_myt_stupid_buildp)/$(1),$(t_myt_stupid_buildp)/$(1):$(jdkcp):$(t_bsrc_outp_j):$(t_base_outp_j):$(antcp):$(t_jsl_outp_classes):$(t_jgraphics_outp_classes):$(t_controls_outp_classes):$(t_fxml_outp_classes))

$(t_myt_stupid_buildp)/$(1)/$(_t_myt_stupid_nm).jar: $(t_myt_stupid_buildp)/$(1)/$(_t_myt_stupid_nm).class
	rm -f $$(@)
	(cd $$(dir $$(@)) && $(t_myt_stupid_jar) cf0 $$(shell realpath -m $$(@)) `find -type f -and -not -name '*.jar' -and -not -name '*.h'`)

$(t_myt_stupid_buildp)/$(1)/$(_t_myt_stupid_nm).h: $(t_myt_stupid_buildp)/$(1)/$(_t_myt_stupid_nm).jar
	rm -f $$(@)
	rm -f $$(@).tmp
	$$(call t_b2h_run,$$(<),$(1),$$(@).tmp)
	mv $$(@).tmp $$(@)
endef

$(foreach t_,$(t_myt_stupid_tests),$(eval $(call _t_my_stupid_tgen,$(t_))))

# Workaround on automatic dep gen on clang/ems.
# make: *** No rule to make target `myfxt_stupid/helloworld/mymain.h', needed by `/mnt/zfs/levault/dev/p/jaklintop/myfx/out/ems-ems-debug/build/myfxt_stupid/mytstupid.bc'.  Stop.
# Ugh.
ifeq ($(mf_target_ems),t)
cp.h: ;
cp.inc.cpp: ;
$(t_myt_stupid_buildp)/../myfxt_stupid/%.h: ;
myfxt_stupid/%.h: ;
endif

$(t_myt_stupid_main_objs): $(t_myt_stupid_buildp)/$(call mf_binname_obj,$(call mf_binname_plat,$(mf_target_platform)),%): $$(call mf_srcdepends,$(t_myt_stupid_cxx),$(t_myt_stupid_c_f_def)$(space)$(t_myt_stupid_c_f_inc),$(_t_myt_stupid_bd)/%.cpp) $(t_myt_stupid_h)
	$(call mf_compileobj,$(t_myt_stupid_cxx),$(t_myt_stupid_c_f_all))

$(t_myt_stupid_outo): $(t_myt_stupid_main_objs) $(t_ngraphics_objs_all) $(call avnmkfdbprint,vmobjs) $(call avnmkfdbprint,cpobjs)
	$(call mf_linkobj,$(t_myt_stupid_ld),$(t_myt_stupid_ld_flags))

$(eval $(call mf_echot,myt_stupid,"Building t_myt_stupid..."))

.PHONY: t_myt_stupid
t_myt_stupid: | t_img $(call mf_echot_dep,myt_stupid) $(t_myt_stupid_outo)


endif #ifeq ($(mytests),t)


#----------------------------------------


.PHONY: targets
targets: | \
	t_bsrc \
	t_base \
	t_jgraphics \
	t_jsl \
	t_controls \
	t_fxml \
	t_img \
	t_ngraphics \
	$(if $(mytests),t_myt_stupid) \
	;

.PHONY: all
all: | $(mf_rootp)/makefile $(mf_outp) targets ;

.PHONY: f
f: | clean all ;

define HELP

endef
export HELP
.PHONY: help
help:
	@echo "$$HELP"

