package com._17173.flash.player.ui.stream.extra
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.SkinEvents;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	
	public class StreamSecondExtraBar extends Sprite implements ISkinObjectListener
	{
		protected var _w:Number = 0;
		protected var _h:Number = 88;
		public var _mouseOnBar:Boolean = false;
		
		public function StreamSecondExtraBar()
		{
			super();
			init();
		}
		
		public function addItem(item:Sprite):void {
			addChild(item);
		}
		
		private function init():void {
		}
		
		public function resize():void {
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				_w = 760;
			} else {
				_w = Context.stage.stageWidth;
			}
			drawBg();
		}
		
		private function drawBg():void {
			graphics.clear();
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				if (Context.variables.hasOwnProperty("quizShow")) {
					var flag:Boolean = Context.variables["quizShow"];
					if (flag) {
						graphics.beginFill(0xffffff, 0);
					} else {
						graphics.beginFill(0,0);
					}
				} else {
					graphics.beginFill(0,0);
				}
				graphics.drawRect(0, 0, width, _h);
			} else {
				graphics.beginFill(0xffffff);
				graphics.drawRect(0, 0, Context.stage.stageWidth, _h);
			}
			graphics.endFill();
		}
		
		public function show():void {
//			var ph:Number = Global.skinManager.getSkin(SkinsEnum.BOTTOM_BAR).display.height;
			var ph:Number = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).getSkin(SkinsEnum.BOTTOM_BAR).display.height;
			TweenLite.to(this, 0.5, {"x":(Context.stage.fullScreenWidth - width) / 2, 
				"y":Context.stage.fullScreenHeight - height - ph - 100});
		}
		
		public function hide():void {
			if (_mouseOnBar) return ;
			TweenLite.to(this, 0.5, {"y":Context.stage.fullScreenHeight});
		}
		
		override public function get width():Number {
			return _w;
		}
		
		override public function get height():Number {
			return _h;
		}
		
		public function set mouseOnBar(value:Boolean):void {
			_mouseOnBar = value;
		}
		
		public function listen(event:String, data:Object):void
		{
			switch (event) {
				case SkinEvents.RESIZE : 
					TweenLite.killTweensOf(this);
					resize();
					break;
				case SkinEvents.SHOW_FLOW : 
//					if (Global.settings.isFullScreen) {
					if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
						show();
					}
					break;
				case SkinEvents.HIDE_FLOW : 
//					if (Global.settings.isFullScreen) {
					if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
						hide();
					}
					break;
			}
		}
	}
}