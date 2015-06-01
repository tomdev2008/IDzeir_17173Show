package com._17173.flash.player.business.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.UIManager;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.ui.file.FileBackRecommend;
	import com._17173.flash.player.ui.file.PassWordConfirm;
	import com._17173.flash.player.ui.file.ShareCompoment;
	
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class FileUIManager extends UIManager
	{
		
		protected var _backRec:FileBackRecommend = null;
		private var _share:ShareCompoment = null; 
		private var _pw:PassWordConfirm = null;
		
		public function FileUIManager()
		{
			super();
		}
		
		override protected function initComponents():void { 
			super.initComponents();
		}
		
		override protected function addListeners():void
		{
			super.addListeners();
			
			var eventManager:EventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as EventManager;
			eventManager.listen(PlayerEvents.UI_SHOW_BACK_RECOMMAND, onShowBackRecommand);
			eventManager.listen(PlayerEvents.UI_HIDE_BACK_RECOMMAND, onHideBackRecommand);
			eventManager.listen(PlayerEvents.UI_SHOW_TALK, onShowTalkHandler);
			eventManager.listen(PlayerEvents.UI_SHOW_SHARE, onShowShareHandler);
			eventManager.listen(PlayerEvents.REPLAY_THE_VIDEO, replayVideo);
			eventManager.listen(PlayerEvents.VIDEO_SEEK, videoSeek);
			eventManager.listen(PlayerEvents.SHOW_PASS_WORD, showPassWord);
			eventManager.listen(PlayerEvents.HIDE_PASS_WORD, hidePassWord);
			eventManager.listen(PlayerEvents.UI_CHANGE_DEFINITION, onChangingDef);
//			eventManager.listen(PlayerEvents.UI_PALY_BTN_CLICK, playBtnClick);
		}
		
		/**
		 * 切换清晰度 
		 * @param data
		 * 
		 */		
		private function onChangingDef(data:Object):void {
//			Global.videoManager["definition"] = data;
			if (Context.getContext(ContextEnum.VIDEO_MANAGER)) {
				Context.getContext(ContextEnum.VIDEO_MANAGER)["definition"] = data;
			}
		}
		
		protected function onShowTalkHandler(data:Object):void
		{
			if(Context.getContext(ContextEnum.SETTING)["isFullScreen"]) {
//				Global.eventManager.send(PlayerEvents.UI_TOGGLE_FULL_SCREEN);
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_TOGGLE_FULL_SCREEN);
			}
			if(Context.getContext(ContextEnum.SETTING)["type"] == PlayerType.F_ZHANEI)
			{
				var js:FileBusinessJSDelegate = Context.getContext(ContextEnum.JS_DELEGATE) as FileBusinessJSDelegate;
				FileBusinessJSDelegate(js).showTalk();
			}
			else if(Context.getContext(ContextEnum.SETTING)["type"] == PlayerType.F_ZHANWAI || Context.getContext(ContextEnum.SETTING)["type"] == PlayerType.F_CUSTOM)
			{
				//有可能相关部门不让这种链接后面带参数的跳转，可能需要做本地两个swf之间交互的东西
				var url:String = Context.variables["url"] + "?t=" + (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.playedTime + "#SOHUCS";
				Util.toUrl(url);
			}
		}
		
		protected function onShowShareHandler(data:Object):void
		{
			if(!_share)
			{
				_share = new ShareCompoment();
			}
			_share.showShare();
		}
		
		protected function replayVideo(data:Object = null):void
		{
			_backRecLayer.clear();
//			Global.videoManager.replay();
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).replay();
		}
		
		override protected function onVideoStart(data:Object):void {
			super.onVideoStart(data);
		}
		
		protected function onShowBackRecommand(data:Object):void {
//			if(Global.settings.params.hasOwnProperty("skipBR") && Global.settings.params["skipBR"])
			if(Context.variables.hasOwnProperty("skipBR") && Context.variables["skipBR"])
			{
				Debugger.log(Debugger.INFO, "内部版本，跳过后推!");
				return;
			}
			
			var js:FileBusinessJSDelegate = Context.getContext(ContextEnum.JS_DELEGATE) as FileBusinessJSDelegate;
			var showFlag:Boolean = js.getPlayNextState();
//			Debugger.log(Debugger.INFO, "是否不联播：" + showFlag);
			if(showFlag)
			{
//				Global.settings.params["showBackRec"] = true;
				Context.variables["showBackRec"] = true;
				if (_backRec == null) {
					_backRec = backRecommend;
				}
				_backRecLayer.clear();
				_backRecLayer.addChild(_backRec);
			} else {
				//如果在连播状态下，全屏有的浏览器不会自动退出
//				if(Global.settings.isFullScreen)
				if(Context.getContext(ContextEnum.SETTING)["isFullScreen"])
				{
					Context.stage.displayState = StageDisplayState.NORMAL;
				}
			}
			
		}
		
		protected function get backRecommend():FileBackRecommend {
			return new FileBackRecommend();
		}
		
		override protected function onMouseRollOver(event:MouseEvent):void {
			super.onMouseRollOver(event);
//			if(Global.settings.isError)
			if(Context.getContext(ContextEnum.SETTING)["isError"])
			{
				return;
			}
		}
		
		override protected function onMouseRollOut(event:Event):void {
			super.onMouseRollOut(event);
//			if(Global.settings.isError)
			if(Context.getContext(ContextEnum.SETTING)["isError"])
			{
				return;
			}
		}
		
		protected function videoSeek(data:Object = null):void {
			if(data && data.hasOwnProperty("description") && data["description"] != "")
			{
				var tempArr:Array = String(data["description"]).split(" ");
				if(tempArr.length >= 3)
				{
					if(tempArr[2] <= 0)
					{
//						_componentLayer.replay();
					}
				}
			}
//			if (Global.settings.params["showBackRec"]) {
			if (Context.variables["showBackRec"]) {
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
			}
//			_backRecLayer.clear();
		}
		
		private function showPassWord(data:Object = null):void
		{
			if(!_pw) {
				_pw = new PassWordConfirm();
			}
			_pw.showPassword();
		}
		
		private function hidePassWord(data:Object = null):void
		{
			if(_pw) {
				_pw.hidePassword();
			}
		}
		
		protected function onHideBackRecommand(data:Object):void {
//			Global.settings.params["showBackRec"] = false;
			Context.variables["showBackRec"] = false;
			if(_backRec) {
				_backRecLayer.clear();
				_backRec = null;
			}
		}
		
		override protected function onUIVideoPlayAndPause(data:Object):void {
			if (Context.variables.hasOwnProperty("queueComplete") && Context.variables["queueComplete"]) {
				var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
				if (data) {
					e.send(PlayerEvents.UI_HIDE_BIG_PALY_BTN);
					e.send(PlayerEvents.UI_HIDE_PREVIDEW_PAGE);
//					Global.eventManager.send(PlayerEvents.UI_HIDE_BIG_PALY_BTN);
//					Global.eventManager.send(PlayerEvents.UI_HIDE_PREVIDEW_PAGE);
				} else {
					e.send(PlayerEvents.UI_SHOW_BIG_PALY_BTN);
//					Global.eventManager.send(PlayerEvents.UI_SHOW_BIG_PALY_BTN);
				}
				super.onUIVideoPlayAndPause(data);
			}
		}
		
	}
}