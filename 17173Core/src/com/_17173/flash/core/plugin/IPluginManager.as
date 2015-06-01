package com._17173.flash.core.plugin
{
	public interface IPluginManager
	{
		
		/**
		 * 添加一个plugin定义.
		 * 如果该plugin是class定义,则module参数为必须.
		 * 如果该plugin是外部模块(.swf),则module参数为空.
		 *  
		 * @param name
		 * @param module
		 */		
		function addPlugin(name:String, module:Class = null):void;
		/**
		 * 获取一个plugin.如果该plugin已经被添加,则根据其是否被初始化来决定初始化或者从缓存里获取并返回.
		 * 如果该plugin不存在,则当成外部模块引用处理,自行添加并试图加载外部模块.
		 *  
		 * @param name
		 * @return 
		 */		
		function getPlugin(name:String):IPluginItem;
		/**
		 * 通过name确定一个plugin是否存在于添加过的定义中.
		 *  
		 * @param name
		 * @return 
		 */		
		function hasPlugin(name:String):Boolean;
		/**
		 * 移除一个plugin.
		 *  
		 * @return 
		 */		
		function removePlugin():Boolean;
		
	}
}