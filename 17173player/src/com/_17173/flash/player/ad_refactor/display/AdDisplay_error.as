package com._17173.flash.player.ad_refactor.display
{
	import com._17173.flash.core.util.time.Ticker;
	
	public class AdDisplay_error extends BaseAdDisplay_refactor
	{
		
		private static const TIME:int = 15;
		
		private var _currentTime:int = 0;
		private var _adTime:AdTimeComp = null;
		private var _content:AdErrorContent = null;
		
		public function AdDisplay_error()
		{
			super();
			
			_content = new AdErrorContent();
			addChild(_content);
			_adTime = new AdTimeComp();
			_adTime.time = TIME;
			addChild(_adTime);
		}
		
		override protected function start():void {
			super.start();
			
			Ticker.tick(1, update, 0).callbackEllapsedTime = true;
		}
		
		protected function update(time:int):void {
			_currentTime += time;
			var s:int = _currentTime / 1000;
			var r:int = TIME - s;
			if (r <= 0) {
				complete(null);
				Ticker.stop(update);
			} else {
				if (_adTime) {
					_adTime.time = r;
				}
			}
		}
		
		override public function resize(w:int, h:int):void {
			super.resize(w, h);
			_adTime.x = w - _adTime.width;
			_adTime.y = 0;
			this.graphics.clear();
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
			_content.x = (width - _content.width) / 2;
			_content.y = (height - _content.height) / 2;
		}
		
	}
}