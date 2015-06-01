package com._17173.flash.core.components.interfaces
{
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	public interface ISkinComponent
	{
		
		function get skinVo():ISkinClass;
		
		function addSkinUI(disp:DisplayObject,index:int = -1):void;
		
		function removeSkinUi(disp:DisplayObject):void;
		
		function getCompRect():Rectangle;
		
		function changeRect(tw:int,th:int):void;
	}
}