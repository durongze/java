using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Mail;
using System.Net;
using Outlook = Microsoft.Office.Interop.Outlook;

namespace Email
{   
   public class EmailHelper
    {
        public bool isInTime(string start, string end)
        {
            TimeSpan startTime = DateTime.Parse(start).TimeOfDay;
            TimeSpan endTime = DateTime.Parse(end).TimeOfDay;

            TimeSpan dspNow = DateTime.Now.TimeOfDay;
            if (dspNow > startTime && dspNow < endTime)
            {
                return true;
            }
            return false;
        }
        
        public bool isAmTime()
        { 
            string start = "05:30";
            string end = "09:01";
            return isInTime(start, end);
        }
        
        public bool isPmTime()
        { 
            string start = "17:30";
            string end = "23:59";
            return isInTime(start, end);
        }
        
        public string GetEvent()
        {
            string work = null;
            if (isAmTime()) {
                work = "上班";
            } 
            if (isPmTime()) {
                work = "下班";
            }
            return work;
        }
        
        public string WriteMailSubject()
        {
            string subject = null;
            string work = null;
            work = GetEvent();
            subject = DateTime.Now.ToString("yyyy/MM/dd") + work + "签到";
            return subject;
        }
        
        public string WriteMailCtx()
        {
            string content = null;
            string work = null;
            work = GetEvent();
            content = DateTime.Now.ToString("yyyy/MM/dd") + work + "签到, 谢谢！";
            return content;
        }
        
        
        public void WriteMail() 
        {
            Outlook.Application olApp = new Outlook.Application();
            Outlook.MailItem mailItem = (Outlook.MailItem)olApp.CreateItem(Outlook.OlItemType.olMailItem);
            mailItem.To = "durongze@qq.com";
            mailItem.CC = "duyongzeyx@qq.com";
            mailItem.Subject = WriteMailSubject();
            mailItem.BodyFormat = Outlook.OlBodyFormat.olFormatHTML;
            mailItem.HTMLBody = WriteMailCtx();

            // mailItem.Attachments.Add(@"c:\test.rar");
            //((Outlook._MailItem)mailItem).Send();
            ((Outlook._MailItem)mailItem).Save();
            mailItem = null;
            olApp = null;
        }
        public void ExportMail(Outlook.MailItem mail, String path)
        {
            if (mail.Subject != null)
            {
                String fileName = mail.Subject.Replace("/", "-");
                mail.SaveAs(path + "\\" + fileName + ".msg");
            }
        }
        public void DisplayMail(Outlook.MailItem mail)
        {
            if (mail != null)
            {
                System.Console.WriteLine(mail.Sender);
                System.Console.WriteLine(mail.To);
                System.Console.WriteLine(mail.CC);
                System.Console.WriteLine(mail.Subject);
                System.Console.WriteLine(mail.ReceivedTime);
                System.Console.WriteLine(mail.Body);
                ExportMail(mail, "d:\\");
            }
        }
        public void DisplayFolder(Outlook.MAPIFolder folder)
        {
            Outlook.MailItem mail;
            int mailCnt = folder.Items.Count;
            // foreach (var item in folder.Items)
            {
                // DisplayMail((Outlook.MailItem)item);
            }
            // for (int idx = 1; idx <= mailCnt; ++idx)
            {
                // DisplayMail((Outlook.MailItem)folder.Items[idx]);
            }
            System.Collections.IEnumerator ie = folder.Items.GetEnumerator();
            while (ie.MoveNext())
            {
                DisplayMail((Outlook.MailItem)ie.Current);
            }
        }
        public void DisplayAllFolder()
        {
            Outlook.MAPIFolder folder;
            Outlook.Application olApp = new Outlook.Application();
            Outlook.NameSpace olNs = olApp.GetNamespace("MAPI");
            // for (folder = olNs.PickFolder(); ;)
            // folder = olNs.GetDefaultFolder(Outlook.OlDefaultFolders.olFolderDrafts);
            // folder = olNs.GetDefaultFolder(Outlook.OlDefaultFolders.olFolderInbox);
            // folder = olNs.GetDefaultFolder(Outlook.OlDefaultFolders.olFolderOutbox);
            // folder = olNs.GetDefaultFolder(Outlook.OlDefaultFolders.olFolderJournal);
            folder = olNs.GetDefaultFolder(Outlook.OlDefaultFolders.olFolderSentMail);
            // folder = olNs.GetDefaultFolder(Outlook.OlDefaultFolders.olFolderDeletedItems);
            {
                DisplayFolder(folder);
            }
        }
        public static void Main(string[] args)
        {
            EmailHelper eh = new EmailHelper();
            // eh.WriteMail();
            eh.DisplayAllFolder();
            return ;
        }
    }
}