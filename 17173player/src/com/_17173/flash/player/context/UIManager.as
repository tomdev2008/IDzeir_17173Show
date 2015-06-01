package com._17173.flash.player.context
{
	import com._17173.flash.core.components.layer.ToolTipLayer;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.interfaces.IRendable;
	import com._17173.flash.core.plugin.IPluginManager;
	import com._17173.flash.core.skin.ISkinManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.RedirectData;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.model.SkinEvents;
	import com._17173.flash.player.module.PluginEnum;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	import com._17173.flash.player.ui.BasePT;
	import com._17173.flash.player.ui.ComponentLayer;
	import com._17173.flash.player.ui.PopupLayer;
	import com._17173.flash.player.ui.RecommendLayer;
	import com._17173.flash.player.ui.VideoLayer;
	import com._17173.flash.player.ui.comps.ErrorCompoment;
	import com._17173.flash.player.ui.comps.PT;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.tip.IToolTipManager;
	import com._17173.flash.player.ui.tip.PlayerToolTip;
	import com._17173.flash.player.ui.tip.Tooltip;
	import com._17173.flash.player.ui.tip.TooltipData;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * UI管理类,作为中间层,代理视图控件和逻辑层之间的交互.
	 *  
	 * @author shunia-17173
	 */	
	public class UIManager extends Sprite implements IRendable, IContextItem, IToolTipManager
	{
		
		public static const UI_IN_OUT_TIME:int = 3000;
		public static const TOOLTIP_DIS_TIME:int = 5000;
		/**
		 *扩展层级名  
		 */		
		private static const PT_DELAY:int = 1000;
		
		protected var _layers:Dictionary = null;
		
		protected var _videoLayer:VideoLayer = null;
		protected var _componentLayer:ComponentLayer = null;
		/**
		 *组件层上 视频之下的层级 
		 */
		protected var _adLayer:PopupLayer = null;
		protected var _componenBeferLayer:Sprite = null;
		protected var _popupLayer:PopupLayer = null;
		protected var _backRecLayer:RecommendLayer = null;
		/**
		 * 品推层
		 */		
		protected var _ptLayer:PopupLayer = null;
		/**
		 *tooltip层级 
		 */		
		protected var _toolTipLayer:ToolTipLayer = null;
		
		protected var _tooltip:Tooltip = null;
		private var _errorComp:ErrorCompoment = null;
		protected var _pt:BasePT = null;
		
		public function UIManager()
		{
			super();
			
//			toggleEnabled(false);
		}
		
		public function startUp(param:Object):void {
			_layers = new Dictionary();
			
			addListeners();
		}
		
		public function showPT():void {
			if (_pt == null) {
				_pt = new PT();
			}
			_ptLayer.popup(_pt, null, true);
		}
		
		public function hidePT(data:Object = null):void {
			if (_pt) {
				_ptLayer.closePopup(_pt);
//				_pt = null;
			}
		}
		
		public function toggleEnabled(enabled:Boolean = true):void {
			if (enabled) {
				_componentLayer.mouseUse = true;
				_videoLayer.mouseEnabled = true;
				_videoLayer.mouseChildren = true;
				//全局事件
				Context.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseRollOver);
				Context.stage.addEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
				Context.stage.addEventListener(Event.MOUSE_LEAVE, onMouseRollOut);
			} else {
				_componentLayer.mouseUse = false;
				_videoLayer.mouseEnabled = false;
				_videoLayer.mouseChildren = false;
				//全局事件
				Context.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseRollOver);
				Context.stage.removeEventListener(MouseEvent.ROLL_OVER, onMouseRollOver);
				Context.stage.removeEventListener(Event.MOUSE_LEAVE, onMouseRollOut);
			}
		}
		
		protected function addListeners():void {
			//全局事件
			Context.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreen);
			
			var eventManager:EventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as EventManager;
			//UI操作触发的消息
			eventManager.listen(PlayerEvents.UI_PLAY_OR_PAUSE, onUIVideoPlayAndPause);
			eventManager.listen(PlayerEvents.UI_VOLUME_CHANGE, onUIVolumeChange);
			eventManager.listen(PlayerEvents.UI_VOLUME_MUTE, onVolumeMute);
			eventManager.listen(PlayerEvents.UI_TOGGLE_FULL_SCREEN, onToggleFullscreen);
			eventManager.listen(PlayerEvents.UI_HIDE_PT, hidePT);
			eventManager.listen(PlayerEvents.UI_RESIZE, onUIResize);
			//播放器状态变化触发的消息
			eventManager.listen(PlayerEvents.VIDEO_INIT, onVideoInit);
			eventManager.listen(PlayerEvents.VIDEO_LOADED, onVideoLoaded);
			eventManager.listen(PlayerEvents.VIDEO_START, onVideoStart);
			eventManager.listen(PlayerEvents.VIDEO_FINISHED, onVideoFinished);
			//全局BI事件
			eventManager.listen(PlayerEvents.BI_INIT_COMPLETE, onBiComplete);
			eventManager.listen(PlayerEvents.BI_READY, onBIReady);
		}
		
		private function onBiComplete(data:Object):void {
			initComponents();
		}
		
		protected function onBIReady(data:Object):void {
		}
		
		protected function initComponents():void {
			_videoLayer = new VideoLayer();
			_videoLayer.name = "video";
			_videoLayer.mouseEnabled = false;
			_layers[_videoLayer.name] = _videoLayer;
			Context.stage.addChild(_videoLayer);
			
			_backRecLayer = new RecommendLayer();
			_backRecLayer.name = "backRec";
			_layers[_backRecLayer.name] = _backRecLayer;
			Context.stage.addChild(_backRecLayer);
			
			//扩展层
			_componenBeferLayer = new Sprite();
			_componenBeferLayer.name = "componenbefer";
			_layers[_componenBeferLayer.name] = _componenBeferLayer;
			_componenBeferLayer.mouseChildren = false;
			_componenBeferLayer.mouseEnabled = false;
			Context.stage.addChild(_componenBeferLayer);
			
			_ptLayer = new PopupLayer();
			_ptLayer.name = "ptpopup";
			_layers[_ptLayer.name] = _ptLayer;
			Context.stage.addChild(_ptLayer);
			
			_adLayer = new PopupLayer();
			_adLayer.name = "adpopup";
			_layers[_adLayer.name] = _adLayer;
			Context.stage.addChild(_adLayer);
			
			_componentLayer = new ComponentLayer();
			_componentLayer.name = "component";
			_layers[_componentLayer.name] = _componentLayer;
			_componentLayer.mouseEnabled = false;
			Context.stage.addChild(_componentLayer);
			

			_popupLayer = new PopupLayer();
			_popupLayer.name = "popup";
			_layers[_popupLayer.name] = _popupLayer;
			Context.stage.addChild(_popupLayer);
			
			_toolTipLayer = new ToolTipLayer(Context.stage);
			_toolTipLayer.name = "tooltip";
			_layers[_toolTipLayer.name] = _toolTipLayer;
			initToolTip();
			Context.stage.addChild(_toolTipLayer);
		}
		
		protected function onFullScreen(event:FullScreenEvent):void {
			if (event.fullScreen == false) {
				Context.stage.removeEventListener(MouseEvent.CLICK, onStageClicked, true);
			}
			
			Context.getContext(ContextEnum.SETTING).isFullScreen = event.fullScreen;
			Context.getContext(ContextEnum.BUSINESS_MANAGER).resize();
//			Global.settings.isFullScreen = event.fullScreen;
//			Global.businessManager.resize();
			
			//退出全屏，回复原始播放比例
//			if (Context.stage.displayState == StageDisplayState.NORMAL) {
//				Global.settings.videoScale = Settings.VIDEO_SCALES[Settings.VIDEO_SIZE_100];
////				_componentLayer.refresh();
//				
//				Global.eventManager.send(PlayerEvents.UI_VIDEO_RESIZE);
//			}
		}
		
		protected function onVideoFinished(data:Object = null):void {
//			_componentLayer.hideLoading();
//			_componentLayer.refresh();
		}
		
		protected function onMouseRollOut(event:Event):void {
//			Global.eventManager.send(PlayerEvents.SKIN_EVENT, {"event":SkinEvents.HIDE_FLOW});
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.SKIN_EVENT, {"event":SkinEvents.HIDE_FLOW});
		}
		
		protected function onMouseRollOver(event:MouseEvent):void {
			Ticker.stop(onUIAnimTimerComplete);
			Ticker.tick(UI_IN_OUT_TIME, onUIAnimTimerComplete, 1);
			
//			Global.eventManager.send(PlayerEvents.SKIN_EVENT, {"event":SkinEvents.SHOW_FLOW});
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.SKIN_EVENT, {"event":SkinEvents.SHOW_FLOW});
		}
		
		protected function onUIAnimTimerComplete():void {
//			Global.eventManager.send(PlayerEvents.SKIN_EVENT, {"event":SkinEvents.HIDE_FLOW});
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.SKIN_EVENT, {"event":SkinEvents.HIDE_FLOW});
		}
		
		protected function onUIVideoPlayAndPause(data:Object):void {
//			Global.videoManager.togglePlay(data);
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).togglePlay(data);
		}
		
		protected function onUIVolumeChange(data:Object):void {
			if (Context.getContext(ContextEnum.VIDEO_MANAGER)) {
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).volume = int(data);
			}
//			if (Global.videoManager) {
//				Global.videoManager.volume = int(data);
//			}
		}
		
		private function onVolumeMute(data:Object):void {
			if (Context.getContext(ContextEnum.VIDEO_MANAGER)) {
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).volume = int(data);
			}
//			if (Global.videoManager) {
//				Global.videoManager.volume = int(data);
//			}
		}
		
		protected function onVideoStart(data:Object):void {
			_backRecLayer.clear();
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
//			Global.eventManager.send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
		}
		
		/**
		 * 视频的metadata已到 
		 * @param data
		 */		
		private function onVideoInit(data:Object):void {
			//如果播放前帖，前帖中的设置videoLayer的鼠标不可用会先执行，因此，init之后就相当于失效，播放按钮可点击，这里多加一个判断
			if(!_componentLayer.mouseEnabled && !_componentLayer.mouseChildren)
			{
				_videoLayer.mouseEnabled = false;
				_videoLayer.mouseChildren = false;
			}
			if (!_pt) {
//				_componentLayer.showLoading();
			}
//			_componentLayer.refresh();
		}
		
		/**
		 * 视频成功加载,调整UI界面. 
		 * @param data
		 */		
		private function onVideoLoaded(data:Object):void {
//			_componentLayer.refresh();
		}
		
		/**
		 * 变换全屏和非全屏. 
		 */		
		protected function onToggleFullscreen(data:Object = null):void {
			//弹出是否允许全屏交互时,不管点击按钮与否,都会触发底层事件,所以在这里强行捕获点击事件并停掉
			//在停掉之前可能会没有正确的移除捕获的事件,所以强制先移除掉
			Context.stage.removeEventListener(MouseEvent.CLICK, onStageClicked, true);
			
			//记录当前全屏状态用以比对
			var currentState:String = Context.stage.displayState;
			var toState:String = null;
			
			//统计
			onStatistic(!Context.variables["backFullscreen"]);
			//根据当前变量中是否为真全屏作为基础判断
			if (Context.variables["backFullscreen"]) {
				//如果当前功能为假全屏,则进入假全屏逻辑
				toState = toNormalscreen();
				backFullScreen();
			} else {
				//真全屏逻辑
				//如果当前是非全屏状态,则进入全屏逻辑,否则进入非全屏逻辑
				if (currentState == StageDisplayState.NORMAL) {
					toState = toFullscreen();
				} else {
					toState = toNormalscreen(); 
				}
			}
			
			//切换全屏状态
			if (toState != currentState) {
				changeDisplayState(toState);
			}
		}
		
		protected function onStatistic(isTrueFullscreen:Boolean):void {
			if (isTrueFullscreen) {
				if ((Context.getContext(ContextEnum.SETTING)).isFullScreen == false) {
					IStat(Context.getContext(ContextEnum.STAT)).stat(
						StatTypeEnum.QM, StatTypeEnum.EVENT_CLICK, {"action":RedirectDataAction.ACTION_CLICK_FULL, "type":RedirectDataAction.CLICK_TYPE_NORMAL});
					IStat(Context.getContext(ContextEnum.STAT)).stat(
						StatTypeEnum.BI, StatTypeEnum.EVENT_REDIRECT, {"action":RedirectDataAction.ACTION_CLICK_FULL, "click_type":RedirectDataAction.CLICK_TYPE_NORMAL});
				}
			} else {
				//假回链统计
				var url:String = Context.variables["url"];
//				var videoData:IVideoData = (Context.getContext(ContextEnum.VIDEO_MANAGER) as VideoManager).data;
				var videoData:IVideoData = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data;
				if (videoData && videoData.playedTime && !Context.variables["lv"]) {
					url += "?t=" + videoData.playedTime;
				}
				var redirectData:RedirectData = new RedirectData();
				redirectData.click_type = RedirectDataAction.CLICK_TYPE_REDIRECTION;//"1";
				redirectData.action = RedirectDataAction.ACTION_BACK_FAKE_FULL;
				redirectData.url = url;
				redirectData.send();
			}
		}
		
		/**
		 * 切换到全屏状态
		 *  
		 * @return 
		 */		
		protected function toFullscreen():String {
			if (Util.allowFullscreen(Context.stage)) {
				var p:IPluginManager = Context.getContext(ContextEnum.PLUGIN_MANAGER) as IPluginManager;
				//是否有需要输入文字的模块
				var businessFullscreenInteractive:Boolean = 
					p.hasPlugin(PluginEnum.BULLETS) || p.hasPlugin(PluginEnum.BULLETS_OUT);
				//需要输入并且允许全屏交互才进入全屏交互状态
				if (businessFullscreenInteractive && Util.allowFullscreenInteractive) {
					return StageDisplayState.FULL_SCREEN_INTERACTIVE;
				} else {
					return StageDisplayState.FULL_SCREEN;
				}
			} else {
				return StageDisplayState.NORMAL;
			}
		}
		
		/**
		 * 切换到非全屏状态
		 *  
		 * @return 
		 */		
		protected function toNormalscreen():String {
			return StageDisplayState.NORMAL;
		}
		
		/**
		 * 切换全屏之前需要先改变全屏变量，否则会先执行resize再接受到全屏状态改变
		 */		
		protected function changeDisplayState(toState:String):void {
			//更新数据状态
//			Global.settings.isFullScreen = toState == StageDisplayState.NORMAL ? false : true;
			Context.getContext(ContextEnum.SETTING).isFullScreen = toState == StageDisplayState.NORMAL ? false : true;
			
			//硬件缩放不一定所有的版本都支持,加一个try..catch
			try {
				if (toState != StageDisplayState.NORMAL && Context.stage.hasOwnProperty("fullScreenSourceRect")) {
					//硬件缩放,从api上来看可能会比不加这一句快
					Context.stage.fullScreenSourceRect = 
						new Rectangle(0, 0, Context.stage.fullScreenWidth, Context.stage.fullScreenHeight);
				}
				
				//侦听全局点击事件,以防止用户在确认交互模式时点击舞台导致触发其他事件
				if (toState == StageDisplayState.FULL_SCREEN_INTERACTIVE) {
					Context.stage.addEventListener(MouseEvent.CLICK, onStageClicked, true);
				}
				
				//切换
				Context.stage.displayState = toState;
			} catch (e:Error) {
				//更新数据状态
//				Global.settings.isFullScreen = Context.stage.displayState == StageDisplayState.NORMAL ? false : true;
				Context.getContext(ContextEnum.SETTING).isFullScreen = Context.stage.displayState == StageDisplayState.NORMAL ? false : true;
			};
		}
		
		/**
		 * 回链全屏
		 */		
		protected function backFullScreen():void {
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).togglePlay(false);
			if (Context.variables["showBackRec"]) {
				
			} else {
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SHOW_BIG_PALY_BTN);
			}
//			Global.videoManager.togglePlay(false);
//			if (Global.settings.params["showBackRec"]) {
//				
//			} else {
//				Global.eventManager.send(PlayerEvents.UI_SHOW_BIG_PALY_BTN);
//			}
		}
		
		private function updateFp(content:String):void {
			showTooltipArr([content, "|", "最新版本"], function ():void {
				Util.toUrl("http://get.adobe.com/cn/flashplayer/");
			});
		}
		
		/**
		 * 在全屏可交互时强制取消底层的事件监听
		 *  
		 * @param e
		 */		
		private function onStageClicked(e:Event):void {
			e.stopImmediatePropagation();
			e.stopPropagation();
			e.preventDefault();
			Context.stage.removeEventListener(MouseEvent.CLICK, onStageClicked, true);
		}
		
		/**
		 * 每帧更新 
		 * @param time
		 */		
		public function update(time:int):void {
			
		}
		
		/**
		 * 对UI界面进行重新布局. 
		 */		
		protected function onUIResize(data:Object = null):void {
//			Global.eventManager.send(PlayerEvents.SKIN_EVENT, {"event":SkinEvents.RESIZE});
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.SKIN_EVENT, {"event":SkinEvents.RESIZE});
		}
		
		/**
		 * 显示tooltip.10秒后自动消失,或点击关闭按钮进行关闭. 
		 * @param data TooltipData.fromContent
		 */		
		public function showTooltip(data:TooltipData):void {
			if (data) {
				if (_tooltip == null) {
					_tooltip = new Tooltip();
					_tooltip.addEventListener("close", function (e:Event):void {
						hideTooltip();
					});
				}
				_tooltip.data = data;
				onShowTooltip();
			}
		}
		
		/**
		 * 通过数组解析tooltip数据 
		 * @param data
		 * @param callback
		 */		
		public function showTooltipArr(data:Array, callback:Function = null):void {
			if (data) {
				showTooltip(
					TooltipData.fromContent(
						data[0], 
						data.length > 1 ? data[1] : null, 
						data.length > 2 ? data[2] : null, 
						callback));
			}
		}
		
		/**
		 * 显示tooltip 
		 */		
		protected function onShowTooltip():void {
			Context.stage.addChild(_tooltip);
			Ticker.stop(hideTooltip);
			Ticker.tick(TOOLTIP_DIS_TIME, hideTooltip);
		}
		
		/**
		 * 隐藏tooltip
		 *  
		 * @param o
		 */		
		public function hideTooltip():void {
			Ticker.stop(hideTooltip);
			if(_tooltip && _tooltip.parent) {
				_tooltip.parent.removeChild(_tooltip);
			}
		}
		
		/**
		 * 弹出一个显示对象.在所有层级之上. 
		 * @param window
		 */		
		public function popup(window:DisplayObject, point:Point = null, anim:Boolean = true):void {
			_popupLayer.popup(window, point, anim);
		}
		
		/**
		 * 关闭一个弹出对象. 
		 * @param value
		 * 
		 */		
		public function closePopup(window:DisplayObject):void {
			_popupLayer.closePopup(window);
		}
		
		/**
		 * 通过名字获取视图层.
		 *  
		 * @param layerName
		 * @return 
		 * 
		 */		
		public function getLayer(layerName:String):Sprite {
			return _layers[layerName];
		}
		
		public function get needUpdate():Boolean {
			return true;
		}
		
		/**
		 * 可以供video用的高宽. 
		 * @return 
		 */		
		public function get avalibleVideoWidth():Number {
			return Context.stage.stageWidth;
		}
		
		/**
		 * 可以供video用的高宽. 
		 * @return 
		 */		
		public function get avalibleVideoHeight():Number {
			var h:Number = Context.stage.stageHeight;
//			if (!Global.settings.isFullScreen) {
//				var bottomBar:ISkinObject = Global.skinManager.getSkin(SkinsEnum.BOTTOM_BAR);
			if (!Context.getContext(ContextEnum.SETTING).isFullScreen) {
				var bottomBar:ISkinObject = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).getSkin(SkinsEnum.BOTTOM_BAR);
				h -= bottomBar.display.height;
			}
			return h;
		}
		
		/**
		 * 展现出错面板. 
		 * @param info
		 */		
		public function showErrorPanel(error:PlayerErrors):void {
//			_componentLayer.hideLoading();
			
			if(!_errorComp)
			{
				_errorComp = new ErrorCompoment();
			}
			_errorComp.showError(error);
			popup(_errorComp);
		}
		
		public function hideErrorPanel():void {
			if (_errorComp) {
				closePopup(_errorComp);
			}
		}
		
		public function get bottomBarHeight():Number
		{
//			var bottomBar:ISkinObject = Global.skinManager.getSkin(SkinsEnum.BOTTOM_BAR);
			var bottomBar:ISkinObject = (Context.getContext(ContextEnum.SKIN_MANAGER) as ISkinManager).getSkin(SkinsEnum.BOTTOM_BAR);
			return bottomBar.display.height;
		}
		
		public function cleanPopUp():void
		{
			_popupLayer.cleanPopUp();
			_adLayer.cleanPopUp();
		}
		
		public function get contextName():String {
			// TODO Auto Generated method stub
			return ContextEnum.UI_MANAGER;
		}
		/**
		 *初始化tooltip样式 全局只能初始化一次
		 * 
		 */		
		public function initToolTip():void{
			_toolTipLayer.setTipPanel(new PlayerToolTip());
		}
		
		/**
		 *注册普通ToolTip
		 * @param dsObj 注册的显示对象
		 * @param htmlText 需要提示的信息
		 * 
		 */		
		public function registerTip(dsObj:DisplayObject,htmlText:String):void{
			_toolTipLayer.registerTip(dsObj,htmlText)
		}
		/**
		 *注册高级ToolTip 
		 * @param dsObj 注册的显示对象
		 * @param showDsObj 高级提示
		 * 
		 */		
		public function registerTip1(dsObj:DisplayObject,showDsObj:DisplayObject):void{
			_toolTipLayer.registerTip1(dsObj,showDsObj);
		}
		/**
		 *注销ToolTip （注销时，如正在显示注销对象的Tooltip则会一起移除）
		 * @param dsObj 需要注销的显示对象
		 * 
		 */	
		public function destroyTip(dsObj:DisplayObject):void{
			_toolTipLayer.destroyTip(dsObj);
		}
		
	}
}