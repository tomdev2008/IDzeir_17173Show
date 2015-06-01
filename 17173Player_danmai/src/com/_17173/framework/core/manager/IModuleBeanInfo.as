package com._17173.framework.core.manager
{
	import com._17173.framework.core.module.IModuleInfo;

	/**
	 * @author Cray
	 * @version 1.0
	 * @date Oct 28, 2014 10:54:36 AM
	 */
	public interface IModuleBeanInfo
	{
		function get name():String;
		function get add():Boolean;
		function get load():Boolean;
		function get fixed():Boolean;
		function get interactive():Boolean;
		function get delayLoad():Number;
		function set delayLoad(value:Number):void;
		function get center():Number;
		function set center(value:Number):void;
		function get middle():Number;
		function set middle(value:Number):void;
		function get top():Number;
		function set top(value:Number):void;
		function get bottom():Number;
		function set bottom(value:Number):void;
		function get left():Number;
		function set left(value:Number):void;
		function get right():Number;
		function set right(value:Number):void;
		function get moduleInfo():IModuleInfo;
		function set moduleInfo(module:IModuleInfo):void;
	}
}