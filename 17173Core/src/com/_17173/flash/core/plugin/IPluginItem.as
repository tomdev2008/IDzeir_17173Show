package com._17173.flash.core.plugin
{
	import flash.events.IEventDispatcher;

	public interface IPluginItem extends IEventDispatcher
	{
		function set name(value:String):void;
		function get name():String;
		function init():void;
		function get isInited():Boolean;
	}
}