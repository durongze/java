using System;
using System.Diagnostics;
using System.Runtime.InteropServices;
using System.Text;

namespace MyProcQQ
{
    internal static class NativeMethods
    {
        public const int MAX_PATH = 260;

        // Dialog Codes
        internal const int WM_GETDLGCODE = 0x0087;
        internal const int DLGC_STATIC = 0x0100;

        [StructLayout(LayoutKind.Sequential)]
        public struct HWND
        {
            public IntPtr h;

            public static HWND Cast(IntPtr h)
            {
                HWND hTemp = new HWND();
                hTemp.h = h;
                return hTemp;
            }

            public static implicit operator IntPtr(HWND h)
            {
                return h.h;
            }

            public static HWND NULL
            {
                get
                {
                    HWND hTemp = new HWND();
                    hTemp.h = IntPtr.Zero;
                    return hTemp;
                }
            }

            public static bool operator ==(HWND hl, HWND hr)
            {
                return hl.h == hr.h;
            }

            public static bool operator !=(HWND hl, HWND hr)
            {
                return hl.h != hr.h;
            }

            override public bool Equals(object oCompare)
            {
                HWND hr = Cast((HWND)oCompare);
                return h == hr.h;
            }

            public override int GetHashCode()
            {
                return (int)h;
            }
        }


        [StructLayout(LayoutKind.Sequential)]
        public struct RECT
        {
            public int left;
            public int top;
            public int right;
            public int bottom;

            public RECT(int left, int top, int right, int bottom)
            {
                this.left = left;
                this.top = top;
                this.right = right;
                this.bottom = bottom;
            }

            public bool IsEmpty
            {
                get
                {
                    return left >= right || top >= bottom;
                }
            }
        }

        [StructLayout(LayoutKind.Sequential)]
        public struct POINT
        {
            public int x;
            public int y;

            public POINT(int x, int y)
            {
                this.x = x;
                this.y = y;
            }
        }

        // WinEvent specific consts and delegates

        public const int EVENT_MIN = 0;
        public const int EVENT_MAX = 0x7FFFFFFF;

        public const int EVENT_SYSTEM_MENUSTART = 0x0004;
        public const int EVENT_SYSTEM_MENUEND = 0x0005;
        public const int EVENT_SYSTEM_MENUPOPUPSTART = 0x0006;
        public const int EVENT_SYSTEM_MENUPOPUPEND = 0x0007;
        public const int EVENT_SYSTEM_CAPTURESTART = 0x0008;
        public const int EVENT_SYSTEM_CAPTUREEND = 0x0009;
        public const int EVENT_SYSTEM_SWITCHSTART = 0x0014;
        public const int EVENT_SYSTEM_SWITCHEND = 0x0015;

        public const int EVENT_OBJECT_CREATE = 0x8000;
        public const int EVENT_OBJECT_DESTROY = 0x8001;
        public const int EVENT_OBJECT_SHOW = 0x8002;
        public const int EVENT_OBJECT_HIDE = 0x8003;
        public const int EVENT_OBJECT_FOCUS = 0x8005;
        public const int EVENT_OBJECT_STATECHANGE = 0x800A;
        public const int EVENT_OBJECT_LOCATIONCHANGE = 0x800B;

        public const int WINEVENT_OUTOFCONTEXT = 0x0000;
        public const int WINEVENT_SKIPOWNTHREAD = 0x0001;
        public const int WINEVENT_SKIPOWNPROCESS = 0x0002;
        public const int WINEVENT_INCONTEXT = 0x0004;

        // WinEvent fired when new Avalon UI is created
        public const int EventObjectUIFragmentCreate = 0x6FFFFFFF;

        // the delegate passed to USER for receiving a WinEvent
        public delegate void WinEventProcDef(int winEventHook, int eventId, IntPtr hwnd, int idObject, int idChild, int eventThread, uint eventTime);
        
        internal delegate bool EnumChildrenCallbackVoid(IntPtr hwnd, IntPtr lParam);
        
        // the delegate passed to USER for receiving an EnumThreadWndProc
        // internal delegate bool EnumThreadWndProc(IntPtr hwnd, ref ENUMTOOLTIPWINDOWINFO lParam);
        // the delegate passed to USER for receiving an EnumThreadWndProc
        public delegate bool EnumThreadWndProc(NativeMethods.HWND hwnd, NativeMethods.HWND lParam);

        [StructLayout(LayoutKind.Sequential)]
        internal struct Win32Rect
        {
            internal int left;
            internal int top;
            internal int right;
            internal int bottom;

            internal Win32Rect(int left, int top, int right, int bottom)
            {
                this.left = left;
                this.top = top;
                this.right = right;
                this.bottom = bottom;
            }

            internal bool IsEmpty
            {
                get
                {
                    return left >= right || top >= bottom;
                }
            }

            static internal Win32Rect Empty
            {
                get
                {
                    return new Win32Rect(0, 0, 0, 0);
                }
            }

            internal void Normalize(bool isRtoL)
            {
                // Invert the left and right values for right-to-left windows
                if (isRtoL)
                {
                    int temp = this.left;
                    this.left = this.right;
                    this.right = temp;
                }
            }
        }

        [StructLayout(LayoutKind.Sequential)]
        internal struct Win32Point
        {
            internal int x;
            internal int y;

            internal Win32Point(int x, int y)
            {
                this.x = x;
                this.y = y;
            }

        }

        [StructLayout(LayoutKind.Sequential)]
        internal struct SIZE
        {
            internal int cx;
            internal int cy;

            internal SIZE(int cx, int cy)
            {
                this.cx = cx;
                this.cy = cy;
            }
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        internal struct ENUMTOOLTIPWINDOWINFO
        {
            internal IntPtr hwnd;
            internal int id;
            internal string name;
        }

        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        internal struct ENUMCHILDWINDOWFROMRECT
        {
            internal IntPtr hwnd;
            internal NativeMethods.Win32Rect rc;
        }
    }

    internal static class ExternDll
    {

#if FEATURE_PAL && !SILVERLIGHT

#if !PLATFORM_UNIX
        internal const String DLLPREFIX = "";
        internal const String DLLSUFFIX = ".dll";
#else // !PLATFORM_UNIX
#if __APPLE__
        internal const String DLLPREFIX = "lib";
        internal const String DLLSUFFIX = ".dylib";
#elif _AIX
        internal const String DLLPREFIX = "lib";
        internal const String DLLSUFFIX = ".a";
#elif __hppa__ || IA64
        internal const String DLLPREFIX = "lib";
        internal const String DLLSUFFIX = ".sl";
#else
        internal const String DLLPREFIX = "lib";
        internal const String DLLSUFFIX = ".so";
#endif
#endif // !PLATFORM_UNIX

        public const string Kernel32 = DLLPREFIX + "rotor_pal" + DLLSUFFIX;
        public const string User32 = DLLPREFIX + "rotor_pal" + DLLSUFFIX;
        public const string Mscoree  = DLLPREFIX + "sscoree" + DLLSUFFIX;

#elif FEATURE_PAL && SILVERLIGHT

        public const string Kernel32 = "coreclr";
        public const string User32 = "coreclr";


#else
        public const string Activeds = "activeds.dll";
        public const string Advapi32 = "advapi32.dll";
        public const string Comctl32 = "comctl32.dll";
        public const string Comdlg32 = "comdlg32.dll";
        public const string Gdi32 = "gdi32.dll";
        public const string Gdiplus = "gdiplus.dll";
        public const string Hhctrl = "hhctrl.ocx";
        public const string Imm32 = "imm32.dll";
        public const string Kernel32 = "kernel32.dll";
        public const string Loadperf = "Loadperf.dll";
        public const string Mscoree = "mscoree.dll";
        public const string Clr = "clr.dll";
        public const string Msi = "msi.dll";
        public const string Mqrt = "mqrt.dll";
        public const string Ntdll = "ntdll.dll";
        public const string Ole32 = "ole32.dll";
        public const string Oleacc = "oleacc.dll";
        public const string Oleaut32 = "oleaut32.dll";
        public const string Olepro32 = "olepro32.dll";
        public const string PerfCounter = "perfcounter.dll";
        public const string Powrprof = "Powrprof.dll";
        public const string Psapi = "psapi.dll";
        public const string Shell32 = "shell32.dll";
        public const string User32 = "user32.dll";
        public const string Uxtheme = "uxtheme.dll";
        public const string WinMM = "winmm.dll";
        public const string Winspool = "winspool.drv";
        public const string Wtsapi32 = "wtsapi32.dll";
        public const string Version = "version.dll";
        public const string Vsassert = "vsassert.dll";
        public const string Fxassert = "Fxassert.dll";
        public const string Shlwapi = "shlwapi.dll";
        public const string Crypt32 = "crypt32.dll";
        public const string ShCore = "SHCore.dll";
        public const string Wldp = "wldp.dll";

        // system.data specific
        internal const string Odbc32 = "odbc32.dll";
        internal const string SNI = "System.Data.dll";

        // system.data.oracleclient specific
        internal const string OciDll = "oci.dll";
        internal const string OraMtsDll = "oramts.dll";

        // UI Automation
        internal const string UiaCore = "UIAutomationCore.dll";
#endif //!FEATURE_PAL
    }
    class MyQQ
    {
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        public struct GUITHREADINFO
        {
            public int cbSize;
            public int dwFlags;
            public NativeMethods.HWND hwndActive;
            public NativeMethods.HWND hwndFocus;
            public NativeMethods.HWND hwndCapture;
            public NativeMethods.HWND hwndMenuOwner;
            public NativeMethods.HWND hwndMoveSize;
            public NativeMethods.HWND hwndCaret;
            public NativeMethods.RECT rc;
        }

        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool GetGUIThreadInfo(int idThread, ref GUITHREADINFO guiThreadInfo);

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern NativeMethods.HWND GetDesktopWindow();

        [DllImport("user32.dll")]
        public static extern bool EnumThreadWindows(int dwThreadId, NativeMethods.EnumThreadWndProc enumThreadWndProc, NativeMethods.HWND lParam);

        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool GetWindowRect(NativeMethods.HWND hwnd, out NativeMethods.RECT rc);

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern bool IsWindow(NativeMethods.HWND hwnd);

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern bool IsWindowEnabled(NativeMethods.HWND hwnd);

        [DllImport("user32.dll")]
        public static extern bool IsWindowVisible(NativeMethods.HWND hwnd);

        [DllImport("user32.dll")]
        public static extern bool IsIconic(NativeMethods.HWND hwnd);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        public static extern int GetClassName(NativeMethods.HWND hWnd, StringBuilder classname, int nMax);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        public static extern int RealGetWindowClass(NativeMethods.HWND hWnd, StringBuilder classname, int nMax);

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        internal extern static bool IsChild(NativeMethods.HWND parent, NativeMethods.HWND child);

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern bool PhysicalToLogicalPoint(NativeMethods.HWND hwnd, ref NativeMethods.POINT pt);



        public const int VK_SHIFT = 0x10;
        public const int VK_CONTROL = 0x11;
        public const int VK_MENU = 0x12;

        public const int KEYEVENTF_EXTENDEDKEY = 0x0001;
        public const int KEYEVENTF_KEYUP = 0x0002;
        public const int KEYEVENTF_UNICODE = 0x0004;
        public const int KEYEVENTF_SCANCODE = 0x0008;

        public const int MOUSEEVENTF_VIRTUALDESK = 0x4000;

        [StructLayout(LayoutKind.Sequential)]
        public struct INPUT
        {
            public int type;
            public INPUTUNION union;
        };

        [StructLayout(LayoutKind.Explicit)]
        public struct INPUTUNION
        {
            [FieldOffset(0)] public MOUSEINPUT mouseInput;
            [FieldOffset(0)] public KEYBDINPUT keyboardInput;
        };

        [StructLayout(LayoutKind.Sequential)]
        public struct MOUSEINPUT
        {
            public int dx;
            public int dy;
            public int mouseData;
            public int dwFlags;
            public int time;
            public IntPtr dwExtraInfo;
        };

        [StructLayout(LayoutKind.Sequential)]
        public struct KEYBDINPUT
        {
            public short wVk;
            public short wScan;
            public int dwFlags;
            public int time;
            public IntPtr dwExtraInfo;
        };

        public const int INPUT_MOUSE = 0;
        public const int INPUT_KEYBOARD = 1;

        [DllImport("user32.dll", SetLastError = true)]
        public static extern int SendInput(int nInputs, INPUT[] mi, int cbSize);



        [DllImport("user32.dll")]
        public static extern void SwitchToThisWindow(NativeMethods.HWND hwnd, bool fAltTab);


        [DllImport(ExternDll.User32, ExactSpelling = true, SetLastError = true)]
        internal static extern bool EnumChildWindows(IntPtr hwndParent, NativeMethods.EnumChildrenCallbackVoid lpEnumFunc, IntPtr lParam);
    
        [DllImport(ExternDll.User32, ExactSpelling = true)]
        internal static extern bool SetForegroundWindow(IntPtr hWnd);

        [DllImport("user32.dll")]
        public static extern int FindWindowEx(int hwndParent, int hwndChildAfter, string lpszClass, string lpszWindow);
        [DllImport("user32.dll")]
        public static extern int FindWindow(string strclassName, string strWindowName);
        [DllImport("user32.dll")]
        public static extern int GetLastActivePopup(int hWnd);
        [DllImport("user32.dll")]
        public static extern int AnyPopup();
        [DllImport("user32.dll")]
        public static extern int GetWindowText(int hWnd, StringBuilder lpString, int nMaxCount);

        [DllImport("user32.dll")]
        public static extern int EnumWindows(NativeMethods.EnumChildrenCallbackVoid lpfn, int lParam);

        [DllImport("user32.dll", CharSet = CharSet.Auto)]
        public static extern int MoveWindow(IntPtr hWnd, int x, int y, int nWidth, int nHeight, bool BRePaint);

        public int AutoLogin(IntPtr hwndTX)
        {
            INPUT[] input = new INPUT[4];
            SetForegroundWindow(hwndTX);
            input[0].type = input[1].type = input[2].type = input[3].type = INPUT_KEYBOARD;
            input[0].union.keyboardInput.wVk = input[2].union.keyboardInput.wVk = VK_MENU;
            input[1].union.keyboardInput.wVk = input[3].union.keyboardInput.wVk = 0x53;
            input[2].union.keyboardInput.dwFlags = input[3].union.keyboardInput.dwFlags = KEYEVENTF_KEYUP;
            SendInput(4, input, input.Length * 56);
            return 0;
        }

        bool ChildrenCallback(IntPtr hwnd, IntPtr lParam)
        {
            // AutoLogin(myProc[i].Handle);
            Console.WriteLine("ChildWindow:" + hwnd);
            return true;
        }

        bool ThreadCallback(NativeMethods.HWND hwnd, NativeMethods.HWND lParam) 
        {
            Console.WriteLine("ChildWindow:" + hwnd);
            return true;
        }
        public int AllProcess()
        {
            Process[] myProc = Process.GetProcesses();
            for (int i = 0; i < myProc.Length; ++i)
            {
                if (myProc[i].ProcessName.Equals("QQ"))
                {
                    Console.WriteLine("ProcessName:" + myProc[i].ProcessName + ",id:" + myProc[i].Id + ",handle:" + myProc[i].Handle);
                    NativeMethods.HWND handle = NativeMethods.HWND.Cast(myProc[i].Handle);
                    Console.WriteLine("MainWindowTitle:" + myProc[i].MainWindowTitle + ",isWin:" + IsWindow(handle));
                    NativeMethods.RECT rect;
                    GetWindowRect(handle, out rect);
                    Console.WriteLine("MainWindowRect:" + rect.left + "," + rect.top + "," + rect.right + "," + rect.bottom);
                    // if (rect.right > 0 && rect.bottom > 0) 
                    {
                        MoveWindow(myProc[i].Handle, rect.left,  rect.top , rect.right , rect.bottom , true);
                        EnumChildWindows(myProc[i].Handle, ChildrenCallback, myProc[i].Handle);
                        EnumThreadWindows(myProc[i].Id, ThreadCallback, handle);
                    }
                }
            }
            Console.WriteLine("myProc:" + myProc.Length);
            return 0;
        }
        static public void Main()
        {
            MyQQ proc = new MyQQ();
            proc.AllProcess();
            Console.ReadLine();
        }
    }
}