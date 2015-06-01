package com._17173.flash.player.business.file
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.statemachine.StateMachineEvent;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.interfaces.IVideoData;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.business.file.queue.FileBusinessControlQueue;
	import com._17173.flash.player.business.file.queue.FileCheckADis173;
	import com._17173.flash.player.business.file.queue.FileCheckADisLocal;
	import com._17173.flash.player.business.file.queue.FileInitVideoState;
	import com._17173.flash.player.business.file.queue.FileShowErrorState;
	import com._17173.flash.player.business.file.queue.InitVideoDispatchState;
	import com._17173.flash.player.business.file.queue.PTDelayeState;
	import com._17173.flash.player.business.file.queue.ParallelState;
	import com._17173.flash.player.business.file.queue.ShowADState;
	import com._17173.flash.player.business.file.queue.ShowPWState;
	import com._17173.flash.player.context.BusinessManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.VideoData;
	import com._17173.flash.player.model.PlayerErrors;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	
	import flash.events.Event;
	import flash.ui.Keyboard;
	
	public class FileBusinessManager extends BusinessManager
	{
		
		private var _canSendRecord:Boolean = false;
		private var _lastPlayTime:Number = 0;
		private var _playTimeMinWatched:int = 0;
		private var _canAddPlayNumber:Boolean = true;
		
		/**
		 * 初始化队列 
		 */		
		protected var _queue:FileBusinessControlQueue = null;
		
		protected var _queueArr:Array;
		
		private var _queueComplete:Boolean = false;
		
		public function FileBusinessManager()
		{
			super();
			_queue = new FileBusinessControlQueue();
		}
		
		protected function queueComplete(data:Object):void {
			_queue.removeEventListener(StateMachineEvent.STATE_COMPLETED, queueComplete);
			_queueComplete = true;
			Context.variables["queueComplete"] = true;
			if (_error) {
				showError(_error);
			}
		}
		
		/**
		 * 初始化视频信息
		 * @return 
		 */		
		override protected function initVideoData():VideoData {
			var v:FileVideoData = new FileVideoData();
			v.cid = Context.variables["cid"];
			return v;
		}
		
		override protected function onVideoReady(data:Object):void {
			//启动第一次统计
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_PLAY_START, {"duration":"0"});
		}
		
		override protected function initVideoDispatch():void {
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_LOADED, {"duration":"0"});
			initStates();
			startSateMachine();
		}
		
		override protected function addListeners():void {
			super.addListeners();
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.UI_PLAY_OR_PAUSE, onUIVideoPlayAndPause);
		}
		
		/**
		 * 给状态机添加状态，并且开始执行状态机
		 */		
		private function startSateMachine():void {
			_queue.cleanUp();
			for (var i:int = 0; i < _queueArr.length; i++) {
				_queue.addState(_queueArr[i]);
			}
		}
		
		/**
		 * 初始化需要用的状态
		 */		
		protected function initStates():void {
			_queue.addEventListener(StateMachineEvent.STATE_COMPLETED, queueComplete);
			_queueArr = new Array();
			
			var ps:ParallelState = new ParallelState();
			//获取调度、延迟PT
			ps.addItems([new InitVideoDispatchState(), new PTDelayeState()]);
			var checkADPS:ParallelState = new ParallelState();
			//广告验证：是否是本地、是否是审核版本
			checkADPS.addItems([new FileCheckADisLocal(), new FileCheckADis173()]);
			var showADPS:ParallelState = new ParallelState();
			//加载显示广告、初始化视频
			showADPS.addItems([new FileInitVideoState(), new ShowADState()]);
			
			_queueArr.push(ps);
			_queueArr.push(new ShowPWState());//显示密码
			_queueArr.push(checkADPS);
			_queueArr.push(showADPS);
			_queueArr.push(new FileShowErrorState());//验证是否有错误信息
//			_queueArr.push(new FileShowLiveRecState());//点播推荐直播
		}
		
		override public function startUp(param:Object):void {
			super.startUp(param);
		}
		
		override protected function onSwitchStream(data:Object):void {
			_queueComplete = false;
			Context.variables["queueComplete"] = false;
			if(data.hasOwnProperty("cid")){
//				if (Global.videoData) {
//					Global.videoData["cid"] = data.cid;
//				}
				if ((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data) {
					(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data["cid"] = data.cid;
				}
				Context.variables["cid"] = data["cid"];
			}
			super.onSwitchStream(data);
//			Global.eventManager.send(PlayerEvents.REINIT_VIDEO);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.REINIT_VIDEO);
		}
		
		/**
		 * 提示出错信息. 
		 * @param msg
		 */		
		override protected function showError(info:PlayerErrors):void {
//			Global.settings.isError = true;
			Context.getContext(ContextEnum.SETTING).isError = true;
			_error = info;
			
			if (!_queueComplete) {
				return;
			}
			//默认trace出来
			Debugger.log(Debugger.ERROR, "[business]", "出错,code: ", info.id, ",message: ", info.msg, ",error: ", info.error);
			
			onError(info);
			
			if (info.needErrorPanel) {
				Context.getContext(ContextEnum.UI_MANAGER).showErrorPanel(info);
				(Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).stop();
//				Global.uiManager.showErrorPanel(info);
//				Global.videoManager.stop();
			}
			
			_error = null;
		}
		
		override protected function onVideoStart(data:Object=null):void {
			super.onVideoStart(data);
			
			_lastPlayTime = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.playedTime;
//			_lastPlayTime = Global.videoData.playedTime;
		}
		
		/**
		 * 视频播放结束. 
		 * @param data
		 */		
		override protected function onVideoFinished(data:Object = null):void {
			super.onVideoFinished(data);
			
			this.sendStopToJS();
		}
		
		override protected function onEnterFrame(e:Event):void {
			super.onEnterFrame(e);
			
			sendPlayRecord();
			var vd:IVideoData = null;
			if (Context.getContext(ContextEnum.VIDEO_MANAGER)) {
				vd = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data;
			}
			var min:int = vd ? vd.playedTime / 60 : 0;
//			var min:int = Global.videoData ? Global.videoData.playedTime / 60 : 0;
			if (min != _playTimeMinWatched) {
				_playTimeMinWatched = min;
				//做一次一分钟统计
				IStat(Context.getContext(ContextEnum.STAT)).stat(
					StatTypeEnum.BI, StatTypeEnum.EVENT_PLAY_STOP, {"duration":"60"});
			}
			if(_canAddPlayNumber && vd && (vd.playedTime - _lastPlayTime) >= 5)
			{
				var videoData:VideoData = vd as VideoData;
				Context.getContext(ContextEnum.DATA_RETRIVER)["addPlayNumber"](videoData.cid);
				_canAddPlayNumber = false;
			}
		}
		
		/**
		 * 发送播放记录 
		 * 播放开始后记录一次，然后没10秒记录一次
		 */
		public function sendPlayRecord():void
		{
			if (!Context.getContext(ContextEnum.VIDEO_MANAGER)) {
				return;
			}
			var vd:IVideoData = (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data;
			if(vd && (vd.playedTime - _lastPlayTime) >= 10)
			{
				_lastPlayTime = vd.playedTime;
				doSendPlayRecord();
			}
//			if(Global.videoData && (Global.videoData.playedTime - _lastPlayTime) >= 10)
//			{
//				_lastPlayTime = Global.videoData.playedTime;
//				doSendPlayRecord();
//			}
		}
		
		private function doSendPlayRecord():void
		{
//			if(Global.settings.userLogin)
			if(Context.getContext(ContextEnum.SETTING).userLogin)
			{
				sendRcordToServieces();
			}
			else
			{
				sendRcordToJS();
			}
		}
		
		private function sendRcordToJS():void
		{
//			Global.jsDelegate["onLocalPoint"]();
			_(ContextEnum.JS_DELEGATE)["onLocalPoint"]();
		}
		
		private function sendRcordToServieces():void
		{
//			Global.dataRetriver["sendPlayRecord"]();
			_(ContextEnum.DATA_RETRIVER)["sendPlayRecord"]();
		}
		
		public function sendStopToJS():void
		{
//			Global.jsDelegate["playEnd"]();
			_(ContextEnum.JS_DELEGATE).send("playEnd");
		}
		
		protected function onUIVideoPlayAndPause(data:Object):void {
			if (_queueComplete) {
				if ((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).isFinished) {
					(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.REPLAY_THE_VIDEO);
					(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
				}
				Context.getContext(ContextEnum.UI_MANAGER).cleanPopUp();
			}
//			if (_queueComplete) {
//				if (Global.videoManager.isFinished) {
//					Global.eventManager.send(PlayerEvents.REPLAY_THE_VIDEO);
//					Global.eventManager.send(PlayerEvents.UI_HIDE_BACK_RECOMMAND);
//				}
//				Global.uiManager.cleanPopUp();
//			}
		}
		
		override protected function startUpInternal():void {
			super.startUpInternal();
		}
		
		/**
		 * 键盘事件的处理方法
		 */		
		override protected function keyHandler(value:uint):void {
			var vm:IVideoManager = Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager;
			var e:IEventManager = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			var setting:Object = Context.getContext(ContextEnum.SETTING);
			if(vm.video) {
				switch (value) {
					case Keyboard.LEFT : 
						if (vm.data) {
							vm.seek(vm.data.playedTime - 30);
						}
//						vm.seek(Global.videoData.playedTime - 30);
						break;
					case Keyboard.RIGHT : 
						if (vm.data) {
							vm.seek(vm.data.playedTime + 30);
						}
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