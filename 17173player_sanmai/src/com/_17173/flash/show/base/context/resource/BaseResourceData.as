package com._17173.flash.show.base.context.resource
{
	import flash.utils.getTimer;

	public class BaseResourceData implements IResourceData
	{
		protected var _key:String = null;
		protected var _loadedTime:int = 0;
		protected var _userTime:int = 0;
		protected var _lastUserTime:int;
		protected var _resource:*;
		protected var _prototype:*;
		public var isAutoGc:Boolean = false;
		public function BaseResourceData(source:*,keyStr:String)
		{
			setupSource(source);
			_key = keyStr;
			_loadedTime = getTimer();
			updateUserTime();
		}
		
		public function get key():String
		{
			return _key;
		}
		
		public function get source():*
		{
			return _resource;
		}
		
		public function get newSource():*
		{
			return _resource;
		}
		
		public function get loadedTime():int
		{
			return _loadedTime;
		}
		
		protected function setupSource(source:*):void{
			_resource = source;
		}
		
		protected function updateUserTime():void
		{
			_userTime = getTimer();
		}
		
		public function get freeTime():int{
			return getTimer() - _userTime;
		}
	}
}