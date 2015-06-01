package com._17173.flash.core.video.interfaces
{
	import com._17173.flash.core.interfaces.IDisposable;
	
	import flash.display.DisplayObject;
	import flash.net.NetStream;

	public interface IVideoPlayer extends IDisposable
	{
		
		function play():void;
		function pause():void;
		function resume():void;
		function stop():void;
		function get isPlaying():Boolean;
		function set isPlaying(isPlaying:Boolean):void;
		function set stream(value:NetStream):void;
		function get stream():NetStream;
		function get video():DisplayObject;
		
		function resize(w:int, h:int):void;
		function center(w:int, h:int):void;
		
		function get width():Number;
		function get height():Number;
		function get x():Number;
		function get y():Number;
		function set width(value:Number):void;
		function set height(value:Number):void;
		function set x(value:Number):void;
		function set y(value:Number):void;
		
		function get originalWidth():Number;
		function get originalHeight():Number;
		
	}
}