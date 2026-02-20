using System;
using System.Threading;

namespace MyThrApp
{
    class MyThread
    {
        
        static void ThrProc()
        {
            string val = Thread.CurrentThread.Name;
            Console.WriteLine("This is {0}", val);
            for (int i = 0; i < 10; ++i){
                Thread.Sleep(1000);
                Console.WriteLine(val + " i=" + i);
            }
        }
        static void Main(string[] args)
        {
            Thread thr = new Thread(new ThreadStart(ThrProc));
            thr.Name = "ThrProc";
            thr.Start();
            Console.WriteLine("Main Thread Waiting....");
            Console.ReadKey();
        }
    }
}