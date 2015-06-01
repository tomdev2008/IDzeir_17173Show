package com._17173.flash.player.ui.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class BackRecommendLittleSmall extends Sprite
	{
		private var _bg:Sprite = null;
		private var _center:MovieClip = null;
		
		public function BackRecommendLittleSmall(width:Number, height:Number)
		{
			super();
			
			_bg = new Sprite();
			_bg.graphics.clear();
			_bg.graphics.beginFill(0x000000);
			_bg.graphics.drawRect(0, 0, width, height);
			_bg.graphics.endFill();
			addChild(_bg);
			
			_center = new mc_backRec_small_replay();
			addChild(_center);
			
			init();
			resize();
		}
		
		private function init():void
		{
			_center.addEventListener("onReplay", onReplay);
		}
		
		private function onReplay(evt:Event):void
		{
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.REPLAY_THE_VIDEO);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
//			Global.eventManager.send(PlayerEvents.REPLAY_THE_VIDEO);
//			Global.eventManager.send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
		}
		
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