package com._17173.flash.show.base.module.video.base.push
{
	import com._17173.flash.core.components.common.Alert;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.Locale;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.module.video.base.JSProxy;
	import com._17173.flash.show.base.module.video.base.SeniorSupport;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundCodec;
	import flash.media.SoundTransform;
	import flash.net.NetStream;

	public class VideoEquipmentManager
	{	
		private static var _instance:VideoEquipmentManager = null;
		private var _senior:SeniorSupport = new SeniorSupport();
		private var _e:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
		
		public static const HIGHMAX:int = 54000;
		public static const HIGHMIN:int = 34000;
		
		public static const LOWMAX:int = 34000;
		public static const LOWMIN:int = 20000;
		/**
		 * 麦克风 
		 */		
		private var _mic:Microphone;
		/**
		 * 麦克风名字 
		 */		
		private var _micName:String;
		/**
		 * 摄像头 
		 */		
		private var _camera:Camera;
		/**
		 * 摄像头名字 
		 */		
		private var _cameraName:String;
		/**
		 * 摄像头数据 
		 */		
		private var _cameraData:CameraData = null;
		/**
		 * 麦克风数据 
		 */		
		private var _micData:MicData = null;
		/**
		 * 清晰度 0为插件高清，1为非插件高清，2为非插件标清 
		 */		
		private var _qualityIndex:int = 0;
		/**
		 * 是否使用插件 
		 */		
		private var _isUsePlugin:Boolean;
		/**
		 * 插件版本号 
		 */		
		private var _pluginVer:String ="";
		/**
		 * 插件摄像头名字 
		 */		
		private var _pluginCameraName:String;
		/**
		 * 插件摄像头 
		 */		
		private var _pluginCamera:Camera;
		/**
		 * 插件Id 
		 */		
		private var _pluginCamId:int = -1;
		/**
		 * 是否有插件   0是普通，1是插件,2是新插件
		 */		
		private var _isFlashX:int = 0;
		
		/**
		 * 是否可以下载插件  0是不可下载， 1是可下载
		 */
		private var _isFlashXDown:int = 0;
		
		/**
		 * 插件下载地址 
		 */
		private var _flashXUrl:String = "";
		
		public function VideoEquipmentManager()
		{
			_e.listen(SEvents.PLUGIN_DATA,pluginData);
			_e.listen(SEvents.BANDWIDTH_CHANGE,changeBandWidth);
		}

		
		public function get flashXUrl():String
		{
			return _flashXUrl;
		}

		/**
		 * @private
		 */
		public function set flashXUrl(value:String):void
		{
			_flashXUrl = value;
		}

		public function get isFlashXDown():int
		{
			return _isFlashXDown;
		}

		/**
		 * @private
		 */
		public function set isFlashXDown(value:int):void
		{
			_isFlashXDown = value;
		}

		public function get isFlashX():int
		{
			return _isFlashX;
		}
		
		public function set isFlashX(value:int):void
		{
			_isFlashX = value;
		}
		
		public function get pluginCamera():Camera
		{
			return _pluginCamera;
		}

		public function set pluginCamera(value:Camera):void
		{
			_pluginCamera = value;
		}

		public function get pluginCameraName():String
		{
			return _pluginCameraName;
		}

		public function set pluginCameraName(value:String):void
		{
			_pluginCameraName = value;
		}

		public function get pluginVer():String
		{
			return _pluginVer;
		}

		public function set pluginVer(value:String):void
		{
			_pluginVer = value;
		}

		public function get isUsePlugin():Boolean
		{
			return _isUsePlugin;
		}

		public function set isUsePlugin(value:Boolean):void
		{
			_isUsePlugin = value;
		}

		public function get qualityIndex():int
		{
			return _qualityIndex;
		}

		public function set qualityIndex(value:int):void
		{
			_qualityIndex = value;
		}

		public function get cameraName():String
		{
			return _cameraName;
		}

		public function set cameraName(value:String):void
		{
			_cameraName = value;
		}

		public function get camera():Camera
		{
			return _camera;
		}

		public function set camera(value:Camera):void
		{
			_camera = value;
		}

		public function get micName():String
		{
			return _micName;
		}

		public function set micName(value:String):void
		{
			_micName = value;
		}

		public function get mic():Microphone
		{
			return _mic;
		}

		public function set mic(value:Microphone):void
		{
			_mic = value;
		}

		public static function getInstance():VideoEquipmentManager{
			if(_instance == null){
				_instance = new VideoEquipmentManager();
			
			}
			return _instance;
		}
		
		private function changeBandWidth(data:Object):void{
			var number:int = cameraData.bandwidth + (data as int);
			if(qualityIndex == 1){
				if(number >= HIGHMAX){
					number = HIGHMAX;
				}
				if(number <= HIGHMIN){
					number = HIGHMIN;
				}
				cameraData.bandwidth = number;
				cameraData.quality = 0;
			}
			updateCamrea();
//			if(qualityIndex == 2){
//				if(number >= BandWidthListener.LOWMAX){
//					number = BandWidthListener.LOWMAX;
//				}
//				if(number <= BandWidthListener.LOWMIN){
//					number = BandWidthListener.LOWMIN;
//				}
//			}
			
		}
		
		/**
		 * 更新插件信息 
		 * @param info
		 * 
		 */		
		public function updatePlugin(info:Object):void{
			isFlashX  = info.isFlashX;
			pluginCameraName = info.virtualCamName;
			pluginVer = info.pluginVer;
			isFlashXDown = info.isFlashXDown;
			flashXUrl = info.flashXUrl;
			
		}
		
		/**
		 * 输出音量值 
		 * @return 
		 * 
		 */		
		public function getActivityLevel():int{
			if(mic){
				return mic.activityLevel;
			}
			return 0;
		}
		
		/**
		 * 设置插件Camera 
		 * @return 返回插件index
		 * 
		 */		
		public function setPlugunCamera():void{
			if(isFlashX != 0){
				_pluginCamId = Camera.names.indexOf(pluginCameraName);
				if (_pluginCamId < 0) {
					var locale:Locale = Context.getContext(CEnum.LOCALE);
					(Context.getContext(CEnum.UI) as IUIManager).popupAlert(locale.get("tips", "jsProxy"), locale.get("reBrowser", "jsProxy"), -1, Alert.BTN_OK);
				}else{
					pluginCamera = Camera.getCamera(String(_pluginCamId));
					pluginCamera.setMode(64000, 48000, 30, false);
					pluginCamera.setLoopback(false);
					pluginCamera.setMotionLevel(0, 0);	
					Debugger.log(Debugger.INFO,"插件摄像头宽高为",pluginCamera.width,pluginCamera.height);
				}
			}
		}
		
		/**
		 * 设置Camera
		 * @param camName 摄像头名字
		 * @return 是否有摄像头存在
		 * 
		 */		
		public function setCamera(camName:String):Boolean{
			var camIndex:int = Camera.names.indexOf(camName);
			if(camIndex == -1) {
				return false;
			}
			cameraName = camName;
			camera = Camera.getCamera(String(camIndex));
			Debugger.log(Debugger.INFO,"camera = "+camera);
			camera.setMode(cameraData.cWidth, cameraData.cHeight, cameraData.fps, false);
			updateCamrea();
			return true;
		}
		
		/**
		 * 设置Camera清晰度 
		 * @param bool
		 * 
		 */		
		public function setQulityMode(bool:Boolean):void{
			isUsePlugin = false;
			if (bool) {
				cameraData.def = CameraData.DEF_NORMAL;
			} else {
				cameraData.def = CameraData.DEF_LOW;
			}
			camera.setMode(cameraData.cWidth, cameraData.cHeight, cameraData.fps, false);
			updateCamrea();
		}
		
		public function get cameraData():CameraData {
			if (!_cameraData) {
				_cameraData = new CameraData();
			}
			return _cameraData;
		}
		
		/**
		 * 更新Camera配置数据 
		 * @param cameraData
		 * 
		 */		
		public function updateCamrea():void {
			if (Context.variables["c"]) {
				Debugger.log(Debugger.INFO, "[settings]", "视频用url配置进行覆盖处理");
				_cameraData.updateByConfig(Context.variables["c"]);
			}
			camera.setLoopback(false);
			camera.setMotionLevel(0, 0);
			camera.setQuality(cameraData.bandwidth, cameraData.quality);
//			每隔多少帧有一个关键帧
			camera.setKeyFrameInterval(cameraData.keyFrameInterval);
		}
		
		public function get micData():MicData {
			if (_micData == null) {
				_micData = new MicData();
			}
			
			return _micData;
		}
		
		/**
		 * 更新Mic配置数据 
		 * @param micData
		 * 
		 */		
		public function updateMic():void {
			if (Context.variables["m"]) {
				Debugger.log(Debugger.INFO, "[settings]", "麦克风用url配置进行覆盖处理");
				micData.updateByConfig(Context.variables["m"]);
			}
			mic.codec = micData.codec;
			mic.rate = micData.rate;
//			mic.encodeQuality = 10;
//			mic.noiseSuppressionLevel = 20;
//			mic.setUseEchoSuppression(true);
//			mic.setLoopBack(true);
			
			mic.setUseEchoSuppression(true);
			mic.setLoopBack(false);
			mic.setSilenceLevel(micData.silenceLevel, micData.timeout);
			var st:SoundTransform = new SoundTransform();
			st.volume = micData.volume;
			mic.soundTransform = st;
			mic.gain = micData.gain;
			if (Context.variables.showData.supportEnhanceMic()) {
				_senior.setEnhanceMic(mic);
			}
		}
		/**
		 * 设置Mic 
		 * @param micName 麦克风名字
		 * @return 是否存在麦克风
		 * 
		 */		
		public function setMic(micName:String):Boolean{
			var micIndex:int = Microphone.names.indexOf(micName);
			if(micIndex == -1){
				return false;
			}
			mic = Microphone.getEnhancedMicrophone(micIndex);
			if(mic == null){
				Debugger.log(Debugger.INFO,"增加麦克风调用失败，改为调用普通麦克风");
				mic = Microphone.getMicrophone(micIndex);
			}
			if (mic) {
				this.micName = micName;
			}
			updateMic();
			return true;
		}
		
		/**
		 * 返回stream data 
		 * @return 
		 * 
		 */		
		public function getStreamData():Object{
			var obj:Object = new Object;
			obj.ac = getAudioCodecId(mic.codec);
			obj.ar = mic.rate * 1000;
			obj.fr = camera.fps;
			obj.vc = (_senior ? _senior.getVideoCodecId() : -1);
			obj.wd = (camera.width);
			obj.ht = (camera.height);
			obj.dr = Math.floor((camera.bandwidth) * 8 / 1000);
			return obj;
		}
		
		/**
		 * 是否使用能插件摄像头 
		 * 
		 */		
		public function isSetPluginCamera():void{
			if(isFlashX != 0){
				if(_pluginCamId < 0){
					isUsePlugin = false;
				}else{
					isUsePlugin = true;
					JSProxy.getInstance().setMediaName(cameraName, micName);
					JSProxy.getInstance().releasePlugin(false);
				}
			}else{
				isUsePlugin = false;
			}
		}
		/**
		 * 是否选择插件 
		 * @return 
		 * 
		 */		
		public function get isPluginSelected():Boolean{
			return isFlashX != 0 && isUsePlugin;
		}
		
		/**
		 * stream H264 
		 * @param stream
		 * @return 
		 * 
		 */		
		public function setH264(stream:NetStream):NetStream{
			return _senior.setH264(stream);
		}
		
		private function pluginData(data:Object):void{
			updatePlugin(data);
			setPlugunCamera();
		}
		/**
		 * 音频解码器对应的ac数值
		 * @param codecName
		 * @return 
		 * 
		 */		
		private function getAudioCodecId(codecName:String):int {
			var codecId:int = -1;
			switch(codecName){
				case SoundCodec.NELLYMOSER.toLocaleLowerCase():
					codecId = 6;
					break;
				case SoundCodec.SPEEX.toLocaleLowerCase():
					codecId = 11;
					break;
			}
			return codecId;
		}
	}
}