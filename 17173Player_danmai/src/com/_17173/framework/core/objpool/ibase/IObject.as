package com._17173.framework.core.objpool.ibase
{
	/** 
	 * @author Cray
	 * @version 创建时间：Oct 25, 2014 11:34:37 PM 
	 **/ 
	public interface IObject
	{
		/**
		 * 重置数据 
		 * 
		 */		
		function reset():void;
		/**
		 * 销毁所有引用
		 * EG: removeEventListener, obj=null
		 * 等待GC回收 
		 * 
		 */		
		function dipose():void;
	}
}