package com._17173.flash.player.module.showRec.ui
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.ui.comps.Pic;
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 直播/点播推荐秀场 图片组件
	 * @author 安庆航
	 * 
	 */	
	public class ShowRecImage extends Sprite
	{
		private var _img:Pic;
		private var _mask:Sprite;
		private var _w:Number = 128;
		private var _h:Number = 72;
		private var _bg:Sprite;
		private var _close:MovieClip;
		private var _url:String;
		
		public function ShowRecImage()
		{
			super();
			_img = new Pic();
			_img.addEventListener("loadComplete", loadComplete);
			_img.buttonMode = true;
			_img.useHandCursor = true;
			_img.addEventListener(MouseEvent.CLICK, imageClick);
			
			_close = new mc_showRecClsoBtn();
			
			_bg = new Sprite();
			_bg.graphics.clear();
			_bg.graphics.beginFill(0, 0);
			_bg.graphics.drawRect(0, 0, _w, _h);
			_bg.graphics.endFill();
			addChild(_bg);
			
			_mask = new Sprite();
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xff00ff, 0);
			_mask.graphics.drawRect(0, 0, _w, _h);
			_mask.graphics.endFill();
			addChild(_mask);
			
			_bg.mask = _mask;
		}
		
		public function set source(value:String):void {
			_img.content = value;
			_img.width = _w;
			_img.height = _h;
			_img.y = _h;
			
			_close.y = _h;
			_close.x = _w - _close.width;
		}
		
		public function set url(value:String):void {
			_url = value;
		}
		
		private function loadComplete(evt:Event):void {
			TweenLite.to(_img, 1, {"y":0});
			TweenLite.to(_close, 1, {"y":0});
			_bg.addChild(_img);
			this.dispatchEvent(new Event("loadComplete"));
			
			if (Context.variables["type"] != PlayerType.F_ZHANWAI){
				Ticker.tick(10000, closeImage);
			}
			
			
			_bg.addChild(_close);
			_close.buttonMode = true;
			_close.useHandCursor = true;
			_close.addEventListener(MouseEvent.MOUSE_OVER, mouseRollOver);
			_close.addEventListener(MouseEvent.MOUSE_OUT, mouseRollOut);
			_close.addEventListener(MouseEvent.CLICK, closeImage);
		}
		
		private function mouseRollOver(evt:MouseEvent):void {
			if (_close) {
				_close.gotoAndStop(2);
			}
		}
		
		private function mouseRollOut(evt:MouseEvent):void {
			if (_close) {
				_close.gotoAndStop(1);
			}
		}
		
		private function closeImage(evt:MouseEvent = null):void {
			TweenLite.to(_img, 1, {"y":_h, "onComplete":closeComplete});
			TweenLite.to(_close, 1, {"y":_h});
		}
		
		
		private function closeComplete():void {
			this.dispatchEvent(new Event("closeComplete"));
		}
		
		private function imageClick(evt:MouseEvent):void {
			if (Util.validateStr(_url)) {
				Util.toUrl(_url);
			}
		}
		
		override public function get width():Number {
			return _img.width;
		}
		
		override public function get height():Number {
			return _img.height;
		}
	}
}