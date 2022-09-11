package mypkg;

import java.io.*;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.*;
import org.openqa.selenium.ie.*;
import org.openqa.selenium.firefox.*;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.By;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class Web 
{
    WebDriver iebw = null;
    String win_browser = "C:/Program Files (x86)/Google/Chrome/Application/chrome.exe";
    String win_browser_driver = "C:/Windows/chromedriver.exe";

    String linux_browser = "/usr/bin/google-chrome";
    String linux_browser_driver = "/usr/bin/chromedriver";

    String url = "http://www.baidu.com";
	String kw = "kw";
    String btn = "su";
    String searchKw = "duyongze";

    public Web()
    {
        // iebw = new FirefoxDriver();
        // iebw = new InternetExplorerDriver();

        ChromeOptions options = new ChromeOptions();
        options.addArguments("disable-infobars");
        String osName = System.getProperties().getProperty("os.name");
        if (osName != "Linux") {
            options.setBinary(win_browser);
            System.setProperty("webdriver.chrome.driver", win_browser_driver);
        } else {
            options.setBinary(linux_browser);
            System.setProperty("webdriver.chrome.driver", linux_browser_driver);
        }

        iebw = new ChromeDriver(options);

        iebw.manage().window().maximize();
    }

    public void SwitchToSpecFrame()
    {

    }

    public void ExecJavaScript(WebElement element)
    {
        JavascriptExecutor js = (JavascriptExecutor)iebw;
        try {
            Thread.sleep(5000);
            js.executeScript("arguments[0].click();", element);
        } catch (Exception e) {
            System.out.println("click fail");
        }
    }
    
    public void GetWebPage()
    {
        iebw.get(url);
        WebElement kwElement = iebw.findElement(By.id(kw));
        kwElement.sendKeys(searchKw);
        kwElement.sendKeys(Keys.ENTER);
        WebElement btnElement = iebw.findElement(By.id(btn));
        ExecJavaScript(btnElement);
        return ;
    }
    
    public static void main(String args[])
    {
        Web drzWeb = new Web();
        drzWeb.GetWebPage();
        return ;
    }
}
