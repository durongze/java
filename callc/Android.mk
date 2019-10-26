#1.这个变量用于给出当前文件的路径，my-dir返回当前Android.mk 所在目录的路径
LOCAL_PATH := $(call my-dir)

#2.CLEAR_VARS:指向一个编译脚本，这个必须再开始一个新模块之前包含
include $(CLEAR_VARS)

#3. 这个模块的名字，它必须是唯一的，而且不能包含空格
LOCAL_MODULE := my

#4.为c编译器传递额外的参数（宏定义等）
LOCAL_LDFLAGS := -Wl,--build-id

#5.给c或cpp文件添加一个log库 
LOCAL_LDLIBS :=-L$(SYSROOT)/usr/lib -lm -llog

#6.要编译的文件列表
LOCAL_SRC_FILES := com_durongze_jni_CallC.cpp

LOCAL_C_INCLUDES +=$(SYSROOT)/include

#7.可选变量,表示头文件的搜索路径
include $(BUILD_SHARED_LIBRARY)

