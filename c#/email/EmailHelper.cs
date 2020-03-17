using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Mail;
using System.Net;
using System.Reflection;
using Outlook = Microsoft.Office.Interop.Outlook;

namespace Email
{
    public class EmailHelper
    {
        Outlook.Application olApp = new Outlook.Application();
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
                GetMailField(mail);
                System.Console.WriteLine("Sender : " + mail.SenderEmailAddress);
                System.Console.WriteLine("To : " + mail.To);
                System.Console.WriteLine("CC : " + mail.CC);
                System.Console.WriteLine("Subject : " + mail.Subject);
                System.Console.WriteLine("ReceivedTime : " + mail.ReceivedTime);
                System.Console.WriteLine("Body : " + mail.Body);
            }
        }
        public void ProcMail(Outlook.MailItem mail)
        {
            if (mail != null)
            {
                DisplayMail(mail);
                // ExportMail(mail, "d:\\");
            }
        }
        public void ProcFolder(Outlook.MAPIFolder folder)
        {
            Outlook.MailItem item = null;
            int mailCnt = folder.Items.Count;
            // foreach (var item in folder.Items)
            // for (int idx = 1; idx <= mailCnt; ++idx, item = (Outlook.MailItem)folder.Items[idx])
            for (System.Collections.IEnumerator ie = folder.Items.GetEnumerator(); ie.MoveNext(); item = (Outlook.MailItem)ie.Current)
            {
                ProcMail(item);
            }
        }

        /*
            (Outlook.OlDefaultFolders.olFolderInbox);
            (Outlook.OlDefaultFolders.olFolderOutbox);
            (Outlook.OlDefaultFolders.olFolderDrafts);
            (Outlook.OlDefaultFolders.olFolderJournal);
            (Outlook.OlDefaultFolders.olFolderSentMail);
            (Outlook.OlDefaultFolders.olFolderDeletedItems); 
        */
        public void ProcFolder(Outlook.OlDefaultFolders idx)
        {
            Outlook.NameSpace olNs = olApp.GetNamespace("MAPI");
            Outlook.MAPIFolder folder;
            folder = olNs.GetDefaultFolder(idx);
            ProcFolder(folder);
        }
        public void ProcNameSpace()
        {
            foreach(Outlook.OlDefaultFolders i in Enum.GetValues(typeof(Outlook.OlDefaultFolders)))
            {
                ProcFolder(i);
            }
        }

        public IList<string> GetMailProperties(Outlook.MailItem mail)
        {
            IList<string> propties = new List<string>();

            Type t = typeof(Outlook.MailItem);
            foreach (PropertyInfo pi in t.GetProperties())
            {
                propties.Add(pi.Name);
                var val = pi.GetValue(mail, null);
                System.Console.WriteLine(val.ToString());
            }
            return propties;
        }
        public IList<string> GetMailField(Outlook.MailItem mail)
        {
            IList<string> member = new List<string>();

            Type t = typeof(Outlook.MailItem);
            foreach (MemberInfo pi in t.GetDefaultMembers())
            {
                member.Add(pi.Name);
                var val = pi.GetCustomAttributes(true);
                System.Console.WriteLine(val.ToString());
            }
            return member;
        }
        public static void Main(string[] args)
        {
            EmailHelper eh = new EmailHelper();
            // eh.WriteMail();
            eh.ProcNameSpace();
            return ;
        }
    }
}