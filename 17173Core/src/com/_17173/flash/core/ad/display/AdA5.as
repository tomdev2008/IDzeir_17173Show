package com._17173.flash.core.ad.display
{
	import com._17173.flash.core.ad.BaseAdDisplay;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 此广告内显示对象都是负坐标.
	 * 挂角广告 
	 * @author shunia-17173
	 */	
	public class AdA5 extends BaseAdDisplay
	{
		
		private static const S_W:int = 80;
		private static const S_H:int = 60;
		private static const B_W:int = 634;
		private static const B_H:int = 60;
		
		private static const SIDE_W:int = 5;
		private static const SIDE_H:int = 12;
		
		private var _fakeW:Number = 80;
		private var _fakeH:Number = 60;
		
		private var _close:MovieClip = null;
		
		public function AdA5()
		{
			super();
			
			_close = new mc_ad_close();
			_close.x = width - _close.width + 1;
			_close.y = 1;
			addChild(_close);
			
			_close.addEventListener(MouseEvent.CLICK, closeClick);
		}
		
		
		private function closeClick(evt:MouseEvent):void
		{
			dispatchEvent(new Event("close"));
		}
		
		override public function resize(w:Number, h:Number):void {
			super.resize(width, height);
		}
		
		override public function get width():Number {
			return _fakeW;
		}
		
		override public function get height():Number {
			return _fakeH;
		}
		
	}
}