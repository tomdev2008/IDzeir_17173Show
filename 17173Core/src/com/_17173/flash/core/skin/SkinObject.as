package com._17173.flash.core.skin
{
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 皮肤封装类.将皮肤中的class定义进行保存,实例化之后即可以根据prototype中的注册属性等进行验证处理.
	 *  
	 * @author shunia-17173
	 */	
	public class SkinObject implements ISkinObject
	{
		
		private var _display:DisplayObject = null;
		private var _validated:Boolean = false;
		
		private var _prototype:SkinObjectPrototype = null;
		
		public function SkinObject()
		{
		}
		
		/**
		 * 初始化控件.
		 *  
		 * @param comp
		 * @param prototype
		 * @return 
		 */		
		internal function init(prototype:SkinObjectPrototype):SkinObject {
			_prototype = prototype;
			if (_prototype.cls) {
				var comp:* = new _prototype.cls();
				if (comp is DisplayObject) {
					_display = comp as DisplayObject;
				}
				_validated = true;
				return this;
			} else {
				Debugger.tracer("[skinobject]", "trying to swap invalid flash component class");
				return null;
			}
		}
		
		public function call(functionName:String, ...args):void {
			if (_validated == false) return;
			
			try {
				if (_display.hasOwnProperty(functionName)) {
					var func:Function = _display[functionName] as Function;
					if (func != null && func.length == args.length) {
						func.apply(null, args);
					}
				}
			} catch (e:Error) {
				Debugger.tracer("[skinobject]", "calling a undefined function: ", functionName);
			}
		}
		
		public function get display():DisplayObject {
			if (!_validated) {
				Debugger.tracer("[skinobject]", "no display has been swaped.");
				_display = new Sprite();
			}
			return _display;
		}
		
		public function get(propertyName:String):* {
			if (!_validated) {
				Debugger.tracer("[skinobject]", "invalid property get: <", propertyName, "> on a unswaped skin object");
				return null;
			} else {
				try {
					if (_display.hasOwnProperty(propertyName)) {
						return _display[propertyName];
					}
				} catch (e:Error) {
					Debugger.tracer("[skinobject]", "can not get property: ", propertyName);
					return null;
				}
			}
		}
		
		public function listen(eventName:String, callback:Function, capture:Boolean = false):void {
			if (!_validated) {
				Debugger.tracer("[skinobject]", "invalid operation <listener> on a unswaped skin object");
			} else {
				if (_prototype && _prototype.validateEvent(eventName)) {
					_display.addEventListener(eventName, callback, capture);
				}
			}
		}
		
		public function on(eventName:String, data:Object):void {
			if (!_validated) {
				Debugger.tracer("[skinobject]", "invalid operation <listener> on a unswaped skin object");
			} else {
				if (_display is ISkinObjectListener) {
					var listener:ISkinObjectListener = _display as ISkinObjectListener;
					listener.listen(eventName, data);
				}
			}
		}
		
		public function set(propertyName:String, value:*):void {
			if (!_validated) {
				Debugger.tracer("[skinobject]", "invalid property set: <", propertyName, "> on a unswaped skin object");
			} else {
				try {
					if (_prototype && _prototype.validateSetProperty(propertyName) && _display.hasOwnProperty(propertyName)) {
						_display[propertyName] = value;
					}
				} catch (e:Error) {
					Debugger.tracer("[skinobject]", "can not set property: ", propertyName);
				}
			}
		}
		
	}
}