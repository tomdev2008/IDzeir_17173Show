package com._17173.flash.core.components.interfaces
{
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GroupElement;

	public interface IOutputTxt
	{
		/**
		 * 添加一条显示记录,不是立即显示出来，定时器从队列里面定时取
		 * @param str:String 加入显示的文本内容
		 * @param elf:ElementFormat 本行显示内容的格式
		 */
		function append(str:String,elf:ElementFormat=null):void;
		
		/**
		 * 向文本中添加一条显示元素 
		 * @param element 
		 * 
		 */		
		function addElement(element:GroupElement):void
		
		/**
		 * 重新设置大小
		 */
		function resize():void;
		
		/**
		 * 清除文本内容
		 */
		function clear():void;
		
		/**
		 * 销毁文本
		 */
		function dispose():void;
		
		/**
		 * 文本宽度
		 * @param value:Number 文本宽
		 */
		function set textWidth(value:Number):void;
		
		/**
		 * 文本最大行数
		 */
		function set maxLines(value:uint):void;
		
		/**
		 * 文本最大行数
		 */
		function get maxLines():uint;
		
		/**
		 * 聊天锁定状态 
		 * @return 
		 * 
		 */		
		function get locked():Boolean;
	}
}