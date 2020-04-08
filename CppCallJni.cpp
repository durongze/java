#include "com_durongze_jni_CallC.h"
#include <Windows.h>

#define JAVA_HOME "D:\\Program Files\\Java\\jre1.8.0_60"
#define JVM_DLL JAVA_HOME "\\bin\\server\\" "jvm.dll"

#ifdef __cplusplus
#if __cplusplus
extern "C" {
#endif
#endif

	typedef int(*JNICreateJavaVM)(JavaVM **pvm, void **penv, void *args);
	typedef int (*JNIGetCreatedJavaVMs)(JavaVM **vmBuf, jsize bufLen, jsize *nVMs);
	int main() {
		int status = 0;
		JavaVM *pvm = NULL;
		JNIEnv *penv = NULL;
		JavaVMOption options[4];
		options[0].optionString = "-Djava.compiler=NONE";
		options[1] = { "-Djava.class.path=.;D:\\Program Files\\Java\\jre1.8.0_60\\lib\\dt.jar;D:\\Program Files\\Java\\jre1.8.0_60\\lib\\tools.jar", NULL };
		options[2].optionString = "-verbose:NONE";
		options[3].optionString = "-XX:+CreateMinidumpOnCrash";
		JavaVMInitArgs args = { JNI_VERSION_1_8, 4, options, JNI_TRUE };
		char *jvmDll = JVM_DLL;
		HMODULE hmod = LoadLibraryA("D:\\Program Files\\Java\\jre1.8.0_60\\bin\\server\\jvm.dll");
		JNICreateJavaVM pJNICreateJavaVM = (JNICreateJavaVM)GetProcAddress(hmod, "JNI_CreateJavaVM");
		JNIGetCreatedJavaVMs pJNIGetCreateJavaVMs = (JNIGetCreatedJavaVMs)GetProcAddress(hmod, "JNI_GetCreatedJavaVMs");
		JavaVM *pvms[32] = { 0 };
		jsize pvmsnum = 0;
		status = pJNIGetCreateJavaVMs(pvms, sizeof(pvms), &pvmsnum);
		status = pJNICreateJavaVM(&pvm, (void**)&penv, (void*)&args);
		if (status == JNI_ERR) {
			return 0;
		}
		int num = 2;
		jclass intArrCls = penv->FindClass("java/lang/String");
		jobjectArray names = penv->NewObjectArray(num, intArrCls, NULL);
		jintArray ages = penv->NewIntArray(num);
		jfloatArray heights = penv->NewFloatArray(num);

		for (int idx = 0; idx < num; ++idx) {
			const char *pns = "xxx";
			jstring ns = penv->NewStringUTF(pns);
			jint intArr[1] = { idx };
			jfloat floatArr[1] = { idx };
			penv->SetIntArrayRegion(ages, idx, 1, intArr);
			penv->SetFloatArrayRegion(heights, idx, 1, floatArr);
			penv->SetObjectArrayElement(names, idx, ns);
			penv->ReleaseStringUTFChars(ns, 0);
		}

		jobjectArray res = (jobjectArray)Java_com_durongze_jni_CallC_CInterface(penv, NULL, names, ages, heights, num);

		pvm->DestroyJavaVM();
	}

#ifdef __cplusplus
#if __cplusplus
}
#endif
#endif
