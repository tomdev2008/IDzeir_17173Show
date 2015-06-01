package com._17173.flash.core.util
{
	public class uid
	{
		private static var _id:Number = -1;
		
		public static function getID():Number {
			return _id ++;
		}
		
	}
}