package com._17173.flash.player.ui
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * PT基类
	 * @author Administrator
	 * 
	 */	
	public class BasePT extends Sprite
	{
		protected var _bg:Shape = null;
		protected var _pt:MovieClip = null;
		
		protected var _ptw:Number = 0;
		protected var _pth:Number = 0;
		
		public function BasePT()
		{
			super();
			init();
			addListen();
		}
		
		protected function init():void{
			_bg = new Shape();
			addChild(_bg);
		}		
		
		protected function addListen():void {
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		}
		
		protected function onAdded(event:Event):void {
			_pt.gotoAndPlay(1);
			//重置一下位置
			//			resize();
		}
		
		protected function onRemoved(event:Event):void {
			_pt.gotoAndStop(1);
		}
		
		public function resize():void {
//			var aw:Number = Global.uiManager.avalibleVideoWidth;
//			var ah:Number = Global.uiManager.avalibleVideoHeight;
			var aw:Number = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth;
			var ah:Number = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight;
			
//			if (Global.settings.isFullScreen) {
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				var topbar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.FULLSCREEN_TOP_BAR);
				if (topbar) {
					ah -= topbar.display.height;
				}
				var bottombar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.BOTTOM_BAR);
				if (bottombar) {
					ah -= bottombar.display.height;
				}
			}
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000);
			_bg.graphics.drawRect(0, 0, aw, ah);
			_bg.graphics.endFill();
			
			var scale:Number = 1;
			if (_ptw > aw || _pth > ah) {
				var sx:Number = aw / _ptw;
				var sy:Number = ah / _pth;
				scale = sx < sy ? sx : sy;
			}
			_pt.scaleX = _pt.scaleY = scale;
			_pt.x = (_bg.width - _pt.width) / 2;
			_pt.y = (_bg.height - _pt.height) / 2;
		}
		
	}
}