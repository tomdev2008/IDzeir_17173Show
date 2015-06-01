package com._17173.framework.core.objpool.ibase
{
	/** 
	 * @author Cray
	 * @version 创建时间：Oct 25, 2014 11:42:39 PM 
	 **/ 
	public interface IBaseObjectPool
	{
		/**
		 * 清理对象池 
		 * 
		 */		
		function clear():void;
		/**
		 * 关闭对象池 
		 * 
		 */		
		function close():void;
		/**
		 * 对象池是否激活 
		 * @return 
		 * 
		 */		
		function get active():Boolean;
		/**
		 * 设置对象池状态 
		 * @param value
		 * 
		 */		
		function set active(value:Boolean):void;
	}
}