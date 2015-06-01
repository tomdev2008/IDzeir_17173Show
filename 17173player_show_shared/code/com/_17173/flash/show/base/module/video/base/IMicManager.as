package com._17173.flash.show.base.module.video.base
{
	

	public interface IMicManager
	{
		/**
		 * 上麦 
		 * @param data  参数为userId 和micindex
		 * 
		 */		
		function micUp(data:Object):void;
		
		/**
		 * 下麦 
		 * @param data 参数为micIndex
		 * 
		 */		
		function micDown(data:Object):void;
		
		/**
		 * 切麦 
		 * @param data 参数为micIndex
		 * 
		 */		
		function micChange(data:Object):void;
		
		/**
		 * 闭麦 
		 * @param data  参数为micIndex，userId
		 * 
		 */		
		function micSoundClose(data:Object):void;
		
		/**
		 * 开麦 
		 * @param data  参数为micIndex，userId
		 * 
		 */		
		function micSoundOpen(data:Object):void;
		
		/**
		 * 上麦序 
		 * @param data
		 * 
		 */		
		function micUpList(data:Object):void;
		
		
		/**
		 * 下麦序 
		 * @param data  参数为userId 要关闭的用户id
		 * 
		 */		
		function micDownList(data:Object):void;
		
	}
}