package com._17173.flash.core.video.interfaces
{
	public interface IVideoData
	{
		
		function set connectionURL(value:String):void;
		function get connectionURL():String;
		function set streamName(value:String):void;
		function get streamName():String;
		function set useP2P(value:Boolean):void;
		function get useP2P():Boolean;
		function set isStream(value:Boolean):void;
		function get isStream():Boolean;
		function set playedTime(value:Number):void;
		function get playedTime():Number;
		function set totalTime(value:Number):void;
		function get totalTime():Number;
		function set loadedBytes(value:Number):void;
		function get loadedBytes():Number;
		function set totalBytes(value:Number):void;
		function get totalBytes():Number;
		function get loadedTime():Number;
		function set loadedTime(value:Number):void;
		function get title():String;
		function set title(value:String):void;
	}
}