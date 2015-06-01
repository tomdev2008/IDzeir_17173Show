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
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class PlayAndPause extends Sprite
	{
		protected var _btn:MovieClip;
		
		public function PlayAndPause()
		{
			initMC();
			var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			e.listen(PlayerEvents.BI_AD_COMPLETE, ADComplete);
			e.listen(PlayerEvents.BI_START_LOAD_AD_INFO, loadAD);
			e.listen(PlayerEvents.VIDEO_PAUSE, onPusue);
			e.listen(PlayerEvents.VIDEO_RESUME, onResume);
			e.listen(PlayerEvents.VIDEO_SEEK, onResume);
			e.listen(PlayerEvents.VIDEO_FINISHED, onFinished);
			e.listen(PlayerEvents.REPLAY_THE_VIDEO, onReplayVideo);
			e.listen(PlayerEvents.REINIT_VIDEO, onStop);
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function initMC():void {
			_btn = new mc_playAndPause();
			addChild(_btn);
		}
		
		/**
		 * 广告播放结束按钮可以使用 
		 * @param data
		 * 
		 */		
		protected function ADComplete(data:Object):void {
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		/**
		 * 广告开始加载按钮不可用 
		 * @param data
		 * 
		 */		
		protected function loadAD(data:Object):void {
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		protected function onPusue(data:Object):void {
//			if (!Global.videoManager.isPlaying) {
			if (!(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).isPlaying) {
				_btn.gotoAndStop(1);
			}
		}
		
		/**
		 * 视频用内部切换，播放另一个视频，初始化播放按钮状态
		 */		
		protected function onStop(data:Object):void {
			_btn.gotoAndStop(1);
		}
		
		protected function onResume(data:Object):void {
			_btn.gotoAndStop(2);
		}
		
		protected function onFinished(data:Object):void {
			var m:Object = Context.getContext(ContextEnum.VIDEO_MANAGER);
			if (m && m.data && !m.data.isStream) {
				_btn.gotoAndStop(3);
			}
		}
		
		protected function onReplayVideo(data:Object):void {
			onResume(null);
		}
		
		protected function onClick(event:MouseEvent):void {
			var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
//			e.send(PlayerEvents.UI_PLAY_OR_PAUSE, !Global.videoManager.isPlaying);
			e.send(PlayerEvents.UI_PLAY_OR_PAUSE, !(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).isPlaying);
			//点击统计
			var action:String = null;
			if (_btn.currentFrame == 2) {
				action = RedirectDataAction.ACTION_CLICK_PAUSE;
			} else {
				action = RedirectDataAction.ACTION_CLICK_PLAY;
			}
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.QM, StatTypeEnum.EVENT_CLICK, {"action":action});
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_CLICK, {"action":action, "click_type":RedirectDataAction.CLICK_TYPE_NORMAL});
		}
	}
}