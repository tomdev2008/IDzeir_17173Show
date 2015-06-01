package com._17173.flash.player.context
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.interactive.IKeyboardManager;
	import com._17173.flash.core.interfaces.IRendable;
	import com._17173.flash.core.plugin.ExternalPluginItem;
	import com._17173.flash.core.plugin.IPluginItem;
	import com._17173.flash.core.plugin.IPluginManager;
	import com._17173.flash.core.plugin.PluginEvents;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.PluginEnum;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	/**
	 * 用于管理播放器的业务逻辑.
	 *  
	 * @author shunia-17173
	 */	
	public class BusinessManager implements IContextItem
	{
		
		/**
		 * 15s超时 
		 */		
		private static const OUT_TIME:int = 10000;
		/**
		 * 开始检测超时后,当前加载的字节数 
		 */		
		private var _prevLoadedSize:int = 0;
		private var _prevLoadedTime:int = 0;
		private var _prevLoadedLength:int = 0;
		
		protected var _renderItems:Vector.<IRendable> = null;
		protected var _isResized:Boolean = false;
		protected var _baseTime:int = 0;
		protected var _ellapsedTime:int = 0;
		protected var _isSwitching:Boolean = false;
		
		protected var _isPTDelayed:Boolean = false;
		protected var _error:PlayerErrors = null;
		protected var _videoData:IVideoData = null;
		protected var _complete:Boolean = false;
		
		protected var _e:IEventManager = null;
		
		public function BusinessManager() {
			//初始化渲染物数组
			_renderItems = new Vector.<IRendable>();
		}
		
		/**
		 * 启动播放器逻辑. 
		 */		
		protected function onBIInitComplete(data:Object):void {
			//创建videoData
//			Global.videoData = initVideoData();
//			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data = initVideoData();
			//添加事件侦听
			addListeners();
			//plugins
			Context.getContext(ContextEnum.PLUGIN_MANAGER)["initAll"]();
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_READY);
		}
		
		/**
		 * 创建videoData 
		 * @return 
		 */		
		protected function initVideoData():VideoData {
			var v:VideoData = new VideoData();
			return v;
		}
		
		/**
		 * 监听各种事件. 
		 */		
		protected function addListeners():void {
			//开启刷新
			_baseTime = getTimer();
			Context.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//监听舞台高宽变化
			Context.stage.addEventListener(Event.RESIZE, resize);
//			Core.stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullscreen);
			//业务事件
			_e.listen(PlayerEvents.VIDEO_READY, onVideoReady);
			_e.listen(PlayerEvents.VIDEO_INIT, onVideoInit);
			_e.listen(PlayerEvents.VIDEO_START, onVideoStart);
			_e.listen(PlayerEvents.VIDEO_LOADED, onReadyToPlay);
			_e.listen(PlayerEvents.VIDEO_FINISHED, onVideoFinished);
			_e.listen(PlayerEvents.BI_RELOAD_VIDEO, onReloadVideo);
			_e.listen(PlayerEvents.BI_VIDEO_PLAY_OUT_TIME, onVideoPlayOutTime);
			_e.listen(PlayerEvents.BI_SWITCH_STREAM, onSwitchStream);
			_e.listen(PlayerEvents.BI_READY, onBIReady);
			//侦听Error
			_e.listen(PlayerEvents.ON_PLAYER_ERROR, showError);
			//模块事件
			_e.listen(PluginEvents.ALL_COMPLETE, onPluginComplete);
			_e.listen(PlayerEvents.BI_AD_COMPLETE, adComplete);
		}
		
		protected function onBIReady(data:Object):void {
			//显示品推
			showPT();
			//加载ui配置
			initUI();
			//初始化视频核心
			initVideoManager();
			//为ui逻辑增加更新
//			addRenderItem(Global.uiManager);
			addRenderItem(Context.getContext(ContextEnum.UI_MANAGER));
			//启动内部逻辑
			startUpInternal();
			initKeyBord();
			//强制reszie
			resize();
		}
		
		/**
		 * 加载ui配置
		 */		
		protected function initUI():void {
			(Context.getContext(ContextEnum.EVENT_MANAGER) as EventManager).send(PlayerEvents.UI_INTED);
		}
		
		/**
		 * 初始化播放器核心 
		 */		
		protected function initVideoManager():void {
//			var p:IPluginItem = Global.pluginManager.getPlugin(playerCoreName);
			var p:IPluginItem = (Context.getContext(ContextEnum.PLUGIN_MANAGER) as IPluginManager).getPlugin(playerCoreName);
			p.addEventListener(PluginEvents.COMPLETE, onPlayerCoreLoaded);
		}
		
		/**
		 * 播放器核心加载成功.
		 *  
		 * @param e
		 */		
		private function onPlayerCoreLoaded(e:Event):void {
			Debugger.log(Debugger.INFO, "[business]", "播放器核心文件加载成功!");
			var p:ExternalPluginItem = e.target as ExternalPluginItem;
			p.removeEventListener(PluginEvents.COMPLETE, onPlayerCoreLoaded);
			var playerCore:Object = p.warpper is Loader ? Loader(p.warpper).content : p.warpper;
			if (playerCore.hasOwnProperty("videoManager") && playerCore["videoManager"]) {
//				Global.videoManager = playerCore["videoManager"];
//				Context.injectContext(ContextEnum.VIDEO_MANAGER, Global.videoManager);
				Context.injectContext(ContextEnum.VIDEO_MANAGER, playerCore["videoManager"]);
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data = initVideoData();
				//为视频逻辑增加更新
//				addRenderItem(Global.videoManager);
				addRenderItem(Context.getContext(ContextEnum.VIDEO_MANAGER));
				//初始化视频
				initVideoDispatch();
			}
			else {
				Debugger.log(Debugger.INFO, "[business]", "播放器核心无内容!");
			}
		}
		
		protected function get playerCoreName():String {
			return PluginEnum.PLAYER_CORE_FILE;
		}
		
		protected function onReloadVideo():void {
			Debugger.log(Debugger.INFO, "[business]", "重新加载视频!");
			
			initVideoDispatch();
		}
		
		protected function showPT():void {
//			Global.uiManager.showPT();
			Context.getContext(ContextEnum.UI_MANAGER).showPT();
			Ticker.tick(1000, onPTDelayed);
		}
		
		protected function onPTDelayed():void {
			_isPTDelayed = true;
			initComplete();
		}
		
		private function onPluginComplete(data:Object = null):void {
			Debugger.log(Debugger.INFO, "[business]", "通知js准备结束!");
			_e.remove(PluginEvents.ALL_COMPLETE, onPluginComplete);
			//通知js初始化完毕
//			Global.jsDelegate.send("ready");
			_(ContextEnum.JS_DELEGATE).send("ready");
			//BI初始化完毕,通知
			_e.send(PlayerEvents.BI_COMPLETE);
		}
		
		protected function onVideoReady(data:Object):void {
		}
		
		/**
		 * 启动视频调度 
		 */		
		protected function initVideoDispatch():void {
			Debugger.log(Debugger.INFO, "[business]", "启动调度!");
			// 强制关闭当前视频先
			_(ContextEnum.VIDEO_MANAGER).stop();
			
			Context.getContext(ContextEnum.DATA_RETRIVER).startDispatch(
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data ? (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data["cid"] : Context.variables["cid"], 
				onVideoDataRetrived, onVideoDataFail);
//			Global.dataRetriver.startDispatch(
//				Global.videoData ? Global.videoData["cid"] : Context.variables["cid"], 
//				onVideoDataRetrived, onVideoDataFail);
		}
		
		/**
		 * 视频调度失败 
		 */		
		protected function onVideoDataFail(error:PlayerErrors):void {
			Debugger.log(Debugger.INFO, "[business]", "调度获取失败!");
			_error = error;
			
			initComplete();
		}
		
		/**
		 * 视频调度已经获取 
		 * @param video
		 */		
		protected function onVideoDataRetrived(video:IVideoData):void {
			Debugger.log(Debugger.INFO, "[business]", "调度已获取!");
			_e.send(PlayerEvents.BI_GET_VIDEO_INFO, video);
			_videoData = video;
			initComplete();
		}
		
		/**
		 * 从业务层面上,初始化动作已经结束
		 * 当所有初始化动作完成之后调用这个方法 
		 */		
		protected function initComplete():void {
			if (isCompleted) {
				_complete = true;
				Debugger.log(Debugger.INFO, "[business]", "业务处理完成!");
				
				//有错就显示错误,没错就开始预加载视频
				if (_error) {
					Debugger.log(Debugger.INFO, "[business]", "必要信息中有错误数据，进行出错处理!");
					//显示错误
					showError(_error);
				} else if (_videoData) {
					Debugger.log(Debugger.INFO, "[business]", "开始视频播放!");
					//初始化播放器
//					Global.videoManager.init(_videoData);
					(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).init(_videoData);
					_e.send(PlayerEvents.BI_PLAYER_INITED);
				}
				_error = null;
				_videoData = null;
			}
		}
		
		/**
		 * 是否已经可以完成并进行初始化了
		 *  
		 * @return 
		 */		
		protected function get isCompleted():Boolean {
			return _isPTDelayed && (_error || _videoData);
		}
		
		/**
		 * 将renderItem放入帧循环中进行update. 
		 * @param renderItem
		 */		
		public function addRenderItem(renderItem:IRendable):void {
			if (_renderItems.indexOf(renderItem) != -1) return;
			
			_renderItems.push(renderItem);
		}
		
		/**
		 * 将renderItem从帧循环中移除.不再update. 
		 * @param renderItem
		 */	
		public function removeRenderItem(renderItem:IRendable):void {
			if (_renderItems.indexOf(renderItem) == -1) return;
			
			_renderItems.splice(_renderItems.indexOf(renderItem), 1);
		}
		
		/**
		 * 在不刷新页面的情况下切换流/视频. 
		 * @param 点播播放器传cid;直播播放器传roomId
		 */		
		protected function onSwitchStream(data:Object):void {
			_isSwitching = true;
			_complete = false;
			_videoData = null;
			_error = null;
//			Global.uiManager.cleanPopUp();
			Context.getContext(ContextEnum.UI_MANAGER).cleanPopUp();
			showPT();
//			Global.videoManager.stop();
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).stop();
			//切换时如果传cid 说明是点播播放器
			//切换时如果传roomId 说明是直播播放器
			_e.send(PlayerEvents.BI_PLAYER_SWITCH_STREAM);
			_e.send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
			_e.send(PlayerEvents.UI_HIDE_FORE_RECOMMAND);
			initVideoDispatch();
		}
		
		protected function onVideoPlayOutTime(data:Object = null):void {
			Debugger.log(Debugger.WARNING, "[business]", "视频加载超时!");
			
			_e.send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
			_e.send(PlayerEvents.UI_HIDE_FORE_RECOMMAND);
			Context.getContext(ContextEnum.UI_MANAGER).hideErrorPanel();
		}
		
		protected function onVideoInit(data:Object):void {
			Ticker.stop(onOutTime);
			//如果不是stageVideo,则把视频显示对象增加到显示区域中
		}
		
		/**
		 * 通知js播放已开始. 
		 */		
		protected function onVideoStart(data:Object = null):void {
//			Global.jsDelegate.play();
			_(ContextEnum.JS_DELEGATE).send("play");
		}
		
		/**
		 * 启动其他内容.
		 * 需要时可以覆写. 
		 */		
		protected function startUpInternal():void {
//			Global.uiManager.toggleEnabled(true);
			Context.getContext(ContextEnum.UI_MANAGER).toggleEnabled(true);
		}
		
		/**
		 * 注册键盘快捷键
		 */		
		protected function initKeyBord():void {
			var k:IKeyboardManager = Context.getContext(ContextEnum.KEYBOARD) as IKeyboardManager;
			k.registerKeymap( function ():void{ keyHandler(Keyboard.SPACE); }, Keyboard.SPACE);
			k.registerKeymap( function ():void{ keyHandler(Keyboard.UP); }, Keyboard.UP);
			k.registerKeymap( function ():void{ keyHandler(Keyboard.DOWN); }, Keyboard.DOWN);
			k.registerKeymap( function ():void{ keyHandler(Keyboard.LEFT); }, Keyboard.LEFT);
			k.registerKeymap( function ():void{ keyHandler(Keyboard.RIGHT); }, Keyboard.RIGHT);
		}
		/**
		 * 键盘事件的处理方法
		 */		
		protected function keyHandler(value:uint):void {
		}
		
		/**
		 * 监听帧刷新. 
		 * @param e
		 */		
		protected function onEnterFrame(e:Event):void {
			var t:int = getTimer();
			_ellapsedTime = t - _baseTime;
			_baseTime = t;
			
			if (_renderItems && _renderItems.length) {
				for each (var item:IRendable in _renderItems) {
					if (item.needUpdate) {
						item.update(_ellapsedTime);
					}
				}
			}
		}
		
		/**
		 * 视频播放结束. 
		 * @param data
		 */		
		protected function onVideoFinished(data:Object = null):void {
			_e.send(PlayerEvents.UI_SHOW_BACK_RECOMMAND);
		}
		
		/**
		 * 视频加载成功.对播放器做初始化工作.
		 *  
		 * @param data
		 */		
		protected function onReadyToPlay(data:Object = null):void {
			//初始化音量
//			Global.videoManager.volume = Global.settings.volume;
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).volume = Context.getContext(ContextEnum.SETTING).volume;

			//超时
//			_prevLoadedSize = Global.videoData.loadedBytes;
			_prevLoadedSize = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.loadedBytes;
			_prevLoadedTime = getTimer();
			Ticker.tick(300, onOutTime, 0);
		}
		
		/**
		 * 超时 
		 */		
		private function onOutTime():void {
			var v:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager;
			if (!v || !v.isPlaying) return;
			
			if (v.data.loadedBytes != _prevLoadedSize || v.data.loadedTime != _prevLoadedLength) {
				_prevLoadedSize = v.data.loadedBytes;
				_prevLoadedLength = v.data.loadedTime;
				_prevLoadedTime = getTimer();
			} else {
				if (getTimer() - _prevLoadedTime >= OUT_TIME) {
					_e.send(PlayerEvents.BI_VIDEO_PLAY_OUT_TIME);
					Ticker.stop(onOutTime);
				}
			}
		}
		
		/**
		 * 提示出错信息. 
		 * @param msg
		 */		
		protected function showError(info:PlayerErrors):void {
			//默认trace出来
			Debugger.log(Debugger.ERROR, "[business]", "出错,code: ", info.id, ",message: ", info.msg, ",error: ", info.error);
			
			onError(info);
			
			if (info.needErrorPanel) {
				Context.getContext(ContextEnum.UI_MANAGER).hidePT();
				Context.getContext(ContextEnum.UI_MANAGER).showErrorPanel(info);
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).stop();
//				Global.uiManager.hidePT();
//				Global.uiManager.showErrorPanel(info);
//				Global.videoManager.stop();
			}
		}
		
		/**
		 * 具体的解析出错信息
		 *  
		 * @param error
		 */		
		protected function onError(error:PlayerErrors):void {
		}
		
		/**
		 * 舞台大小改变事件监听函数.
		 *  
		 * @param e
		 */		
		public function resize(e:Event = null):void {
			_isResized = true;
			
			resizeDispatch();
		}
		
		private function delayResizeDispatch():void {
			if (_isResized) {
				Ticker.stop(resizeDispatch);
			}
			Ticker.tick(100, resizeDispatch, 1);
		}
		
		private function resizeDispatch():void {
			_isResized = false;
			
			_e.send(PlayerEvents.UI_RESIZE);
		}
		
		
		public function get contextName():String {
			return ContextEnum.BUSINESS_MANAGER;
		}
		
		public function startUp(param:Object):void {
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as EventManager;
			_e.listen(PlayerEvents.BI_INIT_COMPLETE, onBIInitComplete);
		}
		
		public function get error():PlayerErrors {
			return _error;
		}
		
		/**
		 * 所有视频播放之前的业务都完毕,可以开始视频正式播放
		 * 目前为前贴广告结束
		 */		
		protected function adComplete(data:Object):void {
			_e.send(PlayerEvents.BI_VIDEO_CAN_START);
		}
		
	}
}