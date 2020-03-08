package com.durongze;

import java.io.*;

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
    
    public static void main(String[] args) {
        File file = new File("D:\\");
        String[] fileNameList = file.list();
        ShowFileList(fileNameList);
        File[] fileList = file.listFiles();
        ShowFilePath(fileList);
    }
}