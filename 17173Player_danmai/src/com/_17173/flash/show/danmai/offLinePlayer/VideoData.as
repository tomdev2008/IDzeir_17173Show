package com._17173.flash.show.danmai.offLinePlayer
{
	import com._17173.flash.core.video.data.BaseVideoData;
	
	public class VideoData extends BaseVideoData
	{		
		private var _cid:String = null;
		
		public function VideoData()
		{
			super();
		}

		/**
		 * 视频id 
		 * @return 
		 */		
		public function get cid():String
		{
			return _cid;
		}

		public function set cid(value:String):void
		{
			_cid = value;
		}

	}
}