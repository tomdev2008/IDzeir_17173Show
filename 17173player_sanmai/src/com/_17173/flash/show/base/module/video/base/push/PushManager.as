package com._17173.flash.show.base.module.video.base.push
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.Locale;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.layer.UIManager;
	import com._17173.flash.show.base.module.video.base.JSProxy;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;

	/**
	 * 推流交互中心 
	 * @author qiuyue
	 * 
	 */	
	public class PushManager
	{
		private var _e:IEventManager = null;
		private var _pushVideoManager:PushVideoManager =new PushVideoManager;
		/**
		 * 获取调度gslb
		 */		
		private var _gslbManager:PushGslbManager = null;
		private var _pushVideo:BaseVideo = new BaseVideo();
		/**
		 * 分发
		 */		
		private var _poManager:PlsOpenManager = new PlsOpenManager();
		private var _name:String ="";
		private var _liveId:String = "";
		
		/**
		 * gslb成功返回的数据 
		 */		
		private var object:Object = {};
		
		private var _veManager:VideoEquipmentManager = VideoEquipmentManager.getInstance();
		public function PushManager()
		{
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_e.listen(SEvents.CONNECT_STREAM_SUCCESS, connectStreamSucc);
		}

		/**
		 * liveId 
		 */
		public function get liveId():String
		{
			return _liveId;
		}

		/**
		 * @private
		 */
		public function set liveId(value:String):void
		{
			_liveId = value;
		}

		/**
		 * 流名 
		 */
		public function get name():String
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:String):void
		{
			_name = value;
		}

		/**
		 *  流管理类
		 */
		public function get pushVideoManager():PushVideoManager
		{
			return _pushVideoManager;
		}

		/**
		 * 视频显示
		 */
		public function get pushVideo():BaseVideo
		{
			return _pushVideo;
		}
		
		/**
		 * 获取推流IP
		 * @param e
		 * 
		 */		
		private function startGslb():void
		{
			Debugger.log(Debugger.INFO,"(PushVideo)","startGslb");
			if(_liveId != null){
				name = _liveId +"_" + new Date().time;
				_gslbManager = new PushGslbManager();
				_gslbManager.push(name,"","",gslbSuccess,gslbFail);
			}else{
				Debugger.log(Debugger.INFO,"PushVideo里LiveId为空");
			}
		}
		
		/**
		 * 清理
		 * 
		 */	
		public function clear():void{
			liveId = "";
			name = "";
			_pushVideoManager.stop();
			if(_pushVideo && _pushVideo.video){
				_pushVideo.video.clear();
				_pushVideo.video.attachCamera(null);
			}
			if(_veManager.isPluginSelected){
				JSProxy.getInstance().stopedPlugin();
			}
		}
		
		/**
		 * 开始入口 
		 * 
		 */		
		public function push():void{
			if(liveId != ""){
				Debugger.log(Debugger.INFO,"(PushVideo)开始调度");
				startGslb();
			}
		}
		
		/**
		 * 捕获Camera 
		 * 
		 */		
		public function attachCamera():void{
			if(_veManager.isPluginSelected){
				_pushVideo.video.attachCamera(_veManager.pluginCamera);
			}else{
				_pushVideo.video.attachCamera(_veManager.camera);
			}
		}

		/**
		 * 获取调度成功
		 * @param e
		 * 
		 */	
		private function gslbSuccess(data:Object):void
		{
			object = data;
			connectStream();
		}
		/**
		 * 获取调度失败
		 * @param e
		 * 
		 */	
		private function gslbFail():void
		{
			Debugger.log(Debugger.INFO,"获取调度失败");
		}
		
		/**
		 * 开始推流 
		 * 
		 */		
		private function connectStream():void
		{
			if(_veManager.isPluginSelected){
				JSProxy.getInstance().setStreamUrl(object.rtmpFullyUri);
			}else{
				initStream();
			}
		}
		
		/**
		 * 初始化CamManager
		 * 
		 */		
		private function initStream():void
		{
			var baseVideoData:PushVideoData = new PushVideoData;
			baseVideoData.connectionURL = object.connectionURL;
			baseVideoData.streamName = object.streamName;
			baseVideoData.liveId = _liveId;
			baseVideoData.optimal = 1;
			_pushVideoManager.init(baseVideoData);
		}
		
		/**
		 * pls_open
		 * @param data
		 * 
		 */		
		private function connectStreamSucc(data:Object):void
		{
			Debugger.log(Debugger.INFO,"(PushVideo)","发送分发请求pls_open");
			_poManager.open(_veManager.qualityIndex,name,object.key,object.hid,object.connectionURL,(_veManager.qualityIndex == 0)?_veManager.pluginVer:"",openSucc,openFail);
			
		}
		
		private function openSucc():void{
			Debugger.log(Debugger.INFO,"(PushVideo)","推流开始成功");
			_e.send(SEvents.SHOW_TIMER_PANEL);
		}
		
		private function openFail():void{
			Debugger.log(Debugger.INFO,"(PushVideo)","推流开始失败");
			var locale:Locale = Context.getContext(CEnum.LOCALE) as Locale;
			(Context.getContext(CEnum.UI) as UIManager).popupAlert(locale.get("tips","jsProxy"),locale.get("failPush","camModule"),-1,1);
		}
	}
}