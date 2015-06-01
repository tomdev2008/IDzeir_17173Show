package com._17173.flash.player.ui.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.business.file.FileCustomerDataRetriver;
	import com._17173.flash.player.business.file.FileDataRetriver;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerScope;
	import com._17173.flash.player.ui.comps.BaseRightBar;
	import com._17173.flash.player.ui.comps.MobilePanel;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class FileCustomerRightBar extends BaseRightBar
	{
		private var _share:MovieClip = null;
		private var _talk:MovieClip = null;
		private var _mobile:MovieClip = null;
		private var _record:MovieClip = null;
		private var _mobilePanel:MobilePanel = null;
		private var _showResizDic:Dictionary = null;
		
		public function FileCustomerRightBar()
		{
			_showResizDic = new Dictionary();
			Context.getContext(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.UI_INTED, onModuleComplete);
		}
		
		private function onModuleComplete(value:Object):void {
			addListeners();
			resize();
		}
		
		private function initComp():void {
			var uiModule:Object = Context.variables["UIModuleData"];
			if (!uiModule) {
				return;
			}
			if (uiModule[FileCustomerDataRetriver.M6] && _showResizDic["share"]) {
				//分享
				if (!_share) {
					_share = new mc_rightbar_share();
				}
				_con.addChild(_share);
				if (!_share.hasEventListener("onShare")) {
					_share.addEventListener("onShare", onShareTo);
				}
			}
			if (uiModule[FileCustomerDataRetriver.M5] && _showResizDic["mobile"]) {
				//移动版
				if (!_mobile) {
					_mobile = new mc_rightbar_mobile();
				}
				_con.addChild(_mobile);
				if (!_mobile.hasEventListener("onMobile")) {
					_mobile.addEventListener("onMobile", onShowMobileApp);
				}
			}
			if (uiModule[FileCustomerDataRetriver.M4] && _showResizDic["comment"]) {
				//评论
				if (!_talk) {
					_talk = new mc_rightbar_talk();
				}
				_con.addChild(_talk);
				if (!_talk.hasEventListener("onComment")) {
					_talk.addEventListener("onComment", onGotoComment);
				}
				
			}
			if (uiModule[FileCustomerDataRetriver.M7] && _showResizDic["record"]) {
				//录制
				if (!_record) {
					_record = new mc_rightbar_record();
				}
				_con.addChild(_record);
				if (!_record.hasEventListener("onRecord")) {
					_record.addEventListener("onRecord", onRecord);
				}
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
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SHOW_SHARE);
		}
		
		private function onGotoComment(e:Event):void {
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SHOW_TALK);
//			Global.eventManager.send(PlayerEvents.UI_SHOW_TALK);
		}
		
		private function onRecord(evt:Event):void {
//			if (Global.settings.isFullScreen) {
//				Global.eventManager.send(PlayerEvents.UI_TOGGLE_FULL_SCREEN);
//			}
			if (Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_TOGGLE_FULL_SCREEN);
			}
			Util.toUrl(FileDataRetriver.CLIENT_17173_URL);
		}
		
		override protected function onCheckShow(event:MouseEvent):void {
			if (event.stageX > (Context.stage.stageWidth - width - 100) && 
				Context.stage.stageWidth >= PlayerScope.PLAYER_WIDTH_4) {
				onShow();
			} else {
				onHide();
			}
		}
		
		override public function resize():void {
			if (this.numChildren > 0) {
				//删除当前所以内容，为了解决全屏和高端较小切换的时候背景不变化的bug
				this.removeChildren(0, this.numChildren - 1);
			}
			init();
			checkResizeDic();
			if (_con.numChildren > 0) {
				_con.removeChildren(0, _con.numChildren - 1);
			}
			initComp();
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
		
		/**
		 * 根据当前高度计算那些组件可以被显示
		 */	
		private function checkResizeDic():void {
			var h:Number = Context.stage.stageHeight;
			_showResizDic["share"] = true;
			_showResizDic["mobile"] = true;
			_showResizDic["comment"] = true;
			_showResizDic["record"] = true;
			if (h < PlayerScope.PALYER_HEIGHT_1) {
				_showResizDic["share"] = false;
			}
			if (h < PlayerScope.PALYER_HEIGHT_2) {
				_showResizDic["mobile"] = false;
			}
			if (h < PlayerScope.PALYER_HEIGHT_3) {
				_showResizDic["comment"] = false;
				_showResizDic["record"] = false;
			}
		}
		
	}
}