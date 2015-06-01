package com._17173.flash.show.base.module.seat
{
	import flash.geom.Point;

	public class SeatConfig
	{
		public function SeatConfig()
		{
		}
		/**
		 *每排座位起点 
		 */		
		public static var potConfig:Array = [new Point(146,39),new Point(22,60),new Point(23,102)];
		/**
		 *每排座位数量 
		 */		
		public static var seatRowCountConfig:Array = [15,21,21];
		/**
		 *座位宽度 
		 */		
		public static const seatSpace:int = 40;
		/**
		 *站立时间 
		 */		
		public static const standTime:int = 4000;
		/**
		 *坐下后cd时间 
		 */		
		public static const standWaitTime:int = 2000;
		/**
		 *座位组件宽度 
		 */		
		public static const seatWidth:int = 155;
		/**
		 *座位组件高度 
		 */		
		public static const seatHeight:int = 135;
		
		/**
		 * 座位高度偏移量
		 */		
		public static const seatRowYs:Array = [
			[0, 5, 5, 5, 2, 2, 1, 0, 0, -1, -2, -3, -4, -5, -6],
			[0, 6, 6, 6, 5, 5, 4, 4, 3, 1, 0, -1, -1, -2, -4, -5, -5, -6, -6, -6, -6],
			[0, 6, 6, 5, 5, 5, 4, 4, 3, 2, 1, 0, -1, -2, -4, -5, -5, -5, -6, -5, -6]
		]
	}
}