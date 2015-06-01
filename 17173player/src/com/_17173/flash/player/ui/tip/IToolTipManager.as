package com._17173.flash.player.ui.tip
{
	import flash.display.DisplayObject;

	public interface IToolTipManager
	{
		/**
		 * 注册tooltip 
		 * @param dsObj 注册显示对象
		 * @param htmlText 显示文本
		 * 
		 */		
		function registerTip(dsObj:DisplayObject,htmlText:String):void;
		/**
		 *注册tooltip1 
		 * @param dsObj 注册显示对象
		 * @param showDsObj 显示提示
		 * 
		 */		
		function registerTip1(dsObj:DisplayObject,showDsObj:DisplayObject):void;
		/**
		 *销毁 tooltip 
		 * @param dsObj
		 * 
		 */		
		function destroyTip(dsObj:DisplayObject):void;
		/**
		 * 获取场景上空余的可用空间坐标位置.
		 *  
		 * @return 
		 */		
		
		/**
		 *初始化tip样式 
		 * 
		 */		
		function initToolTip():void;
	}
}