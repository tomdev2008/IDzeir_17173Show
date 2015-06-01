package com._17173.flash.player.ui.comps
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class PlayAndPauseBig extends Sprite
	{
		private var _canShow:Boolean = false;
		
		private var _bigBtn:DisplayObject = null;
		
		private var _e:IEventManager;
		
		public function PlayAndPauseBig()
		{
			super();
			initMC();
			addEventListeners();
		}
		
		private function addEventListeners():void {
//			Global.eventManager.listen(PlayerEvents.UI_SHOW_BIG_PALY_BTN, showBigPlayBtn);
//			Global.eventManager.listen(PlayerEvents.UI_HIDE_BIG_PALY_BTN, hideBigPlayBtn);
//			Global.eventManager.listen(PlayerEvents.VIDEO_PAUSE, onPusue);
//			Global.eventManager.listen(PlayerEvents.VIDEO_RESUME, onResume);
//			Global.eventManager.listen(PlayerEvents.VIDEO_FINISHED, onResume);
			_e.listen(PlayerEvents.UI_SHOW_BIG_PALY_BTN, showBigPlayBtn);
			_e.listen(PlayerEvents.UI_HIDE_BIG_PALY_BTN, hideBigPlayBtn);
			_e.listen(PlayerEvents.VIDEO_PAUSE, onPusue);
			_e.listen(PlayerEvents.VIDEO_RESUME, onResume);
			_e.listen(PlayerEvents.VIDEO_FINISHED, onResume);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onPusue(data:Object):void {
//			if (_canShow && !Global.videoManager.isPlaying) {
			if (_canShow && !(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).isPlaying) {
				this.visible = true;
			}
		}
		
		protected function onResume(data:Object):void {
			if (_canShow) {
				this.visible = false;
			}
		}
		
		protected function showBigPlayBtn(data:Object):void {
			_canShow = true;
			this.visible = true;
		}
		
		protected function hideBigPlayBtn(data:Object):void {
			_canShow = false;
			this.visible = false;
		}
		
		protected function onClick(event:MouseEvent):void {
			var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			e.send(PlayerEvents.UI_PLAY_OR_PAUSE, true);
			//点击统计
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.QM, StatTypeEnum.EVENT_CLICK, {"action":RedirectDataAction.ACTION_CLICK_PLAY});
		}
		
		protected function initMC():void {
			_bigBtn = btn;
			addChild(_bigBtn);
			_e = (Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager);
		}
		
		protected function get btn():DisplayObject {
			return new mc_playAndPause_big(); 
		}
		
	}
}