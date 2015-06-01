package com._17173.flash.player.ui.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.business.file.FileDataRetriver;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.SkinEvents;
	import com._17173.flash.player.ui.comps.MobilePanel;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class RightBar extends Sprite implements ISkinObjectListener
	{
		private var _share:MovieClip = null;
		private var _talk:MovieClip = null;
		private var _mobile:MovieClip = null;
		private var _record:MovieClip = null;
		private var _mobilePanel:MobilePanel = null;
		private var _con:Sprite = null;
		private var _canShow:Boolean = false;
		private var _e:IEventManager;
		private var _videoCanStart:Boolean = false;
		
		public function RightBar()
		{
			super();
			
			this.visible = false;
			
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			_con = new Sprite();
			addChild(_con);
			
			_share = new mc_rightbar_share();
			_con.addChild(_share);
			_mobile = new mc_rightbar_mobile();
			_con.addChild(_mobile);
			_talk = new mc_rightbar_talk();
			_con.addChild(_talk);
			_record = new mc_rightbar_record();
			_con.addChild(_record);
			
			init();
			resize();
			
			Context.stage.addEventListener(MouseEvent.MOUSE_MOVE, onCheckShow);
			_e.listen(PlayerEvents.BI_PLAYER_INITED, videoInit);
			_e.listen(PlayerEvents.BI_INIT_COMPLETE, onBIInitVideoInfo);
			_e.listen(PlayerEvents.UI_TOGGLE_FULL_SCREEN, function ():void {x = Context.stage.stageWidth});
			_e.listen(PlayerEvents.UI_SHOW_BACK_RECOMMAND, showBackRec);
			_e.listen(PlayerEvents.UI_HIDE_BACK_RECOMMAND, hideBackRec);
			_e.listen(PlayerEvents.BI_VIDEO_CAN_START, videoCanStart);
			
			x = Context.stage.stageWidth;
			this.visible = false;
		}
		
		private function init():void {
			if (_mobile) {
				_mobile.addEventListener("onMobile", onShowMobileApp);
			}
			if (_share) {
				_share.addEventListener("onShare", onShareTo);
			}
			if (_talk) {
				_talk.addEventListener("onComment", onGotoComment);
			}
			if (_record) {
				_record.addEventListener("onRecord", onRecord);
			}
		}
		
		protected function onCheckShow(event:MouseEvent):void {
			if (event.stageX > (Context.stage.stageWidth - width - 100)) {
				onShow();
			} else {
				onHide();
			}
		}
		
		private function onShowMobileApp(e:Event):void {
			if (_mobilePanel == null) {
				_mobilePanel = new MobilePanel();
			}
			Context.getContext(ContextEnum.UI_MANAGER).popup(_mobilePanel);
			if (!Context.variables["showBackRec"]) {
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SHOW_BIG_PALY_BTN);
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).togglePlay(false);
			}
//			Global.uiManager.popup(_mobilePanel);
//			if (!Global.settings.params["showBackRec"]) {
//				Global.eventManager.send(PlayerEvents.UI_SHOW_BIG_PALY_BTN);
//				Global.videoManager.togglePlay(false);
//			}
		}
		
		private function onShareTo(e:Event):void {
//			Global.eventManager.send(PlayerEvents.UI_SHOW_SHARE);
			_e.send(PlayerEvents.UI_SHOW_SHARE);
		}
		
		private function onGotoComment(e:Event):void {
//			Global.eventManager.send(PlayerEvents.UI_SHOW_TALK);
			_e.send(PlayerEvents.UI_SHOW_TALK);
		}
		
		private function onRecord(evt:Event):void {
//			if (Global.settings.isFullScreen) {
//				Global.eventManager.send(PlayerEvents.UI_TOGGLE_FULL_SCREEN);
//			}
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				_e.send(PlayerEvents.UI_TOGGLE_FULL_SCREEN);
			}
			Util.toUrl(FileDataRetriver.CLIENT_17173_URL);
		}
		
		public function resize():void
		{
			if(_con && contains(_con))
			{
				var d:DisplayObject = null;
				var i:int = 0;
				var tmp:int = 50;
				for (i; i < _con.numChildren; i ++) {
					d = _con.getChildAt(i);
					if (d) {
						d.x = 0;
						d.y = i * tmp;
					}
				}
			}
			if(_con && contains(_con))
			{
				_con.graphics.clear();
				_con.graphics.beginFill(0x1d1d1d);
				_con.graphics.drawRect(0, 0, 58, _con.numChildren * 50);
				_con.graphics.endFill();
			}
		}
		
		private function videoInit(data:Object):void {
			_canShow = true;
		}
		
		private function onBIInitVideoInfo(data:Object):void {
			_canShow = false;
		}
		
		public function listen(event:String, data:Object):void {
			switch (event) {
				case SkinEvents.RESIZE : 
					resize();
					break;
				case SkinEvents.HIDE_FLOW : 
					onHide();
					break;
			}
		}
		
		/**
		 * 后推不能显示rightbar 
		 * @param data
		 * 
		 */		
		private function showBackRec(data:Object):void {
			this.visible = false;
			_canShow = false;
		}
		
		private function hideBackRec(data:Object):void {
			if (_videoCanStart) {
				x = Context.stage.stageWidth;
				this.visible = true;
				_canShow = true;
			}
		}
		
		private function onShow():void {
			if (_canShow) {
				this.visible = _videoCanStart;
//				y = (Global.uiManager.avalibleVideoHeight - height) / 2;
				y = (Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight - height) / 2;
				TweenLite.to(this, 0.5, {"x":Context.stage.stageWidth - width});
			}
		}
		
		private function onHide():void {
			if (_canShow) {
//				y = (Global.uiManager.avalibleVideoHeight - height) / 2;
				y = (Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight - height) / 2;
				TweenLite.to(this, 0.5, {"x":Context.stage.stageWidth, onComplete:function ():void{this.visible = false}});
			}
		}
		
		private function videoCanStart(data:Object):void {
			_videoCanStart = true;
			this.visible = true;
		}
		
	}
}