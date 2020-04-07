package com.durongze.jni;

public class CallC{
    public native String[] CInterface(String[] name, int[] age, float[] height, int num);
    static {
        System.loadLibrary("CLibrary");
    }
    public static void main(String[] args){
        int idx = 0;
        int num = 2;
        String[] name = new String[num]; // ("durongze", "duyongze");
        int[] age = new int[num]; // (28, 30);
        float[] height = new float[num]; // (177, 188);
        for (idx = 0; idx < num; ++idx){
            name[idx] = Integer.toString(100 + idx);
            age[idx] = 200 + idx;
            height[idx] = 300 + idx;
        }
        String[] vals = new CallC().CInterface(name, age, height, num);
        for (idx = 0; idx < vals.length; ++idx){
            System.out.println(vals[idx]);
        }
    }
};