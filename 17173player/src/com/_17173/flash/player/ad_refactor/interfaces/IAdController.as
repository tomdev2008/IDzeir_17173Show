package com._17173.flash.player.ad_refactor.interfaces
{
	import flash.events.IEventDispatcher;

	public interface IAdController extends IEventDispatcher
	{
		
		/**
		 * 根据提供的数据解析接下来的业务逻辑.
		 * 数据包含错误数据或者得到的广告数据序列.
		 *  
		 * @param value
		 */		
		function set data(value:Object):void;
		/**
		 * 释放 
		 */		
		function dispose():void;
		
	}
}