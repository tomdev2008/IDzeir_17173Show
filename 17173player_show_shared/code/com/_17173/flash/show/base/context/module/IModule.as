package com._17173.flash.show.base.context.module
{
	/**
	 * 模块要实现的默认接口.
	 * 如果需要利用模块对外进行接口调用,那么应该在继承BaseModule的基础上,设计并实现自己需要的接口.
	 *  
	 * @author shunia-17173
	 */	
	public interface IModule
	{
		
		/**
		 * 定义一个名字.用以进行区分.
		 * 实际实现里是一个预定义的模块相对路径.
		 *  
		 * @param value
		 */		
		function set name(value:String):void;
		function get name():String;
		/**
		 * 默认的数据接口,
		 * 可以通过该接口进行数据传递.不支持只写属性,key/value的属性赋值，key为属性,value为数组打包的值
		 * 同时可以可以执行key/value的函数调用，key为函数,value为数组打包的参数，无参数可value = null
		 * @param value
		 */		
		function set data(value:Object):void;
		
		/**
		 * 模块版本
		 */
		function get version():String;
	}
}