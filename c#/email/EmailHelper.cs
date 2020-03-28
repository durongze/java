using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Net.Mail;
using System.Net;
using System.Reflection;
using Outlook = Microsoft.Office.Interop.Outlook;
using System.Globalization;

namespace Email
{
    public class EmailHelper
    {
        Outlook.Application olApp = new Outlook.Application();
        enum TimeCondType
        {
            Day,
            Week,
            Month,
            Season,
            Year
        };
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
        public bool IsInDate(DateTime start, DateTime end, DateTime target)
        {
            if (target > start && target < end)
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
            if (mail.Subject != null && ProcEmailCond(mail))
            {
                String fileName = mail.Subject.Replace("/", "-");
                fileName = fileName + mail.ReceivedTime.ToString().Replace("/", "-");
                fileName = path + "\\" + fileName + ".msg";
                mail.SaveAs(fileName);
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
                // DisplayMail(mail);
                ExportMail(mail, "d:\\");
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

        public static DateTime GetTimeStartByType(string TimeType, DateTime now)
        {
            switch (TimeType)
            {
                case "Day":
                    return now.AddDays(0).Date;
                case "Week":
                    return now.AddDays(-(int)now.DayOfWeek + 1).Date;
                case "Month":
                    return now.AddDays(-now.Day + 1).Date;
                case "Season":
                    var time = now.AddMonths(0 - ((now.Month - 1) % 3)).Date;
                    return time.AddDays(-time.Day + 1).Date;
                case "Year":
                    return now.AddDays(-now.DayOfYear + 1).Date;
                default:
                    return DateTime.Now;
            }
        }

        public static DateTime GetTimeEndByType(string TimeType, DateTime now)
        {
            switch (TimeType)
            {
                case "Day":
                    return now.AddDays(1).Date.AddSeconds(-1);
                case "Week":
                    return now.AddDays(7 - (int)now.DayOfWeek + 1).Date.AddSeconds(-1);
                case "Month":
                    return now.AddMonths(1).AddDays(-now.AddMonths(1).Day + 1).Date.AddSeconds(-1);
                case "Season":
                    var time = now.AddMonths((3 - now.Month % 3) % 3 + 1);
                    return time.AddDays(-time.AddMonths(1).Day).Date.AddSeconds(-1);
                case "Year":
                    var time2 = now.AddYears(1);
                    return time2.AddDays(-time2.DayOfYear).Date.AddDays(1).Date.AddSeconds(-1);
                default:
                    return DateTime.Now;
            }
        }

        public bool IsInSpecDate(Outlook.MailItem mail, string specDateType)
        {
            DateTime start = GetTimeStartByType(specDateType, DateTime.Now);
            DateTime end = GetTimeEndByType(specDateType, DateTime.Now);
            DateTime target = mail.ReceivedTime;
            return IsInDate(start, end, target);
        }
        public bool ProcEmailCond(Outlook.MailItem mail)
        {
            switch (m_timeType)
            {
                case TimeCondType.Day:
                    return (IsInSpecDate(mail, "Day"));
                case TimeCondType.Week:
                    return (IsInSpecDate(mail, "Week"));
                case TimeCondType.Month:
                    return (IsInSpecDate(mail, "Month"));
                case TimeCondType.Season:
                    return (IsInSpecDate(mail, "Season"));
                case TimeCondType.Year:
                    return (IsInSpecDate(mail, "Year"));

            }
            return false;
        }

        void SetTimeCondType(TimeCondType type)
        {
            m_timeType = type;
        }
        TimeCondType m_timeType = TimeCondType.Year;
        public static void Main(string[] args)
        {
            EmailHelper eh = new EmailHelper();
            // eh.WriteMail();
            // eh.ProcNameSpace();
            eh.SetTimeCondType(TimeCondType.Month);
            eh.ProcFolder(Outlook.OlDefaultFolders.olFolderSentMail);
            return ;
        }
    }
}