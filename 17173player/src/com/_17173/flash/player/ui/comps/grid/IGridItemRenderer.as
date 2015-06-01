package com._17173.flash.player.ui.comps.grid
{
	import com._17173.flash.core.interfaces.IDisposable;

	public interface IGridItemRenderer extends IDisposable
	{
		
		function set data(value:Object):void;
		function get width():Number;
		function get height():Number;
		function set width(value:Number):void;
		function set height(value:Number):void;
		
	}
}