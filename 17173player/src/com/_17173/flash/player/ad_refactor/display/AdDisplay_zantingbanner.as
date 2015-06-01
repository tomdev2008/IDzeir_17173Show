package com._17173.flash.player.ad_refactor.display
{
	import com._17173.flash.core.ad.BaseAdDisplay;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class AdDisplay_zantingbanner extends BaseAdDisplay
	{
		
		private static const W:int = 468;
		private static const H:int = 60;
		
		private var _p:Point = null;
		private var _close:MovieClip = null;
		
		public function AdDisplay_zantingbanner(anchor:Point)
		{
			super();
			
			_p = anchor;
		}
		
		override protected function onAddToStage(event:Event):void {
			super.onAddToStage(event);
			
			if (_close == null) {
				_close = new mc_ad_close();
				_close.x = width - _close.width - 2;
				_close.y = 2;
				addChild(_close);
				_close.addEventListener(MouseEvent.CLICK, closeClick);
			}
			if (_ad && _ad is MovieClip) {
				MovieClip(_ad).gotoAndPlay(1);
			}
		}
		
		private function closeClick(evt:MouseEvent):void {
			dispatchEvent(new Event("close"));
		}
		
		override protected function onRemoveState(event:Event):void {
			super.onRemoveState(event);
			
			if (_ad && _ad is MovieClip) {
				MovieClip(_ad).gotoAndStop(1);
			}
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
				super.resize(w, h);
				
				// 重新计算位置
				_p.x = (w - width) / 2;
				_p.y = h - height;
			}
		}
	}
}