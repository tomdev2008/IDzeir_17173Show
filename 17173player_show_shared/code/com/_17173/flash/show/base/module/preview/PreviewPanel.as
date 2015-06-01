package com._17173.flash.show.base.module.preview
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.authority.AuthorityStaitc;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.module.video.base.push.BaseVideo;
	import com._17173.flash.show.base.module.video.base.JSProxy;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import com._17173.flash.show.base.module.video.base.push.VideoEquipmentManager;
	
	/**
	 * 推流初始化 
	 * @author qiuyue
	 * 
	 */	
	public class PreviewPanel extends Sprite
	{
		private var _e:IEventManager = null;
		/**
		 * 选择摄像头界面
		 */		
		private var _selector:SelectorPanel = null;
		/**
		 * 视频显示
		 */		
		private var _previewVideo:BaseVideo = new BaseVideo();
		/**
		 * 背景
		 */		
		private var _backGround:BackGround = new BackGround();
		/**
		 * 选择分辨率界面 
		 */		
		private var _qualityPanel:QualityPanel = null;
		
		private var _videoEquipManager:VideoEquipmentManager = VideoEquipmentManager.getInstance();
		public function PreviewPanel()
		{
			super();
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_e.listen(SEvents.QUALITY_CHANGE,qualityChange);
			_e.listen(SEvents.CHANGE_CAMERA,changeCamera);
		}
		
		public function show():void{
			var user:User = Context.getContext(CEnum.USER) as User;
			var can:Boolean = user.validateAuthority(user.me,AuthorityStaitc.THING_38).can;
			if(can){
				showPreviewInit();
				JSProxy.getInstance().init();
			}
		}
		
		private function showPreviewInit():void{
			createBg();
			createSelector();
			this.visible = true;
		}
		
		public function changeBtnName(bool:Boolean):void{
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var label:String = "";
			if(bool){
				//设置label 为关闭   
				label = local.get("btn_label_closecar", "bottom");
			}else{
				//设置label 为 开启  
				label = local.get("btn_label_opencar", "bottom");
			}
			//发送改变按钮label事件
			_e.send(SEvents.CHANGE_BOTTOM_BUTTON_LABEL,{type:SEvents.CAMER_SHOW_CLICK,label:label});

		}
		
		public function updateBtn():void{
			if(_qualityPanel){
				_qualityPanel.update();
			}
		}
		
		/**
		 * 创建背景 
		 * 
		 */		
		private function createBg():void
		{
			if(!this.contains(_backGround)){
				
				this.addChild(_backGround);
				_previewVideo.x = 5;
				_previewVideo.y = 6;
				_previewVideo.width = 261;
				_previewVideo.height = 197;
				this.addChild(_previewVideo);
			}
		}
		/**
		 * 创建Selector 
		 * 
		 */		
		private function createSelector():void
		{
			if(!_selector){
				_selector = new SelectorPanel();
			}
			if(!this.contains(_selector)){
				this.addChild(_selector);
			}
			_e.remove(SEvents.SELECTPANEL_CLOSE,selectorClose);
			_e.listen(SEvents.SELECTPANEL_CLOSE,selectorClose);
			_previewVideo.video.attachCamera(null);
			_previewVideo.visible = false;
			this._selector.visible = true;
		}
		
		public function resetPanel():void{
			if(_qualityPanel && _qualityPanel.visible){
				createSelector();
				if(_qualityPanel){
					_qualityPanel.visible = false;
				}
			}
		}
		/**
		 * 摄像头界面关闭 
		 * @param data
		 * 
		 */		
		private function selectorClose(data:Object):void
		{
			_previewVideo.video.clear();
			_selector.visible = false;
			createQualityPanel();
//			if(_camManager.isPluginSelected){
//				_camManager.pluginCamera.addEventListener(StatusEvent.STATUS, cameraStatusHandler);
//				_camManager.pluginCamera.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
//				_camVideo.video.attachCamera(_camManager.pluginCamera);
//			}else{
//				_camManager.camera.addEventListener(StatusEvent.STATUS, cameraStatusHandler);
//				_camManager.camera.addEventListener(ActivityEvent.ACTIVITY, activityHandler);
//				_camVideo.video.attachCamera(_camManager.camera);
//			}
			_previewVideo.visible = true;
 		
		}
//		/**
//		 * flash支持消息 
//		 * @param e
//		 * 
//		 */		
//		private function cameraStatusHandler(e:StatusEvent):void 
//		{
//			if (e.code == "Camera.Muted") {
//			} else if (e.code == "Camera.Unmuted") {
//				trace(Capabilities.avHardwareDisable);
//				
//			}
//		}
//		/**
//		 * flash支持消息 
//		 * @param e
//		 * 
//		 */	
//		private function activityHandler(event:ActivityEvent	):void 
//		{
//			if (event.activating) {
//				
//			} 
//		}
		
		private function qualityChange(data:Object):void{
			if(_videoEquipManager.isUsePlugin){
				_previewVideo.video.attachCamera(null);
				JSProxy.getInstance().releasePlugin(false);
			}else{
				JSProxy.getInstance().releasePlugin(true);
			}
		}
		
		/**
		 * 切换摄像头 
		 * @param data
		 * 
		 */		
		private function changeCamera(data:Object):void{
			if(_videoEquipManager.isPluginSelected){
				_previewVideo.video.attachCamera(_videoEquipManager.pluginCamera);
			}else{
				_previewVideo.video.attachCamera(_videoEquipManager.camera);
			}
		}
		
		/**
		 * 分辨率界面关闭 
		 * @param data
		 * 
		 */		
		private function qualityClose(data:Object):void
		{
			_e.send(SEvents.SEND_VIDEO_DATA);
			Context.variables.showData.camInit = true;
			var iuser:IUser = (Context.getContext(CEnum.USER) as IUser);
			if(iuser){
				if(iuser.getUserMicStatus(iuser.me.id) == 2){
					var micIndex:int = iuser.getMicIndex(iuser.me.id);
					if(micIndex != -1){
						var order:Object = Context.variables.showData.order[micIndex];
						if(order){
							var liveId:int = order.liveId;
							Debugger.log(Debugger.INFO,"流liveId = "+ order.liveId);
							var smasterId:int = order.masterId;
							_e.send(SEvents.MIC_UP_MESSAGE,{"torder":micIndex, "sliveId":liveId, "smasterId":smasterId});
						}
					}
				}
			}
		}
		
		private function createQualityPanel():void
		{
			if(!_qualityPanel){
				_qualityPanel = new QualityPanel();
			}
			if(!this.contains(_qualityPanel)){
				this.addChild(_qualityPanel);
			}
			_e.remove(SEvents.QUALITYPANEL_CLOSE,qualityClose);
			_e.listen(SEvents.QUALITYPANEL_CLOSE,qualityClose);
			_qualityPanel.init();
			_qualityPanel.x = 60;
			_qualityPanel.y = 0;
			_qualityPanel.scaleX = 0.9;
			_qualityPanel.scaleY = 0.9;
			_qualityPanel.alpha = 0.85;
			_qualityPanel.visible = true;
			_qualityPanel.update();
			
		}
	}
}