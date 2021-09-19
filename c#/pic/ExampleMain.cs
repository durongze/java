using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Collections.Generic;
using System.Reflection;
using Gif.Components;

namespace Example
{
	class ExampleMain
	{
		static void DrawYellowBox(int bx, int by, Graphics g)
		{
			SolidBrush yellowBrush = new SolidBrush(Color.FromArgb(255, 255, 0));
			SolidBrush greenBrush = new SolidBrush(Color.FromArgb(0, 128, 0));
			SolidBrush blackBrush = new SolidBrush(Color.Black);
			Pen borderPen = new Pen(Color.Black);
			Pen yellowPen = new Pen(Color.Yellow, 2); 
													  
			g.FillRectangle(yellowBrush, bx, by, 30, 30);
			g.FillRectangle(greenBrush, bx + 3, by + 3, 24, 24);
	
			g.DrawLine(borderPen, bx + 3, by + 5, bx + 24, by + 26);
			g.DrawLine(borderPen, bx + 5, by + 3, bx + 26, by + 24);
			g.DrawLine(yellowPen, bx + 3, by + 3, bx + 26, by + 26);
			g.DrawLine(borderPen, bx + 24, by + 3, bx + 4, by + 23);
			g.DrawLine(borderPen, bx + 26, by + 5, bx + 5, by + 26);
			g.DrawLine(yellowPen, bx + 26, by + 3, bx + 3, by + 26);

			g.DrawRectangle(borderPen, bx, by, 29, 29);
			g.DrawRectangle(borderPen, bx + 3, by + 3, 23, 23);
		}

		static void DrawWord(int bx, int by, Graphics g, String str)
		{
			Font f = new Font("����", 28);
			Brush b = new SolidBrush(Color.DarkOrange);
			g.DrawString(str, f, b, bx, by);
		}
		static int CalcCoordX(int width, int word, int idx)
		{
			return idx % width * word;
		}
		static int CalcCoordY(int width, int word, int idx)
		{
			return idx / width * word;
		}

		static Image DrawImage(Image img, String s, int i)
		{
			int x, y;
			Graphics g = Graphics.FromImage(img);
			x = CalcCoordX(6, 40, i);
			y = CalcCoordY(6, 40, i);
			DrawYellowBox(x, y, g);
			DrawWord(x, y, g, s.Substring(i, 1));
			return img;
		}

		static string[] GetAllFile(string path) 
		{
			string[] files = Directory.GetFiles(path, "*.png");
			return files;
		}
		static int GenImages(String str, String imageFile, List<Image> images)
		{
			Image imgSrc;
			if (!File.Exists(imageFile)) {
				Console.WriteLine(imageFile + " does not exist. pwd:" + System.IO.Directory.GetCurrentDirectory());
				return -1;
			}
			imgSrc = Image.FromFile(imageFile);
			
			for (int i = 0; i < str.Length; ++i) 
			{
				// images.Add((Image)DrawImage((Image)imgSrc.Clone(), str, i).Clone());
				images.Add((Image)DrawImage(imgSrc, str, i).Clone());
			}
			return 0;
		}

		static void LoadImages(String[] imageFiles, List<Image> images)
		{
			for (int i = 0; i < imageFiles.Length; ++i)
			{
				images.Add(Image.FromFile(imageFiles[i]));
			}
		}
		static void EncGifFile(List<Image> images, String outputFile)
		{
			MemoryStream memStream = new MemoryStream();
			AnimatedGifEncoder e = new AnimatedGifEncoder();
			e.Start(memStream);
			e.SetDelay(500);
			//-1:no repeat,0:always repeat
			e.SetRepeat(0);
			for (int i = 0, count = images.Count; i < count; i++)
			{
				e.AddFrame(images[i]);
			}
			e.Finish();
			FileStream fs = new FileStream(outputFile, FileMode.OpenOrCreate);
			BinaryWriter w = new BinaryWriter(fs);
			w.Write(memStream.ToArray());
			fs.Close();
			memStream.Close();
		}
		static void DecGifFile(string gifFile, string outputPath)
		{
			GifDecoder gifDecoder = new GifDecoder();
			gifDecoder.Read(gifFile);
			for (int i = 0, count = gifDecoder.GetFrameCount(); i < count; i++)
			{
				Image frame = gifDecoder.GetFrame(i);  // frame i
				frame.Save(outputPath + Guid.NewGuid().ToString() + ".png", ImageFormat.Png);
			}
		}
		[STAThread]
		static void Main(string[] args)
		{
			List<Image> images = new List<Image>();
			Console.WriteLine("GenImages. pwd:" + System.IO.Directory.GetCurrentDirectory());
			int ret = GenImages("durongze", "res/00.png", images);
			if (ret != 0) {
				return ;
			}
			// string [] PngFiles = GetAllFile("res");
			// LoadImages(PngFiles, images);
			EncGifFile(images, "res/out.gif");
		}
	}
}
