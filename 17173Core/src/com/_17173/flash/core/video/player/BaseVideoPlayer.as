package com._17173.flash.core.video.player
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoPlayer;
	
	import flash.display.DisplayObject;
	import flash.net.NetStream;
	
	public class BaseVideoPlayer implements IVideoPlayer
	{
		
		protected var _stream:NetStream = null;
		protected var _video:Object = null;
		
		protected var _aw:Number = 0;
		protected var _ah:Number = 0;
		protected var _tw:Number = 0;
		protected var _th:Number = 0;
		
		protected var _isPlaying:Boolean = true;
		
		public function BaseVideoPlayer()
		{
		}
		
		public function pause():void
		{
			if (_isPlaying == false) return;
			_isPlaying = false;
			if (_stream == null) return;
			_stream.pause();
			Debugger.log(Debugger.INFO,"BaseVideoPlayer pause()");
		}
		
		public function play():void
		{
			resume();
		}
		
		public function resume():void
		{
			if (_isPlaying == true) return;
			if (_stream == null) return;
			_isPlaying = true;
			_stream.resume();
		}
		
		public function stop():void
		{
			if (_stream == null) return;
			_isPlaying = false;
			_stream.close();
		}
		
		public function get isPlaying():Boolean {
			return _isPlaying;
		}
		
		public function set isPlaying(isPlaying:Boolean):void{
			this._isPlaying = isPlaying;
		}
		
		/**
		 * 附加在当前播放器中的流. 
		 * @param value
		 * 
		 */		
		public function set stream(value:NetStream):void
		{
			_stream = value;
			
			if (_video && _video["attachNetStream"]) {
				_video["attachNetStream"](_stream);
//				//默认就会开始播放
//				_isPlaying = true;
			}
			if (_stream) {
				if (_isPlaying) {
					_stream.resume();
				} else {
					_stream.pause();
				}
			}
		}
		
		public function get stream():NetStream {
			return _stream;
		}
		
		public function get video():DisplayObject {
			return _video as DisplayObject;
		}
		
		public function resize(w:int, h:int):void {
			_aw = w;
			_ah = h;
			updateVideo();
		}
		
		public function center(w:int, h:int):void {
			_tw = w;
			_th = h;
			updateVideo();
		}
		
		protected function updateVideo():void {
			//override
		}
		
		public function set width(value:Number):void {
			
		}
		
		public function get width():Number {
			return 0;
		}
		
		public function set height(value:Number):void {
			
		}
		
		public function get height():Number {
			return 0;
		}
		
		public function set x(value:Number):void {
			
		}
		
		public function get x():Number {
			return 0;
		}
		
		public function set y(value:Number):void {
			
		}
		
		public function get y():Number {
			return 0;
		}
		
		public function dispose():void
		{
			stream = null;
			_isPlaying = false;
			if (_video && _video.hasOwnProperty("parent") && _video.parent != null && _video.parent.contains(_video)) {
				_video.parent.removeChild(_video);
			}
			_video = null;
		}
		
		public function get originalHeight():Number
		{
			return _video ? _video.videoHeight : height;
		}
		
		public function get originalWidth():Number
		{
			return _video ? _video.videoWidth : width;
		}
		
		
	}
}