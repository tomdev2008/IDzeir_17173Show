package com._17173.flash.player.ad_refactor.display.loader
{
	import com._17173.flash.player.ad_refactor.interfaces.IAdAsync;
	
	import flash.display.DisplayObject;

	public interface IAdPlayer extends IAdAsync
	{
		
		function getTime():Number;
		
		function get display():DisplayObject;
		
		function get soundTarget():Object;
		
		function resize(w:int, h:int):void;
		
		function get width():int;
		function get height():int;
		
	}
}