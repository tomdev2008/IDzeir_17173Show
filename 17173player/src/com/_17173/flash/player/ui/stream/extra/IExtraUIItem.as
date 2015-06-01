package com._17173.flash.player.ui.stream.extra
{
	import flash.events.IEventDispatcher;

	public interface IExtraUIItem extends IEventDispatcher
	{
		
		function refresh(isFullScreen:Boolean = false):void;
		function get side():Boolean;
	}
}