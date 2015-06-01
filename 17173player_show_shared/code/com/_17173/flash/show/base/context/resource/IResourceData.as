package com._17173.flash.show.base.context.resource
{

	public interface IResourceData
	{
		/**
		 *获取key 
		 * @return 
		 * 
		 */		
		function get key():String;
		/**
		 *获取资源(clone)
		 * @return 
		 * 
		 */		
		function get source():*;
		/**
		 *获取新建资源 
		 * @return 
		 * 
		 */		
		function get newSource():*;
		/**
		 *最后加载时间 
		 * @return 
		 * 
		 */		
		function get loadedTime():int;
	}
}