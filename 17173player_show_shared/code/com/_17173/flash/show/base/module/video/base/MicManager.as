package com._17173.flash.show.base.module.video.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.layer.UIManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.net.URLVariables;

	public class MicManager implements IContextItem,IMicManager
	{
		private var _s:IServiceProvider = null;
		private var _e:IEventManager = null;
		
		public function MicManager()
		{
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_s.socket.listen(SEnum.R_GETLIVEID.action,SEnum.R_GETLIVEID.type, changeOrder);
			_s.socket.listen(SEnum.R_SOUND_STATUS.action,SEnum.R_SOUND_STATUS.type, changeVolume);
			_s.socket.listen(SEnum.R_ENDVIDEO.action,SEnum.R_ENDVIDEO.type, endVideo);
			_s.socket.listen(SEnum.R_DUANLIU.action,SEnum.R_DUANLIU.type,duanliu);
			_s.socket.listen(SEnum.R_CAIJIFAIL.action,SEnum.R_CAIJIFAIL.type,caijiFail);
			
			_e.listen(SEvents.MIC_UP,micUp);
			_e.listen(SEvents.MIC_DOWN,micDown);
			_e.listen(SEvents.MIC_CHANGE,micChange);
			_e.listen(SEvents.MIC_SOUND_CLOSE,micSoundClose);	
			_e.listen(SEvents.MIC_SOUND_OPEN,micSoundOpen);
			_e.listen(SEvents.MIC_UP_LIST,micUpList);
			_e.listen(SEvents.MIC_DOWN_LIST,micDownList);
			_e.listen(SEvents.REQUEST_MAI_CLICK,requestClick);

		}
		public function get contextName():String{
			return CEnum.MICMANAGER;
		}
		
		public function startUp(param:Object):void{
			
		}
		
		/**
		 * 底栏按钮点击 
		 * @param data
		 * 
		 */		
		private function requestClick(data:Object):void{
			var user:User = Context.getContext(CEnum.USER) as User;
			var micStatus:int = user.getUserMicStatus(user.me.id);
//			麦序状态
			if(micStatus == 0){
//				是否摄像头初始化
				if(Context.variables.showData.camInit){
					micUpList(null);
				}else{
					(Context.getContext(CEnum.UI) as UIManager).popupAlert("", Context.getContext(CEnum.LOCALE).get("openCamer", "camModule"), -1,1);
				}
				
			}else if(micStatus == 1){
				micDownList({"userId":Context.variables.showData.masterID});
			}else{
				var micIndex:int = user.getMicIndex(user.me.id);
				if(micIndex != -1){
					micDown({"micIndex":micIndex})
				}
			}
		}
		
		/**
		 * 上麦 
		 * @param data
		 * 
		 */		
		public function micUp(data:Object):void{
				upMicToServer(data.userId,data.micIndex);
		}
		
		/**
		 * 下麦 
		 * @param data
		 * 
		 */		
		public function micDown(data:Object):void{
			var micIndex:int = data.micIndex;
			if(micIndex >= 1 && micIndex <= 3){
				var order:Object = Context.variables.showData.order[micIndex];
				if(order != null){
					downMicToServer(micIndex);
				}
			}
		}

		/**
		 * 切麦 
		 * @param data
		 * 
		 */		
		public function micChange(data:Object):void{
			var micIndex:int = data.micIndex;
			var userId:int = data.userId;
			if(micIndex >= 1 && micIndex <= 3){
				var order:Object = Context.variables.showData.order[micIndex];
				if(order != null){
					if(order.masterId == userId){
						changeMicToServer(userId, micIndex);
					}
				}
			}
		}
		
		/**
		 * 闭麦 
		 * @param data
		 * 
		 */		
		public function micSoundClose(data:Object):void{
			var micIndex:int = data.micIndex;
			var userId:int = data.userId;
			if(micIndex >= 1 && micIndex <= 3){
				var order:Object = Context.variables.showData.order[micIndex];
				if(order != null){
					if(order.isMute == 0){
						micSoundToServer(userId);
					}
				}
			}
		}
		
		/**
		 * 开麦 
		 * @param data
		 * 
		 */		
		public function micSoundOpen(data:Object):void{
			var micIndex:int = data.micIndex;
			var userId:int = data.userId;
			if(micIndex >= 1 && micIndex <= 3){
				var order:Object = Context.variables.showData.order[micIndex];
				if(order != null){
					if(order.isMute == 1){
						micSoundToServer(userId);
					}
				}
			}
		}
		
		/**
		 * 上麦序 
		 * @param data
		 * 
		 */		
		public function micUpList(data:Object):void{
			micIndexUpToServer();
		}
		
		
		/**
		 * 下麦序 
		 * @param data
		 * 
		 */		
		public function micDownList(data:Object):void{
			micIndexDownToServer(data.userId);
		}
		
		
		/**
		 * 断流 
		 * @param data
		 * 
		 */		
		private function duanliu(data:Object):void{
			Debugger.log(Debugger.INFO,"[MicManager]","断流，发送重连消息");
			_e.send(SEvents.VIDEO_BREAK_OFF,data);
		}
		
		/**
		 * 采集失败 
		 * @param data
		 * 
		 */		
		private function caijiFail(data:Object):void{
			Debugger.log(Debugger.INFO,"[MicManager]","采集失败,发送重连消息");
			_e.send(SEvents.IS_SHOW_LOADING,{"micIndex":data.order,"isShow":1});
			_e.send(SEvents.VIDEO_BREAK_OFF,data);
		}
		
		/**
		 * 闭麦或者开卖，是否有声音 
		 * @param data
		 * 
		 */		
		private function changeVolume(data:Object):void{
			
			var obj:Object = data.ct;
			obj["timestamp"]=data.timestamp;
			var orderList:Object = Context.variables.showData.order;
			Debugger.log(Debugger.INFO,"[MicManager]","开闭麦",obj.masterId + "静音状态 = "+obj.isMute,"麦序为"+ obj.order);
			orderList[obj.order].isMute = obj.isMute;
			_e.send(SEvents.MUTE_MESSAGE,obj);
		}
		
		/**
		 * 下麦Socket消息 
		 * @param data
		 * 
		 */		
		private function endVideo(data:Object):void{
			var iUser:IUser = Context.getContext(CEnum.USER) as IUser;
			var obj:Object = data.ct;
			obj["timestamp"]=data.timestamp;
			//obj.userId = obj.masterId;
			//obj.userName = obj.nickName;
			var order:Object = Context.variables.showData.order;
			if(obj.order >= 1 && obj.order <= 3){
				Debugger.log(Debugger.INFO,"[MicManager]","下麦  用户Id = "+obj.masterId," 麦序为 ="+ obj.order);
				for(var i:int = 1; i<=3; i++){
					var orderObj:Object = order[i];
					if(orderObj && orderObj.masterId == obj.masterId){
						order[i] = null;
					}
				}
//				if(order[obj.order] && order[obj.order].masterId == obj.masterId){
//					order[obj.order] = null;
//				}
				_e.send(SEvents.MIC_DOWN_MESSAGE,obj);
				_e.send(SEvents.UPDATE_MIC_DATA,iUser.orderArray());
			}
		}
		/**
		 * 上、切麦序消息 
		 * @param data 
		 * 
		 */		
		private function changeOrder(data:Object):void{
//			分4种，  上麦（麦上没人），上麦（麦上有人），切麦,下麦
			var iUser:IUser = (Context.getContext(CEnum.USER) as IUser);
			var obj:Object = data.ct;
			obj["timestamp"]=data.timestamp;
			var suserinfo:Object = obj.suserinfo;
			var tuserinfo:Object = obj.tuserinfo;
			var muserinfo:Object = obj.muserinfo;
			var order:Object = Context.variables.showData.order;
			Debugger.log(Debugger.INFO,"(MicManager)","上、切麦消息","obj.sth = "+obj.sth);
			if(obj.sth == 1){
				Debugger.log(Debugger.INFO,"(MicManager)","上、切麦消息","obj.smasterId =" + obj.smasterId ," obj.tmasterId =" + obj.tmasterId);
				if(obj.sorder != 0){
					if(obj.smasterId != 0){
						if(order[obj.sorder]){
							Debugger.log(Debugger.INFO,"obj.sorder = "+ order[obj.sorder].nickName);
						}
						if(order[obj.torder]){
							Debugger.log(Debugger.INFO,"obj.torder = "+ order[obj.torder].nickName);
						}
						var sorder:Object = order[obj.sorder];
						var torder:Object = order[obj.torder];
						order[obj.sorder] = torder;
						order[obj.torder] = sorder;
						_e.send(SEvents.CHANGE_MIC_MESSAGE,obj);
						_e.send(SEvents.UPDATE_MIC_DATA,iUser.orderArray());
						if(order[obj.sorder]){
							Debugger.log(Debugger.INFO,"obj.sorder = "+ order[obj.sorder].nickName);
						}
						if(order[obj.torder]){
							Debugger.log(Debugger.INFO,"obj.torder = "+ order[obj.torder].nickName);
						}
					}else{
						Debugger.log(Debugger.INFO,"(MicManager)","上、切麦消息","要上麦的目标为空，obj.sorder = " + obj.sorder +"  obj.smasterId ="+ obj.smasterId);
					}
					
				}else{
					Debugger.log(Debugger.INFO,"(MicManager)","上、切麦消息","麦序的order 为" + obj.sorder);
				}
			}else{
//				 上麦
				Debugger.log(Debugger.INFO,"(MicManager)","上、切麦消息","obj.smasterId = "+obj.smasterId," obj.sliveId =" + obj.sliveId);
				if(obj.smasterId != 0){
					var torderObj:Object = order[obj.torder];
					if(!torderObj){
						torderObj = new Object();
					}
//					麦上有人
					if(obj.tmasterId != 0){
						torderObj = new Object();
					}
					torderObj.isMute = obj.isMute;
					torderObj.liveId = obj.sliveId;
					torderObj.masterId = obj.smasterId;
					torderObj.masterNo = obj.smasterNo;
					torderObj.nickName = obj.snickName;
					torderObj.cId = obj.scId;
					torderObj.hd = obj.hd;
//					torder为目标位置
					order[obj.torder] = torderObj;	
//					(Context.getContext(CEnum.USER) as IUser).addUserFromData({"userId":obj.smasterId, "micStatus":2});
					_e.send(SEvents.MIC_UP_MESSAGE,obj);
					_e.send(SEvents.UPDATE_MIC_DATA,iUser.orderArray());
				}else{
					Debugger.log(Debugger.INFO,"(MicManager)","上、切麦消息","要上麦的目标为空，obj.sorder = " + obj.sorder +"  obj.smasterId ="+ obj.smasterId);
				}
			}
			var chatData:Object = new Object;
//			切麦为2，抢麦为1，抱麦为0   切麦时，sorder和torder 都要用，抱麦和抢麦都用torder属性
			if(obj.sth == 1){
				chatData.type = 2;
				if(tuserinfo == null){
					chatData.type = 0;
				}
			}else{
				if(obj.tmasterId != 0){
					chatData.type = 1;
				}else{
					chatData.type = 0;
				}
			}
			chatData.sorder = obj.sorder;
			chatData.torder = obj.torder;
			if(suserinfo){
				chatData.suserinfo = obj.suserinfo;
			}else{
				if(obj.smasterId != "0"){
					suserinfo = new Object();
					suserinfo.userId = obj.smasterId;
					suserinfo.name = obj.snickName;
					chatData.suserinfo = suserinfo;
				}
			}
			if(tuserinfo){
				chatData.tuserinfo = obj.tuserinfo;
			}else{
				if(obj.tmasterId != "0"){
					tuserinfo = new Object();
					tuserinfo.userId = obj.tmasterId;
					tuserinfo.name = obj.tnickName;
					chatData.tuserinfo = tuserinfo;
				}
			}
			if(muserinfo){
				chatData.muserinfo = obj.muserinfo;
			}else{
				if(obj.masterId != "0"){
					muserinfo = new Object();
					muserinfo.userId = obj.masterId;
					muserinfo.name = obj.nickName;
					chatData.muserinfo = muserinfo;
				}
			}
			chatData["timestamp"]=data.timestamp;
			Debugger.log(Debugger.INFO,"[MicManager]","发送上切麦消息给聊天");
			_e.send(SEvents.UPDATE_MIC_MESSAGE,chatData);
		}
		
		private function succ(data:Object):void{
			if(data.hasOwnProperty("msg")){
				Debugger.log(Debugger.INFO, "[MicManager]", "成功提示"+data.msg);
			}
		}
		
		private function fail(data:Object):void{
			Debugger.log(Debugger.INFO, "[MicManager]", "失败提示"+data.msg);
		}
			
		private function upMicToServer(userId:int,micIndex:int):void
		{
			Debugger.log(Debugger.INFO, "[MicManager]", "上麦消息", "userId = "+userId, "麦为"+micIndex);
			var url:URLVariables = new URLVariables();
			url["roomId"] = Context.variables.showData.roomID;
			url["masterId"] = userId;
			url["order"] = micIndex;
			url["result"] = "json";
			_s.http.getData(SEnum.MIC_UP, url, succ, fail);
		}
		
		private function downMicToServer(micIndex:int):void{
			if(micIndex >= 1 && micIndex <= 3){
				var order:Object = Context.variables.showData.order[micIndex];
				if(order){
					var url:URLVariables = new URLVariables();
					if(!Utils.validate(order,"liveId"))
					{
						throw new Error("order数据错误："+this+" liveId不存在或者为null")
					}
					url["liveId"] = order.liveId;
					url["closeCode"] = 2;
					Debugger.log(Debugger.INFO, "[MicManager]", "下麦消息", "liveId = "+order.liveId);
					_s.http.getData(SEnum.MIC_DOWN, url, succ, fail);
				}
			}
		}
		
		private function micIndexDownToServer(userId:int):void{
			Debugger.log(Debugger.INFO, "[MicManager]", "发送下麦序消息","userId ="+userId);
			var url:URLVariables = new URLVariables();
			url["roomId"] = Context.variables.showData.roomID;
			url["result"] = "json";
			url["masterId"] = userId;
			_s.http.getData(SEnum.MIC_INDEX_DOWN, url, succ, fail);
		}
		
		private function micIndexUpToServer():void{
			Debugger.log(Debugger.INFO, "[MicManager]", "发送上麦序消息");
			var url:URLVariables = new URLVariables();
			url["roomId"] = Context.variables.showData.roomID;
			_s.http.getData(SEnum.MIC_INDEX_UP, url, succ, fail);
		}
		
		
		
		private function changeMicToServer(userId:int,micIndex:int):void{
			Debugger.log(Debugger.INFO, "[MicManager]", "发送切麦序消息", "userId ="+userId, "micIndex ="+micIndex);
			var url:URLVariables = new URLVariables();
			url["roomId"] = userId;
			url["order"] = micIndex;
			url["result"] = "json";
			_s.http.getData(SEnum.MIC_UP, url, succ, fail);
		}
		
		private function micSoundToServer(userId:int):void{
			Debugger.log(Debugger.INFO, "[MicManager]", "发送开闭麦消息", "userId ="+userId);
			var urlVa:URLVariables = new URLVariables();
			urlVa["roomId"] = Context.variables["roomId"];
			urlVa["masterId"] = userId;
			urlVa["result"] = "json";
			_s.http.getData(SEnum.MUTE_SOUND, urlVa, succ, fail);
		}
	}
}