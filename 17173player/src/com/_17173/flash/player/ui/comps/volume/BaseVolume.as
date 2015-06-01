package com._17173.flash.player.ui.comps.volume
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BaseVolume extends Sprite
	{
		protected var _btn:MovieClip = null;
		
		private var isVolumeSwitch:Boolean = true;
		
		public function BaseVolume()
		{
			super();
			_btn = btn;
			_btn.addEventListener(MouseEvent.CLICK,changeVolume);
			addChild(_btn);
			isVolumeSwitch = true;
//			Global.eventManager.listen(PlayerEvents.UI_VOLUME_CHANGE,volumeSwitch);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.UI_VOLUME_CHANGE,volumeSwitch);
		}
		
		protected function get btn():MovieClip {
			return new volume_laba();
		}
		
		private function volumeSwitch(data:Object):void
		{
			var number:int = int(data);
			if(number <= 0)
			{
				closeVolume();
			}
			else
			{
				openVolume();
			}
		}
		
		private function changeVolume(event:MouseEvent):void
		{
			event.stopPropagation();
			isVolumeSwitch = !isVolumeSwitch;
//			Global.eventManager.send(PlayerEvents.UI_VOLUME_MUTE,isVolumeSwitch);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_VOLUME_MUTE,isVolumeSwitch);
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_REDIRECT, {"action":RedirectDataAction.ACTION_CLICK_SOUND, "click_type":RedirectDataAction.CLICK_TYPE_NORMAL});
		}
		
		public function openVolume():void
		{
			isVolumeSwitch = true;
			(_btn as MovieClip).gotoAndStop(1);
		}
		
		public function closeVolume():void
		{
			isVolumeSwitch = false;
			(_btn as MovieClip).gotoAndStop(2);
		}
		
	}
}