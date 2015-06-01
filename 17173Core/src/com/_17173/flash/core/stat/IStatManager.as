package com._17173.flash.core.stat
{
	public interface IStatManager
	{
		
		/**
		 * 发出统计数据 
		 * @param data {"key":"value"}形式的值对
		 */		
		function stat(data:Object = null):void;
		
	}
}