package com._17173.flash.core.video.data
{
	import com._17173.flash.core.video.interfaces.IVideoData;
	
	public class BaseVideoData implements IVideoData
	{
		
		protected var _connectionURL:String = null;
		protected var _streamName:String = null;
		protected var _useP2P:Boolean = false;
		protected var _isStream:Boolean = false;
		protected var _playedTime:Number = 0;
		protected var _totalTime:Number = 0;
		protected var _loadedBytes:Number = 0;
		protected var _totalBytes:Number = 0;
		protected var _loadedTime:Number = 0;
		protected var _title:String = "";
		
		public function BaseVideoData()
		{
		}
		
		public function set connectionURL(value:String):void
		{
			_connectionURL = value;
		}
		
		public function get connectionURL():String
		{
			return _connectionURL;
		}
		
		public function set streamName(value:String):void
		{
			_streamName = value;
		}
		
		public function get streamName():String
		{
			return _streamName;
		}
		
		public function set useP2P(value:Boolean):void
		{
			_useP2P = value;
		}
		
		public function get useP2P():Boolean
		{
			return _useP2P;
		}
		
		public function set isStream(value:Boolean):void
		{
			_isStream = value;
		}
		
		public function get isStream():Boolean
		{
			return _isStream;
		}
		
		public function set playedTime(value:Number):void
		{
			_playedTime = value;
		}
		
		public function get playedTime():Number
		{
			return _playedTime;
		}
		
		public function set totalTime(value:Number):void
		{
			_totalTime = value;
		}
		
		public function get totalTime():Number
		{
			return _totalTime;
		}
		
		public function set loadedBytes(value:Number):void
		{
			_loadedBytes = value;
		}
		
		public function get loadedBytes():Number {
			return _loadedBytes;
		}
		
		public function set totalBytes(value:Number):void {
			_totalBytes = value;
		}
		
		public function get totalBytes():Number
		{
			return _totalBytes;
		}

		public function get loadedTime():Number
		{
			return _loadedTime;
		}

		public function set loadedTime(value:Number):void
		{
			_loadedTime = value;
		}

		/**
		 * 视频标题 
		 * @return 
		 */		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			_title = value;
		}
		
	}
}