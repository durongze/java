package com.durongze.jni;

public class CallC{
    public native void CInterface();
    static {
        System.loadLibrary("CLibrary");
    }
    public static void main(String[] args){
        new CallC().CInterface();
    }
};