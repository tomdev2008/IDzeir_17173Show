package com._17173.flash.show.base.module.video
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.module.BaseModuleDelegate;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	
	
	
	
	
	

	/**
	 * 拉流代理类 
	 * @author qiuyue
	 * 
	 */	
	public class VideoDelegate extends BaseModuleDelegate
	{
		/**
		 * liveModule 
		 */		
		private var _iVideoModule:IVideoModule = null;
		/**
		 * 待执行任务列表 
		 */		
		private var _taskArray:Array = null;
		public function VideoDelegate(){
			super();
			_taskArray = new Array();
			_s.socket.listen(SEnum.R_STARTPUSH.action, SEnum.R_STARTPUSH.type, onLiveData);
			//_s.socket.listen(SEnum.R_RENAME.action, SEnum.R_RENAME.type, updateName);
//			//用户退出房间
//			_s.socket.listen(SEnum.R_USER_EXIT.action, SEnum.R_USER_EXIT.type, onUserExit);
//			//用户登陆
//			_s.socket.listen(SEnum.R_USER_ENTER.action, SEnum.R_USER_ENTER.type, onUserEnter);
			
			_e.listen(SEvents.USER_EXIT, onUserExit);
			_e.listen(SEvents.USER_ENTER, onUserEnter);
			_e.listen(SEvents.USER_NAME_UPDATE,updateName);
			
			_e.listen(SEvents.MIC_UP_MESSAGE,micUpMessage);
			_e.listen(SEvents.MIC_DOWN_MESSAGE,endVideo);
			_e.listen(SEvents.CHANGE_MIC_MESSAGE,changeMicMesage);
			_e.listen(SEvents.MUTE_MESSAGE,changeVolume);
			_e.listen(SEvents.ON_LIVE_VOLUME_CHANGE,onLiveVolumeChange);
			_e.listen(SEvents.VIDEO_BREAK_OFF,videoBreakOff);
			_e.listen(SEvents.IS_SHOW_LOADING,isShowLoading);
			_e.listen(SEvents.VIDEO_RE_PUSH,videoRePush);
			_e.listen(SEvents.UPDATE_SOUND_STATUS,changeVolume);
			_e.listen(SEvents.LIVE_VIDEO_CONNECT,liveConnect);
			isPopClose();
		}
		
		/**
		 * 用户退出房间. 
		 */		
		private function onUserExit(data:Object):void {
			if(module != null){
				clearLiveVideo(data);
				_iVideoModule.onUserExit(data);
				
			}
		
			
		}
		/**
		 * 用户登陆房间. 
		 */		
		private function onUserEnter(data:Object):void {
			if(module != null){
				_iVideoModule.onUserEnter(data);
			}
		}
		
		
		/**
		 *关闭游览器时检测是否可以关闭 
		 * 
		 */		
		public function isPopClose():void{
			JSBridge.addCall("isPopClose", null, null, function():Boolean{
				var user:IUser = Context.getContext(CEnum.USER) as IUser;
				if(user.getMicIndex(user.me.id) != -1){
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
				_iVideoModule.clearLiveVideo(data);
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
				_iVideoModule.videoRePush(data);
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
				_iVideoModule.liveConnect(data);
			}
			
		}
		
		/**
		 * 显示loading 
		 * @param data
		 * 
		 */		
		private function isShowLoading(data:Object):void{
			if(module == null){
				load();
				pushTask(isShowLoading,data);
			}else{
				_iVideoModule.isShowLoading(data);
			}
			
		}
		
		private function micUpMessage(data:Object):void{
			Debugger.log(Debugger.INFO,"(LiveDelegate)","上麦消息");
			if(data.tmasterId != 0){
				if(data.tmasterId == Context.variables.showData.masterID){
					Debugger.log(Debugger.INFO,"(LiveDelegate)","上麦消息，结束直播");
					_iVideoModule.hideCam();
				}
			}
			if(data.smasterId != 0){
				if(data.smasterId == Context.variables.showData.masterID){
					Debugger.log(Debugger.INFO,"(LiveDelegate)","上麦消息，开始推流");
					_iVideoModule.endVideo(data.torder);
					_iVideoModule.onPushData(data);
				}
			}
			if(data.tmasterId != 0 && data.smasterId != 0){
				if(data.smasterId != Context.variables.showData.masterID && data.tmasterId != Context.variables.showData.masterID){
					_iVideoModule.endVideo(data.torder);
				}
			}
			_iVideoModule.updateVideoData(data.torder);
		}
		
		/**
		 * 断流 
		 * @param data
		 * 
		 */		
		private function videoBreakOff(data:Object):void{
			var masterId:int = data.ct.masterId;
			var order:int = data.ct.order;
			if(masterId == Context.variables.showData.masterID){
				var orderObj:Object = Context.variables.showData.order[order];
				if(orderObj && orderObj.masterId == masterId){
					Debugger.log(Debugger.INFO,"(LiveDelegate)","videoBreakOff");
					_e.send(SEvents.VIDEO_RE_PUSH);
				}
			}
		}
		/**
		 * 切麦 
		 * @param data
		 * 
		 */		
		private function changeMicMesage(data:Object):void{
			if(data.torder != 0 && data.sorder != 0){
				_iVideoModule.move(data);
			}
		}

		override protected function onModuleLoaded():void{
			// TODO Auto Generated method stub
			super.onModuleLoaded();
			_iVideoModule = _swf as IVideoModule;
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
				var order:Object = Context.variables.showData.order;
				for(var i:int = 1; i<=3; i++){
					var orderObj:Object = order[i];
					if(orderObj == null){
						_iVideoModule.endVideo(i);
					}
				}
//				_iLiveModule.endVideo(data.order);
				if(data.masterId == Context.variables.showData.masterID){
					Debugger.log(Debugger.INFO,"(LiveDelegate)"," hideCam");
					_iVideoModule.hideCam();
				}
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
				var orderIndex:int = -1;
				//way  0是第一次直播 1是续播
				var order:Object = null;
				for(var i:int = 1;i<=3 ;i++){
					var orderObj:Object = Context.variables.showData.order[i];
					if(orderObj){
						if(orderObj.liveId == obj.liveId){
							order = orderObj;
							orderIndex = i;
						}
					}
				}
				if(order == null)
					order = new Object();
				order.cId  = obj.cId;
				order.ckey = obj.ckey;
				order.hd = obj.hd;
				order.liveId = obj.liveId;
				order.masterId = obj.masterId;
				order.masterNo = obj.masterNo;
				order.nickName = obj.nickName;
				order.cdnType = obj.cdnType;
				order.streamName = obj.streamName;
				Debugger.log(Debugger.INFO,"(LiveDelegate)","nickName = "+ obj.nickName," liveId =" +obj.liveId +" order= "+ orderIndex);
				if(orderIndex == -1){
					Debugger.log(Debugger.INFO,"麦序为-1，没找到对应的LiveId, liveId= "+ obj.liveId);
				}else{
					obj.order = orderIndex;
					Context.variables.showData.order[orderIndex] = order;
				}
				if(Context.variables.showData.masterID != obj.masterId){
					_iVideoModule.onLiveData(obj.order);
				}else{
					_iVideoModule.endVideo(obj.order);
				}
				obj.timestamp = data.timestamp;
				if(obj.way == 0){
					_e.send(SEvents.PUSH_VIDEO_START,obj);
				}
				var iUser:IUser = Context.getContext(CEnum.USER) as IUser;
				_e.send(SEvents.UPDATE_MIC_DATA,iUser.orderArray());
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
				_iVideoModule.changeSoundStatus(data);
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
				_iVideoModule.onLiveVolumeChange(data);
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
				_iVideoModule.updateName(data.ct);
			}
		}
	}
}