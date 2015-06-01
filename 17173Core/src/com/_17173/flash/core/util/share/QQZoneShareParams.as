package com._17173.flash.core.util.share
{
	public class QQZoneShareParams extends ShareToParams
	{
		private var _title:String = null;
		private var _url:String = null;
		private var _pic:String = null;
		private var _desc:String = null;
		private var _summary:String = null;
		private var _site:String = null;
		private var _showcount:String = "0";
		
		public function QQZoneShareParams()
		{
			super();
			
			_baseURL = "http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey";
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
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
		
		public function get desc():String
		{
			return _desc;
		}
		
		public function set desc(value:String):void
		{
			_desc = value;
		}
		
		public function get summary():String
		{
			return _summary;
		}
		
		public function set summary(value:String):void
		{
			_summary = value;
		}
		
		public function get site():String
		{
			return _site;
		}
		
		public function set site(value:String):void
		{
			_site = value;
		}
		
		public function get showcount():String
		{
			return _showcount;
		}
		
		public function set showcount(value:String):void
		{
			_showcount = value;
		}
		
		override public function toObject():Object {
			return {"title":_title, "url":_url, "showcount":_showcount, "pic":_pic, "site":site, "summary":summary, "desc":desc};
		}
	}
}