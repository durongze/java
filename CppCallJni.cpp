#include "com_durongze_jni_CallC.h"
#include <Windows.h>

#define JAVA_HOME "D:\\Program Files\\Java\\jre1.8.0_60"

#define JVM_DLL JAVA_HOME "\\bin\\server\\" "jvm.dll"
typedef int (*JNICreateJavaVM)(JavaVM **pvm, void **penv, void *args);
int main() {
	JavaVM *pvm = NULL;
	JNIEnv *penv = NULL;
	JavaVMInitArgs args;
	JavaVMOption options[1] = {"-Djava.class.path=.;D:\\Program Files\\Java\\jre1.8.0_60\\lib\\dt.jar;D:\\Program Files\\Java\\jre1.8.0_60\\lib\\tools.jar"};
	args.options = options;
	args.nOptions = 1;
	args.version = JNI_VERSION_1_6;
	args.ignoreUnrecognized = JNI_TRUE;
	char *jvmDll = JVM_DLL;
	HMODULE hmod = LoadLibraryA("D:\\Program Files\\Java\\jre1.8.0_60\\bin\\server\\jvm.dll");
	JNICreateJavaVM pJNICreateJavaVM = (JNICreateJavaVM)GetProcAddress(hmod, "JNI_CreateJavaVM");
	int status = pJNICreateJavaVM(&pvm, (void**)&penv, (void**)&args);
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
