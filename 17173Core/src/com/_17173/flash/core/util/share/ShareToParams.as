package com._17173.flash.core.util.share
{
	public class ShareToParams
	{
		
		protected var _baseURL:String = null;
		protected var _newPage:Boolean = true;
		
		public function ShareToParams()
		{
		}
		
		public function get newPage():Boolean
		{
			return _newPage;
		}
		
		public function set newPage(value:Boolean):void
		{
			_newPage = value;
		}

		public function get baseURL():String
		{
			return _baseURL;
		}

		public function set baseURL(value:String):void
		{
			_baseURL = value;
		}
		
		public function toObject():Object {
			return null;
		}

	}
}