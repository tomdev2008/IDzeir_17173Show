package com._17173.flash.core.util.share
{
	public class WeiboShareParams extends ShareToParams
	{
		
		private var _url:String = null;
		private var _count:int = 0;
		private var _appkey:String = null;
		private var _title:String = null;
		private var _pic:String = null;
		private var _relatedUID:String = null;
		private var _language:String = null;	//zh_cn / zh_tw
		private var _dpc:int = 1;
		
		public function WeiboShareParams()
		{
			super();
			
			_baseURL = "http://service.weibo.com/share/share.php";
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		public function get count():int
		{
			return _count;
		}

		public function set count(value:int):void
		{
			_count = value;
		}

		public function get appkey():String
		{
			return _appkey;
		}

		public function set appkey(value:String):void
		{
			_appkey = value;
		}

		public function get title():String
		{
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

		public function get pic():String
		{
			return _pic;
		}

		public function set pic(value:String):void
		{
			_pic = value;
		}

		public function get relatedUID():String
		{
			return _relatedUID;
		}

		public function set relatedUID(value:String):void
		{
			_relatedUID = value;
		}

		public function get language():String
		{
			return _language;
		}

		public function set language(value:String):void
		{
			_language = value;
		}
		
		override public function toObject():Object {
			return {"title":_title, "url":_url, "appkey":_appkey, "relateUid":_relatedUID, "pic":_pic, "count":_count, "language":_language, "dpc":_dpc};
		}
		
	}
}