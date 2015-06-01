package com._17173.flash.player.ui.comps.progressbar
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.SkinEvents;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * SEO 视频游戏  进度条
	 * @author anqinghang
	 */	
	public class ProgressBarSeoVideo extends Sprite implements ISkinObjectListener
	{
		private var pro:BaseProgressBar;
		protected var _tip:ControlBarProgressTip = null;
		private var vd:IVideoManager;
		
		private var _loadProgress:Number = 0;
		protected var _playProgress:Number = 0;
		
		public function ProgressBarSeoVideo()
		{
			super();
			visible = false;
			init();
		}
		
		private function init():void {
			pro = progressBar;
			pro.addEventListener("progressChangeEvent", getProEvent);
			pro.addEventListener("mousePositionEvent", getMousePositionEvent);
			pro.addEventListener(MouseEvent.ROLL_OUT, proMouseOut);
			pro.addEventListener("hideTipEvent", hideTipEvent);
			pro.addEventListener("leftBtnClickEvent", leftBtnClickEvent);
			pro.addEventListener("rightBtnClickEvent", rightBtnClickEvent);
			pro.y = -4;
			addChild(pro);
			
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.VIDEO_INIT, startUpdate);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.BI_PLAYER_INITED, onInit);
		}
		
		protected function get progressBar():BaseProgressBar {
			return new SeoVideoProgressBar(Context.stage);
		}
		
		protected function rightBtnClickEvent(event:Event):void
		{
			vd.seek((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.playedTime + 10);
		}
		
		protected function leftBtnClickEvent(event:Event):void
		{
			vd.seek((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.playedTime - 10);
		}
		
		protected function hideTipEvent(event:Event):void
		{
			proMouseOut(null);
		}
		
		protected function proMouseOut(event:MouseEvent):void
		{
			if (_tip && this.contains(_tip)) {
				removeChild(_tip);
			}
		}
		
		protected function getMousePositionEvent(event:Event):void
		{
			if (_tip == null) {
				_tip = new ControlBarProgressTip();
			}
			addChild(_tip);
			_tip.time = pro.currentMousePosition * (_(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalTime;
			_tip.y = pro.y - 15;
			_tip.x = this.mouseX;
		}
		
		protected function getProEvent(event:Event):void
		{
			if (vd) {
				vd.seek(pro.proValue * (_(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalTime);
			}
		}
		
		private function onInit(data:Object):void {
			visible = true;
		}
		
		private function startUpdate(data:Object):void {
			vd = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager;
			Ticker.tick(1, update, 0, true);
		}
		
		private function update():void {
			if (Context.getContext(ContextEnum.VIDEO_MANAGER) && (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data) {
				var played:Number = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.playedTime;
				var total:Number = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalTime;
				played = played > total ? total : played;
				if (total == 0) {
					_playProgress = 0;
				} else {
					_playProgress = played / total;
				}
				
				if (pro) {
					pro.proValue = _playProgress;
				}
				
				var totalToLoad:Number = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.totalBytes;
				if (totalToLoad > 0) {
					var loaded:Number = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.loadedBytes;
					_loadProgress = loaded / totalToLoad;
					//由于理论数据和真实数据会有差异，因此能导致loaded大于totalToLoad
					if(_loadProgress > 1)
					{
						_loadProgress = 1;
					}
				}
				if (pro) {
					pro.loadValue = _loadProgress;
				}
			}
		}
		
		public function listen(event:String, data:Object):void
		{
			switch (event) {
				case SkinEvents.SHOW_FLOW : 
					pro.setProgressBarState(true);
					break;
				case SkinEvents.HIDE_FLOW : 
					pro.setProgressBarState(false);
					break;
				case SkinEvents.RESIZE : 
					pro.resize();
					break;
			}
		}
		
		override public function get height():Number {
			return 10;
		}
		
	}
}