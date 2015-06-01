package com._17173.flash.show.base.context.net
{
	
	public interface IHttpService
	{
		
		/**
		 * get数据.
		 *  
		 * @param action	接口路径
		 * @param params	get参数,可以是urlvariables或者k-v形式的object
		 * @param onResult	成功回调,回调方法需要接受一个数据参数.可以为空
		 * @param onFail	失败回调.可以为空
		 * @param skipErrorCheck 是否跳过通用的error处理逻辑
		 * @return 
		 */		
		function getData(action:String, params:Object, onResult:Function, onFail:Function = null, skipErrorCheck:Boolean = false):void;
		/**
		 * post数据.
		 *  
		 * @param action	接口路径
		 * @param data		post数据,可以是urlvariables或者k-v形式的object
		 * @param onResult	成功回调,回调方法需要接受一个数据参数.可以为空
		 * @param onFail	失败回调.可以为空
		 * @param skipErrorCheck 是否跳过通用的error处理逻辑
		 * @return 
		 */		
		function postData(action:String, data:Object, onResult:Function = null, onFail:Function = null, skipErrorCheck:Boolean = false):void;
		/**
		 * 获取素材.
		 *  
		 * @param url
		 * @param onResult
		 * @param onFail
		 */		
		function getAsset(url:String, onResult:Function, onFail:Function = null):void;
		/**
		 * 获取文本文件.
		 *  
		 * @param url
		 * @param onResult
		 * @param onFail
		 */		
		function getFile(url:String, onResult:Function, onFail:Function = null):void;
		
		/**
		 * 关闭http接口功能 默认为true
		 * @param bool
		 * 
		 */		
		function set enabled(bool:Boolean):void;
		
	}
}