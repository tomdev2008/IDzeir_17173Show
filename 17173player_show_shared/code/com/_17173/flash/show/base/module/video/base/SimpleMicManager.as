package com._17173.flash.show.base.module.video.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.net.URLVariables;
	
	public class SimpleMicManager implements IContextItem,IMicManager
	{
		private var _s:IServiceProvider = null;
		private var _e:IEventManager = null;
		
		public function SimpleMicManager()
		{
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_s.socket.listen(SEnum.R_SOUND_STATUS.action,SEnum.R_SOUND_STATUS.type, changeVolume);
			_s.socket.listen(SEnum.R_ENDVIDEO.action,SEnum.R_ENDVIDEO.type, endVideo);
			_s.socket.listen(SEnum.R_DUANLIU.action,SEnum.R_DUANLIU.type,duanliu);
			_s.socket.listen(SEnum.R_CAIJIFAIL.action,SEnum.R_CAIJIFAIL.type,caijiFail);
			
			_e.listen(SEvents.MIC_DOWN,micDown);
			_e.listen(SEvents.MIC_SOUND_CLOSE,micSoundClose);	
			_e.listen(SEvents.MIC_SOUND_OPEN,micSoundOpen);
			
		}
		public function get contextName():String{
			return CEnum.MICMANAGER;
		}
		
		public function startUp(param:Object):void{
			
		}
		
		public function micUp(data:Object):void{
			
		}
		/**
		 * 下麦 
		 * @param data
		 * 
		 */		
		public function micDown(data:Object):void{
			downMicToServer(1);
		}
		
		/**
		 * 闭麦 
		 * @param data
		 * 
		 */		
		public function micSoundClose(data:Object):void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo != null){
				if(liveInfo.isMute == 0){
					micSoundToServer(liveInfo.masterId);
				}
			}
		}
		
		/**
		 * 开麦 
		 * @param data
		 * 
		 */		
		public function micSoundOpen(data:Object):void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo != null){
				if(liveInfo.isMute == 1){
					micSoundToServer(liveInfo.masterId);
				}
			}
		}
		
		/**
		 * 上麦序 
		 * @param data
		 * 
		 */		
		public function micUpList(data:Object):void{
			
		}
		
		
		/**
		 * 下麦序 
		 * @param data
		 * 
		 */		
		public function micDownList(data:Object):void{
			
		}
		
		public function micChange(data:Object):void{
			
		}
		
		/**
		 * 断流 
		 * @param data
		 * 
		 */		
		private function duanliu(data:Object):void{
			_e.send(SEvents.VIDEO_BREAK_OFF,data);
		}
		
		private function caijiFail(data:Object):void{
			Debugger.log(Debugger.INFO,"(CamModule)","采集失败");
			_e.send(SEvents.IS_SHOW_LOADING,{"micIndex":1,"isShow":1});
			_e.send(SEvents.VIDEO_BREAK_OFF,data);
		}
		
		/**
		 * 闭麦或者开卖，是否有声音 
		 * @param data
		 * 
		 */		
		private function changeVolume(data:Object):void{
			
			var obj:Object = data.ct;
			var liveInfo:Object = Context.variables.showData.liveInfo;
			Debugger.log(Debugger.INFO,"(MicManager)","开闭麦",obj.masterId + "   isMute = "+obj.isMute);
			liveInfo.isMute = obj.isMute;
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
			obj["timestamp"]= obj.endTime;
			//obj.userId = obj.masterId;
			//obj.userName = obj.nickName;
			var liveInfo:Object = Context.variables.showData.liveInfo;
			
			Debugger.log(Debugger.INFO,"(MicManager)","下麦 masterId = "+obj.masterId);
			if(liveInfo){
				liveInfo.masterId = 0;
				liveInfo.liveId = 0;
				liveInfo.cId = 0;
				liveInfo.ckey = 0;
				liveInfo.nickName = "";
			}
			_e.send(SEvents.MIC_DOWN_MESSAGE,obj);
		}
		
		private function succ(data:Object):void{
			if(data.hasOwnProperty("msg")){
				Debugger.log(Debugger.INFO,data.msg);
			}
		}
		
		private function fail(data:Object):void{
			Debugger.log(Debugger.INFO,"提示"+data.msg);
			//			(Context.getContext(CEnum.UI) as UIManager).popupAlert("提示",data.msg);
		}
		
//		private function upMicToServer(userId:int,micIndex:int):void
//		{
//			var url:URLVariables = new URLVariables();
//			url["roomId"] = Context.variables.showData.roomID;
//			url["masterId"] = userId;
//			url["order"] = micIndex;
//			url["result"] = "json";
//			_s.http.getData(SEnum.MIC_UP, url, succ, fail);
//		}
//		
		private function downMicToServer(micIndex:int):void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo){
				var url:URLVariables = new URLVariables();
				//					url["roomId"] = Context.variables.showData.roomId;
				//					url["masterId"] = order.masterId;
				url["liveId"] = liveInfo.liveId;
				url["closeCode"] = 2;
				_s.http.getData(SEnum.MIC_DOWN, url, succ, fail);
			}
		}
		
		private function micSoundToServer(userId:int):void{
			var urlVa:URLVariables = new URLVariables();
			urlVa["roomId"] = Context.variables["roomId"];
			urlVa["masterId"] = userId;
			_s.http.getData(SEnum.MUTE_SOUND, urlVa, succ, fail);
		}
	}
}

