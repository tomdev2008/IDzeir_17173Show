package com._17173.flash.show.base.context.text
{
	import com._17173.flash.core.components.interfaces.IGraphic;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-19  下午7:29:31
	 */
	public interface IGraphicTextManager
	{
		/**
		 * 创建一个图文混排显示对象
		 * @param elements 每个元素实现IGraphicElement接口
		 * @param options 实现IOption接口的配置文本属性参数
		 * @return
		 *
		 */
		function createGraphicText(elements:Array = null, options:* = null):DisplayObject;
		/**
		 * 从json里面获取表情数据，初始化表情工厂
		 * @param value
		 * @param _factory 表情加载方法
		 */
		function initFactory(value:Object,_factory:Function):void;

		/**
		 * 获取图文混排元素工厂
		 * @return
		 *
		 */
		function get factory():IGraphic;

		/**
		 * 从对象池获取 GraphicTextElement
		 * @return
		 *
		 */
		function createElement():GraphicTextElement;

		/**
		 * 回收图文混排显示对象
		 * @param line
		 * @return
		 *
		 */
		function returnObject(line:DisplayObject):Boolean;

		/**
		 * 图文混排事件集中处理器
		 * @return
		 *
		 */
		function get controler():EventDispatcher;

		/**
		 * 注册图文混排点击事件
		 * @param action
		 * @param handler 接受一个参数，为ContentElement的userData为可选参数
		 * @return
		 */
		function registerAction(action:String, handler:Function):Boolean;

		/**
		 * 删除图文混排点击事件
		 * @param action
		 * @param handler 接受一个参数，为ContentElement的userData为可选参数
		 * @return
		 */
		function removeAction(action:String, handler:Function):Boolean
	}
}