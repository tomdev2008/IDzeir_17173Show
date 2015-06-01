package com._17173.flash.player.business.stream
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.plugin.IPluginManager;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.skin.ISkinObjectListener;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.UIManager;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.model.SkinEvents;
	import com._17173.flash.player.module.PluginEnum;
	import com._17173.flash.player.module.quiz.QuizEvents;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.comps.StreamPT;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.rec.BaseGridStreamRecommand;
	import com._17173.flash.player.ui.stream.rec.StreamOrgnizeRecommand;
	import com._17173.flash.player.ui.stream.rec.StreamPersonalRecommand;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	
	
	/**
	 * 直播播放器的ui控制类,覆写了部分通用ui逻辑.增加了特有界面. 
	 * @author shunia-17173
	 */	
	public class StreamUIManager extends UIManager
	{
		private var _isOrgGot:Boolean = false;
		private var _backRecVisible:Boolean = false;
		
		/**
		 * 直播播放器下面的条,用来显示送礼和弹幕,以后可能会被扩展. 
		 */		
		protected var _streamExtraBar:ISkinObject = null;
		
		/**
		 * 直播第二个扩展栏，用于显示竞猜
		 */		
		protected var _streamSecondExtraBar:ISkinObject = null;
		
		/**
		 * 直播底栏
		 */
		protected var _streamBottomBar:ISkinObject = null;
		/**
		 * 直播后推 
		 */		
		private var _streamBackRec:BaseGridStreamRecommand = null;
		private var _mouseOnExtraBar:Boolean = false;
		private var _mouseOnSecondExtraBar:Boolean = false;
		private var _mouseOnBottomBar:Boolean = false;
		
		public function StreamUIManager()
		{
			super();
		}
		
		override protected function addListeners():void {
			super.addListeners();
			
			var eventManager:EventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as EventManager;
			eventManager.listen(PlayerEvents.VIDEO_STOP, onVideoStop);
			eventManager.listen(PlayerEvents.UI_SHOW_FORE_RECOMMAND, onShowForeRecommand);
			eventManager.listen(PlayerEvents.UI_SHOW_BACK_RECOMMAND, onShowBackRecommand);
			eventManager.listen(PlayerEvents.UI_HIDE_BACK_RECOMMAND, onHideBackRecommand);
			eventManager.listen(PlayerEvents.UI_HIDE_FORE_RECOMMAND, onHideForeRecommand);
			eventManager.listen(PlayerEvents.BI_AD_COMPLETE, onAdComplete);
			//竞猜面板显示或者消失的事件
			if (Context.variables["type"] == PlayerType.S_ZHANNEI)
			{
				eventManager.listen(QuizEvents.QUIZ_HIDE_QUIZ_UI, onQuizHide);
				eventManager.listen(QuizEvents.QUIZ_SHOW_QUIZ_UI, onQuizShow);
			}
		}
		
		private function onAdComplete(e:Object):void {
			_backRecVisible = true;
			if (_streamBackRec) {
				_streamBackRec.visible = true;
			}
		}
		
		private function onQuizHide(e:Event):void {
			_streamSecondExtraBar.display.removeEventListener(MouseEvent.ROLL_OVER,onRollOverSecodnExtraBar);
			_streamSecondExtraBar.display.removeEventListener(MouseEvent.ROLL_OUT,onRollOutSecondExtraBar);
			
			if (_mouseOnSecondExtraBar) {
				mouseOnBar = false;
//				Global.eventManager.send(PlayerEvents.SKIN_EVENT, {"event":SkinEvents.HIDE_FLOW});
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.SKIN_EVENT, {"event":SkinEvents.HIDE_FLOW});
			} 
			_mouseOnSecondExtraBar = false;
		}
		
		private function onQuizShow(e:Event):void {
			_streamSecondExtraBar.display.addEventListener(MouseEvent.ROLL_OVER,onRollOverSecodnExtraBar);
			_streamSecondExtraBar.display.addEventListener(MouseEvent.ROLL_OUT,onRollOutSecondExtraBar);
		}
		
		override protected function onBIReady(data:Object):void {
			super.onBIReady(data);
			
			initStreamBar();
		}
		
		protected function onVideoStop(data:Object = null):void {
			onShowBackRecommand(null);
		}
		
		public override function showPT():void {
			if (_pt == null) {
				_pt = new StreamPT();
			}
			_ptLayer.popup(_pt, null, true);
		}
		
		public override function hidePT(data:Object = null):void {
			if (_pt) {
				_ptLayer.closePopup(_pt);
			}
		}
		/**
		 * 视频连不上,则判断是前推还是后推. 
		 */		
		protected function onVideoNotFound(data:Object):void {
			onShowForeRecommand(null);
		}
		
		protected function onVideoCanNotConnect(data:Object):void {
			
		}
		
		protected function onShowForeRecommand(data:Object):void {
			onShowRec(false);
		}
		
		protected function onShowBackRecommand(data:Object):void {
			onShowRec(true);
		}
		
		protected function onShowRec(back:Boolean = false):void {
			Context.variables["showRec"] = true;
			
			//去除多余界面
			Context.getContext(ContextEnum.UI_MANAGER).hideErrorPanel();
			Context.getContext(ContextEnum.UI_MANAGER).hidePT();
			
			showRec(back);
		}
		
		private function showRec(back:Boolean = false):void {
			if (_streamBackRec == null) {
//				if (Global.videoData["isOrg"]) {
				if ((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data["isOrg"]) {
					_streamBackRec = new StreamOrgnizeRecommand();
				} else {
					_streamBackRec = new StreamPersonalRecommand();
				}
				_streamBackRec.isBack = back;
				_streamBackRec.startReq();
			}
			if (!_backRecLayer.contains(_streamBackRec)) {
				_backRecLayer.addChild(_streamBackRec);
			}
			_streamBackRec.resize();
			_streamBackRec.visible = _backRecVisible;
		}
		
		/**
		 * 由于直播的广告形式为关闭直播的声音，因此如果广告未播放完毕之前禁止其他地方更改声音
		 */		
		override protected function onUIVolumeChange(data:Object):void {
			if (Context.getContext(ContextEnum.VIDEO_MANAGER) && Context.variables.hasOwnProperty("ADPlayComplete") && Context.variables["ADPlayComplete"]) {
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).volume = int(data);
			}
//			if (Global.videoManager && Context.variables.hasOwnProperty("ADPlayComplete") && Context.variables["ADPlayComplete"]) {
//				Global.videoManager.volume = int(data);
//			}
		}
		
		protected function onHideForeRecommand(data:Object):void {
			onHideRec();
		}
		
		protected function onHideBackRecommand(data:Object):void {
			onHideRec();
		}
		
		protected override function onUIResize(data:Object = null):void {
			super.onUIResize(data);
			var obj:Object = new Object();
			obj.width = obj.height = 0;
			if (Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth != null) {
				obj.width = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoWidth;
			}
			if (Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight != null) {
				obj.height = Context.getContext(ContextEnum.UI_MANAGER).avalibleVideoHeight;
			}
//			Debugger.log(Debugger.INFO,"[bigFrontPie]","width is " + obj.width  + " height is " + obj.height);
			JSBridge.addCall("setVideoRegion",obj);
		}
		
		private function onHideRec():void {
			Context.variables["showRec"] = false;
			if (_streamBackRec && _backRecLayer.contains(_streamBackRec)) {
				_backRecLayer.removeChild(_streamBackRec);
				_streamBackRec = null;
			}
		}
		
		override protected function onVideoFinished(data:Object=null):void {
			super.onVideoFinished(data);
			
			onShowRec(true);
		}
		
		/**
		 * 初始化最下面那条控件. 
		 */		
		protected function initStreamBar():void {
//			var bottomBar:ISkinObject = Global.skinManager.getSkin(SkinsEnum.BOTTOM_BAR);
			_streamBottomBar = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).getSkin(SkinsEnum.BOTTOM_BAR);
			var iskin:ISkinManager = Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager;
			_streamExtraBar = iskin.attachSkinByName(SkinsEnum.STREAM_EXTRA_BAR, DisplayObjectContainer(_streamBottomBar.display));
			_streamExtraBar.call("registerItem",[ExtraUIItemEnum.USER_INFO],[ExtraUIItemEnum.QUIZ, ExtraUIItemEnum.GIFT]);
			_streamSecondExtraBar = iskin.attachSkinByName(SkinsEnum.STREAM_SECOND_EXTRA_BAR, DisplayObjectContainer(_streamBottomBar.display));
		}
		
		override protected function onFullScreen(event:FullScreenEvent):void {
			var isFullscreen:Boolean = false;
			isFullscreen = event.fullScreen;
			if (isFullscreen)
			{
				updateExtraBar(_streamSecondExtraBar, event.fullScreen, 100);
				if (needShowExtraBar) {
					updateExtraBar(_streamExtraBar, event.fullScreen, 30);
				}
				if (Context.variables["type"] == PlayerType.S_ZHANNEI)
				{
					_streamBottomBar.display.addEventListener(MouseEvent.ROLL_OVER,onRollOverBottomBar);
					_streamBottomBar.display.addEventListener(MouseEvent.ROLL_OUT,onRollOutBottomBar);
					_streamExtraBar.display.addEventListener(MouseEvent.ROLL_OVER,onRollOverExtraBar);
					_streamExtraBar.display.addEventListener(MouseEvent.ROLL_OUT,onRollOutExtraBar);
					if (secondBarIsShow) {
						_streamSecondExtraBar.display.addEventListener(MouseEvent.ROLL_OVER,onRollOverSecodnExtraBar);
						_streamSecondExtraBar.display.addEventListener(MouseEvent.ROLL_OUT,onRollOutSecondExtraBar);
					}
				}
			}
			else
			{
				if (needShowExtraBar) {
					updateExtraBar(_streamExtraBar, event.fullScreen, 30);
				}
				updateExtraBar(_streamSecondExtraBar, event.fullScreen, 100);
				if (Context.variables["type"] == PlayerType.S_ZHANNEI)
				{
					_streamExtraBar.display.removeEventListener(MouseEvent.ROLL_OVER,onRollOverExtraBar);
					_streamExtraBar.display.removeEventListener(MouseEvent.ROLL_OUT,onRollOutExtraBar);
					_streamBottomBar.display.removeEventListener(MouseEvent.ROLL_OVER,onRollOverBottomBar);
					_streamBottomBar.display.removeEventListener(MouseEvent.ROLL_OUT,onRollOutBottomBar);
					if (secondBarIsShow) {
						_streamSecondExtraBar.display.removeEventListener(MouseEvent.ROLL_OVER,onRollOverSecodnExtraBar);
						_streamSecondExtraBar.display.removeEventListener(MouseEvent.ROLL_OUT,onRollOutSecondExtraBar);
					}
				}
			}

			super.onFullScreen(event);
			
			//全屏的时候要把_toolTipLayer层级设置为最高
			if (_toolTipLayer && Context.stage.contains(_toolTipLayer)) {
				Context.stage.setChildIndex(_toolTipLayer, Context.stage.numChildren - 1);
			}
		}
		
		private function onRollOverBottomBar(e:MouseEvent):void {
			_mouseOnBottomBar = true;
			mouseOnBar = true;
		}
		
		private function onRollOutBottomBar(e:MouseEvent):void {
			_mouseOnBottomBar = false;
			mouseOnBar = (_mouseOnBottomBar || _mouseOnExtraBar || (secondBarIsShow&&_mouseOnSecondExtraBar));
		}
		
		private function onRollOverExtraBar(e:MouseEvent):void {
			_mouseOnExtraBar = true; 
			mouseOnBar = true;
		}
		
		private function onRollOutExtraBar(e:MouseEvent):void {
			_mouseOnExtraBar = false;
			mouseOnBar = (_mouseOnBottomBar || _mouseOnExtraBar || (secondBarIsShow&&_mouseOnSecondExtraBar));
		}
		
		private function onRollOverSecodnExtraBar(e:MouseEvent):void {
			_mouseOnSecondExtraBar = true;
			mouseOnBar = true;
		}
		
		private function onRollOutSecondExtraBar(e:MouseEvent):void {
			_mouseOnSecondExtraBar = false;
			mouseOnBar = (_mouseOnBottomBar || _mouseOnExtraBar || (secondBarIsShow&&_mouseOnSecondExtraBar));
		}
		
		private function set mouseOnBar(value:Boolean):void {
			_streamExtraBar.display["mouseOnBar"] = value;
			_streamBottomBar.display["mouseOnBar"] = value;
			_streamSecondExtraBar.display["mouseOnBar"] = value;
		}
		
		private function get mouseOnBar():Boolean {
			return  (_mouseOnBottomBar || _mouseOnExtraBar || (secondBarIsShow&&_mouseOnSecondExtraBar));
		}
		
		private function get secondBarIsShow():Boolean {
			return Context.variables["quizShow"];
		}
		/**
		 * 是否需要显示直播播放器下面那一条. 
		 * @return 
		 */		
		private function get needShowExtraBar():Boolean {
			var ip:IPluginManager = (Context.getContext(ContextEnum.PLUGIN_MANAGER) as IPluginManager);
			return ip.hasPlugin(PluginEnum.BULLETS) || 
				ip.hasPlugin(PluginEnum.GIFT) || 
				ip.hasPlugin(PluginEnum.BULLETS_OUT) || 
				ip.hasPlugin(PluginEnum.PLAYER_OUT_GIFT);
//			return Global.pluginManager.hasPlugin(PluginEnum.BULLETS) || 
//				Global.pluginManager.hasPlugin(PluginEnum.GIFT) || 
//				Global.pluginManager.hasPlugin(PluginEnum.BULLETS_OUT) || 
//				Global.pluginManager.hasPlugin(PluginEnum.PLAYER_OUT_GIFT);
		}
		
		/**
		 * 更新streamBar的位置和布局. 
		 * @param isFullScreen
		 */		
//		private function updateStreamExtraBar(isFullScreen:Boolean):void {
//			if (_streamExtraBar == null || _streamExtraBar.display.parent == null) return;
//			
//			var iskin:ISkinManager = Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager;
//			
//			var bottomBar:ISkinObject = iskin.getSkin(SkinsEnum.BOTTOM_BAR);
//			//先移除
//			iskin.deattachSkin(_streamExtraBar);
//			//根据之前是否全屏,再次添加,在全屏效果跳转之前
//			if (isFullScreen) {
//				iskin.attachSkin(_streamExtraBar, Context.stage);
//			} else {
//				iskin.attachSkin(_streamExtraBar, DisplayObjectContainer(bottomBar.display));
//			}
//			if (isFullScreen) {
//				_streamExtraBar.display.x = (Context.stage.fullScreenWidth - _streamExtraBar.display.width) / 2;
//				_streamExtraBar.display.y = Context.stage.fullScreenHeight - _streamExtraBar.display.height - bottomBar.display.height - 30;
//			} else {
//				ISkinObjectListener(bottomBar.display).listen(SkinEvents.RESIZE, null);
//			}
//		}
		
		/**
		 * 更新streamBar的位置和布局. 
		 * @param isFullScreen
		 */	
		private function updateExtraBar(dis:ISkinObject, isFullScreen:Boolean, offset:int):void {
			if (dis == null || dis.display.parent == null) return;
			
			var iskin:ISkinManager = Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager;
			
			var bottomBar:ISkinObject = iskin.getSkin(SkinsEnum.BOTTOM_BAR);
			//先移除
			iskin.deattachSkin(dis);
			//根据之前是否全屏,再次添加,在全屏效果跳转之前
			if (isFullScreen) {
				iskin.attachSkin(dis, Context.stage);
			} else {
				iskin.attachSkin(dis, DisplayObjectContainer(bottomBar.display));
			}
			if (isFullScreen) {
				dis.display.x = (Context.stage.fullScreenWidth - dis.display.width) / 2;
				dis.display.y = Context.stage.fullScreenHeight - dis.display.height - bottomBar.display.height - offset;
			} else {
				ISkinObjectListener(bottomBar.display).listen(SkinEvents.RESIZE, null);
				//dis.display.y = 100;
			}
		}
		

	}
}