package com._17173.flash.core.ad.display
{
	import com._17173.flash.core.ad.BaseAdDisplay;
	import com._17173.flash.core.interfaces.IRendable;
	
	import flash.display.Sprite;
	
	public class AdError extends BaseAdDisplay implements IRendable
	{
		private var _adTime:AdTimeComp = null;
		private var _totalTime:int = 15;
		private var _currentTime:int;
		private var _bg1:Sprite = null;
		private var _offsetH:Number = 40;//播放器高度偏移量
		private var _content:AdErrorContent;
		
		public function AdError()
		{
			super();
			
			_adTime = new AdTimeComp();
			addChild(_adTime);
			creatComp();
		}
		
		private function creatComp():void {
			if (!_bg1) {
				_bg1 = new Sprite();
				addChild(_bg1);
			}
			if (!_content) {
				_content = new AdErrorContent();
//				_content.width = 320;
//				_content.height = 295;
				addChild(_content);
			}
			_isPlaying = true;
		}
		
		override public function set data(value:Array):void {
			_adTime.time = _totalTime;
			_adTime.soundUI = this;
			this.setChildIndex(_adTime, this.numChildren - 1);
		}
		
		public function update(time:int):void
		{
			if (_isPlaying || _error) {
				_currentTime += time;
				var s:int = _currentTime / 1000;
				var r:int = _totalTime - s;
				if (r <= 0) {
					_isPlaying = false;
					_error = false;
					onAdComplete();
				} else {
					if (_adTime) {
						_adTime.time = r;
					}
				}
			}
		}
		
		public function get needUpdate():Boolean
		{
			return true;
		}
		
		override public function resize(w:Number, h:Number):void {
			if (_adTime) {
				_adTime.x = w - _adTime.width;
				_adTime.y = 0;
			}
			_bg1.graphics.clear();
			_bg1.graphics.beginFill(0x000000);
			_bg1.graphics.drawRect(0, 0, w, h);
			_bg1.graphics.endFill();
			_content.x = (_bg1.width - _content.width) / 2;
			_content.y = (_bg1.height - _content.height) / 2;
		}
	}
}