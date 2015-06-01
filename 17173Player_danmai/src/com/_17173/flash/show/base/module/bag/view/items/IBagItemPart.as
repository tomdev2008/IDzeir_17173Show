package com._17173.flash.show.base.module.bag.view.items
{
	import flash.display.DisplayObject;

	/**
	 *背包item部件接口 
	 * @author yeah
	 */	
	public interface IBagItemPart
	{
	
		/**
		 *数据 
		 * @return 
		 */		
		function get data():Object;
		function set data(value:Object):void;
		
		/**
		 *返回本身 
		 * @return 
		 */		
		function get self():DisplayObject;
		
		/**
		 *部件类型 
		 * @return 
		 */		
		function get type():String;
		
		/**
		 *是否适用自动布局(垂直排列) 
		 * 如果=false 请在item初始化时手动在item内部设置其位置如果需要
		 * @return 
		 */		
		function get autoAlign():Boolean;
	}
}