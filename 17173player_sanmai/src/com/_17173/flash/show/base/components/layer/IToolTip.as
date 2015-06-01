package com._17173.flash.show.base.components.layer
{
	import flash.display.DisplayObject;

	public interface IToolTip
	{
		function registerTip(dsObj:DisplayObject,htmlText:String):void;
		function registerTip1(dsObj:DisplayObject,showDsObj:DisplayObject):void;
		function destroyTip(dsObj:DisplayObject):void;
	}
}