package com._17173.flash.show.module.video
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.interactive.IKeyboardManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.authority.AuthorityStaitc;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.context.user.UserData;
	import com._17173.flash.show.base.module.video.base.LoadOtherModules;
	import com._17173.flash.show.base.module.video.live.LiveVideo;
	import com._17173.flash.show.base.module.video.live.VideoInfoPanel;
	import com._17173.flash.show.base.module.video.push.PhotoPanel;
	import com._17173.flash.show.base.module.video.push.PushInfoPanel;
	import com._17173.flash.show.base.module.video.push.PushVideo;
	import com._17173.flash.show.base.module.video.push.RightTopPanel;
	import com._17173.flash.show.base.module.video.push.VolumePanel;
	import com._17173.flash.show.danmai.offLinePlayer.FilePlayerBusiness;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLVariables;
	import flash.ui.Keyboard;
	
	/**
	 *  拉流 Module
	 * @author qiuyue
	 * 
	 */	
	public class SimpleVideoModule extends BaseModule implements ISimpleVideoModule
	{
		/**
		 * 拉流数组，包含当前有几个拉流
		 */		
		private var _objMid:Array = null;
		private var _objBg:Object = null;
		private var _objFront:Object = null;
		/**
		 * 当前拉流的index，主要用于区分每个LiveVideo，无其他含义
		 */		
		private var _currintIndex:int = 1;
		
		private var _e:IEventManager = null;
		
		
		private var _spriteBg:Sprite = null;
		private var _spriteMid:Sprite = null;
		private var _spriteFront:Sprite = null;
		private var _rtopPanel:RightTopPanel = null;
		private var _volumePanel:VolumePanel = null;
		private var _pushVideo:PushVideo = null;
		private var _photo:PhotoPanel = null;
		private var underLindeVideo:FilePlayerBusiness = null;
		protected var _s:IServiceProvider = null;
		
		private var _loadOtherModule:LoadOtherModules = new LoadOtherModules();
		
		public function SimpleVideoModule(){
			super();
			_version = "0.0.6";
		}
		
		override protected function onAdded(event:Event):void{
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			
			var roomData:URLVariables = new URLVariables();
			roomData["roomId"] = Context.variables["roomId"];
			_s.http.getData(SEnum.ORDERS_INFO, roomData, succ, fail);
		}
		
		private function succ(data:Object):void{
			Context.variables.showData.liveInfo = data.order[1];
			var iuser:IUser = Context.getContext(CEnum.USER) as IUser;
			var obj:Object = data.order[1];
			if(obj.masterId != 0){
				var dataObj:Object = new Object();
				dataObj.userId = obj.masterId;
				dataObj.userName = obj.nickName;
				if(obj.isInRoom == 0){
					iuser.addUserFromData(dataObj);
				}else{
					iuser.addUserFromData(dataObj, false);
				}
			}
			onReady();
		}
		
		private function fail(data:Object):void{
			var obj:Object = new Object();
			obj.liveId = "0";
			obj.masterId = "0";
			Context.variables.showData.liveInfo = obj;
			onReady();
		}
		
		public function onReady():void{
			update();
			//周星礼物开始请求数据
			getWeekGiftData();
			//每隔15秒请求周星排行数据
			Ticker.tick(15000,getWeekGiftData,-1);
			function getWeekGiftData():void{
				_s.http.getData(SEnum.VIDEO_WEEKGIFT,{"masterUid":Context.variables.showData.roomOwnMasterID},function (data:Object):void{
					updateWeekGiftStar(data);
				});
			}
		}
		
		private function update():void{
			_spriteBg = new Sprite();
			this.addChild(_spriteBg);
			_spriteMid = new Sprite();
			this.addChild(_spriteMid);
			_spriteFront = new Sprite();
			this.addChild(_spriteFront);
			_objBg = new Object;
			_objMid = new Array;
			_objFront = new Object;
				
			/** 创建视频背景 **/
			createLiveVideoBg(1);
				
			createLiveVideo(1);
			createUnderLineVideo();
			/** 初始化直播信息，如果没有直播显示离线录像 **/
			updateVideo();
				
			createCamVideo();
			createCamVideoComponents();
			
//			createPhotoPanel();
			createLiveVideoFront(1);
			
			_e.listen(SEvents.LIVE_PAUSE,livePause);
				
			var k:IKeyboardManager = Context.getContext(CEnum.KEYBOARD) as IKeyboardManager;
			k.registerKeymap(popLog, Keyboard.CONTROL, Keyboard.ALTERNATE, Keyboard.NUMBER_3);
			loadModule();
		}
		
		
		private function loadModule():void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			var array:Array = new Array;
			if(liveInfo && liveInfo.liveId != 0 && liveInfo.masterId != Context.variables.showData.masterID){
				array.push(1);
			}
			_loadOtherModule.start(array);
		}
		
		private function popLog():void{
			
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo && liveInfo.liveId != 0){
				if(liveInfo.masterId == Context.variables.showData.masterID){
					var _pushInfoPanel:PushInfoPanel = new PushInfoPanel(_pushVideo.pushVideoManager.source);
					_pushInfoPanel.x = 20;
					_pushInfoPanel.y = 20;
					Context.stage.addChild(_pushInfoPanel);
				}else{
					var _videoInfoPanel:VideoInfoPanel = new VideoInfoPanel(getLiveVideo(1).liveVideoManager.source, getLiveVideo(1).index);
					_videoInfoPanel.x = 20;
					_videoInfoPanel.y = 20;
					Context.stage.addChild(_videoInfoPanel);
				}
			}
			
		}
		
		protected override function init():void{	
			super.init();
		}
		
		
		/**
		 * 用户离开房间 
		 * @param data
		 * 
		 */		
		public function onUserExit(data:Object):void{
			try
			{
				var iuser:IUser = Context.getContext(CEnum.USER) as IUser;
				var micIndex:int = iuser.getMicIndex((data.user as UserData).id);
				var liveInfo:Object = Context.variables.showData.liveInfo;
				if(micIndex >=1 && micIndex <=3 && _objBg && liveInfo.masterId == (data.user as UserData).id){
					var lbg:SimpleLiveVideoBg = _objBg[micIndex] as SimpleLiveVideoBg;
					if(lbg){
						lbg.onUserExit(data);
						lbg.update();
					}
					var lo:SimpleLiveVideoFront = _objFront[micIndex] as SimpleLiveVideoFront;
					if(lo){
						lo.update();
					}
				}
			} 
			catch(error:Error) 
			{
				Debugger.log(Debugger.INFO,"onUserExit Error");
			}
			
		}
		
		/**
		 * 用户进入房间 
		 * @param data
		 * 
		 */		
		public function onUserEnter(data:Object):void{
			try
			{
				var iuser:IUser = Context.getContext(CEnum.USER) as IUser;
				var micIndex:int = iuser.getMicIndex((data.user as UserData).id);
				var liveInfo:Object = Context.variables.showData.liveInfo;
				if(micIndex >=1 && micIndex <=3 && _objBg){
					var lbg:SimpleLiveVideoBg = _objBg[micIndex] as SimpleLiveVideoBg
					if(lbg){
						lbg.onUserEnter(data);
						lbg.update();
					}
					var lo:SimpleLiveVideoFront = _objFront[micIndex] as SimpleLiveVideoFront;
					if(lo){
						lo.update();
					}
				}
			} 
			catch(error:Error) 
			{
				Debugger.log(Debugger.INFO,"onUserEnter Error");
			}
			
		}
		
		private function createPhotoPanel():void{
			_photo = new PhotoPanel();
			_spriteMid.addChild(_photo);
			_photo.x = 703;
			_photo.y = 59;
			_photo.visible = false;
		}
		
		private function createCamVideo():void{
			_pushVideo = new PushVideo();
			_spriteMid.addChild(_pushVideo);
			_pushVideo.visible = false;
		}
		
		private function getUnderLineVideoCID():String{
			var cID:String = Context.variables.showData.underLineVideoCid;
			if(cID != ""){
				var first:String = cID.split("?")[0];
				if(first != ""){
					var secondArray:Array = first.split("/");
					if(secondArray.length > 0){
						var thirdArray:Array = secondArray.pop().split(".");
						if(thirdArray.length > 0){
							return thirdArray[0];
						}
					}
				}
			}
			return "";
		}
		
		private function createUnderLineVideo():void {
			if(!underLindeVideo){
				underLindeVideo = new FilePlayerBusiness();
				underLindeVideo.videoX = 0;
				underLindeVideo.videoY = 0;
				underLindeVideo.videoWidth = 480;
				underLindeVideo.videoHeight = 360;
				underLindeVideo.videoParent = getLiveVideo(1).underLineSprite;
			}
		}
		
		private function showUnderLineVideo():void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			var user:IUser = Context.getContext(CEnum.USER) as IUser;
			var liveVideo:LiveVideo = getLiveVideo(1);
			if(liveInfo.liveId == 0 && !user.validateAuthority(user.me,AuthorityStaitc.THINT_IS_ROOM_ADMIN).can){
				var cid:String = getUnderLineVideoCID();
				if(cid != ""){
					if(underLindeVideo){
						underLindeVideo.start(cid);
						liveVideo.isShowVideoTitle(2);
						liveVideo.resetPauseBtn();
						liveVideo.changeConnected(true);
					}
					
				}
			}
		}
		
		private function hideUnderLindeVideo():void{
			if(underLindeVideo){
				underLindeVideo.stop();
				var liveVideo:LiveVideo = getLiveVideo(1);
				liveVideo.isShowVideoTitle(-1);
			}
		}
		/**
		 * 创建推流组件
		 * 
		 */		
		private function createCamVideoComponents():void{
			if(!_rtopPanel){
				_rtopPanel = new RightTopPanel();
			}
			if(!this.contains(_rtopPanel)){
				this.addChild(_rtopPanel);
			}
			_rtopPanel.visible = false;
			_pushVideo.rtopPanel = _rtopPanel;
			
			if(!_volumePanel){
				_volumePanel = new VolumePanel();
			}
			if(!this.contains(_volumePanel)){
				this.addChild(_volumePanel);
			}
			_volumePanel.visible = false;
			_pushVideo.volumePanel = _volumePanel;
		}
		/**
		 * 创建一个拉流背景
		 * @param micIndex 麦序
		 * 
		 */		
		private function createLiveVideoBg(micIndex:int):void{
			var liveBg:SimpleLiveVideoBg = new SimpleLiveVideoBg(micIndex);
			_spriteBg.addChild(liveBg);
			_objBg[micIndex] = liveBg;
		}
		
		/**
		 * 创建一个拉流背景
		 * @param micIndex 麦序
		 * 
		 */		
		private function createLiveVideoFront(micIndex:int):void{
			var liveOp:SimpleLiveVideoFront = new SimpleLiveVideoFront(micIndex);
			_spriteFront.addChild(liveOp);
			_objFront[micIndex] = liveOp;
			liveOp.update();
		}
		
		private function updateVideo():void{
			var liveVideo:LiveVideo = getLiveVideo(1);
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo.cId && liveInfo.ckey && liveInfo.hasOwnProperty("masterId") && liveInfo.masterId != 0){
				if((Context.getContext(CEnum.USER) as User).me.id != liveInfo.masterId){
					hideUnderLindeVideo();
					liveVideo.videoData.cId = liveInfo.cId;
					liveVideo.videoData.ckey = liveInfo.ckey;
					liveVideo.videoData.name = liveInfo.streamName;
					liveVideo.videoData.cdntype = liveInfo.cdnType;
					liveVideo.connectLive();
					liveVideo.isShowVideoTitle(1);
				}
			}else{
				/** 没有直播不显示新手任务 **/
				(Context.getContext(CEnum.EVENT)as IEventManager).send(SEvents.TASK_SHOW,{"showTask":false});
				var user:IUser = Context.getContext(CEnum.USER) as IUser;
				if(!user.validateAuthority(user.me,AuthorityStaitc.THINT_IS_ROOM_ADMIN).can){
					showUnderLineVideo();
				}else{
					hideUnderLindeVideo();
				}
			}
		}
		/**
		 * 创建一个拉流
		 * @param micIndex 麦序
		 * 
		 */		
		private function createLiveVideo(micIndex:int):void{
			var liveVideo:LiveVideo = new LiveVideo(micIndex, _currintIndex, false);
			_spriteMid.addChild(liveVideo);
			createLiveVideoComponents(liveVideo);
			_objMid.push(liveVideo);
			//liveVideo.move(micIndex);
			_currintIndex++;
		}
		
		private function createLiveVideoComponents(liveVideo:LiveVideo):void{
			var loadingIcon:LoadingIcon = new LoadingIcon();
			loadingIcon.visible = false;
			loadingIcon.gotoAndStop(1);
			_spriteFront.addChild(loadingIcon);
			liveVideo.loadingIcon = loadingIcon;
			var	_videoTitle:VideoTitle = new VideoTitle();
			_spriteFront.addChild(_videoTitle);
			_videoTitle.stop();
			_videoTitle.visible = false;
			liveVideo.videoTitle = _videoTitle;
		}
		
		private function getLiveVideo(micIndex:int):LiveVideo{
			var liveVideo:LiveVideo = null;
			if(_objMid){
				for(var i:int =0;i<_objMid.length;i++){
					liveVideo = _objMid[i];
					if(liveVideo.micIndex == micIndex){
						return liveVideo;
					}
				}
			}
			return liveVideo;
		}
		
		/**
		 * 暂停 
		 * @param data
		 * 
		 */		
		private function livePause(data:Object):void{
			var liveVideo:LiveVideo = getLiveVideo(data as int);
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveVideo && liveInfo.liveId != 0){
				liveVideo.pause();
			}else{
				var cid:String = getUnderLineVideoCID();
				if(underLindeVideo && cid != ""){
					if(!underLindeVideo.isPause){
						underLindeVideo.pause();
					}else{
						underLindeVideo.play();
					}
				}
				
			}
		}
		
		/**
		 * 数据更新
		 * @param order 麦序
		 * 
		 */		
		public function onLiveData(order:int):void{
			var liveVideo:LiveVideo = getLiveVideo(order);
			if(liveVideo){
				var liveInfo:Object = Context.variables.showData.liveInfo;
				if( liveInfo!= null){
					if(liveInfo.masterId != Context.variables.showData.masterID){
						hideUnderLindeVideo();
						liveVideo.videoData.cId = liveInfo.cId;
						liveVideo.videoData.ckey = liveInfo.ckey;
						liveVideo.videoData.name = liveInfo.streamName;
						liveVideo.videoData.cdntype = liveInfo.cdnType;
						liveVideo.connectLive();
						liveVideo.isShowVideoTitle(1);
					}else{
						liveVideo.endVideo();
					}
				}
			}
			(_objBg[order] as SimpleLiveVideoBg).update();
			(_objFront[order] as SimpleLiveVideoFront).update();
		}
		
		/**
		 * 声音状态改变 
		 * @param obj
		 * 
		 */		
		public function changeSoundStatus(obj:Object):void{
			var liveVideo:LiveVideo = getLiveVideo(1);
			if(liveVideo){
				var liveInfo:Object = Context.variables.showData.liveInfo;
				if(liveInfo && liveInfo.hasOwnProperty("isMute")){
					liveVideo.changeSoundStatus(liveInfo.isMute);
				}
			}
			(_objBg[1] as SimpleLiveVideoBg).update();
			(_objFront[1] as SimpleLiveVideoFront).update();
		}
		
		/**
		 * 关闭视频 
		 * @param order
		 * 
		 */		
		public function endVideo():void{			
			var liveVideo:LiveVideo = getLiveVideo(1);
			if(liveVideo){
				liveVideo.endVideo();
				liveVideo.isShowVideoTitle(-1);
				
			}
			if(_objBg && _objBg.hasOwnProperty("1")){
				(_objBg[1] as SimpleLiveVideoBg).update();
			}
			if(_objFront && _objFront.hasOwnProperty("1")){
				(_objFront[1] as SimpleLiveVideoFront).update();
			}
			showUnderLineVideo();
		}
		
		
		/**
		 * 声音改变 
		 * @param data
		 * 
		 */		
		public function onLiveVolumeChange(data:Object):void{
			var liveVideo:LiveVideo = getLiveVideo(1);
			if(liveVideo){
				var liveInfo:Object = Context.variables.showData.liveInfo;
				if(liveInfo && liveInfo.hasOwnProperty("isMute")){
					liveVideo.onLiveVolumeChange(data.volumeNumber,liveInfo.isMute);
				}
			}
			if(underLindeVideo){
				underLindeVideo.setVolum(data.volumeNumber);
			}
			
		}
		
		public function hideCam():void{
			if(_pushVideo){
				_pushVideo.hideCam();
			}
			Util.refreshPage();
		}
		
		public function videoRePush(data:Object):void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo){
				_pushVideo.videoRePush();
			}
		}
		
		public function showPhoto():void{
			_photo.visible = true;
		}
		
		public function roomSucc(data:Object):void{
			_pushVideo.startPush({"torder":1,"sliveId":data});
		}
		
		public function changeOLVideo():void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo.cId && liveInfo.ckey && liveInfo.hasOwnProperty("masterId") && liveInfo.masterId != 0){
				if((Context.getContext(CEnum.USER) as User).me.id != liveInfo.masterId){
					hideUnderLindeVideo();
				}
			}else{
				var user:IUser = Context.getContext(CEnum.USER) as IUser;
				if(!user.validateAuthority(user.me,AuthorityStaitc.THINT_IS_ROOM_ADMIN).can){
					showUnderLineVideo();
				}else{
					hideUnderLindeVideo();
				}
			}
		}
		
		
		public function liveConnect(data:Object):void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo){
				var liveVideo:LiveVideo = getLiveVideo(1);
				if(liveVideo){
					liveVideo.reConnectLive();
				}
				
			}
		}
		/**
		 * 更新周礼物之星 
		 * @param data
		 * 
		 */		
		public function updateWeekGiftStar(data:Object):void
		{
			if(_objFront!=null && _objFront.hasOwnProperty(1))
			(_objFront[1] as SimpleLiveVideoFront).updateWeekGiftStar(data);
		}
		
		/**
		 * 清理Video画面 
		 * @param data
		 * 
		 */		
		public function clearLiveVideo(data:Object):void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo){
				if(liveInfo.masterId == (data.user as UserData).id){
					var liveVideo:LiveVideo = getLiveVideo(1);
					liveVideo.clearVideo();
				}
			}
		}
		
		public function updateName(data:Object):void{
			if(Context.variables.showData.roomOwnMasterID ==data.userId ){
				Context.variables.showData.roomOwnMasterName = data.name;
			}
			if(_objBg && _objBg.hasOwnProperty("1")){
				(_objBg[1] as SimpleLiveVideoBg).update();
			}
			
			if(_objFront && _objFront.hasOwnProperty("1")){
				(_objFront[1] as SimpleLiveVideoFront).update();
			}
		}
		
		public function isShowLoading(data:Object):void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo && liveInfo.masterId != 0){
				var liveVideo:LiveVideo;
				if(data && data.hasOwnProperty("index")){
					if(data.hasOwnProperty("isShow")){
						for(var i:int = 0;i < _objMid.length ; i++){
							liveVideo = _objMid[i];
							if(liveVideo.index == data.index){
								liveVideo.isShowLoading(data);
							}else{
								liveVideo.isShowLoading(null);
							}
						}
					}
				}
				if(data && data.hasOwnProperty("micIndex")){
					if(data.hasOwnProperty("isShow")){
						for(var j:int = 0;j < _objMid.length ; j++){
							liveVideo = _objMid[j];
							if(liveVideo.micIndex == data.micIndex){
								liveVideo.isShowLoading(data);
							}else{
								liveVideo.isShowLoading(null);
							}
						}
					}
				}
			}else{
				if(liveVideo){
					liveVideo.isShowLoading(null);
				}
			}
		}
	}
}


