package com._17173.flash.core.components.interfaces
{
	import flash.display.DisplayObject;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.GroupElement;

	public interface IGraphic
	{
		
		/**
		 * 初始化表情数据 
		 * @param faces 表情数据的数组
		 * @param _factory 生成表情图标的方法，参数为表情数据的url属性，返回一个显示对象
		 */		
		function createGraphic(faces:Array,_factory:Function):void;
		/**
		 * 将字符串转化成图文混排元素
		 * @param msg:String 待转化的字符串
		 * @param elf:ElementFormat 图文元素的格式
		 * @return 返回元素组
		 * */
		function getGroupElement(msg:String,elf:ElementFormat=null):GroupElement;
		
		/**
		 * 获取表情内容
		 * */
		function get graphicMap():Vector.<Object>;
		
		/**
		 * 向表情工厂中注入一个表情
		 * @param gaphic
		 * @return 返回该标签的使用标签
		 * 
		 */		
		function injectGraphic(gaphic:DisplayObject):String;
		/**
		 * 把字符串分成Vector作为GroupElement的内容 
		 * @param msg
		 * @param elf 指定的样式
		 * @return 
		 * 
		 */		
		function getElements(msg:String,elf:ElementFormat=null):Vector.<ContentElement>;
		/**
		 * 设置图文混排聊天的默认样式 
		 * @param value
		 * 
		 */		
		function set format(value:ElementFormat):void;
		/**
		 * 拷贝图文混排默认样式 
		 * @return 
		 * 
		 */		
		function cloneFormat():ElementFormat;
		
		/**
		 * 获取提取表情正则 
		 * @return 
		 * 
		 */		
		function get tagRegExp():RegExp;
		
		/**
		 * 返回字符串计算之后的长度，每个表情算一个长度 
		 * @param str
		 * @return 
		 * 
		 */
		function getTotal(str:String):uint;
	}
}