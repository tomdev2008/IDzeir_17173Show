package com._17173.flash.player.ad_refactor.display
{
	import com._17173.flash.player.ad_refactor.interfaces.IAdAsync;
	
	import flash.display.DisplayObject;

	public interface IAdDisplay_refactor extends IAdAsync
	{
		/**
		 * 缩放方法
		 *  
		 * @param w
		 * @param h
		 */		
		function resize(w:int, h:int):void;
		/**
		 * 获取实际的显示对象,绝大部分情况下使用自身即可.
		 *  
		 * @return 
		 */		
		function get display():DisplayObject;
		
	}
}