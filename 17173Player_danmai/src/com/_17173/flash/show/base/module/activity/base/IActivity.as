package com._17173.flash.show.base.module.activity.base
{
	import flash.display.DisplayObjectContainer;

	public interface IActivity
	{
		/**
		 *获取请求数据 
		 * @param url
		 * 
		 */		
		function getDate(url:String):void;
		/**
		 *移除显示 
		 * 
		 */		
		function remove():void;
		/**
		 *显示 
		 * 
		 */		
		function show():void;
		/**
		 *活动名 
		 * @return 
		 * 
		 */		
		function get actName():String;
		
		function set actName(name:String):void;
		/**
		 *设置父级 
		 * @param dsp
		 * 
		 */		
		function set parent(dsp:DisplayObjectContainer):void;
	}
}