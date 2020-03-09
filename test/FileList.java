package com.durongze;

import java.io.*;
import java.util.*;
import java.lang.*;

public class FileList{
    public static void ShowFileList(String[] fileList)
    {
        System.out.println("ShowFileList");
        for (String s:fileList) {
            System.out.println(s);
        }
    }
    
    public static void ShowFilePath(File[] fileList)
    {
        System.out.println("ShowFilePath");
        for (File f:fileList) {
            if (!f.exists()) {
                continue;
            }
            if (f.isFile()) {
                System.out.println("file:");
            } else if(f.isDirectory()) {
                System.out.println("dir:");
            }
            System.out.println(f.getAbsolutePath());
        }
    }
    
    public byte[] ReadBinary(File f) throws Exception 
    {
        InputStream in = new FileInputStream(f);
        byte[] data = new byte[(int)f.length()];
        try {
            System.out.println("f size:" + f.length());
            in.read(data);
            OutputStream out = new FileOutputStream(new File("d:\\xx.bin"));
            out.write(data);
            out.close();
        } catch (Exception e) {
            // System.out.println("dir:");
        }
        return data;
    }
    public void ProcAllFile(File[] fileList) throws Exception 
    {
        System.out.println("ShowFilePath");
        for (File f:fileList) {
            if (!f.exists()) {
                continue;
            }
            if (f.isFile()) {
                // System.out.println("file:");
                String fext = f.getAbsolutePath();
                if (fext.contains(".txt")) {
                    byte[] ctx = ReadBinary(f);
                    File fileExt = new File(fext.replace(".txt", ".bin"));
                    System.out.println(fileExt.getAbsolutePath());
                }
            } else if(f.isDirectory()) {
                // System.out.println("dir:");
            }
            
        }
    }
    // inputStream和OutputStream的子类都是字节流
    // 主要处理音频、图片、歌曲、字节流（1字节处理）
    // Reader和Writer的子类都是字符流
    // 主要处理字符或字符串，字符流（2字节处理）
    // 字节流将读取到的字节数据，去指定的编码表中获取对应的文字
    
    // 节点流中常用类
    // 字节输 入/出 流FileInputStream FileOutputStream
    // 字符输 入/出 流FileReader      FileWriter
    
    // 处理流中常用类
    // 缓冲字节输 入/出 流 
    // BufferedOutputStream BufferedInputStream
    // 缓冲字符输 入/出 流
    // BufferedReader BufferedWriter
    
    // 字节流转换成字符流的桥梁
    // InputStreamReader(InputStream in)
    // InputStreamReader(InputStream in, String charsetName)
    // OutputStreamWriter(OutputStream out)
    // OutputStreamWriter(OutputStream out, String charsetName)
    
    // InputStream 字节输入流
    //      - FileInputStream
    //      - PipedInputStream
    //      - FilterInputStream
    //              - LineNumberInputStream
    //              - DataInputStream
    //              - BufferedInputStream
    //              - PushbackInputStream
    //      - ByteArrayInputStream
    //      - SequenceInputStream
    //      - StringBufferInputStream
    //      - ObjectInputStream
    
    // Reader 字符输入流
    //      - BufferedReader    - LineNumberReader
    //      - CharArrayReader
    //      - InputStreamReader - FileReader
    //      - FilterReader      - PushbackReader
    //      - PipedReader
    //      - StringReader
    
    public static void main(String[] args) throws Exception {
        File file = new File("D:\\");
        // String[] fileNameList = file.list();
        // ShowFileList(fileNameList);
        File[] fileList = file.listFiles();
        // ShowFilePath(fileList);
        FileList fl = new FileList();
        fl.ProcAllFile(fileList);
    }
}