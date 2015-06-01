package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.model.RedirectData;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.model.SkinEvents;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	
	public class Watermark extends Sprite implements ISkinObjectListener
	{
		private var _ui:DisplayObject = null;
		private var _clickMask:Sprite = null;
		
		public function Watermark()
		{
			super();
			init();
			addListener();
		}
		
		private function init():void {
			_ui = new mc_watermark();
			_ui.alpha = 0.7;
			addChild(_ui);
			
			_clickMask = new Sprite();
			_clickMask.graphics.clear();
			_clickMask.graphics.beginFill(0, 0);
			_clickMask.graphics.drawRect(0, 0, _ui.width, _ui.height);
			_clickMask.graphics.endFill();
			_clickMask.buttonMode = true;
			addChild(_clickMask);
		}
		
		private function addListener():void {
			if (_clickMask) {
				_clickMask.addEventListener(MouseEvent.CLICK, mouseClick);
			}
		}
		
		private function mouseClick(evt:MouseEvent):void {
//			if (Global.settings.isFullScreen) {
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				Context.stage.displayState = StageDisplayState.NORMAL;
			}

//			if (Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_OUT_CUSTOM) {
			if (Context.variables["type"] == PlayerType.S_CUSTOM) {
				//回链
				var r:RedirectData = new RedirectData();
				r.click_type = RedirectDataAction.CLICK_TYPE_REDIRECTION;
				r.action = RedirectDataAction.ACTION_BACK_WATERMARK;
				r.send();
			}else{
				//如果不是站外则跳到直播首页
				Util.toUrl("http://v.17173.com/live");
			}
		}
		
		public function resize():void {
			
		}
		
		public function listen(event:String, data:Object):void
		{
			return;
			switch (event) {
				case SkinEvents.RESIZE : 
					resize();
					TweenLite.killTweensOf(this);
					y = Context.stage.stageHeight - height;
					break;
				case SkinEvents.SHOW_FLOW : 
					if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
						TweenLite.to(this, 0.5, {"y":Context.stage.stageHeight - height});
					}
					break;
				case SkinEvents.HIDE_FLOW : 
					if (Context.getContext(ContextEnum.SETTING).isFullScreen) {
						TweenLite.to(this, 0.5, {"y":Context.stage.stageHeight});
					}
					break;
			}
		}
	}
}