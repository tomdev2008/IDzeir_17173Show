package com._17173.flash.show.base.module.preloader
{
	/**
	 * Preloader 模块的接口.
	 *  
	 * @author shunia-17173
	 */	
	public interface IPreloader
	{
		
		/**
		 * 启动一项Preloader.
		 *  
		 * @param name
		 */		
		function start(name:String):void;
		/**
		 * 更新当前启动项的进度.
		 *  
		 * @param progress
		 */		
		function progress(progress:Number):void;
		/**
		 * 完成当前启动项.
		 *  
		 * @param name
		 */		
		function complete(name:String):void;
		
	}
}