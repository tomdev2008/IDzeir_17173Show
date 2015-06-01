package com._17173.flash.core.interactive
{
	public interface IKeyboardManager
	{
		/**
		 * 可以注册一个键盘组合和回调函数,用以在按键被触发时回调相应功能.
		 *  
		 * @param callback
		 * @param keys	需要是从Keyboard类中获取的对应的按键值
		 */		
		function registerKeymap(callback:Function, ...keys):void;
		/**
		 * 是否可用 
		 * @return 
		 * 
		 */		
		function get enable():Boolean;
		function set enable(value:Boolean):void;
	}
}