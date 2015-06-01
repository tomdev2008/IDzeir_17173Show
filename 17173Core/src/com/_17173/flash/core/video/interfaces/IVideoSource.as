package com._17173.flash.core.video.interfaces
{
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public interface IVideoSource
	{
		
		function connect(conntionURL:String = null, streamURL:String = null, streamInvoke:Function = null, faultRetryTime:int = 3):void;
		
		function get stream():NetStream;
		function get connection():NetConnection;
		
		function get info():Object;
		
		function get originalWidth():int;
		function get originalHeight():int;
		
		function get time():Number;
		function set time(value:Number):void;
		
		function get totalTime():Number;
		
		function get bytesLoaded():int;
		function get bytesTotal():int;
		
		function get loadedTime():Number;
		
		function get volume():Number;
		function set volume(value:Number):void;
		
		function get loadStartTime():Number;
		function set loadStartTime(value:Number):void;
		
		function get streamURL():String;
		function get connectionURL():String;
		
		function close():void;
	}
}