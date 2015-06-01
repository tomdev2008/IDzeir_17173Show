package com._17173.flash.player.ui.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BackRecommendSmall extends Sprite
	{
		private var _bg:Sprite = null;
		protected var _center:MovieClip = null;
		private var _e:IEventManager;
		
		public function BackRecommendSmall(width:Number, height:Number)
		{
			super();
			
			_bg = new Sprite();
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000);
			_bg.graphics.drawRect(0, 0, width, height);
			_bg.graphics.endFill();
			addChild(_bg);
			
			addCenter();
			
			init();
			resize();
		}
		
		protected function addCenter():void {
			_center = new mc_backRec_small_center();
			addChild(_center);
		}
		
		private function init():void
		{
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			_center.addEventListener("onReplay", onReplay);
			_center.addEventListener("onShare", onShare);
			_center.addEventListener("onTalk", onTalk);
		}
		
		private function onReplay(evt:Event):void
		{
			_e.send(PlayerEvents.REPLAY_THE_VIDEO);
			_e.send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
		}
		
		private function onShare(evt:Event):void
		{
			_e.send(PlayerEvents.UI_SHOW_SHARE);
		}
		
		private function onTalk(evt:Event):void
		{
			_e.send(PlayerEvents.UI_SHOW_TALK);
		}
		
//		private function onReplay(evt:Event):void
//		{
//			Global.eventManager.send(PlayerEvents.REPLAY_THE_VIDEO);
//			Global.eventManager.send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
//		}
//		
//		private function onShare(evt:Event):void
//		{
//			Global.eventManager.send(PlayerEvents.UI_SHOW_SHARE);
//		}
//		
//		private function onTalk(evt:Event):void
//		{
//			Global.eventManager.send(PlayerEvents.UI_SHOW_TALK);
//		}
		
		public function resize():void
		{
			if(_center && this.contains(_center))
			{
				_center.x = (this.width - _center.width) / 2;
				_center.y = (this.height - _center.height) / 2;
			}
		}
	}
}