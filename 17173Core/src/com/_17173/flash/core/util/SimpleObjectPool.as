package com._17173.flash.core.util
{
	import flash.utils.Dictionary;

	public class SimpleObjectPool
	{
		
		private static var _pools:Dictionary = new Dictionary();
		
		private var _template:Class = null;
		private var _objects:Array = null;
		
		public function SimpleObjectPool(template:Class)
		{
			_template = template;
			_objects = [];
		}
		
		public static function getPool(template:Class):SimpleObjectPool {
			if (!_pools[template]) {
				_pools[template] = new SimpleObjectPool(template);
			}
			return _pools[template];
		}
		
		public function getObject():* {
			if (_objects.length == 0) {
				returnObject(new _template());
			}
			return _objects.shift();
		}
		
		public function returnObject(value:*):void {
			if (_objects.indexOf(value) == -1) {
				_objects.push(value);
			}
		}
		
		public function destroyObject(value:*):void {
			var index:int = _objects.indexOf(value);
			if (index > -1) {
				_objects.splice(index, 1);
			}
			value = null;
		}
		
		public function destroyAll():void {
			_objects = [];
			delete _pools[_template];
			_template = null;
		}
		
	}
}