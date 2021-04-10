using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
 
namespace TCPClient
{
    class Program
    {
        static void Main(string[] args)
        {
            ThreadPool.SetMinThreads(100, 100);
            ThreadPool.SetMaxThreads(200, 200); 

            Parallel.For(1, 10, x =>
            {
                SendData("Tom");
            });

            Console.WriteLine("All Completed!");
            Console.ReadKey();
        }

        private static void SendData(string Name)
        {
            Task.Run(() =>
            {
                Console.WriteLine("Start");
                TcpClient tcpClient = new TcpClient();
                tcpClient.Connect("127.0.0.1", 9000);
                Console.WriteLine("Connected");
                NetworkStream netStream = tcpClient.GetStream();

                Task.Run(() =>
                {
                    Thread.Sleep(100);
                    while (true)
                    {
                        if (!tcpClient.Client.Connected)
                        {
                            break;
                        }

                        if (netStream == null)
                        {
                            break;
                        }

                        try
                        {
                            if (netStream.DataAvailable)
                            {
                                byte[] data = new byte[1024];
                                int len = netStream.Read(data, 0, 1024);
                                var message = Encoding.UTF8.GetString(data, 0, len);
                                Console.WriteLine(message);
                            }
                        }
                        catch
                        {
                            break;
                        }

                        Thread.Sleep(10);
                    }
                });

                for (int i = 0; i < 100; i++)
                {
                    byte[] datas = Encoding.UTF8.GetBytes(Name);
                    int Len = datas.Length;
                    netStream.Write(datas, 0, Len);
                    Thread.Sleep(1000);
                }

                netStream.Close();
                netStream = null;
                tcpClient.Close();

                Console.WriteLine("Completed");
            });
        }  
    }
}