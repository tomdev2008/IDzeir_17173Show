package com._17173.flash.show.base.module.lobby
{
	public interface IRoomCard
	{
		/**
		 * 卡片数据 
		 * @param value
		 * 
		 */		
		function set info(value:Object):void;
		
		/**
		 * 点击卡片跳转的地址 
		 * @return 
		 * 
		 */		
		function get url():String;
	}
}