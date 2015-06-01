package com._17173.flash.show.base.module.video.base
{
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.Locale;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.layer.UIManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.external.ExternalInterface;
	
	public class JSProxy
	{
		private var jsCb:String = "";
		
		private var _volume:int = 0;
		private static var _instance:JSProxy = null;
		
		private var _e:IEventManager;
		
		public function JSProxy() 
		{
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			jsCb = Context.variables.objectName;
		}
		
		public function get volume():int
		{
			return _volume;
		}

		public function set volume(value:int):void
		{
			_volume = value;
		}

		public function init():void{
			addListener();
			JSBridge.addCall(jsCb + ".player");
		}
		
		private function addListener():void{
			onRegister();
			ready();
		}
		public static function getInstance():JSProxy{
			if(_instance == null){
				_instance = new JSProxy();
			}
			return _instance;
		}
		
		public function onRegister():void
		{
			if (ExternalInterface.available) {
				Debugger.log(Debugger.INFO,"[JSProxy]","注册js方法");
				JSBridge.addCall("pushStream", null, null, pushStream,true);
				JSBridge.addCall("stopStream", null, null, stopStream,true);
				JSBridge.addCall("pluginMsg", null, null, pluginMsg,true);
				JSBridge.addCall("setShowStatus", null, null, setShowStatus,true);
				JSBridge.addCall("setFlashXData", null, null, setFlashXData,true);
				JSBridge.addCall("volumeNumber", null, null, volumeNumber,true);
			}
		}
		
		public function volumeNumber(number:int):void{
			this.volume = number;
		}
		
		public function pushStream(obj:Object):void 
		{
			
		}
		
		public function stopStream():void 
		{
			Debugger.log(Debugger.INFO,"[JSProxy]","js返回停止流");
			stopedPlugin();
		}
		
		/**
		 * 插件返回状态
		 * A0001	摄像头检测结果
		 * A0002	插件推流结果
		 * A0003	异常段流	无res
		 * A0004	摄像头释放结果
		 * A0005	摄像头启动结果
		 * 
		 * @param	code	状态码
		 * @param	res		结果：1为成功，0为失败
		 * @param   pluginResult 插件返回code
		 */
		public function pluginMsg(code:String, result:String, pluginResult:String):void {
			var res:Boolean = Boolean(parseInt(result));
			Debugger.log(Debugger.INFO,"[JSProxy]","插件返回状态", code, res, pluginResult);
			var locale:Locale = Context.getContext(CEnum.LOCALE) as Locale;
			switch(code){
				case "A0001":
					
					break;
				case "A0002":
					if(res){
						_e.send(SEvents.CONNECT_STREAM_SUCCESS);
					}else{
						
						(Context.getContext(CEnum.UI) as UIManager).popupAlert(locale.get("tips", "jsProxy"), locale.get("camFail", "jsProxy"));
					}
					break;
				case "A0003":
					(Context.getContext(CEnum.UI) as UIManager).popupAlert(locale.get("tips", "jsProxy"), locale.get("socketFail", "jsProxy"),-1,3);
					break;
				case "A0004":
					if(res){
						_e.send(SEvents.CHANGE_CAMERA);
					}else{
						var alert:Alert = new Alert(locale.get("tips", "jsProxy"), locale.get("stopfail", "jsProxy"),-1,1,okFun);
						alert.showCloseBtn = false;
						(Context.getContext(CEnum.UI) as UIManager).popupAlertPanel(alert);
//						(Context.getContext(CEnum.UI) as UIManager).popupAlert(locale.get("tips", "jsProxy"), locale.get("stopfail", "jsProxy"),-1,1,okFun);
					}
					break;
				case "A0005":
					if(res){
						_e.send(SEvents.CHANGE_CAMERA);
					}else{
						var error:Alert = new Alert(locale.get("tips", "jsProxy"), locale.get("setFail", "jsProxy"),-1, 1, okFun);
						error.showCloseBtn = false;
						(Context.getContext(CEnum.UI) as UIManager).popupAlertPanel(error);
//						(Context.getContext(CEnum.UI) as UIManager).popupAlert();
					}
					break;
			}
		}
		
		private function okFun():void{
			_e.send(SEvents.RESET_PREVIEW);
		}
		
		/**
		 * 
		 * @param	code	状态码	A系列表示采集器	B系列表示直播播放器
		 * 
		 * A0001	上麦序		显示：等待上麦
		 * A0002	下麦序
		 * B0001	没有直播 ：房间未开启状态时显示
		 * B0002	窗口闲置 ：房间开启无人上麦时显示
		 * B0003	缓冲中 ：  加载视频流时显示
		 * B0004	等待主播开始： 抱麦的过程中，断流，断网， 主播未开始等情况时显示。
		 */
		public function setShowStatus(code:String):void
		{
			Debugger.log(Debugger.INFO,"setShowStatus:", code);
			switch (code) {
				case "A0001":
					break;
				case "A0002":
					break;
			}
		}
		/**
		 * 插件信息 
		 * @param obj
		 * 
		 */		
		public function setFlashXData(obj:Object):void{
			Debugger.log(Debugger.INFO,"[JSProxy]","插件flash状态","obj.isFlashX" + obj.isFlashX,"obj.virtualCamName" +obj.virtualCamName, "obj.pluginVer"+obj.pluginVer,"obj.isFlashXDown" + obj.isFlashXDown,"obj.flashXUrl" + obj.flashXUrl);
			_e.send(SEvents.PLUGIN_DATA,obj);
		}
		/**
		 * 发送摄像头名字和mic名字 
		 * 
		 */		
		public function setMediaName(cameraName:String, micName:String):void
		{
			Debugger.log(Debugger.INFO,"[JSProxy]", "发送名字给插件，摄像头名字"+cameraName, "麦克风名字"+micName);
			JSBridge.addCall(jsCb + ".setMediaName", {"camName":cameraName, "audioName":micName});
		}
		/**
		 * 发给插件摄像头 streamName 
		 * @param name
		 * 
		 */		
		public function setStreamUrl(name:String):void {
			Debugger.log(Debugger.INFO,"[JSProxy]" ,"发送流地址，地址为："+name);
			JSBridge.addCall(jsCb+".setStreamUrl", {"name":name});
		}
		
		/**
		 * 通知 js 用户要切换摄像头
		 * @param needRelease		0 插件需要释放，1 为不需要释放
		 * 
		 */		
		public function releasePlugin(isRelease:Boolean):void
		{
			Debugger.log(Debugger.INFO,"[JSProxy]", "插件摄像头切换",(isRelease?0:1));
			JSBridge.addCall(jsCb+".setCam", {"cam":(isRelease?0:1)});
		}
		
		private function ready():void
		{
			JSBridge.addCall(jsCb + ".ready");
		}
		
		public function stopedPlugin():void
		{
			Debugger.log(Debugger.INFO,"[JSProxy]", "发送插件流停止");
			JSBridge.addCall(jsCb + ".stopFlashX");
		}
	}

}