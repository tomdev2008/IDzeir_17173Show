package com._17173.flash.show.base.components.interfaces
{
	import flash.display.DisplayObject;

	public interface IMoveContainer
	{
		/**
		 *添加显示组件 如果成功才可以继续
		 * @param item
		 * 
		 */		
		function playItem(item:DisplayObject):Boolean;
		/**
		 *移除 
		 * @param item
		 * 
		 */		
		function removeItem(item:DisplayObject):void;
		/**
		 *插入 
		 * @param item
		 * 
		 */		
		function insertItem(item:DisplayObject):Boolean;
		
		/**
		 *开始 
		 * 
		 */		
		function start():void;
		/**
		 *停止 
		 * 
		 */		
		function stop():void;
		/**
		 *清空 
		 * 
		 */		
		function clean():void;
	}
}