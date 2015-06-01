package com._17173.flash.core.context
{
	
	import flash.display.Stage;
	import flash.utils.Dictionary;

	/**
	 * 注册上下文所需要用到的类定义.
	 *  
	 * @author shunia-17173
	 */	
	public class Context
	{
		
		private static var _contexts:Dictionary = new Dictionary();
		private static var _registerd:Dictionary = new Dictionary();
		private static var _variables:Object = {};
		
		private static var _stage:Stage = null;
		
		public function Context() {
		}
		
		/**
		 * 注入context.
		 *  
		 * @param name
		 * @param context	IContextItem实例
		 */		
		public static function injectContext(name:String, context:IContextItem):void {
			_contexts[name] = {"name":name, "context":context, "default":null, "param":null, "inited":true};
		}
		
		/**
		 * 增加context.
		 * 增加的context如果用于initAll方法,将会按照增加的先后顺序进行处理.
		 *  
		 * @param name 定义的上下文类的名称.
		 * @param context 上下文的实际定义,可以是类(Class)或者实例(Instance).
		 */		
		public static function regContext(name:String, context:*, defaultContext:* = null, param:* = null):void {
			var c:Object = _registerd.hasOwnProperty(name) ? _registerd[name] : null;
			if (!c) {
				c = {"name":name};
			}
			c["context"] = context;
			c["default"] = defaultContext;
			c["param"] = param;
			c["inited"] = false;
			_registerd[name] = c;
//			
//			var hasDef:Boolean = _registerd.hasOwnProperty(name);
//			var c:Object = hasDef ? _contexts[name]["context"] : null;
//			if (!(hasDef && c)) {
//				var context:Object = {"name":name, "context":context, "default":defaultContext, "param":param, "inited":false};
//				_contexts[name] = context;
//				if (!hasDef) {
//					_registerd.push(context);
//				}
//			}
		}
		
		/**
		 * 是否存在指定的context
		 *  
		 * @param name
		 */		
		public static function hasContext(name:String):Boolean {
			return _contexts.hasOwnProperty(name) && _contexts[name]// && (_contextDict[name]["context"] || _contextDict[name]["default"]);
		}
		
		/**
		 * 获取context.
		 *  
		 * @param name 定义的上下文类的名称.
		 * @return 上下文类的实例.
		 */		
		public static function getContext(name:String):* {
			if (hasContext(name)) {		// 已初始化
				if (_contexts[name]["inited"]) {
					return _contexts[name]["context"];
				} else {
					initContext(_contexts[name]);
					return getContext(name);
				}
			} else if (_registerd.hasOwnProperty(name) && _registerd[name]) {		// 已注册
				initRegisterdContext(name);
				return getContext(name);
			}
			return null;
		}
		
		/**
		 * 初始化指定的context.
		 *  
		 * @param name
		 */		
		private static function initContext(context:Object):Object {
			var specContext:* = context["context"];
			var defaultContext:* = context["default"];
			specContext = specContext ? specContext : defaultContext;
			var item:IContextItem = null;
			if (specContext is Class) {
				item = new specContext() as IContextItem;
			} else {
				item = specContext as IContextItem;
			}
			if (item) {
				item.startUp(context.hasOwnProperty("param") && context["param"] ? context["param"] : variables);
			}
			context["context"] = item;
			context["inited"] = true;
			
			return context;
		}
		
		/**
		 * 初始化已经注册的context
		 *  
		 * @param name
		 * @return 
		 */		
		private static function initRegisterdContext(name:String):void {
			_contexts[name] = initContext(_registerd[name]);
			delete _registerd[name];
		}
		
		/**
		 * 启动所有的context,进行注册.将会按照注册顺序进行初始化. 
		 */		
		public static function initAll():void {
			for (var k:String in _registerd) {
				initRegisterdContext(k);
			}
//			while (_registerd.length) {
//				var context:Object = _registerd.shift();
//				getContext(context.name);
//			}
		}

		/**
		 * 上下文环境变量
		 *  
		 * @return 
		 * 
		 */		
		public static function get variables():Object {
			return _variables;
		}

		/**
		 * 全局stage 
		 * @return 
		 */		
		public static function get stage():Stage {
			return _stage;
		}

		public static function set stage(value:Stage):void {
			_stage = value;
		}

		
	}
}