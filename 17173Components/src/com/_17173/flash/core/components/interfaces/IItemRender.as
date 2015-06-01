package com._17173.flash.core.components.interfaces
{
	/** 
	 * @author idzeir
	 * 创建时间：2014-2-12  上午9:55:23
	 */
	public interface IItemRender
	{
		/**
		 * 初始化执行 
		 * @param value
		 */		
		function startUp(value:Object):void;
		
		/**
		 * 鼠标滑过执行 
		 */		
		function onMouseOver():void;
		/**
		 * 鼠标滑出执行 
		 */		
		function onMouseOut():void;
		/**
		 * 选中执行 
		 */		
		function onSelected():void;
		/**
		 * 取消选中执行 
		 */		
		function unSelected():void;
	}
}