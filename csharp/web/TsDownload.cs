using System;
using System.Threading;
using OpenQA.Selenium;
using OpenQA.Selenium.IE;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support;

class TsDownload {
    IWebDriver iebw;
    string url = "https://www.ztbw.net/guocanju/gdjzj/1-3.html";
    string jsZoom = "document.body.style.zoom='1'";
    public TsDownload()
    {
        iebw = new InternetExplorerDriver();
        // iebw = new ChromeDriver();
    }
    ~TsDownload()
    {
        iebw.Close();
    }
    public void GetWebPage()
    {
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

    public int FindElementById(string kw)
    {
        IWebElement element = iebw.FindElement(By.Id(kw));
        Console.WriteLine(element.ToString());
        element.SendKeys("123456");
        return 0;
    }

    public static void TsDownloadMain(string[] args) {
        Console.WriteLine("Main");
        TsDownload wc = new TsDownload();
        wc.GetWebPage();
        return;
    }
}