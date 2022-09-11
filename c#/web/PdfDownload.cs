using System;
using System.Threading;
using OpenQA.Selenium;
using OpenQA.Selenium.IE;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support;
using JavaScriptEngineSwitcher.Core;
using JavaScriptEngineSwitcher.ChakraCore;
// using JavaScriptEngineSwitcher.V8;

class PdfDownload
{
    IWebDriver iebw;
    string url = "https://max.book118.com/user_center_v1/detail/keledge/viewk?aid=8102076040003027&order_no=&token=&type=web&v=1";
    string jsZoom = "document.body.style.zoom='1'";
    public PdfDownload()
    {
        iebw = new InternetExplorerDriver();
        // iebw = new ChromeDriver();
    }
    ~PdfDownload()
    {
        iebw.Close();
    }
    public void GetWebPage()
    {
        ExecJavaScript(jsZoom);
        iebw.Navigate().GoToUrl(url);
        Console.WriteLine("PageSource:\n" + iebw.PageSource.ToString());
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

    public int FindElementByClassName(string kw)
    {
        Ck("", "", "", "", "");

        IWebElement element = iebw.FindElement(By.ClassName(kw));
        Console.WriteLine(element.ToString());
        element.SendKeys("123456");
        return 0;
    }
    public static string Ck(string cert, string ts, string nullPara, string page, string token)
    {
        /*
        var basePath = AppDomain.CurrentDomain.BaseDirectory;
        IJsEngineSwitcher engineSwitcher = JsEngineSwitcher.Current;
        engineSwitcher.EngineFactories.Add(new ChakraCoreJsEngineFactory());
        engineSwitcher.DefaultEngineName = ChakraCoreJsEngine.EngineName;
        using (IJsEngine engine = JsEngineSwitcher.Current.CreateDefaultEngine())
        {
            engine.ExecuteFile(string.Format(@"{0}/Scripts/myscipt.js", basePath));
            string[] arr = new string[] { cert, ts, nullPara, page, token };
            engine.Execute("var $CFMethod=$.ck;");
            var publickey = engine.CallFunction("$CFMethod", arr);
            return publickey.ToString();
        }
        */
        return "";
    }
    
    public static void PdfDownloadMain(string[] args) {
        Console.WriteLine("Main");
        PdfDownload wc = new PdfDownload();
        wc.GetWebPage();
        return;
    }
}