package com._17173.flash.show.base.module.userCard
{
	public interface IUserCardData
	{
		
		/**
		 * 卡片要显示的用户id.
		 *  
		 * @param value
		 */		
		function set uid(value:String):void;
		function get uid():String;
		/**
		 * 基本的用户操作项集合.
		 *  
		 * @return 
		 */		
		function get baseActions():Array;
		/**
		 * 可扩展的用户操作项集合.
		 *  
		 * @return 
		 * 
		 */		
		function get expandActions():Array;
		
	}
}