package com._17173.framework.core.manager
{
	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 28, 2014 11:00:49 AM
	 */
	public interface IModuleDisplayManager
	{
		/**
		 * 指定到某个模块停止下载 
		 * @param name
		 * 
		 */		
		function stopLoadAtModuleName(name:String):void;
		/**
		 * 重新启动下载 
		 * 必须之前有停止过
		 */		
		function continueLoad():void;	
		/**
		 * 启动配置 
		 * 
		 */		
		function startUp():void;
		/**
		 * 加载所有模块 
		 * 
		 */		
		function loadModuleAll():void;
		/**
		 * 获得模块信息 
		 * @param name
		 * @return 
		 * 
		 */		
		function getModuleBeanInfo(name:String):IModuleBeanInfo;
		/**
		 * 将模块加载到舞台 
		 * @param modBeanInfo
		 * 
		 */		
		function addModule(name:String):void;
		/**
		 * 在舞台上删除模块 
		 * @param modBeanInfo
		 * 
		 */		
		function removedModule(name:String):void;
		/**
		 * 是否包含模块 
		 * @param name
		 * @return 
		 * 
		 */		
		function containsModule(name:String):Boolean;
		/**
		 * 立即更新模块显示列表 
		 * 
		 */		
		function updateModuleDisplay():void;
	}
}