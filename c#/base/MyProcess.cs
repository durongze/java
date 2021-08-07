using System;
using System.Diagnostics;

namespace MyProcApp
{
    class MyProcess
    {
        public int AllProcess()
        {
            Process[] myProc = Process.GetProcesses();
            for (int i = 0; i < myProc.Length; ++i)
            {
                if (myProc[i].ProcessName.Contains("BaseApp"))
                {
                    System.Console.WriteLine(myProc[i].ProcessName + ":" + myProc[i].Id + ":" + myProc[i].Handle + "\n");
                    AllModules(myProc[i]);
                }
            }
            return 0;
        }
        public int AllModules(Process p)
        {
            int idx = 0;
            ProcessModuleCollection allmodules = p.Modules;
            foreach (ProcessModule m in allmodules)
            {
                ++idx;
                if (m.ModuleName != null)
                {
                    System.Console.WriteLine(idx.ToString() + ":" + m.ModuleName);
                }
            }
            return 0;
        }
        static public void Main() 
        {
            MyProcess proc = new MyProcess();
            proc.AllProcess();
            System.Console.ReadLine();
        }
    }
}