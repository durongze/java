package com.durongze;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class Excel 
{
    String filePath = null;
    public Excel (String fp)
    {
        filePath = fp;
    }
    public void ShowCell(Cell cell)
    {
        if(cell == null){
            return ;
        }
        cell.setCellType(CellType.STRING);
        System.out.print(cell.getStringCellValue() + " ");
    }
    
    public void ShowRow(Row row)
    {
        if(row == null){
            return ;
        }
        int columNos = row.getLastCellNum();
        System.out.println("columNos : " + columNos);
        for (int j = 0; j < columNos; j++) {
            Cell cell = row.getCell(j);
            System.out.println("cell : " + j);
            ShowCell(cell);
        }
    }
    
    public void ShowSheet(Sheet sheet)
    {
        if(sheet == null){
            return ;
        }
        int rowNos = sheet.getLastRowNum();
        System.out.println("rowNos : " + rowNos);
        for (int i = 0; i <= rowNos; i++) {
            Row row = sheet.getRow(i);
            System.out.println("row : " + i);
            ShowRow(row);

        }
    }
    public void ShowWorkbook(Workbook wb)
    {
        int numberOfSheets = wb.getNumberOfSheets();
        System.out.println("numberOfSheets : " + numberOfSheets);
        for (int i = 0; i < numberOfSheets; i++) {
            Sheet sheet = wb.getSheetAt(i);
            System.out.println("sheet : " + i);
            ShowSheet(sheet);
        }
    }
    public void WriteExcel() throws IOException 
    {
        FileInputStream is = null;
        System.out.println("Excel\n");
        try {
            is = new FileInputStream(filePath);
            Workbook wb = WorkbookFactory.create(is);
            ShowWorkbook(wb);
        } catch (Exception e) {
            e.printStackTrace();
            if (is != null) {
                is.close();
            }
        }
        return ;
    }
    
    public static void main(String args[]) throws IOException 
    {
        Excel drzExcel = new Excel("d:/note.xlsx");
        drzExcel.WriteExcel();
        return ;
    }
}