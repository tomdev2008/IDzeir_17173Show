package com._17173.flash.core.locale
{
	public interface ILocale
	{
		/**
		 * 当前语言环境.
		 * 
		 * 现有"zh_CN"或者"en_US".
		 *  
		 * @return 
		 */		
		function get locale():String;
		/**
		 * 通过一个包名和字段名称获取对应的语言文字.
		 *  
		 * @param key
		 * @param p
		 * @param params
		 * @return 
		 */		
		function get(key:String, p:String = "default", params:Array = null):String;
	}
}