package com._17173.flash.show.base.context.module
{
	/**
	 * 模块管理类的接口.
	 * 主要实现了统一的初始化,和接口上的加载管理.
	 *  
	 * @author shunia-17173
	 */	
	public interface IModuleManager
	{
		
		/**
		 * 注册模块对应的delegate类.
		 *  
		 * @param moduleName 模块名
		 * @param delegate 模块的class
		 * @isMain 是否主要模块（用于加载策略）
		 */		
		function regDelegate(moduleName:String, delegate:Class = null ,isMain:Boolean = false):void;
		/**
		 * 注销模块对应的delegate类.
		 *  
		 * @param moduleName 模块名
		 */	
		function deregisterDelegate(moduleName:String):void;
		/**
		 * 加载指定的模块.
		 *  
		 * @param moduleName 模块名
		 */		
		function load(moduleName:String):void;
		/**
		 * 卸载指定的模块 
		 * 
		 * @param moduleName 模块名
		 */		
		function unload(moduleName:String):void;
		/**
		 * 获取指定的模块delegate实例.
		 *  
		 * @param moduleName 模块名
		 * @return 指定的模块实例
		 */		
		function get(moduleName:String):IModuleDelegate;
		/**
		 * 判断指定模块是否存在 
		 * 
		 * @param moduleName 模块名
		 * @return 是否存在
		 */		
		function hasModule(moduleName:String):Boolean;
		/**
		 * 加载所有注册的delegate 
		 */		
		function loadAll():void;
		/**
		 * 加载所有注册的delegate 
		 */		
		function loadAllSub():void;
		/**
		 * 卸载所有当前的delegate 
		 */		
		function unloadAll():void;
		/**
		 * 初始化注册了但没有被初始化过的模块 
		 */		
		function initMain():void;
		/**
		 *初始化次要模块 
		 * @return 
		 * 
		 */		
		function initAllSub():void;
		/**
		 * 设置配置文件
		 *  
		 * @param value 配置文件转换而成的数据
		 */		
		function set config(value:*):void;
	}
}