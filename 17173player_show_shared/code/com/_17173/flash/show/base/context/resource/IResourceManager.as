package com._17173.flash.show.base.context.resource
{
	
	import flash.display.MovieClip;

	public interface IResourceManager
	{
		/**
		 *通过键与mc获取bitmaAnim对象 
		 * @param key key
		 * @param mc 动画对象
		 * @return  缓存成功
		 * 
		 */		
		function addAnimDatas4Mc(key:String, mc:MovieClip, colorClip:Boolean = true):Boolean;
		/**
		 *获取AnimData数组
		 * @param key 键
		 * @return 动画数组
		 * 
		 */	
		function getAnimDatas(key:String):Array;
		/**
		 *获取资源 
		 * @param url 地址（皮肤文件需要调用 RESOURCE_PATH + 文件名）
		 * @param key  swf中链接名
		 * @param callBack 回调
		 * 
		 */		
		function loadResource(url:String,callBack:Function = null,key:String = null):void;
		/**
		 *过期检测 
		 * 
		 */		
		function checkExpired():void; 
	}
}