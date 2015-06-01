package com._17173.flash.core.util.share
{
	public class QQWeiboParams extends ShareToParams
	{
		private var _title:String = null;
		private var _url:String = null;
		private var _pic:String = null;
		private var _line1:String = null;
		private var _line2:String = null;
		private var _line3:String = null;
		private var _appkey:String = null;
		
		public function QQWeiboParams()
		{
			super();
			
			_baseURL = "http://share.v.t.qq.com/index.php?c=share&a=index";
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function set url(value:String):void
		{
			_url = value;
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
		
		public function get line1():String
		{
			return _line1;
		}
		
		public function set line1(value:String):void
		{
			_line1 = value;
		}
		
		public function get line2():String
		{
			return _line2;
		}
		
		public function set line2(value:String):void
		{
			_line2 = value;
		}
		
		public function get line3():String
		{
			return _line3;
		}
		
		public function set line3(value:String):void
		{
			_line3 = value;
		}
		
		override public function toObject():Object {
			return {"title":_title, "url":_url, "appkey":_appkey, "pic":_pic, "line1":line1, "line2":line2, "line3":line3};
//			return {"c":"share", "a":"index", "title":_title, "url":_url, "appkey":_appkey, "pic":_pic, "line1":line1, "line2":line2, "line3":line3};
		}
	}
}