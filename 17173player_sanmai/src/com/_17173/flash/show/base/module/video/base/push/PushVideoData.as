package com._17173.flash.show.base.module.video.base.push
{
	import com._17173.flash.core.video.data.BaseVideoData;
	
	public class PushVideoData extends BaseVideoData
	{
		private var _liveId:String = "";
		private var _optimal:int = 0;
		public function PushVideoData()
		{
			super();
		}
		
		public function get liveId():String
		{
			return _liveId;
		}

		public function set liveId(value:String):void
		{
			_liveId = value;
		}

		public function get optimal():int
		{
			return _optimal;
		}

		public function set optimal(value:int):void
		{
			_optimal = value;
		}

	}
}