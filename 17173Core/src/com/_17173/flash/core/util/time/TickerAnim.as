package com._17173.flash.core.util.time
{
	import com._17173.flash.core.util.ease.EaseCore;
	
	import flash.utils.getTimer;

	public class TickerAnim implements ITickerAnim
	{
		
		private var _onComplete:Function = null;
		private var _onUpdate:Function = null;
		private var _ease:Function = EaseCore.LINEAR;
		private var _props:Object = null;
		private var _ellapsed:int = 0;
		private var _init:int = 0;
		
		private var _time:int = 0;
		private var _target:Object = null;
		
		private var _seq:Object = null;
		
		public function TickerAnim()
		{
			_props = {};
			_ellapsed = 0;
			_init = getTimer();
		}
		
		internal function set time(value:int):void {
			_time = value;
		}
		
		internal function set target(value:Object):void {
			_target = value;
		}
		
		public function set onComplete(value:Function):void
		{
			_onComplete = value;
		}
		
		public function set onUpdate(value:Function):void
		{
			_onUpdate = value;
		}
		
		public function set ease(value:Function):void
		{
			_ease = value;
		}
		
		public function addProp(prop:String, value:*):ITickerAnim
		{
			var p:Object = _props[prop];
			if (p == null) {
				p = {};
				p.s = _target[prop];
			}
			p.e = value;
			_props[prop] = p;
			return this as ITickerAnim;
		}
		
		public function dispose():void
		{
			
		}
		
		internal function set seq(value:Object):void {
			_seq = value;
		}
		
		public function onRender(ellasedTime:int):void {
			_ellapsed += ellasedTime;
			if (_ellapsed >= _time) {
				_ellapsed = _time;
				_seq.repeat = 1;
				_seq.eternal = false;
				if (_onComplete != null) {
					_onComplete.apply(null, null);
				}
			} else {
				if (_onUpdate != null) {
					_onUpdate.apply(null, null);
				}
				var r:Number = 0;
				if (_ease != null && _ease.length == 1) {
					r = _ease.apply(null, [_ellapsed / _time]);
				}
				for (var k:String in _props) {
					var p:Object = _props[k];
					if (_target.hasOwnProperty(k)) {
						_target[k] = (p.e - p.s) * r + p.s;
					}
				}
			}
		}
		
	}
}