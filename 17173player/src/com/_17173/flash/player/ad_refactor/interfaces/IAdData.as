package com._17173.flash.player.ad_refactor.interfaces
{
	public interface IAdData
	{
		function get type():String;
		function set type(value:String):void;
		
		function get url():String;
		function set url(value:String):void;
		
		function get time():int;
		function set time(value:int):void;
		
		function get totalTime():int;
		function set totalTime(value:int):void;
		
		function get extension():int;
		function set extension(value:int):void;
		
		function get round():int;
		function set round(value:int):void;
		
		function get jumpTo():String;
		function set jumpTo(value:String):void;
		
		function get sc():String;
		function set sc(value:String):void;
		
		function get cc():String;
		function set cc(value:String):void;
		
		function get tsc():Array;
		function set tsc(value:Array):void;
		
		function get id():String;
		function set id(value:String):void;
	}
}
