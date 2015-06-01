package com._17173.flash.show.base.components.layer
{
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public interface IPopup
	{
		function popupPanel(panel:DisplayObject,popupLeve:int = 0,panelPos:Point = null):void;
		function removePanel(panel:DisplayObject):void;
		function removeAll():void;
	}
}