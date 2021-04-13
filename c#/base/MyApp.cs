using System;
using System.Windows.Forms;
using System.Collections.Generic;
using System.Text;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Text;
using System.Drawing.Drawing2D;
using System.Runtime.InteropServices;
using MyDLL;

namespace MyApplication
{
    class MyApp:Form
    {
        private PictureBox pb;
        private RichTextBox tb;
        private Button btn;
        private GroupBox gb;
        System.Timers.Timer t;

        [DllImport("kernel32.dll")] 
        public static extern int VirtualAllocEx(IntPtr hwnd, int lpaddress, int size, int type, int tect);
        [DllImport("kernel32.dll")]
        public static extern int WriteProcessMemory(IntPtr hwnd, int baseaddress, string buffer, int nsize, int filewriten);
        [DllImport("kernel32.dll")]
        public static extern int GetProcAddress(int hwnd, string lpname);
        [DllImport("kernel32.dll")]
        public static extern int GetModuleHandleA(string name);
        [DllImport("kernel32.dll")]
        public static extern int CreateRemoteThread(IntPtr hwnd, int attrib, int size, int address, int par, int flags, int threadid);
        public MyApp() 
        {
            this.SuspendLayout();
            this.Size = new System.Drawing.Size(800, 600);
            InitGroupBox();
            this.ResumeLayout(false);
            this.PerformLayout();
        }
        ~MyApp() { }

        private void InitTimer()
        {
            t = new System.Timers.Timer(1000);
            t.Elapsed += new System.Timers.ElapsedEventHandler(ProcTimer);
            t.AutoReset = true;
            t.Enabled = true;
        }
        public void ProcTimer(object source, System.Timers.ElapsedEventArgs e)
        {
            Graphics g = Graphics.FromImage(pb.Image);
            Font f = new Font("Times New Roman", 62, FontStyle.Italic);
            Brush b = new SolidBrush(Color.Purple);
            Point p = pb.Location; // new Point(150,150);
            g.DrawString(System.DateTime.Now.ToString(), f, b, p);
        }

        private void InitGroupBox()
        {
            gb = new GroupBox();
            gb.Name = "gb";
            gb.Text = "group";
            gb.Size = new System.Drawing.Size(600, 500);
            // tb.Location = new System.Drawing.Point(400, 450);
            this.Controls.Add(gb);
            InitButton(gb);
            InitTextBox(gb);
            InitPicBox(gb);
            InitTimer();
            return;
        }
        private void InitTextBox(GroupBox gb)
        {
            tb = new RichTextBox();
            tb.Name = "btn";
            tb.Text = "text";
            tb.Visible = true;
            tb.Size = new System.Drawing.Size(400, 200);
            // tb.Location = new System.Drawing.Point(150,150);
            tb.Dock = DockStyle.Top;
            gb.Controls.Add(tb);
            return;
        }
        private void BtnClick(object sender, EventArgs e)
        {
            AllProcess();
            pb.Refresh();
            
        }
        private void InitButton(GroupBox gb)
        {
            btn = new Button();
            btn.Name = "btn";
            btn.Text = "button";
            btn.Visible = true;
            btn.Size = new System.Drawing.Size(60, 40);
            // btn.Location = new System.Drawing.Point(50, 50);
            btn.Dock = DockStyle.Bottom;
            btn.Click += new System.EventHandler(this.BtnClick);
            gb.Controls.Add(btn);
        }

        private void InitPicBox(GroupBox gb)
        {
            pb = new PictureBox();
            pb.Name = "pb";
            pb.Text = "pic";
            pb.Visible = true;
            pb.Size = new System.Drawing.Size(200,50);
            pb.Dock = DockStyle.Fill;
            pb.Load("pic\\01.png");
            gb.Controls.Add(pb);
        }
        public int AllProcess()
        {
            int ret = 0;
            Process[] myProc = Process.GetProcesses();
            for (int i = 0; i < myProc.Length; ++i) {
                if (myProc[i].ProcessName.Contains("App")) 
                {
                    tb.Text = (myProc[i].ProcessName + ":" + myProc[i].Id + ":" + myProc[i].Handle + "\n");
                    AllModules(myProc[i]);
                    ret = Injection(myProc[i], "libMyDll.dll");
                    tb.Text = ret.ToString();
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
                    tb.Text += idx.ToString() + ":" + m.ModuleName + "\n";
                }
            }
            return 0;
        }

        public int Injection(Process name, String libName)
        {
            int temp = 0;
            int addr = VirtualAllocEx(name.Handle, 0, libName.Length, 4096, 4);
            if (addr == 0) 
            {
                return 1;
            }
            int ok = WriteProcessMemory(name.Handle, addr, libName, libName.Length, temp);
            if (ok == 0)
            {
                return 2;
            }
            int hack = GetProcAddress(GetModuleHandleA("Kernel32"), "LoadLibraryA"); 
            if (hack == 0)
            {
                return 3;
            }
            ok = CreateRemoteThread(name.Handle, 0, 0, hack, addr, 0, temp);
            if (ok == 0)
            {
                return 4;
            }
            
            return 0;
        }

        public static void Main()
        {
            MyDll dll = new MyDll();
            dll.Text = "MyDllStr";
            MyApp f = new MyApp();
            f.Text = dll.Text;  
            Application.Run(f);

        }
    }
}