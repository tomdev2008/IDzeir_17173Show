package com._17173.flash.core.ad.interfaces
{
	
	public interface IAdManager 
	{
		/**
		 * 初始化广告视频层 
		 * 
		 * @param config 从json数据转换而来的配置文件
		 * @return 
		 */		
		function init(data:Object, showFlag:Object):void;
		/**
		 * 广告是否可用 
		 * @param type
		 * @return 
		 */		
		function isAdAvalible(type:String):Boolean;
		/**
		 * 获取广告数据. 
		 * @param type
		 * @return 
		 */		
		function getAdData(type:String):Array;
		/**
		 * 获取广告的显示对象 
		 * @param type 来自于AdType
		 */		
		function getAd(type:String):IAdDisplay;
		
	}
}