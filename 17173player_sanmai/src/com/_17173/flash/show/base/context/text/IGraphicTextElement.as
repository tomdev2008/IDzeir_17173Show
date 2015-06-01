package com._17173.flash.show.base.context.text
{

	/**
	 * @author idzeir
	 * 创建时间：2014-2-19  下午7:33:02
	 */
	public interface IGraphicTextElement
	{
		/**
		 * 图文混排 元素颜色
		 * @return
		 *
		 */
		function get color():Number;

		function set color(value:Number):void;
		/**
		 * 图文混排字体大小
		 * @return
		 *
		 */
		function get size():Number;

		function set size(value:Number):void;
		/**
		 * 图文混排字体
		 * @return
		 *
		 */
		function get font():String;

		function set font(value:String):void;
		/**
		 * 图文混排超链接
		 * @param value
		 *
		 */
		function set link(value:String):void;

		function get link():String;


		/**
		 * 获取数据内容，String或者显示对象
		 *  @param value
		 *
		 */
		function set content(value:*):void

		function get content():*;

		/**
		 * 内容元素的类型
		 *  @param value
		 *
		 */
		function set type(value:uint):void

		function get type():uint;

		/**
		 * 重置数据
		 *
		 */
		function reset():void;
	}
}