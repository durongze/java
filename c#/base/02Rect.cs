using System;
namespace Rectangle
{
	class Rect
	{
		double length = 2;
		double width = 1;
		public double GetArea()
		{
			return length * width;
		}
	}
	
	class ExcRect
	{
		static void Main()
		{
			Rect r = new Rect();
			Console.WriteLine("Area:{0}", r.GetArea());
		}
	}
	
}