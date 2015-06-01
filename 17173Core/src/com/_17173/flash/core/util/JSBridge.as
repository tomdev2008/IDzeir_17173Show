package com._17173.flash.core.util
{
	
	import flash.external.ExternalInterface;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * Flash和js交互的代理类,封装了调用方法. 
	 * @author shunia-17173
	 */	
	public class JSBridge
	{
		
		/**
		 * 默认的js命名空间,取window 
		 */		
		private static var _defaultNameSpace:String = "window";
		/**
		 * 是否可用 
		 */		
		private static var _enabled:Boolean = true;
		/**
		 * 重试次数 
		 */		
		private static var _retryTime:int = 3;
		/**
		 * 是否已经检查过当前容器里js的可用性.
		 * 
		 * 当ExternalInterface.available == true时,调用js方法也有可能失败.
		 * 这可能是因为flash绑定参数不允许在当前容器里使用js方法调用.
		 * 这种时候就需要检查当前容器的可用性,用来正确的判断js是否可用. 
		 */		
		private static var _jsCurrentContainerAvailableChecked:Boolean = false;
		/**
		 * 当前容器里的js可用性. 
		 */		
		private static var _jsCurrentContainerAvaliable:Boolean = false;
		/**
		 * 已经列入到队列里的js调用. 
		 */		
		private static var _calls:Array = null;
		
		public function JSBridge()
		{
		}
		
		/**
		 * 是否允许js调用. 
		 * @param value
		 */		
		public static function set enabled(value:Boolean):void {
			_enabled = value;
		}
		
		public static function get enabled():Boolean {
			return _enabled && checkCurrentContainerJSAvailable();
		}
		
		/**
		 * 设置默认的JS命名空间. 
		 * @param value
		 */		
		public static function set defaultNameSpace(value:String):void {
			_defaultNameSpace = value ? value : "window";
		}
		
		public static function get defaultNameSpace():String {
			return _defaultNameSpace;
		}
		
		/**
		 * 调用js方法或者注册回调. 
		 * 
		 * @param functionName	js与flash通讯用的方法指定的名字.如果是call,是js中的方法名,如果是callback,是约定的字段.
		 * @param data			js与flash通讯时如果flash要传递数据给js,则使用此属性传递.不支持多属性,可以将参数整合为object或者array进行传递.
		 * @param ns			调用的js所在的命名空间.如果指定一个非空的string,则将此string当做指定的命名空间.如果指定为null,则默认使用window作为命名空间.如果传递空字符串""/'',则不使用命名空间.
		 * @param callbackFunc	js与flash通讯中用做callback的回调,当js调用flash时会触发注册在functionName对应的此方法.当flash调用js时如果有返回值,则使用此方法得到返回值.
		 * @param isJSCallback	是否callback.
		 */		
		public static function addCall(functionName:String, data:Object = null, ns:String = null, callbackFunc:Function = null, isJSCallback:Boolean = false):* {
			if (!checkCurrentContainerJSAvailable()) {
				//如果根本无法调用js,那么即便需要js功能,也是不可用的.
				_enabled = false;
				return;
			}
			if (!checkFunctional()) return;
			
			var actualName:String = functionName;
			if (!isJSCallback) {
				//三种不同状况的ns对应处理最终调用的js代码
				if (ns == null) {
					actualName = _defaultNameSpace + "." + functionName;
				} else if (Util.trimStr(ns) == "") {
					actualName = functionName;
				} else {
					actualName = ns + "." + functionName;
				}
			}
			
			if (!ExternalInterface.available) {
				retryJSAvailable();
				
				queueCalls(actualName, callbackFunc, isJSCallback);
			} else {
				if (!isJSCallback) {
					var result:Object = null;
					if (data) {
						result = ExternalInterface.call(actualName, data);
					} else {
						result = ExternalInterface.call(actualName);
					}
//					Debugger.log(Debugger.INFO, "[js]", "增加js调用:", actualName);
					if (callbackFunc != null) {
						callbackFunc(result);
					}
					return result;
				} else {
					ExternalInterface.addCallback(actualName, callbackFunc);
//					Debugger.log(Debugger.INFO, "[js]", "增加js回调:", actualName);
				}
			}
			return null;
		}
		
		/**
		 * 检查js的可用性,并对队列数组进行初始化. 
		 * @return 
		 */		
		private static function checkFunctional():Boolean {
			if (checkCurrentContainerJSAvailable() == false) {
				_enabled = false;
			}
			if (!_enabled) {
				if (_calls && _calls.length) {
					_calls = null;
				}
				return false;
			} else {
				if (_calls == null) {
					_calls = [];
				}
				return true;
			}
		}
		
		/**
		 * 检查当前容器内js的可用性.
		 * 如果当前绑定参数里不允许对js进行调用,或者允许的域和flash当前的域不一致,那么可能会出现调用失败.
		 * 通过捕获exception来确定当前js是否确实可用. 
		 * @return 
		 * 
		 */		
		private static function checkCurrentContainerJSAvailable():Boolean {
			if (!_jsCurrentContainerAvailableChecked) {
				try {
					ExternalInterface.call("window");
					_jsCurrentContainerAvailableChecked = true;
					_jsCurrentContainerAvaliable = true;
				} catch (e:Error) {
					_jsCurrentContainerAvaliable = false;
					_jsCurrentContainerAvailableChecked = false;
				}
			}
			return _jsCurrentContainerAvaliable;
		}
		
		/**
		 * 重试与js的连接是否成功. 
		 */		
		private static function retryJSAvailable():void {
			var interval:uint = setInterval(function ():void {
				clearInterval(interval);
				
				if (!ExternalInterface.available) {
					retryJSAvailable();
					_retryTime --;
					
					if (_retryTime == 0) {
						enabled = false;
						checkFunctional();
					}
				} else {
					releaseQueueCalls();
				}
			}, 100);
		}
		
		/**
		 * 在js不可用时,将调用的js方法放入一个先进先出的栈,用来在与js的通讯恢复后对这些调用进行队列处理. 
		 * @param jsFuncName
		 * @param callbackFunc
		 * @param isJSCallback
		 */		
		private static function queueCalls(jsFuncName:String, callbackFunc:Function = null, isJSCallback:Boolean = false):void {
			if (_calls == null) {
				_calls = [];
			}
			
			_calls.push({"jsFuncName":jsFuncName, "callbackFunc":callbackFunc, "isJSCallback":isJSCallback});
		}
		
		/**
		 * 队列处理已经注册的js调用. 
		 */		
		private static function releaseQueueCalls():void {
			if (_calls && _calls.length) {
				for each (var call:Object in _calls) {
					addCall(call.jsFuncName, call.callbackFunc, call.isJSCallback);
				}
			}
		}
		
	}
}