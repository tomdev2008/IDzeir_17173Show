package com._17173.flash.core.event
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	
	import flash.events.Event;

	/**
	 * 基于观察者模式的简要消息机制实现.
	 * 通过对注册消息的轮询实现消息派发.
	 * 事件系统通过enterFrame实现异步.
	 *  
	 * @author shunia-17173
	 */	
	public class EventManager implements IContextItem, IEventManager
	{
		
		public static const CONTEXT_NAME:String = "eventManager";
		
		/**
		 * 当前已经注册的消息队列. 
		 */		
		private var _events:Array = null;
		/**
		 * 用于记录当前正在派发的消息队列. 
		 */		
		private var _dispatching:Object = {};
		/**
		 * 异步渲染标志 
		 */		
		private var _lastInvalidate:Boolean = false;
		
		public function EventManager() {
		}
		
		/**
		 * 注意在同一次渲染时机内,多次派发同一类型的事件,只会在渲染时触发一次同一事件的调用.
		 * 
		 * @inherited 
		 */		
		public function send(type:String, data:Object = null, target:Object = null, immediately:Boolean = false):void {
			//临时记录,用来进行取消派发的动作
			var arr:Array = _dispatching.hasOwnProperty(type) && _dispatching[type] ? _dispatching[type] : [];
			arr.push({"data":data, "target":target});
			_dispatching[type] = arr;
			_lastInvalidate = true;
			
			if (immediately) {
				onRender(null);
			}
		}
		
		public function cancel(type:String):void {
			if (_dispatching.hasOwnProperty(type)) {
				var listeners:Array = _dispatching[type];
				delete _dispatching[type];
			}
		}
		
		public function listen(type:String, callback:Function, target:Object = null, priority:int = 0, weakRef:Boolean = false):void {
			var find:Array = _events.filter(function (item:*, index:int, array:Array):Boolean {
				if (type == item["type"] && callback == item["callback"]) return true;
				return false;
			}, null);
			if (find.length == 0) {
				_events.push({"type":type, "callback":callback, "target":target, "priority":priority, "weakRef":weakRef});
			}
		}
		
		public function remove(type:String, callback:Function, target:Object = null):void {
			//先过滤出要移除的监听
			var registered:Array = _events.filter(function (item:*, index:int, array:Array):Boolean {
				if (item["type"] != type) return false;
				if (item["callback"] != callback) return false;
				if (item["target"] && target != item["target"]) return false;
				
				return true;
			}, null);
			//从全局消息中移除
			for each (var event:Object in registered) {
				var index:int = _events.indexOf(event);
				if (index != -1) {
					_events.splice(index, 1);
				}
			}
			registered = null;
		}
		
		public function get contextName():String {
			return CONTEXT_NAME;
		}
		
		public function startUp(param:Object):void {
			_events = [];
			// 优化eventManager上一个版本无法异步事件,从而导致同步事件的时序问题
//			Context.stage.addEventListener(Event.EXIT_FRAME, onRender);
			Context.stage.addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		/**
		 * 每帧渲染
		 *  
		 * @param event
		 */		
		protected function onRender(event:Event):void {
			if (!_lastInvalidate) return;
			_lastInvalidate = false;
			
			//一一派发
			var listeners:Array = [];
			var callback:Function = null;
			var dispatch:Array = null;
			var e:Object = null;
			var delegate:Object = _dispatching;
			_dispatching = {};
			for (var type:String in delegate) {
				dispatch = delegate[type];
				for each (var evt:Object in dispatch) {
					//对已经进行了监听的事件进行筛选
					listeners = _events.filter(function (item:*, index:int, array:Array):Boolean {
						if (item["type"] != type) return false;
						if (evt.target && item && item["target"] && item["target"] != evt.target) return false;
						return true;
					}, null);
					//优先级排序
					if (listeners.length > 1) {
						listeners.sortOn("priority", Array.NUMERIC);
					}
					//一个个进行派发
					if (listeners && listeners.length) {
						while (listeners.length) {
							e = listeners.shift();
							callback = e["callback"];
							var thisArg:* = evt["target"];
							callback.apply(thisArg, callback.length ? [evt.data] : null);
						}
					}
				}
			}
		}
		
	}
}