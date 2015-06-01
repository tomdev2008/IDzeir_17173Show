package com._17173.flash.show.base.context.module
{
	/**
	 * 模块代理类接口.
	 *  
	 * @author shunia-17173
	 */	
	public interface IModuleDelegate
	{
		
		/**
		 * 设置配置文件 
		 */		
		function load():void;
		/**
		 * 卸载加载的模块. 
		 */		
		function unload():void;
		/**
		 *自动加载 
		 * 
		 */		
		function autoLoad():void;
		/**
		 * 设置代理类配置.
		 * 需要指定代理的模块名称name以用于加载相应的模块.
		 * 需要指定代理的模块的版本号ver.
		 * 需要指定代理的模块的位置信息position.
		 *  
		 * @param value
		 */		
		function set config(value:Object):void;
		/**
		 * 获取当前被代理的模块.
		 *  
		 * @return 
		 */		
		function get module():IModule;
		
		
		/**
		 * 要执行的delegate方法，通过此调用回在模块加载前缓存数据，
		 * 加载完成之后释放数据 
		 * @param handle
		 * @param value
		 */		
		function excute(handle:Function,value:* = null):void;
	}
}