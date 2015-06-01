package com._17173.framework.core.objpool.ibase
{
	/** 
	 * @author Cray
	 * @version 创建时间：Oct 26, 2014 9:54:16 AM 
	 **/ 
	public interface IGenericObjectPool extends IBaseObjectPool
	{
		function borrowObject():IObject;
		function borrowObjectVector(value:int):Vector.<IObject>;
		function returnObject(obj:IObject):void;
		function returnObjectVector(vec:Vector.<IObject>):void;
	}
}