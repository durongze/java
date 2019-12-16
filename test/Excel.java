package com.durongze;

import org.apache.poi.hssf.usermodel.*;

public class Excel 
{
    public void WriteExcel()
    {
        System.out.println("Excel\n");
        return ;
    }
    
    public static void main(String args[])
    {
        Excel drzExcel = new Excel();
        drzExcel.WriteExcel();
        return ;
    }
}