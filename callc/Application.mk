#1.生成的so的最低android版本
APP_PLATFORM := android-19

#2.gcc版本
#NDK_TOOLCHAIN_VERSION:=4.9

#3.是将要生成哪些cpu类型的so。 all代表全部
APP_ABI := all

#4.指定application里要链接额标准c++库
#APP_STL := gnustl_shared

#5.编译选项
APP_CPPFLAGS := -frtti -DCC_ENABLE_CHIPMUNK_INTEGRATION=1 -DCOCOS2D_DEBUG=1

