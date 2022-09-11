using System;
using System.Threading;
using System.Runtime.InteropServices;
using OpenQA.Selenium;
using OpenQA.Selenium.IE;
using OpenQA.Selenium.Chrome;
using OpenQA.Selenium.Support;

class Web{
    IWebDriver iebw;
    String win_browser = "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe";
    String win_browser_driver = "C:/Windows/chromedriver.exe";

    String linux_browser = "/usr/bin/google-chrome";
    String linux_browser_driver = "/usr/bin/chromedriver";

    string url = "http://www.baidu.com";
    string btn = "su";
    string kw = "kw";
    string jsZoom = "document.body.style.zoom='1'";

    public Web() {
        // iebw = new FirefoxDriver();
        // iebw = new InternetExplorerDriver();
        Console.WriteLine(Environment.OSVersion.ToString());
        ChromeOptions options = new ChromeOptions();
        options.AddArguments("disable-infobars");
        if (RuntimeInformation.IsOSPlatform(OSPlatform.Linux)) {
            options.BinaryLocation = (linux_browser);
        } else {
            options.BinaryLocation = (win_browser);         
        }

        iebw = new ChromeDriver(options);
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

    public void DumpDllType(String path)
    {
        var assembly = System.Reflection.Assembly.LoadFile(path);
        Type[] types = assembly.GetTypes();
        Console.WriteLine(types.ToString());
    }

    // 在属性中修改为控制台程序，才能看到输出
    public static void Main(string[] args) {
        Console.WriteLine("Main");
        Web wc = new Web();
        wc.GetWebPage();
        // wc.DumpDllType("/home/du/code/java/java/c#/web/bin/Debug/net5.0/WebDriver.dll");
        wc.InputKeyWord();
        wc.StartSearch();
        return;
    }
}