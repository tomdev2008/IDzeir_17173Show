package com._17173.flash.player.ad_refactor.display.loader
{
	import com._17173.flash.player.ad_refactor.interfaces.IAdData;
	
	import flash.display.DisplayObject;
	
	public class BaseAdPlayer implements IAdPlayer
	{
		
		protected var _display:DisplayObject = null;
		protected var _soundTarget:Object = null;
		
		protected var _data:IAdData = null;
		protected var _onComplete:Function = null;
		protected var _onError:Function = null;
		
		protected var _w:int = 0;
		protected var _h:int = 0;
		
		public function BaseAdPlayer()
		{
		}
		
		public function get display():DisplayObject {
			return _display;
		}
		
		public function get soundTarget():Object {
			return _soundTarget;
		}
		
		public function set data(value:Object):void {
			_data = value as IAdData;
			
			init();
		}
		
		public function resize(w:int, h:int):void {
			_w = w;
			_h = h;
		}
		
		protected function init():void {
			// override
		}
		
		public function getTime():Number {
			return 0;
		}
		
		public function get width():int {
			return _display ? _display.width : 0;
		}
		
		public function get height():int {
			return _display ? _display.height : 0;
		}
		
		public function set onComplete(value:Function):void {
			_onComplete = value;
		}
		
		public function set onError(value:Function):void {
			_onError = value;
		}
		
		protected function complete(result:Object):void {
			if (_onComplete != null) {
				_onComplete.apply(null, [result]);
			}
		}
		
		protected function error(info:Object):void {
			if (_onError != null) {
				_onError.apply(null, [info]);
			}
		}
		
		public function dispose():void {
			_display = null;
			_soundTarget = null;
			_data = null;
			_onComplete = null;
			_onError = null;
		}
		
	}
}