using System;
using System.Threading;
using OpenQA.Selenium;
using OpenQA.Selenium.IE;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support;

class Web{
    IWebDriver iebw;
    string url = "www.baidu.com";
    string btn = "su";
    string kw = "kw";
    string jsZoom = "document.body.style.zoom='1'";
    public Web() {
        iebw = new InternetExplorerDriver();
        // iebw = new ChromeDriver();
    }
    ~Web()
    {
        iebw.Close();
    }
    public void GetWebPage() {
        ExecJavaScript(jsZoom);
        iebw.Navigate().GoToUrl(url);
    }

    void ExecJavaScript(IWebElement element)
    {
        IJavaScriptExecutor js = (IJavaScriptExecutor)iebw;
        Thread.Sleep(5000);
        js.ExecuteScript("arguments[0].click();", element);
    }

    void ExecJavaScript(string jsCmd)
    {
        IJavaScriptExecutor js = (IJavaScriptExecutor)iebw;
        Thread.Sleep(5000);
        js.ExecuteScript(jsCmd);
    }

    public void StartSearch()
    {
        IWebElement element = iebw.FindElement(By.Id(btn));
        Console.WriteLine(element.ToString());
        ExecJavaScript(element);
    }

    public void InputKeyWord()
    {
        IWebElement element = iebw.FindElement(By.Id(kw));
        Console.WriteLine(element.ToString());
        element.SendKeys("123456");
    }
    // 在属性中修改为控制台程序，才能看到输出
    public static void Main(string[] args) {
        Console.WriteLine("Main");
        // Web wc = new Web();
        // TsDownload wc = new TsDownload();
        PdfDownload wc = new PdfDownload();
        wc.GetWebPage();
        wc.FindElementByClassName("img-page");
        return;
    }
}