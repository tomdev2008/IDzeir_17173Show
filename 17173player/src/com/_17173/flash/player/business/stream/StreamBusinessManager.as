package com._17173.flash.player.business.stream
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.plugin.IPluginItem;
	import com._17173.flash.core.plugin.PluginEvents;
	import com._17173.flash.core.plugin.PluginManager;
	import com._17173.flash.core.skin.ISkinObject;
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.core.video.interfaces.IVideoSource;
	import com._17173.flash.player.context.BusinessManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.VideoData;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.module.PluginEnum;
	import com._17173.flash.player.module.quiz.QuizEvents;
	import com._17173.flash.player.module.quiz.data.QuizUserData;
	import com._17173.flash.player.module.quiz.ui.QuizStartButton;
	import com._17173.flash.player.module.quiz.ui.QuizStartQuizPanel;
	import com._17173.flash.player.module.quiz.ui.QuizTipPanel;
	import com._17173.flash.player.module.quiz.ui.QuizTipWithBtnPanel;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	import com._17173.flash.player.ui.comps.SkinsEnum;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	
	import flash.display.DisplayObject;
	import flash.ui.Keyboard;
	
	public class StreamBusinessManager extends BusinessManager
	{
		
		private var _streamInfoGot:Boolean = false;
		
		private var _bufferFull:Boolean = false;
		
		/**
		 *请求失败次数
		 */
		private var _infoErrorCount:int = 0;
		
		//竞猜按钮
		private var _quizBuuton:QuizStartButton;
		//开启竞猜界面
		private var _openQuizPanel:QuizStartQuizPanel;
		//竞猜用户数据
		private var _quizUser:QuizUserData;
		//竞猜用户提示页面
		private var _quizTipPanel:QuizTipPanel;
		//普通主播引导签约界面
		private var _quizSignPanel:QuizTipWithBtnPanel;
		//竞猜组件
		private var _quizPanel:DisplayObject;
		//竞猜请求flag
		private var _quizLoading:Boolean;
		
		private var _quizHasSendClose:Boolean;
		
		private var _quizHasSendOpen:Boolean;
		
		private var _gameCode:String = "";
		
		public function StreamBusinessManager()
		{
			super();
		}
		
		override protected function get playerCoreName():String
		{
			return PluginEnum.PLAYER_CORE_STREAM;
		}
		
		override public function startUp(param:Object):void
		{
			super.startUp(param);
			
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			Context.variables["roomID"] = Context.variables["liveRoomId"];
		}
		
		override protected function addListeners():void
		{
			super.addListeners();
			
			_e.listen(PlayerEvents.VIDEO_START, onVideoStart);
			_e.listen(PlayerEvents.VIDEO_BUFFER_FULL, onVideoBufferFull);
			_e.listen(PlayerEvents.BI_AD_COMPLETE, onAdPlayComplete);
			_e.listen(PlayerEvents.VIDEO_CAN_NOT_CONNECT, onVideoError);
			_e.listen(PlayerEvents.VIDEO_NOT_FOUND, onVideoError);
			_e.listen(PlayerEvents.VIDEO_LOADING_GET_100, onVideoLoadingGet100);
			_e.listen(PlayerEvents.BI_P2P_FAIL, onP2pFail);
			_e.listen(PlayerEvents.BI_USER_INFO_CHANGE, startGetUserInfo);
			_e.listen(QuizEvents.QUZI_CHANGE_FROM_SERVICES, quizChangeFromServices);
		}
		
		/**
		 * 缓冲满
		 *
		 * @param data
		 */
		private function onVideoBufferFull(data:Object = null):void
		{
			_bufferFull = true;
			doHidePT();
		}
		
		protected function onAdPlayComplete(data:Object=null):void
		{
			forceHidePT();
			//用户实际看到视频时间点
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_PLAY_REAL_START, {});
		}
		
		private function onVideoLoadingGet100(data:Object=null):void
		{
			_bufferFull = true;
		}
		
		private function onFirstBufferFul(data:Object = null):void
		{
			_bufferFull = true;
		}
		
		override protected function showPT():void {
			Context.getContext(ContextEnum.UI_MANAGER).showPT();
			showSpecilUI();
			Ticker.tick(2000, onPTDelayed);
		}
		
		/**
		 * 派发可以在广告和品推时可以操作的组件
		 */		
		protected function showSpecilUI():void {
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SPECIL_COMP_ENABLE, [ExtraUIItemEnum.UI_SPECILE_ENABLE_FULL, ExtraUIItemEnum.UI_SPECILE_ENABLE_VOLUME]);
		}
		
		override protected function onPTDelayed():void
		{
			super.onPTDelayed();
			showAD();
		}
		
		/**
		 * 关闭品推
		 */
		public function doHidePT():void
		{
			if (_isPTDelayed && Util.validateObj(Context.variables, "ADPlayComplete") && Context.variables["ADPlayComplete"] && _bufferFull)
			{
				(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_HIDE_PT);
			}		
		}
		
		/**
		 * 强行关闭品推
		 */
		private function forceHidePT():void
		{
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_HIDE_PT);
		}
		/**
		 * 启动其他内容.
		 * 因为要加载广告，所以初始状态时候控制栏不可用
		 */
		override protected function startUpInternal():void
		{
			Context.getContext(ContextEnum.UI_MANAGER).toggleEnabled(false);
		}
		
		override protected function initVideoData():VideoData
		{
			var v:StreamVideoData = new StreamVideoData();
			v.cid = Context.variables["cid"];
			return v;
		}
		
		private function onVideoError(data:Object):void
		{
			retryPort();
		}
		
		override protected function onReloadVideo():void {
			Debugger.log(Debugger.INFO, "[business]", "重新加载视频!");
			
			super.initVideoDispatch();
		}
		
		/**
		 *调度数据需要待视频信息返回才可以调用
		 *
		 */
		override protected function initVideoDispatch():void
		{
			_bufferFull = false;
			getLiveInfo();
		}
		
		override protected function initUI():void {
			super.initUI();
			Context.variables["UIModuleData"] = {"m3":true};
			startGetUserInfo();
			startQuiz();
		}
		
		protected function getLiveInfo():void {
			Debugger.log(Debugger.INFO, "[business]", "获取视频标题等信息!");
			//取视频信息
			if (_streamInfoGot == false)
			{
				_streamInfoGot = true;
				var obj:Object = Context.variables;
				var roomID:String = Context.variables["roomID"];
				if (Util.validateStr(roomID))
				{
					StreamDataRetriver(Context.getContext(ContextEnum.DATA_RETRIVER)).getInfo(roomID, onLiveInfoRetrived, onLiveInfoFail);
				} else {
					_streamInfoGot = false;
					onLiveInfoFail(PlayerErrors.packUpError(PlayerErrors.STREAM_DISPATCH_PARAMETER_INVALID));
				}
			}
		}
		
		/**
		 *调用接口返回错误
		 * @param info
		 *
		 */
		private function onLiveInfoFail(error:PlayerErrors):void
		{
			Debugger.log(Debugger.INFO, "[business]", "视频标题等信息获取失败!");
			_infoErrorCount++;
			if (_infoErrorCount < 3)
			{
				initVideoDispatch();
			}
			else
			{
				onError(error);
			}
		}
		
		private function onLiveInfoRetrived(data:Object):void
		{
			_infoErrorCount = 0;
			//装载数据
			setupInfoData(data.obj);
			Debugger.log(Debugger.INFO, "[business]", "视频标题等信息已获取!");
			super.initVideoDispatch();
		}
		
		protected function setupInfoData(data:Object):void
		{
			for (var key:String in data) {
				if (key == "type") {
					Context.variables["isOrg"] = data["type"];
				} else if (key == "cId") {
					Context.variables["cid"] = data["cId"];
				} else if (key == "isP2p") {
					Context.variables["pr"] = data["isP2p"];
				} else {
					Context.variables[key] = data[key];
				}
			}
			
			Context.variables["pushPathWS"] = data["pushPath"];
			Context.variables["streamNameWS"] = data["streamName"];
			
			//保留云成的逻辑
			//验证判断 如果p2purl为空 则不能使用p2p播放  
			//cdnType==5 是网宿的p2p 
			//cdnType!=5 是云成的p2p
			if(Context.variables["pr"] && data["p2pUrl"] == "" &&(data["cdnType"]!=5)){
				Context.variables["pr"] = 0;
				Debugger.log(Debugger.INFO, "[business]", "由于p2purl为空，所以不能使用p2p播放方式");
			}
			
			
			
			var settings:Object = Context.getContext(ContextEnum.SETTING);
			settings["pageURL"] = data.url;
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data["title"] = Util.validateStr(data.liveTitle) ? HtmlUtil.decodeHtml(data.liveTitle) : data.liveTitle;
//			Global.videoData["title"] = Util.validateStr(data.liveTitle) ? HtmlUtil.decodeHtml(data.liveTitle) : data.liveTitle;
			
			_gameCode = data.gameCode;
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_LOADED, {"game_code":data.gameCode, "duration":0});
			if (!Util.validateStr(Context.variables["flashURL"]))
			{
				Context.variables["flashURL"] = "http://v.17173.com/live/player/Player_stream_customOut.swf&url=" + data.url;
			}
		}
		
		override protected function get isCompleted():Boolean
		{
			return super.isCompleted && _streamInfoGot;
		}
		
		override protected function onVideoStart(data:Object = null):void
		{
			super.onVideoStart(data);
			if (!Context.variables["ADPlayComplete"])
			{
				changeVolume(0);
			}
		}
		
		override protected function onVideoInit(data:Object):void {
			super.onVideoInit(data);
			Ticker.tick(5000, function ():void {
				//启动第一次统计
				IStat(Context.getContext(ContextEnum.STAT)).stat(
					StatTypeEnum.BI, StatTypeEnum.EVENT_PLAY_START, {"duration":"0","game_code":_gameCode});
			});
		}
		
		override protected function onReadyToPlay(data:Object = null):void
		{
			if (Util.validateObj(Context.variables, "ADPlayComplete") && Context.variables["ADPlayComplete"])
			{
				super.onReadyToPlay(data);
			}
		}
		
		override protected function onError(error:PlayerErrors):void
		{
			switch (error.error)
			{
				case PlayerErrors.STREAM_DISPATCH_NO_SERVER: //重试超时
				case PlayerErrors.VIDEO_DISPATCH_URL_RETRIVE_FAIL: //url无效或者返回非200
				case PlayerErrors.STREAM_DISPATCH_PARAMETER_INVALID: //参数无效
					//强行取消显示出错界面
					error.needErrorPanel = false;
					if (Context.variables["showRec"])
					{
						return;
					}
					//视频调度地址出错,出现推荐
//					if (Global.videoManager.video || Global.videoManager.source)
					if ((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).video || (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).source)
					{
						_e.send(PlayerEvents.UI_SHOW_BACK_RECOMMAND);
					}
					else
					{
						_e.send(PlayerEvents.UI_SHOW_FORE_RECOMMAND);
					}
					//把视频去了
					(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).stop();
//					Global.videoManager.stop();
					break;
			}
		}
		
		private function onP2pFail(data:Object = null):void
		{
			reInitDispatch4P2pFail();
		}
		
		/**
		 *p2p链接失败或者p2p地址错误后 重新调用调度
		 *
		 */
		protected function reInitDispatch4P2pFail():void
		{
			Context.variables["pr"] = 0;
			var v:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager;
			v.stop();
			super.initVideoDispatch();
			Debugger.log(Debugger.INFO, "[business]", "p2p失败从新请求非p2p调度");
		}
		
		override protected function onSwitchStream(data:Object):void
		{
			Debugger.log(Debugger.INFO, "[business]", "切流 ADPlayComplete变为false");
			_streamInfoGot = false;
			Ticker.stop(initVideoDispatch);
			if (data.hasOwnProperty("roomID"))
			{
				Context.variables["roomID"] = data["roomID"];
			}
			Context.variables["ADPlayComplete"] = false;
			super.onSwitchStream(data);
		}
		
		
		override protected function onVideoPlayOutTime(data:Object = null):void
		{
			super.onVideoPlayOutTime(data);
			
//			Global.uiManager.showTooltipArr(["当前网速较慢,请关闭其他可能占用网速的软件"]);
			Context.getContext(ContextEnum.UI_MANAGER).showTooltipArr(["当前网速较慢,请关闭其他可能占用网速的软件"]);
			//重新获取调度信息
			_streamInfoGot = false;
			retryPort();
		}
		
		/**
		 * 切换端口重试或者重取调度.
		 *
		 * @return
		 */
		private function retryPort():void
		{
//			Global.uiManager.showPT();
			Context.getContext(ContextEnum.UI_MANAGER).showPT();
			Debugger.log(Debugger.INFO,"[stream]","加载超时 换端口重新获取调度");
			//端口换完了就只好重启调度了
			var changed:String = Context.getContext(ContextEnum.DATA_RETRIVER)["changePort"]();
			if (Util.validateStr(changed))
			{
				Debugger.log(Debugger.INFO,"[stream]","流重连");
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.streamName = changed;
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).connectStream();
//				Global.videoData.streamName = changed;
//				Global.videoManager.connectStream();
			}
			else
			{
				Context.getContext(ContextEnum.VIDEO_MANAGER)["dispose"]();
				//Context.getContext(ContextEnum.VIDEO_MANAGER) dispose
				Debugger.log(Debugger.INFO,"[stream]","重新获取调度");
				//流请求失败,重试调度
				Ticker.tick(3000, initVideoDispatch, 1);
			}
		}
		
		/**
		 * 视频播放结束.
		 * @param data
		 */
		override protected function onVideoFinished(data:Object = null):void
		{
//			Global.videoManager.stop();
			(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).stop();
			super.onVideoFinished(data);
		}
		
		private function showAD():void
		{
			if (!isLocal)
			{
				Context.variables["ADPlayComplete"] = false;
				startShowAD();
			}
			else
			{
				Debugger.tracer(Debugger.INFO, "跳过广告");
				onAdComplete();
			}
		}
		
		private function get isLocal():Boolean
		{
			return false;
			return Context.variables["ref"].indexOf("file:") != -1;
		}
		
		/**
		 * 根据三个广告的状态，判断是否显示广告
		 */
		private function startShowAD():void
		{
			Debugger.log(Debugger.INFO, "[business]", "启动广告逻辑!");
			_e.listen(PlayerEvents.BI_AD_COMPLETE, onAdComplete);
			_e.send(PlayerEvents.BI_START_LOAD_AD_INFO);
		}
		
		private function onAdComplete(data:Object = null):void
		{
			Debugger.log(Debugger.INFO, "[business]", "广告逻辑结束!");
			_e.remove(PlayerEvents.BI_AD_COMPLETE, onAdComplete);
			
			Context.variables["ADPlayComplete"] = true;
			doHidePT();
			changeVolume(Context.getContext(ContextEnum.SETTING)["volume"]);
			Context.getContext(ContextEnum.UI_MANAGER).toggleEnabled(true);
		}
		
		/**
		 * 直播由于有rtmp协议不支持暂停功能，因此当视频加载进入之后才去声音最小处理机制
		 * 当视频加载但是广告并未结束设置声音为0
		 * 当广告加载完毕之后重新设置对应的声音
		 */
		private function changeVolume(value:int):void
		{
			if (Context.getContext(ContextEnum.VIDEO_MANAGER)) {
				var vs:IVideoSource = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).source;
				if (vs)
				{
					vs.volume = value;
				}
			}
		}
		
		/**
		 * 提示出错信息.
		 * @param msg
		 */
		override protected function showError(info:PlayerErrors):void
		{
			Context.getContext(ContextEnum.SETTING)["isError"] = true;
//			Global.settings.isError = true;
			super.showError(info);
		}
		
		/**
		 * 获取用户数据
		 */		
		protected function startGetUserInfo(data:Object = null):void {
			StreamDataRetriver(Context.getContext(ContextEnum.DATA_RETRIVER)).getUserInfo(onGetUserInfoSucc, onGetUserInfoFail);
		}
		
		/**
		 * 获取用户数据成功
		 */		
		private function onGetUserInfoSucc(data:Object):void {
			var currentRoomID:String = Context.variables["roomID"]
			if (data.code == "000000" && data.hasOwnProperty("obj"))
			{
				Debugger.log(Debugger.INFO, "[Business]", "获取用户数据成功，进行更新");
				if (Util.validateObj(data, "obj")) {
					var userInfo:Object = {};
					if (Util.validateObj(Context.variables, "userInfo")) {
						userInfo = Context.variables["userInfo"];
					} else {
						Context.variables["userInfo"] = userInfo;
					}
					var temp:Object = data.obj;
					if (temp.hasOwnProperty("cover"))
					{
						userInfo["faceUrl"] = temp.cover;
					}
					if (temp.hasOwnProperty("jinbi")) {
						userInfo["jinbi"] = temp.jinbi;
					}
					if (temp.hasOwnProperty("yinbi")) {
						userInfo["yinbi"] = temp.yinbi;
					}
					_e.send(PlayerEvents.BI_USER_INFO_GETED, "1");
				}
			}
		}
		
		/**
		 * 获取用户数据失败
		 */	
		private function onGetUserInfoFail(data:Object):void {
			_e.send(PlayerEvents.BI_USER_INFO_GETED, "0");
		}
		
		/**
		 * 开启竞猜功能
		 */		
		private function startQuiz():void {
//			if (Context.variables["type"] == Settings.PLAYER_TYPE_STREAM_ZHANNEI) {
			if (Context.variables["type"] == PlayerType.S_ZHANNEI) {
				Context.getContext(ContextEnum.DATA_RETRIVER).getUserQuizState(Context.variables["liveRoomId"], onGetQuizStateSucc, onGetQuizStateFail);
				_e.listen(QuizEvents.QUIZ_SHOW_START_QUIZ, showOpenQuizPanel);
				_e.listen(QuizEvents.QUIZ_ADD_QUIZ_DATA, addQuizInfo);
				_e.listen(QuizEvents.QUIZ_SHOW_ERROR_PANEL, showQuizErrorPanel);
				_e.listen(QuizEvents.QUIZ_HIDE_QUIZ_UI, hideQuizUI);
				_e.listen(QuizEvents.QUIZ_SHOW_QUIZ_UI, showQuizUI);
			}
		}
		
		private function onGetQuizInfoSucc(data:Object):void {
			if (data && (data as Array).length <= 0) {
				setQuizBtnToBar();
			} else {
				loadQuizModule();
			}
		}
		
		private function onGetQuizInfoFail(data:Object):void {
			
		}
		
		/**
		 * 显示竞猜提示界面
		 */		
		private function showQuizErrorPanel(data:Object):void {
			if (!_quizTipPanel) {
				_quizTipPanel = new QuizTipPanel();
			}
			var temp:Array = (data as String).split(";");
			if (temp.length > 1) {
				_quizTipPanel.setLabel(temp[0], temp[1]);
			} else {
				_quizTipPanel.setLabel(data as String);
			}
//			(Context.getContext(ContextEnum.UI_MANAGER) as UIManager).popup(_quizTipPanel);
			Context.getContext(ContextEnum.UI_MANAGER).popup(_quizTipPanel);
		}
		
		private function onGetQuizStateSucc(data:Object):void {
			resolveQuziUserData(data);
			
			StreamDataRetriver(Context.getContext(ContextEnum.DATA_RETRIVER)).LoadQuzi(Context.variables["liveRoomId"], true, onGetQuizInfoSucc, onGetQuizInfoFail);
		}
		
		private function onGetQuizStateFail(data:Object):void {
			StreamDataRetriver(Context.getContext(ContextEnum.DATA_RETRIVER)).LoadQuzi(Context.variables["liveRoomId"], true, onGetQuizInfoSucc, onGetQuizInfoFail);
		}
		
		private function setQuizBtnToBar():void {
			if (_quizUser && _quizUser.openAU) {
				var streamBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.STREAM_EXTRA_BAR);
				if (!_quizBuuton) {
					_quizBuuton = new QuizStartButton();
				}
				streamBar.call("addItem", _quizBuuton, ExtraUIItemEnum.QUIZ);
//				if (streamBar.display) {
//					var right:Sprite = streamBar.display["right"];
//					if (right.contains(_quizBuuton)) {
//						right.setChildIndex(_quizBuuton, 0);
//						streamBar.call("resize");
//					}
//				}
			} else {
				
			}
		}
		
		private function resolveQuziUserData(data:Object):void {
			if (!_quizUser) {
				_quizUser = new QuizUserData();
			}
			_quizUser.resolveData(data);
			Context.variables["quizUser"] = _quizUser;
		}
		
		/**
		 * 显示开启竞猜panel
		 */		
		private function showOpenQuizPanel(data:Object):void {
			if (_quizUser && _quizUser.openAU) {
				if (_quizUser.role == QuizUserData.QUZI_ANCHORS) {
					popUpTipSignPanel();
				} else {
					popUpOpenQuizPanel();
				}
			}
		}
		
		/**
		 * 引导非签约主播去签约界面
		 */		
		private function popUpTipSignPanel():void {
			if (!_quizSignPanel) {
				_quizSignPanel = new QuizTipWithBtnPanel();
			}
			_quizSignPanel.setData("http://v.17173.com/live/channels.action");
//			(Context.getContext(ContextEnum.UI_MANAGER) as UIManager).popup(_quizSignPanel);
			Context.getContext(ContextEnum.UI_MANAGER).popup(_quizSignPanel);
		}
		
		/**
		 * 显示开启竞猜页面
		 */		
		private function popUpOpenQuizPanel():void {
			if (!_openQuizPanel) {
				_openQuizPanel = new QuizStartQuizPanel();
			}
			_openQuizPanel.initValue();
//			(Context.getContext(ContextEnum.UI_MANAGER) as UIManager).popup(_openQuizPanel);
			Context.getContext(ContextEnum.UI_MANAGER).popup(_openQuizPanel);
		}
		
		private function addQuizInfo(data:Object):void {
			Context.getContext(ContextEnum.DATA_RETRIVER).addQuizInfo(data, onAddQuizback, onAddQuizback);
		}
		
		private function onAddQuizback(data:Object):void {
			loadQuizModule();
			var streamBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.STREAM_EXTRA_BAR);
			streamBar.call("removeItem", _quizBuuton, ExtraUIItemEnum.QUIZ);
		}
		
		private function loadQuizModule():void {
			if (_quizPanel) {
				_quizPanel.visible = true;
			} else {
				if (!_quizLoading) {
					_quizLoading = true;
					var quiz:IPluginItem = (Context.getContext(ContextEnum.PLUGIN_MANAGER) as PluginManager).getPlugin(PluginEnum.QUIZ);
					quiz.addEventListener(PluginEvents.COMPLETE, quizComplete);
				}
			}
		}
		/**
		 * 竞猜模块加载完毕
		 */		
		private function quizComplete(evt:PluginEvents):void {
			//第一次显示竞猜，给js发消息
			Context.variables["quizShow"] = true;
			_quizLoading = false;
			_quizPanel = evt.currentTarget.warpper;
			_quizHasSendOpen = true;
			Context.getContext(ContextEnum.JS_DELEGATE).sendQuizState(1);
		}
		
		/**
		 * 隐藏竞猜主界面，显示开启竞猜按钮
		 */		
		private function hideQuizUI(data:Object):void {
			if (_quizPanel) {
				Context.variables["quizShow"] = false;
				if (!_quizHasSendClose) {
					_quizHasSendClose = true;
					_quizHasSendOpen = false;
					Context.getContext(ContextEnum.JS_DELEGATE).sendQuizState(0);
				}
				_quizPanel.visible = false;
				setQuizBtnToBar();
			}
		}
		
		private function showQuizUI(data:Object):void {
			if (_quizPanel) {
				Context.variables["quizShow"] = true;
				if (!_quizHasSendOpen) {
					_quizHasSendOpen = true;
					_quizHasSendClose = false;
					Context.getContext(ContextEnum.JS_DELEGATE).sendQuizState(1);
				}
				_quizPanel.visible = true;
				var streamBar:ISkinObject = Context.getContext(ContextEnum.SKIN_MANAGER).getSkin(SkinsEnum.STREAM_EXTRA_BAR);
				streamBar.call("removeItem", _quizBuuton, ExtraUIItemEnum.QUIZ);
			}
		}
		
		private function quizChangeFromServices(data:Object):void {
//			Debugger.log(Debugger.INFO, "[quiz]", data as String);
			if (_quizPanel && _quizPanel.visible) {
			} else {
				loadQuizModule();
			}
		}
		
		
		/**
		 * 键盘事件的处理方法
		 */		
		override protected function keyHandler(value:uint):void {
			var vm:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager;
			var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			var setting:Object = Context.getContext(ContextEnum.SETTING);
			if(vm && vm.video) {
				switch (value) {
					case Keyboard.LEFT : 
//						vm.seek(Global.videoData.playedTime - 30);
						break;
					case Keyboard.RIGHT : 
//						vm.seek(Global.videoData.playedTime + 30);
						break;
					case Keyboard.DOWN : 
						e.send(PlayerEvents.UI_CHANGE_VOLUME, setting["volume"] - 10);
						break;
					case Keyboard.UP : 
						e.send(PlayerEvents.UI_CHANGE_VOLUME, setting["volume"] + 10);
						break;
					case Keyboard.SPACE : 
						e.send(PlayerEvents.UI_PLAY_OR_PAUSE, !vm.isPlaying);
						break;
				}
			}
		}
		
		
	}
}
