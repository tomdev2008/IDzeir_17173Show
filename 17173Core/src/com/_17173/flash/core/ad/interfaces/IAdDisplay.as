package com._17173.flash.core.ad.interfaces
{
	import com._17173.flash.core.interfaces.IDisposable;
	
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	/**
	 * 广告显示对象接口
	 *  
	 * @author shunia-17173
	 */	
	public interface IAdDisplay extends IDisposable, IEventDispatcher
	{
		
		/**
		 * 大小改变时进行通知. 
		 * @param w
		 * @param h
		 */		
		function resize(w:Number, h:Number):void;
		/**
		 * 获取该广告所指向的显示对象. 
		 * @return 
		 */		
		function get display():DisplayObject;
		/**
		 * 设置广告数据来更新广告. 
		 * @param value
		 */		
		function set data(value:Array):void;
		function get data():Array;
		
		/**
		 * 源数据
		 * @return 
		 * 
		 */		
		function get sourceData():Array;
		/**
		 * 高度 
		 * @param value
		 */		
		function set height(value:Number):void;
		function get height():Number;
		/**
		 * 宽度 
		 * @param value
		 */		
		function set width(value:Number):void;
		function get width():Number;
		/**
		 * 获取当前是否有错误
		 * @return 
		 * 
		 */		
		function get error():Boolean;
	}
}