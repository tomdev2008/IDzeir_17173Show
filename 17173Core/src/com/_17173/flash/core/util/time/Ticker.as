package com._17173.flash.core.util.time
{
	
	import com._17173.flash.core.util.SimpleObjectPool;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * 计时器,本质上是按frame进行时间差计算,进行事件触发.
	 * 主要是考虑到frame在正常情况下误差比timer要小很多.
	 * 
	 * TODO: 
	 * 		当flash后台时,frame将无法用于进行计时,需要采取另外的办法解决.
	 *  
	 * @author shunia-17173
	 */	
	public class Ticker
	{
		
		private static var _staticTime:int = 0;
		
		private static var _frameRate:int = 30;
		private static var _staticTimeBase:int = 0;
		private static var _ellapsedTime:int = 0;
		private static var _ellapsedFrame:int = 0;
		
		private static var _tickers:Dictionary = null;
		private static var _sequence:Array = null;
		
		public function Ticker()
		{
		}
		
		public static function init(stage:Stage):void {
			_frameRate = stage.frameRate;
			_staticTimeBase = 1000 / _frameRate / 2;
			_tickers = new Dictionary();
			_sequence = [];
			_staticTime = getTimer();
			stage.addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		protected static function onRender(event:Event):void
		{
			update(getTimer() - _staticTime);
			_staticTime = getTimer();
		}
		
		public static function anim(time:int, target:Object):ITickerAnim {
			var anim:TickerAnim = SimpleObjectPool.getPool(TickerAnim).getObject() as TickerAnim;
			anim.time = time;
			anim.target = target;
			var obj:Object = tick(1, anim.onRender, 0, true);
			obj.callbackEllapsedTime = true;
			anim.seq = obj;
			return anim;
		}
		
		public static function tick(time:int, callback:Function, repeat:int = 1, useFrame:Boolean = false):Object {
			if (_tickers[callback]) {
//				Debugger.log(Debugger.WARNING, "Can not attach an registered call back to the ticker!");
				return _tickers[callback];
			}
			
			var obj:Object = {"time":time, "repeat":repeat, "useFrame":useFrame, "callback":callback, "eternal":repeat <= 0 ? true : false};
			_tickers[callback] = obj;
			updateSequence(obj);
			return obj;
		}
		
		public static function stop(callback:Function):void {
			if (_tickers[callback]) {
				var obj:Object = _tickers[callback];
				delete _tickers[callback];
				var index:int = _sequence.indexOf(obj);
				if (index != -1) {
					_sequence.splice(index, 1);
				}
			}
		}
		
		public static function clear():void {
			for (var key:* in _tickers) {
				delete _tickers[key];
			}
		}
		
		public static function update(time:int):void {
			_ellapsedTime = time;
			_ellapsedFrame = 1;
			match();
		}
		
		private static function match():void {
			var i:int = 0;
			while (i < _sequence.length) {
				var obj:Object = _sequence[i];
				var ellapsedTime:int = 0;
				var baseTimeTag:int = 0;
				if (obj.useFrame) {
					ellapsedTime = _ellapsedFrame;
					baseTimeTag = 1;
				} else {
					ellapsedTime = _ellapsedTime;
					baseTimeTag = _staticTimeBase;
				}
				var ellapsed:int = obj.ellapsed;
				var left:int = obj.left;
				var total:int = obj.time;
				if (left >= baseTimeTag) {
					//continue
					obj.ellapsed = ellapsed + ellapsedTime;
					obj.left = left - ellapsedTime;
				}
				if (obj.left <= baseTimeTag) {
					obj.ellapsed = ellapsedTime - left;
					obj.left = total + left - ellapsedTime;
					var callback:Function = null;
					if(obj.hasOwnProperty("callback")) {
						callback = obj["callback"] as Function;
					}
					//tick
//					triggerTicker(obj);
					if (!obj.eternal) {
						obj.repeat = obj.repeat - 1;
						if (obj.repeat <= 0) {
							stop(obj.callback);
						}
					}
					if (callback != null) {
						var callbackParams:* = null;
						if(obj.hasOwnProperty("callbackParams") && obj["callbackParams"]) {
							callbackParams = obj["callbackParams"];
						} else if (obj.hasOwnProperty("callbackEllapsedTime") && obj["callbackEllapsedTime"]) {
							callbackParams = _ellapsedTime;
						} else if (obj.hasOwnProperty("callbackEllapsedFrame") && obj["callbackEllapsedFrame"]) {
							callbackParams = _ellapsedFrame;
						}
						callback.apply(null, !callbackParams ? null : callbackParams is Array ? callbackParams : [callbackParams]);
					}
				}
				
				i ++;
			}
		}
		
		private static function triggerTicker(object:Object):void {
			if (object["callback"]) {
				var callback:Function = object["callback"];
				callback.call(null);
			}
		}
		
		private static function updateSequence(object:Object):void {
			object.ellapsed = 0;
			object.left = object.time;
			_sequence.push(object);
			
			_sequence.sortOn("left", Array.NUMERIC);
		}
		
	}
}