package com._17173.flash.player.module.otherLogo
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.ui.comps.Pic;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LogoUI extends Sprite implements IExtraUIItem
	{
		private var _logo:Pic;
		private var _jumpUrl:String;
		private var _w:Number = 80;
		private var _h:Number = 23;
		
		public function LogoUI(width:Number, height:Number)
		{
			_w = width;
			_h = height;
			super();
		}
		
		public function addUrl(url:String, jump:String = ""):void {
			_logo = new Pic();
			_logo.visible = false;
			_logo.isfit = false;
			_logo.content = url;
			_logo.addEventListener("loadComplete", loadComplete);
			if (jump != "") {
				_jumpUrl = formatUrl(jump);
				_logo.buttonMode = true;
				_logo.addEventListener(MouseEvent.CLICK, logoClick);
			}
			addChild(_logo);
		}
		
		private function loadComplete(evt:Event):void {
			var tempW:Number = _logo.width > _w ? _w : _logo.width;
			var tempH:Number = _logo.height > _h ? _h : _logo.height;
			var sp:Sprite = new Sprite();
			sp.graphics.clear();
			sp.graphics.beginFill(0, 0);
			sp.graphics.drawRect(0, 0, tempW, tempH);
			sp.graphics.endFill();
			this.mask = sp;
			_logo.visible = true;
			addChild(sp);
			this.dispatchEvent(new Event("loadComplete"));
		}
		
		private function logoClick(evt:MouseEvent):void {
			Util.toUrl(_jumpUrl);
		}
		
		private function formatUrl(url:String):String {
			if (url.indexOf("http://") == -1) {
				url = "http://" + url;
			}
			return url;
		}
		
		public function refresh(isFullScreen:Boolean=false):void
		{
		}
		
		public function get side():Boolean
		{
			return ExtraUIItemEnum.SIDE_LEFT;
		}
		
		override public function get width():Number {
			return _w;
		}
		
		override public function get height():Number {
			return _h;
		}
	}
}