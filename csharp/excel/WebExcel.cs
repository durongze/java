using System;
using Microsoft.Office.Interop.Excel;
// using Microsoft.Office.Tools.Excel;

class WebExcel {
    String m_excelName;
    String m_exportPath;
    Microsoft.Office.Interop.Excel.Application m_app;

    public WebExcel() {
        m_excelName = "D:\\note.xlsx";
        m_exportPath = "D:\\test.xlsx";
        m_app = new Microsoft.Office.Interop.Excel.Application();
    }

    public void ShowSheet(Worksheet sheet)
    {
        int rowNum = sheet.Rows.Count;
        int colNum = sheet.Columns.Count;
        Console.WriteLine("rowNum : {0}" + rowNum);
        for (int i = 1; i <= rowNum; i++)
        {
            // big number;
            for (int j = 1; j <= colNum; j++)
            {
                Range r = (Range)sheet.Cells[i, j];
                Console.WriteLine("[{0}] ", r.Text);
            }
        }
    }
    public void ShowWorkbook(Workbook wb)
    {
        int numberOfSheets = wb.Worksheets.Count;
        Console.WriteLine("numberOfSheets : {0}" + numberOfSheets);
        for (int i = 1; i < numberOfSheets; i++)
        {
            Worksheet sheet = (Worksheet)wb.Worksheets[i];
            Console.WriteLine("sheet :{0} " + i);
            ShowSheet(sheet);
        }
    }
    public void AddSheet() {
        Workbook book = m_app.Workbooks.Open(m_excelName, Type.Missing,
        Type.Missing, Type.Missing, Type.Missing, Type.Missing,
        Type.Missing, Type.Missing, Type.Missing, Type.Missing,
        Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);

        ShowWorkbook(book);

        Worksheet sheet = (Worksheet)book.Worksheets[1];
        sheet.Cells[1, 1] = "test";
        book.SaveAs(m_exportPath, Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing, XlSaveAsAccessMode.xlNoChange,
            Type.Missing, Type.Missing, Type.Missing, Type.Missing, Type.Missing);
        book.Close();
    }
    
    // 在属性中修改为控制台程序，才能看到输出
    public static void Main(string[] args){
        WebExcel webExcel = new WebExcel();
        webExcel.AddSheet();
    }
}