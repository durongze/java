using System;
using System.Threading;
using OpenQA.Selenium;
using OpenQA.Selenium.IE;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support;

class CCTVDownload {
    IWebDriver iebw;
    string url = "https://tv.cctv.com/2022/05/06/VIDEQKRGQDSwccR3o0h2knZm220506.shtml?spm=C28340.Pu9TN9YUsfNZ.S93183.55";
    string jsZoom = "document.body.style.zoom='1'";
    public CCTVDownload()
    {
        iebw = new InternetExplorerDriver();
        // iebw = new ChromeDriver();
    }
    ~CCTVDownload()
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

    public static void CCTVDownloadMain(string[] args) {
        Console.WriteLine("Main");
        CCTVDownload wc = new CCTVDownload();
        wc.GetWebPage();
        wc.FindElementById("#_video_player_html5_api");
        return;
    }
}