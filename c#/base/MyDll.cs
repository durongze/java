using System;

 

namespace MyDLL
{
    public class MyDll
    {
        public String Text
        {
            get { return m_Text; }
            set { m_Text = value; }
        }
        private String m_Text;
    }
}