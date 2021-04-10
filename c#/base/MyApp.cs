using System;
using System.Windows.Forms;
using MyDLL;

namespace MyApplication
{
    class App
    {
        public static void Main()

        {
            MyDll dll = new MyDll();
            dll.Text = "MyDllStr";
            Form f = new Form();
            f.Text = dll.Text;  
            Application.Run(f);

        }
    }
}