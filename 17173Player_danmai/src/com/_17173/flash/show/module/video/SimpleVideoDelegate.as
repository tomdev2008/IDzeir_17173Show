package com._17173.flash.show.module.video
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.EventManager;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.UserData;
	import com._17173.flash.show.base.module.stat.base.StatTypeEnum;
	import com._17173.flash.show.base.module.video.base.live.LiveVideoData;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;

	/**
	 * 拉流代理类 
	 * @author qiuyue
	 * 
	 */	
	public class SimpleVideoDelegate extends BaseModuleDelegate
	{
		/**
		 * liveModule 
		 */		
		//private var _iLiveModule:ISimpleVideoModule = null;
		/**
		 * 待执行任务列表 
		 */		
		private var _taskArray:Array = null;
		private var _exitData:Object;
		public function SimpleVideoDelegate(){
			super();
			_taskArray = new Array();
			_s.socket.listen(SEnum.R_STARTPUSH.action, SEnum.R_STARTPUSH.type, onLiveData);
			//20150306 需求变动不在 推送周星榜
//			_s.socket.listen(SEnum.WEEK_GIFT_STAR.action,SEnum.WEEK_GIFT_STAR.type,weekGiftStarHandler);
			//_s.socket.listen(SEnum.R_RENAME.action, SEnum.R_RENAME.type, updateName);
//			//用户退出房间
//			_s.socket.listen(SEnum.R_USER_EXIT.action, SEnum.R_USER_EXIT.type, onUserExit);
//			//用户登陆
//			_s.socket.listen(SEnum.R_USER_ENTER.action, SEnum.R_USER_ENTER.type, onUserEnter);
			
			_e.listen(SEvents.USER_EXIT, onUserExit);
			_e.listen(SEvents.USER_ENTER, onUserEnter);
			_e.listen(SEvents.USER_NAME_UPDATE,updateName);
			
			_e.listen(SEvents.MIC_DOWN_MESSAGE,endVideo);
			_e.listen(SEvents.MUTE_MESSAGE,changeVolume);
			_e.listen(SEvents.ON_LIVE_VOLUME_CHANGE,onLiveVolumeChange);
			_e.listen(SEvents.VIDEO_BREAK_OFF,videoBreakOff);
			_e.listen(SEvents.IS_SHOW_LOADING,isShowLoading);
			_e.listen(SEvents.VIDEO_RE_PUSH,videoRePush);
			_e.listen(SEvents.PHOTO_SHOW_MESSAGE,showPhoto);
			_e.listen(SEvents.OPENR_ROOM_SUCC,roomSucc);
			_e.listen(SEvents.UPDATE_SOUND_STATUS,changeVolume);
			_e.listen(SEvents.CHANGE_OL_VIDEO_PATH,changeOLVideo);
			_e.listen(SEvents.LIVE_VIDEO_CONNECT,liveConnect);
			isPopClose();
			
			
			
		}
		
		/**
		 * 用户退出房间. 
		 */		
		private function onUserExit(data:Object):void {
			if(module != null){
				//暂时不清理用户数据
				var cid:String = "-1";
				var exitId:String = (data.user as UserData).id;
				var liveInfo:Object = Context.variables.showData.liveInfo;
				if(liveInfo){
					cid = liveInfo.masterId;
				}
				if(Context.variables["debug"]){
					Debugger.log(Debugger.INFO,"[LiveDelegate]","用户退出房间，不清除视频","退出用户ID："+exitId+"当前主播ID："+cid+"");
				}
				if(exitId === cid){
					Debugger.log(Debugger.INFO,"[LiveDelegate]","主播退出房间退出房间，不清除视频","退出用户ID："+exitId+"当前主播ID："+cid+"");
					//延时清理主播流信息
					_exitData = data;
					//Ticker.tick(5000,onClear);
				}
//				clearLiveVideo(data);
				
				//_iLiveModule.onUserExit(data);
				this.module.data = {"onUserExit":[data]};
			}
		
		}
		/**
		 *延迟清理主播流数据 
		 * 
		 */		
		private function onClear():void
		{
			// TODO Auto Generated method stub
			try{
				if(_exitData){
					clearLiveVideo(_exitData);
				}
				_exitData = null;
			}catch(e:Error){
				Debugger.log(Debugger.INFO,"[LiveDelegate]","延迟清理主播视频信息错误");
			}
		}
		/**
		 * 用户登陆房间. 
		 */		
		private function onUserEnter(data:Object):void {
			//因为socket异常断开问题，所以做了主播推出房间，延迟清理主播视频策略，当主播推出房间后5秒内进入则取消清理方法
			if(_exitData){
				var enterId:String = (data.user as UserData).id;
				var liveInfo:Object = Context.variables.showData.liveInfo;
				var cid:String;
				if(liveInfo){
					cid = liveInfo.masterId;
				}
				if(cid == enterId){
					//取消清理方法
					_exitData = null;
				}
			}
			if(module != null){
				//_iLiveModule.onUserEnter(data);
				this.module.data = {"onUserEnter":[data]};
			}
		}
		
		/**
		 *关闭游览器时检测是否可以关闭 
		 * 
		 */		
		public function isPopClose():void{
			JSBridge.addCall("isPopClose", null, null, function():Boolean{
				var user:IUser = Context.getContext(CEnum.USER) as IUser;
				var iskick:int = Context.variables["isKick"];
				if(user.getMicIndex(user.me.id) != -1 && iskick == 0){
					return true;
				}
				return false;
			},true);
		}
		
		/**
		 * 清理Video画面 
		 * @param data
		 * 
		 */		
		private function clearLiveVideo(data:Object):void{
			if(module == null){
				load();
				pushTask(clearLiveVideo,data);
			}else{
				//_iLiveModule.clearLiveVideo(data);
				module.data = {"clearLiveVideo":[data]};
			}
		}
		
		/**
		 * 重连 
		 * @param data
		 * 
		 */		
		private function liveConnect(data:Object):void{
			if(module == null){
				load();
				pushTask(liveConnect,data);
			}else{
				//_iLiveModule.liveConnect(data);
				module.data = {"liveConnect":[data]};
			}
		
		}
		
		/**
		 * 切换离线录像 
		 * @param data
		 * 
		 */		
		private function changeOLVideo(data:Object):void{
			if(module == null){
				load();
				pushTask(changeOLVideo,data);
			}else{
				//_iLiveModule.changeOLVideo();
				module.data = {"changeOLVideo":null};
			}
		
		}
		
		/**
		 * 开启房间成功 
		 * @param data
		 * 
		 */		
		private function roomSucc(data:Object):void{
			if(module == null){
				load();
				pushTask(roomSucc,data);
			}else{
				//_iLiveModule.roomSucc(data);
				module.data = {"roomSucc":[data]};
			}
			
		}
		
		/**
		 * 显示照相界面 
		 * @param data
		 * 
		 */		
		private function showPhoto(data:Object):void{
			if(module == null){
				load();
				pushTask(showPhoto,data);
			}else{
				//_iLiveModule.showPhoto();
				module.data = {"showPhoto":null};
			}
		}
		
		/**
		 * 重新推流 
		 * @param data
		 * 
		 */		
		private function videoRePush(data:Object):void{
			if(module == null){
				load();
				pushTask(videoRePush,data);
			}else{
				//_iLiveModule.videoRePush(data);
				module.data = {"videoRePush":[data]};
			}
		
		}
		
		/**
		 * 是否显示loading 
		 * @param data
		 * 
		 */		
		private function isShowLoading(data:Object):void{
			if(module == null){
				load();
				pushTask(isShowLoading,data);
			}else{
				//_iLiveModule.isShowLoading(data);
				module.data = {"isShowLoading":[data]};
			}
		}
		
		/**
		 * 断流 
		 * @param data
		 * 
		 */		
		private function videoBreakOff(data:Object):void{
			var masterId:int = data.ct.masterId;
			if(masterId == Context.variables.showData.masterID){
				var liveInfo:Object = Context.variables.showData.liveInfo;
				if(liveInfo && liveInfo.masterId == masterId){
					_e.send(SEvents.VIDEO_RE_PUSH);
				}
			}
		}
		
		
		override protected function onModuleLoaded():void{
			super.onModuleLoaded();
			//_iLiveModule = _swf as ISimpleVideoModule;
			if(!_swf){			
				return;
			}
			while(_taskArray.length > 0){
				var obj:Object = _taskArray.shift();
				if(obj.hasOwnProperty("data")){
					obj.fun(obj.data);
				}else{
					obj.fun();
				}
			}
			//统计
			onStartBI();			
		}
		
		private function onStartBI():void{
			_e.send(SEvents.BI_STAT, {"type":StatTypeEnum.BI, "event":StatTypeEnum.EVENT_LOADED, "data":{}});
		}
		
		/**
		 * 加入待执行任务 
		 * @param fun 要执行的方法
		 * @param data 要执行方法的参数
		 * 
		 */		
		private function pushTask(fun:Function,data:Object = null):void{
			var obj:Object = new Object();
			obj.fun = fun;
			obj.data = data;
			_taskArray.push(obj);
		}
		/**
		 * 关闭视频 
		 * @param data 
		 * 
		 */		
		private function endVideo(data:Object):void{
			if(module == null){
				load();
				pushTask(endVideo,data);
			}else{
				//重置直播时间
				Context.variables.showData.roomInfo.masterLiveTime = "0";
				
				module.data = {"endVideo":null};
				if(data.masterId == Context.variables.showData.masterID){
					Debugger.log(Debugger.INFO,"(SimpleLiveModule)","关闭推流界面");
					module.data = {"hideCam":null};
				}
			}
		}
		
		/**
		 * 周礼物之星 
		 * @param data
		 * 
		 */		
		public function weekGiftStarHandler(data:Object):void
		{
			if(module == null){
				load();
				pushTask(weekGiftStarHandler,data);
			}else{
				module.data = {"updateWeekGiftStar":[data.ct]};
			}
		}
		
		/**
		 * 数据更新  
		 * @param data
		 * 
		 */		
		private function onLiveData(data:Object):void{
			Debugger.log(Debugger.INFO,"(LiveDelegate)","Start Push OnLiveData Update");
			if(module == null){
				load();
				pushTask(onLiveData,data);
			}else{
				var obj:Object = data.ct;
				var liveInfo:Object = Context.variables.showData.liveInfo;
				liveInfo.cId = data.ct.cId;
				liveInfo.ckey = data.ct.ckey;
				liveInfo.hd = data.ct.hd;
				liveInfo.liveId = data.ct.liveId;
				liveInfo.masterId = data.ct.masterId;
				liveInfo.masterNo = data.ct.masterNo;
				liveInfo.nickName = data.ct.nickName;
				liveInfo.time = data.ct.time;
				liveInfo.way = data.ct.way;
				liveInfo.isMute = data.ct.isMute;
				liveInfo.cdnType = data.ct.cdnType;
				liveInfo.streamName = data.ct.streamName;
				liveInfo.hd = data.ct.hd;
				Context.variables.showData.roomType = data.ct.liveType;
				if("masterLiveTime" in data.ct)
				    Context.variables.showData.roomInfo.masterLiveTime = data.ct.masterLiveTime;
				else
					Context.variables.showData.roomInfo.masterLiveTime = data.ct.time;
				if(liveInfo){
					if(liveInfo.liveId != 0){
						if(liveInfo.masterId != Context.variables.showData.masterID){
							if(data.ct.liveType != 0){
								Util.refreshPage();
							}else{
								module.data = {"onLiveData":[1]};
							}
						}else{
							module.data = {"endVideo":null};
						}
					}
				}
				obj.timestamp = data.timestamp;
				if(obj.way == 0){
					_e.send(SEvents.PUSH_VIDEO_START,obj);
				}
			}
		}
		
		/**
		 * 闭麦或者开卖，是否有声音 
		 * @param data
		 * 
		 */		
		private function changeVolume(data:Object):void{
			if(module == null){
				load();
				pushTask(changeVolume,data);
			}else{
				//_iLiveModule.changeSoundStatus(data);
				module.data = {"changeSoundStatus":[data]};
			}
		}
		
		/**
		 * 声音改变   
		 * @param data micIndex 麦序  volumeNumber 音量数字
		 * 
		 */		
		private function onLiveVolumeChange(data:Object):void{
			if(module == null){
				load();
				pushTask(onLiveVolumeChange,data);
			}else{
				//_iLiveModule.onLiveVolumeChange(data);
				module.data = {"onLiveVolumeChange":[data]};
			}
			
		}
		/**
		 * 更新名字 
		 * @param data
		 * 
		 */		
		private function updateName(data:Object):void{
			if(module == null){
				load();
				pushTask(updateName,data);
			}else{
				module.data = {"updateName":[data.ct]};
			}
		}
	}
}