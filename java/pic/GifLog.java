package mypkg;

import java.io.*;

public class GifLog {
    private static int stackLevel = 3;

    private static String GetFileName()
    {
        return Thread.currentThread().getStackTrace()[stackLevel].getFileName();
    }
    private static String GetClassName()
    {
        return Thread.currentThread().getStackTrace()[stackLevel].getClassName();
    }
    private static String GetFuncName()
    {
        return Thread.currentThread().getStackTrace()[stackLevel].getMethodName();
    }
    private static int GetLineNumber()
    {
        return Thread.currentThread().getStackTrace()[stackLevel].getLineNumber();
    }

    public static void Print(String str) 
    {
        String prefix;
        prefix = "[" + GetFileName();
        prefix += ":" + GetClassName();
        prefix += ":" + GetFuncName();
        prefix += ":" + GetLineNumber();
        prefix += "] ";
        System.out.println(prefix + str);
    }

    public static void main(String[] args) 
    {
        GifLog.Print(" log starting ...");
    }
}