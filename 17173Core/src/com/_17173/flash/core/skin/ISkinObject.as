package com._17173.flash.core.skin
{
	import flash.display.DisplayObject;
	
	/**
	 * 封装皮肤接口,提供处理set/get,实例方法,事件的封装处理方法.
	 * 提供实际封装的元件的实例.
	 * 
	 * 这个接口的实现意义,是将素材中的对象(movieClip),或者实际的显示对象(比如各种ui控件)封装起来,通过接口中的统一的接口方法,进行调用和处理
	 *  
	 * @author shunia-17173
	 */	
	public interface ISkinObject
	{
		/**
		 * 通过属性名,获取component中的公共属性.
		 *  
		 * @param propertyName
		 * @return 
		 */		
		function get(propertyName:String):*;
		/**
		 * 通过属性名,设置component中的公共属性.
		 *  
		 * @param propertyName
		 * @param value
		 */		
		function set(propertyName:String, value:*):void;
		/**
		 * 通过方法名调用component中的公共方法.
		 *  
		 * @param functionName
		 * @param args
		 */		
		function call(functionName:String, ...args):void;
		/**
		 * 通过事件名称,为component添加事件监听
		 *  
		 * @param eventName
		 * @param callback
		 * @param capture
		 */		
		function listen(eventName:String, callback:Function, capture:Boolean = false):void;
		/**
		 * 通过事件名称,为component添加事件回调
		 *  
		 * @param eventName
		 * @param data
		 */		
		function on(eventName:String, data:Object):void;
		/**
		 * 获取实际的component显示对象
		 *  
		 * @return 
		 */		
		function get display():DisplayObject;
	}
}