package com._17173.flash.core.ad.display
{
	import com._17173.flash.core.ad.BaseAdDisplay;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 暂停广告 
	 * @author shunia-17173
	 */	
	public class AdA3 extends BaseAdDisplay
	{
		
		private static const W:int = 320;
		private static const H:int = 240;
		private var _close:MovieClip = null;
		
		public function AdA3()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		private function closeClick(evt:MouseEvent):void
		{
			dispatchEvent(new Event("close"));
		}
		
		protected function onRemoved(event:Event):void {
			if (_ad && _ad is MovieClip) {
				MovieClip(_ad).gotoAndStop(1);
			}
		}
		
		protected function onAdded(event:Event):void {
			if (_close == null) {
				_close = new mc_ad_close();
				_close.x = width - _close.width;
				_close.y = 0;
				addChild(_close);
				_close.addEventListener(MouseEvent.CLICK, closeClick);
			}
			_close.visible = false;
			if (_ad && _ad is MovieClip) {
				MovieClip(_ad).gotoAndPlay(1);
				_close.visible = true;
			}
		}
		
		override protected function onAdLoadSuccess():void {
			super.onAdLoadSuccess();
			
			_close.visible = true;
		}
		
		override protected function drawBg(w:Number, h:Number):void {
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000, 0);
			_bg.graphics.drawRect(0, 0, w, h);
			_bg.graphics.endFill();
		}
		
		override public function get width():Number {
			return W;
		}
		
		override public function get height():Number {
			return H;
		}
		
		override public function resize(w:Number, h:Number):void {
			if (w < W || h < H) {
				visible = false;
			} else {
				visible = true;
				super.resize(width, height);
			}
		}
		
		/**
		 * 是否小于最小限制宽高
		 * 320为暂停广告的宽度，240为暂停广告的高度
		 */		
		public function showFlag(w:Number, h:Number):Boolean {
			var re:Boolean = true;
			if(w < 320 || h < 240)
			{
				re = false;
			}
			return re;
		}
		
	}
}