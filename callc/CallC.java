package com.durongze.jni;

public class CallC{
    public native void CInterface(String[] name, int[] age, float[] height, int num);
    static {
        System.loadLibrary("CLibrary");
    }
    public static void main(String[] args){
        int idx = 0;
        int num = 2;
        String[] name = new String[num]; // ("durongze", "duyongze");
        int[] age = new int[num]; // (28, 30);
        float[] height = new float[num]; // (177, 188);
        for (; idx < num; ++idx){
            name[idx] = Integer.toString(idx);
            age[idx] = idx;
            height[idx] = idx + num;
        }
        new CallC().CInterface(name, age, height, num);
    }
};