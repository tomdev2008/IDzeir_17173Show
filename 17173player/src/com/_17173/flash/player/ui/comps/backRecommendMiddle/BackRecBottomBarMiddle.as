package com._17173.flash.player.ui.comps.backRecommendMiddle
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BackRecBottomBarMiddle extends Sprite
	{
		private var _bg:Sprite = null;
		private var _leftBtn:DisplayObject = null;
		private var _rightBtn:DisplayObject = null;
		protected var _rightbar:MovieClip = null;
		private var _e:IEventManager;
		
		public function BackRecBottomBarMiddle()
		{
			super();
			
			_bg = new Sprite();
			_bg.graphics.clear();
			_bg.graphics.beginFill(0,0);
			_bg.graphics.drawRect(0, 0, Context.stage.stageWidth, 60);
			_bg.graphics.endFill();
			this.addChild(_bg);
			
//			var skinManager:ISkinController = Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinController;
//			_leftBtn = skinManager.attachSkinByName("backRec_left", this);
//			_rightBtn = skinManager.attachSkinByName("backRec_right", this);
//			_rightbar = skinManager.attachSkinByName("backRec_topRight", this);
			
			_leftBtn = new mc_backRec_left();
			addChild(_leftBtn);
			_rightBtn = new mc_backRec_right();
			addChild(_rightBtn);
			addRightBar();
			
			init();
			resize();
		}
		
		protected function addRightBar():void {
			_rightbar = new mc_backRec_topRight();
			addChild(_rightbar);
		}
		
		private function init():void
		{
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			
			_rightbar.addEventListener("onReplay", onReplay);
			_rightbar.addEventListener("onShare", onShare);
			_rightbar.addEventListener("onTalk", onTalk);
			
			_leftBtn.addEventListener(MouseEvent.CLICK, leftHandler);
			_rightBtn.addEventListener(MouseEvent.CLICK, rightHandler);
		}
		
		private function leftHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new Event("leftEvent"));
		}
		
		private function rightHandler(evt:MouseEvent):void
		{
			this.dispatchEvent(new Event("rightEvent"));
		}
		
		private function onReplay(evt:Event):void
		{
			_e.send(PlayerEvents.REPLAY_THE_VIDEO);
			_e.send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
//			Global.eventManager.send(PlayerEvents.REPLAY_THE_VIDEO);
//			Global.eventManager.send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
		}
		
		private function onShare(evt:Event):void
		{
			_e.send(PlayerEvents.UI_SHOW_SHARE);
//			Global.eventManager.send(PlayerEvents.UI_SHOW_SHARE);
		}
		
		private function onTalk(evt:Event):void
		{
			_e.send(PlayerEvents.UI_SHOW_TALK);
//			Global.eventManager.send(PlayerEvents.UI_SHOW_TALK);
		}
		
		public function resize():void
		{
			if(_rightbar && contains(_rightbar))
			{
				_rightbar.x = Context.stage.stageWidth - _rightbar.width - 10;
				_rightbar.y = (_bg.height - _rightbar.height) / 2;
			}
			
			if(_rightBtn && this.contains(_rightBtn))
			{
				_rightBtn.x = _rightbar.x - _rightBtn.width - 15;
				_rightBtn.y = (_bg.height - _rightBtn.height) / 2;
			}
			
			if(_leftBtn && this.contains(_leftBtn))
			{
				_leftBtn.x = 15;
				_leftBtn.y = (_bg.height - _leftBtn.height) / 2;
			}
			
		}
	}
}