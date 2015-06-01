package com._17173.flash.core.util.share
{
	
	public class QQShareParams extends ShareToParams
	{
		
		private var _title:String = null;
		private var _desc:String = null;
		private var _url:String = null;
		private var _site:String = null;
		private var _pic:String = null;
		
		public function QQShareParams()
		{
			super();
			
			_baseURL = "http://connect.qq.com/widget/shareqq/index.html";
		}
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			_title = value;
		}
		
		public function get desc():String
		{
			return _desc;
		}
		
		public function set desc(value:String):void
		{
			_desc = value;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
		}
		
		public function get site():String
		{
			return _site;
		}
		
		public function set site(value:String):void
		{
			_site = value;
		}
		
		public function get pic():String
		{
			return _pic;
		}
		
		public function set pic(value:String):void
		{
			_pic = value;
		}
		
		override public function toObject():Object {
			return {"title":_title, "url":_url, "desc":_desc, "pic":_pic, "site":_site};
		}
		
	}
}