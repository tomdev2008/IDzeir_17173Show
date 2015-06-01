package com._17173.flash.player.business.stream
{
	import com._17173.flash.player.context.VideoData;
	
	public class StreamVideoData extends VideoData
	{
		
		private var _gameCode:String = null;
		private var _isOrg:Boolean = false;
		
		public function StreamVideoData()
		{
			super();
		}

		public function get gameCode():String
		{
			return _gameCode;
		}

		public function set gameCode(value:String):void
		{
			_gameCode = value;
		}

		public function get isOrg():Boolean
		{
			return _isOrg;
		}

		public function set isOrg(value:Boolean):void
		{
			_isOrg = value;
		}
		
	}
}