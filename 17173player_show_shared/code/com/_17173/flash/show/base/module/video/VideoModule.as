package com._17173.flash.show.base.module.video
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.interactive.IKeyboardManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.context.user.UserData;
	import com._17173.flash.show.base.module.video.base.LoadOtherModules;
	import com._17173.flash.show.base.module.video.live.LiveVideo;
	import com._17173.flash.show.base.module.video.live.LiveVideoBg;
	import com._17173.flash.show.base.module.video.live.LiveVideoFront;
	import com._17173.flash.show.base.module.video.live.LiveVolumePanel;
	import com._17173.flash.show.base.module.video.live.VideoInfoPanel;
	import com._17173.flash.show.base.module.video.push.PushInfoPanel;
	import com._17173.flash.show.base.module.video.push.PushVideo;
	import com._17173.flash.show.base.module.video.push.RightTopPanel;
	import com._17173.flash.show.base.module.video.push.VolumePanel;
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
	public class VideoModule extends BaseModule implements IVideoModule
	{
		private var lineArrayX:Array = [506,641,1277,1413];
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
		private var _s:IServiceProvider = null;
		private var _spriteBg:Sprite = null;
		private var _spriteMid:Sprite = null;
		private var _spriteFront:Sprite = null;
		private var _rtopPanel:RightTopPanel = null;
		private var _volumePanel:VolumePanel = null;
		private var _pushVideo:PushVideo = null;
		private var _loadOtherModule:LoadOtherModules = new LoadOtherModules();
		public function VideoModule(){
			super();
		}
		
		override protected function onAdded(event:Event):void{
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			
			var roomData:URLVariables = new URLVariables();
			roomData["roomId"] = Context.variables["roomId"];
			roomData["t"] = Math.random();
			_s.http.getData(SEnum.ORDERS_INFO, roomData, succ, fail);
		}
		
		private function succ(data:Object):void{
			Context.variables.showData.order = data.order;
			var iuser:IUser = Context.getContext(CEnum.USER) as IUser;
			for(var i:int = 1; i<=3 ;i++){
				var obj:Object = data.order[i];
				if(obj){
					var dataObj:Object = new Object();
					dataObj.userId = obj.masterId;
					dataObj.userName = obj.nickName;
					if(obj.isInRoom == 0){
						iuser.addUserFromData(dataObj);
					}else{
						iuser.addUserFromData(dataObj, false);
					}
				}
			}
			onReady();
		}
		
		private function fail(data:Object):void{
			var order:Object = new Object();
			order[1] = null;
			order[2] = null;
			order[3] = null;
			Context.variables.showData.order = order;
			onReady();
		}
		
		
		public function onReady():void{
			update();
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
			createLine();
			createLiveVideoBg(1);
			createLiveVideoBg(2);
			createLiveVideoBg(3);
			createLiveVideo(1);
			createLiveVideo(2);
			createLiveVideo(3);
			createCamVideo();
			createCamVideoComponents();
			createLiveVideoFront(1);
			createLiveVideoFront(2);
			createLiveVideoFront(3);
			_e.listen(SEvents.LIVE_PAUSE,livePause);
			
			var k:IKeyboardManager = Context.getContext(CEnum.KEYBOARD) as IKeyboardManager;
			k.registerKeymap(popLog, Keyboard.CONTROL, Keyboard.ALTERNATE, Keyboard.NUMBER_3);
				
			loadModule();
		}
		
		private function loadModule():void{
			var order:Object = Context.variables.showData.order;
			var array:Array = new Array;
			for (var i:* in order){
				if(order[i] != null && order[i].masterId != Context.variables.showData.masterID){
					array.push(i);
				}
			}
			_loadOtherModule.start(array);
		}
		
		private function popLog():void{
			var iUser:IUser = Context.getContext(CEnum.USER) as IUser;
			var orderArray:Array = iUser.orderArray();
			var hNumber:int = 0;
			for(var i:int = 0;i< orderArray.length;i++){
				if(orderArray[i] != null){
					var _videoInfoPanel:Sprite;
					if((orderArray[i] as IUserData).id == Context.variables.showData.masterID){
						_videoInfoPanel = new PushInfoPanel(_pushVideo.pushVideoManager.source);
					}else{
						_videoInfoPanel = new VideoInfoPanel(getLiveVideo(i+1).liveVideoManager.source, getLiveVideo(i+1).index);
					}
					_videoInfoPanel.x = hNumber;
					_videoInfoPanel.y = 20;
					Context.stage.addChild(_videoInfoPanel);
					hNumber+=_videoInfoPanel.width + 20;
				}
			}
		}
		
		protected override function init():void{	
			super.init();
		}
		
		private function createLine():void{
			for(var i:int = 0;i< 4;i++){
				var diaoLine:DiaoLine = new DiaoLine();
				diaoLine.x = lineArrayX[i];
				diaoLine.y = 0;
				_spriteBg.addChild(diaoLine);
			}	
		}
		
		private function createCamVideo():void{
			_pushVideo = new PushVideo();
			_spriteMid.addChild(_pushVideo);
			_pushVideo.visible = false;
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
				if(micIndex >=1 && micIndex <=3 && _objBg && order && order.masterId == (data.user as UserData).id){
					var order:Object = Context.variables.showData.order[micIndex];
					var lbg:LiveVideoBg = _objBg[micIndex] as LiveVideoBg;
					if(lbg){
						lbg.onUserExit(data);
						lbg.update();
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
				if(micIndex >=1 && micIndex <=3 && _objBg){
					var order:Object = Context.variables.showData.order[micIndex];
					var lbg:LiveVideoBg = _objBg[micIndex] as LiveVideoBg;
					if(lbg){
						lbg.onUserEnter(data);
						lbg.update();
					}
					
				}
			} 
			catch(error:Error) 
			{
				Debugger.log(Debugger.INFO,"onUserEnter Error");
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
			var liveBg:LiveVideoBg = new LiveVideoBg(micIndex);
			_spriteBg.addChild(liveBg);
			_objBg[micIndex] = liveBg;
		}
		
		/**
		 * 创建一个拉流背景
		 * @param micIndex 麦序
		 * 
		 */		
		private function createLiveVideoFront(micIndex:int):void{
			var liveOp:LiveVideoFront = new LiveVideoFront(micIndex);
			_spriteFront.addChild(liveOp);
			_objFront[micIndex] = liveOp;
			liveOp.update();
		}
		
		
		/**
		 * 创建一个拉流
		 * @param micIndex 麦序
		 * 
		 */		
		private function createLiveVideo(micIndex:int):void{
			var liveVideo:LiveVideo = new LiveVideo(micIndex, _currintIndex, true);
			createLiveVideoComponents(liveVideo);
			_spriteMid.addChild(liveVideo);
			_objMid.push(liveVideo);
			liveVideo.move(micIndex);
			_currintIndex++;
			var order:Object = Context.variables.showData.order[micIndex];
			if(order != null){
				if(order.masterId != Context.variables.showData.masterID){
					if(order.hasOwnProperty("cId") && order.hasOwnProperty("ckey")){
						liveVideo.videoData.cId = order.cId;
						liveVideo.videoData.ckey = order.ckey;
						liveVideo.videoData.name = order.streamName;
						liveVideo.videoData.cdntype = order.cdnType;
						liveVideo.connectLive();
						if(order.hd == 0){
							liveVideo.isShowVideoTitle(0);
						}else{
							liveVideo.isShowVideoTitle(-1);
						}
						var iUser:IUser = Context.getContext(CEnum.USER) as IUser;
						_e.send(SEvents.UPDATE_MIC_DATA,iUser.orderArray());
					}
				}
			}
		}
		
		private function createLiveVideoComponents(liveVideo:LiveVideo):void{
			var loadingIcon:LoadingIcon = new LoadingIcon();
			loadingIcon.visible = false;
			loadingIcon.gotoAndStop(1);
			_spriteFront.addChild(loadingIcon);
			liveVideo.loadingIcon = loadingIcon;
			
			var _volumePanel:LiveVolumePanel = new LiveVolumePanel(liveVideo.index);
			_spriteFront.addChild(_volumePanel);
			_volumePanel.visible = false;
			liveVideo.volumePanel = _volumePanel;
			var	_videoTitle:VideoTitle = new VideoTitle();
			_spriteFront.addChild(_videoTitle);
			_videoTitle.stop();
			_videoTitle.visible = false;
			liveVideo.videoTitle = _videoTitle;
		}
		
		private function getLiveVideoByIndex(index:int):LiveVideo{
			var liveVideo:LiveVideo = null;
			if(_objMid){
				for(var i:int =0;i<_objMid.length;i++){
					liveVideo = _objMid[i];
					if(liveVideo.index == index){
						return liveVideo;
					}
				}
			}
			return liveVideo;
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
			var liveVideo:LiveVideo = getLiveVideoByIndex(data as int);
			if(liveVideo){
				liveVideo.pause();
			}
		}
		
		/**
		 * 数据更新 Socket15
		 * @param order 麦序
		 * 
		 */		
		public function onLiveData(order:int):void{
			var liveVideo:LiveVideo = getLiveVideo(order);
			if(liveVideo){
				var obj:Object = Context.variables.showData.order[order]
				if( obj!= null){
					if(obj.masterId != Context.variables.showData.masterID){
						liveVideo.videoData.cId = obj.cId;
						liveVideo.videoData.ckey = obj.ckey;
						liveVideo.videoData.name = obj.streamName;
						liveVideo.videoData.cdntype = obj.cdnType;
						liveVideo.connectLive();
						if(obj.hd == 0){
							liveVideo.isShowVideoTitle(0);
						}else{
							liveVideo.isShowVideoTitle(-1);
						}
					}else{
						liveVideo.endVideo();
					}
				}
			}
			if(_objBg){
				(_objBg[order] as LiveVideoBg).update();
			}
			if(_objFront){
				(_objFront[order] as LiveVideoFront).update();
			}
		}
		
		/**
		 * 声音状态改变 
		 * @param obj
		 * 
		 */		
		public function changeSoundStatus(obj:Object):void{
			var liveVideo:LiveVideo = getLiveVideo(obj.order);
			if(liveVideo){
				var order:Object = Context.variables.showData.order[liveVideo.micIndex];
				if(order){
					liveVideo.changeSoundStatus(order.isMute);
				}
				
			}
			if(_objBg){
				(_objBg[obj.order] as LiveVideoBg).update();
			}
		}
		
		/**
		 * 关闭视频 
		 * @param order
		 * 
		 */		
		public function endVideo(order:int):void{
			var liveVideo:LiveVideo = getLiveVideo(order);
			if(liveVideo){
				liveVideo.endVideo();
				liveVideo.isShowVideoTitle(-1);
			}
			if(_objBg){
				(_objBg[order] as LiveVideoBg).update();
			}
			if(_objFront){
				(_objFront[order] as LiveVideoFront).update();
			}
		}
		
		/**
		 * 声音改变 
		 * @param data
		 * 
		 */		
		public function onLiveVolumeChange(data:Object):void{
			var liveVideo:LiveVideo = getLiveVideoByIndex(data.index);
			if(liveVideo){
				var obj:Object = Context.variables.showData.order[liveVideo.micIndex];
				if(obj){
					liveVideo.onLiveVolumeChange(data.volumeNumber,obj.isMute);
				}
			}
		}
		
		/**
		 * 移动 
		 * @param data
		 * 
		 */		
		public function move(data:Object):void{
			var torder:int = data.torder;
			var sorder:int = data.sorder;
			if(sorder != 0 &&torder != 0){
				var sLiveVideo:LiveVideo = getLiveVideo(sorder);
				var tLiveVideo:LiveVideo = getLiveVideo(torder);
				
				sLiveVideo.move(torder);
				tLiveVideo.move(sorder);
				
				(_objBg[torder] as LiveVideoBg).update();
				(_objFront[torder] as LiveVideoFront).update();
				
				(_objBg[sorder] as LiveVideoBg).update();
				(_objFront[sorder] as LiveVideoFront).update();
				
				var tOrderObj:Object = Context.variables.showData.order[torder];
				var sOrderObj:Object = Context.variables.showData.order[sorder];
				if(tOrderObj){
					if(tOrderObj.masterId == Context.variables.showData.masterID){
						_pushVideo.move(torder);
					}
				}
				if(sOrderObj){
					if(sOrderObj.masterId == Context.variables.showData.masterID){
						_pushVideo.move(sorder);
					}
				}
				
			}
			
		}
		
		
		
		/**
		 * 更新Video显示数据 
		 * @param orderIndex
		 * 
		 */		
		public function updateVideoData(orderIndex:int):void{
			var order:Object = Context.variables.showData.order[orderIndex];
			if(order){
				if(_objBg){
					(_objBg[orderIndex] as LiveVideoBg).update();
				}
				if(_objFront){
					(_objFront[orderIndex] as LiveVideoFront).update();
				}
			}
		}
		
		public function hideCam():void{
			if(_pushVideo){
				Debugger.log(Debugger.INFO,"隐藏CamVideo");
				_pushVideo.hideCam();
			}
		}
		/**
		 * 上麦消息 传来
		 * @param data
		 * 
		 */		
		public function onPushData(data:Object):void{
			if(_pushVideo){
				if(Context.variables.showData.camInit){
					_pushVideo.startPush(data);
				}
			}
			if(_objBg){
				(_objBg[data.torder] as LiveVideoBg).update();
			}
			if(_objFront){
				(_objFront[data.torder] as LiveVideoFront).update();
			}
		}
		/**
		 * 重连推流 
		 * @param data
		 * 
		 */		
		public function videoRePush(data:Object):void{
			var order:Object = Context.variables.showData.order[_pushVideo.micIndex];
			if(order && order.masterId == Context.variables.showData.masterID){
				_pushVideo.videoRePush();
			}
		}
		/**
		 * 重连拉流
		 * @param data
		 * 
		 */		
		public function liveConnect(data:Object):void{
			var order:Object = Context.variables.showData.order;
			if(order){
				var liveVideo:LiveVideo = null;
				if(data && data.hasOwnProperty("index")){
					for(var i:int = 0;i < _objMid.length ; i++){
						liveVideo = _objMid[i];
						if(order[liveVideo.micIndex] != null){
							if(order[liveVideo.micIndex].masterId != Context.variables.showData.masterID){
								if(liveVideo.index == data.index){
									liveVideo.reConnectLive();
								}
							}
						}
					}
				}
			}
		}
		
		/**
		 * 清理Video画面 
		 * @param data
		 * 
		 */		
		public function clearLiveVideo(data:Object):void{
			var order:Object = Context.variables.showData.order;
			if(order){
				for(var i:int = 1;i <= 3 ; i++){
					var obj:Object = order[i];
					if(obj){
						if(obj.masterId == (data.user as UserData).id){
							var liveVideo:LiveVideo = getLiveVideo(i);
							liveVideo.clearVideo();
						}
					}
				}
			}
		}
		
		public function updateName(data:Object):void{
			var order:Object = Context.variables.showData.order;
			for(var i:int = 1;i <= 3 ; i++){
				var obj:Object = order[i];
				if(obj && obj.masterId == data.userId){
					obj.nickName = data.name;
					(_objBg[i] as LiveVideoBg).update();
				}
			}
			
		}
		
		/**
		 * 是否显示loading 
		 * @param data
		 * 
		 */		
		public function isShowLoading(data:Object):void{
			var order:Object = Context.variables.showData.order;
			if(order){
				var liveVideo:LiveVideo = null;
				if(data && data.hasOwnProperty("index")){
					if(data.hasOwnProperty("isShow")){
						for(var i:int = 0;i < _objMid.length ; i++){
							liveVideo = _objMid[i];
							if(order[liveVideo.micIndex] != null){
								if(order[liveVideo.micIndex].masterId == Context.variables.showData.masterID){
									liveVideo.isShowLoading(null);
								}else{
									if(liveVideo.index == data.index){
										liveVideo.isShowLoading(data);
									}else{
										liveVideo.isShowLoading(null);
									}
								}
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
							if(order[liveVideo.micIndex] != null){
								if(order[liveVideo.micIndex].masterId == Context.variables.showData.masterID){
									liveVideo.isShowLoading(null);
								}else{
									if(liveVideo.micIndex == data.micIndex){
										liveVideo.isShowLoading(data);
									}else{
										liveVideo.isShowLoading(null);
									}
								}
							}else{
								liveVideo.isShowLoading(null);
							}
							
						}
					}
				}
			}
		}
	}
}