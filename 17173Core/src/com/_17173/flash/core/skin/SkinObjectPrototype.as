package com._17173.flash.core.skin
{
	/**
	 * 用于注册控件属性,方法,事件,并对其进行验证.
	 * 显式注册的目的是更明确的提供给皮肤封装类进行解析和处理.
	 *  
	 * @author shunia-17173
	 */	
	public class SkinObjectPrototype
	{
		
		private var _prototype:Object;
		
		internal var name:String = null;
		internal var cls:Class = null;
		
		public function SkinObjectPrototype(name:String, cls:Class)
		{
			this.name = name;
			this.cls = cls;
		}
		
		public function addGetProperty(propertyName:String):SkinObjectPrototype {
			return add("get", propertyName);
		}
		
		public function addSetProperty(propertyName:String):SkinObjectPrototype {
			return add("set", propertyName);
		}
		
		public function addFunction(functionName:String):SkinObjectPrototype {
			return add("function", functionName);
		}
		
		public function addEvent(eventName:String):SkinObjectPrototype {
			return add("event", eventName);
		}
		
		public function addListener(eventName:String):SkinObjectPrototype {
			return add("listen", eventName);
		}
		
		private function add(k:String, p:*):SkinObjectPrototype {
			_prototype ||= {};
			if (!_prototype[k]) {
				_prototype[k] = [];
			}
			_prototype[k].push(p);
			
			return this;
		}
		
		internal function validateGetProperty(propertyName:String):Boolean {
			return validate("get", propertyName);
		}
		
		internal function validateSetProperty(propertyName:String):Boolean {
			return validate("set", propertyName);
		}
		
		internal function validateFunction(functionName:String):Boolean {
			return validate("function", functionName);
		}
		
		internal function validateEvent(eventName:String):Boolean {
			return validate("event", eventName);
		}
		
		internal function validateListener(eventName:String):Boolean {
			return validate("listen", eventName);
		}
		
		private function validate(k:String, p:*):Boolean {
			return _prototype && _prototype[k] && _prototype[k].indexOf(p) != -1;
		}
		
	}
}