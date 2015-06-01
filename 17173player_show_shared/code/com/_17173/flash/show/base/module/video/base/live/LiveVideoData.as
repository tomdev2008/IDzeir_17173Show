package com._17173.flash.show.base.module.video.base.live
{
	import com._17173.flash.core.video.data.BaseVideoData;
	
	public class LiveVideoData extends BaseVideoData
	{
		private var _cId:String = "";
		private var _ckey:String = "";
		private var _optimal:int = 0;
		private var _cdntype:String = "";
		private var _name:String = "";
		public function LiveVideoData()
		{
			super();
		}

		public function get name():String
		{
			return _name;
		}

		public function set name(value:String):void
		{
			_name = value;
		}

		public function get cdntype():String
		{
			return _cdntype;
		}

		public function set cdntype(value:String):void
		{
			_cdntype = value;
		}

		public function get ckey():String
		{
			return _ckey;
		}

		public function set ckey(value:String):void
		{
			_ckey = value;
		}

		public function get cId():String
		{
			return _cId;
		}

		public function set cId(value:String):void
		{
			_cId = value;
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