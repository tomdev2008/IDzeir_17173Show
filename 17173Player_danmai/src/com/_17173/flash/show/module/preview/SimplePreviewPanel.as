package com._17173.flash.show.module.preview
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.Locale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.layer.UIManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.module.preview.QualityPanel;
	import com._17173.flash.show.base.module.preview.SelectorPanel;
	import com._17173.flash.show.base.module.video.base.JSProxy;
	import com._17173.flash.show.base.module.video.base.push.BaseVideo;
	import com._17173.flash.show.base.module.video.base.push.VideoEquipmentManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	
	/**
	 * 推流初始化 
	 * @author qiuyue
	 * 
	 */	
	public class SimplePreviewPanel extends Sprite
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
		 * 选择分辨率界面 
		 */		
		private var _qualityPanel:QualityPanel = null;
		
		/**
		 * 房间类型 
		 */		
		private var _selectRoomTypePanel:SelectRoomTypePanel = null;
		
		private var _videoEquipment:VideoEquipmentManager = VideoEquipmentManager.getInstance();
		
		private var _w:Number = 480;
		private var _h:Number = 360;
		
		public function SimplePreviewPanel()
		{
			super();
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_e.listen(SEvents.CHANGE_CAMERA,changeCamera);
			_e.listen(SEvents.QUALITY_CHANGE,qualityChange);
			this.graphics.beginFill(0x080000,1);
			this.graphics.drawRect(0,0,_w,_h);
			this.graphics.endFill();
		}
		
		public function show():void{
			createBg();
			createSelector();
			this.visible = true;
//			_camVideo.video.attachCamera(null);
//			_camVideo.visible = false;
		}
		
		public function updateBtn():void{
			if(_qualityPanel){
				_qualityPanel.update();
			}
		}
		
		/**
		 * 预览重置 
		 * 
		 */		
		public function resetPanel():void{
			createSelector();
			if(_qualityPanel){
				_qualityPanel.visible = false;
			}
		}
		
		/**
		 * 创建背景 
		 * 
		 */		
		private function createBg():void
		{
			if(!this.contains(_previewVideo)){
				_previewVideo.x = 0;
				_previewVideo.y = 0;
				_previewVideo.width = _w;
				_previewVideo.height = _h;
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
				_selector.x = (this.width - 270)/2;
				_selector.y = (this.height - 206)/2;
			}
			_e.remove(SEvents.SELECTPANEL_CLOSE,selectorClose);
			_e.listen(SEvents.SELECTPANEL_CLOSE,selectorClose);
			_previewVideo.video.attachCamera(null);
			_previewVideo.visible = false;
			this._selector.visible = true;
		}
		/**
		 * 摄像头界面关闭 
		 * @param data
		 * 
		 */		
		private function selectorClose(data:Object):void
		{
			_previewVideo.video.clear();
			this._selector.visible = false;
			createQualityPanel();
			_previewVideo.visible = true;
		}
		
		private function qualityChange(data:Object):void{
			if(_videoEquipment.isUsePlugin){
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
			if(_videoEquipment.isPluginSelected){
				_previewVideo.video.attachCamera(_videoEquipment.pluginCamera);
			}else{
				_previewVideo.video.attachCamera(_videoEquipment.camera);
			}
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
//				
//			}
//		}
//		/**
//		 * flash支持消息 
//		 * @param e
//		 * 
//		 */	
//		private function activityHandler(event:ActivityEvent):void 
//		{
//			if (event.activating) {
//			} 
//		}
		
		/**
		 * 分辨率界面关闭 
		 * @param data
		 * 
		 */		
		private function qualityClose(data:Object):void
		{
			_e.send(SEvents.SEND_VIDEO_DATA);
			Context.variables.showData.camInit = true;
			this.removeChild(_qualityPanel);
			var iuser:IUser = (Context.getContext(CEnum.USER) as IUser);
			if(iuser){
				if(iuser.getUserMicStatus(iuser.me.id) == 2){
					var locale:Locale = Context.getContext(CEnum.LOCALE) as Locale;
					(Context.getContext(CEnum.UI) as UIManager).popupAlert(locale.get("tips","jsProxy"),locale.get("continuePush","camModule"),-1,3,sendMicMessage,cancel);
				}else{
 					createRoomPanel();
				}
			}
		}
		
		private function cancel():void{
			_e.send(SEvents.MIC_DOWN,{"micIndex":1});
			Ticker.tick(1000,refresh,1);
		}
		
		private function refresh():void{
			Util.refreshPage();
		}
		
		private function sendMicMessage():void{
			var liveInfo:Object = Context.variables.showData.liveInfo;
			if(liveInfo && liveInfo.liveId != 0){
				var liveId:int = liveInfo.liveId;
				Debugger.log(Debugger.INFO,"流liveId = "+ liveInfo.liveId);
				var smasterId:int = liveInfo.masterId;
				_e.send(SEvents.OPENR_ROOM_SUCC,liveId);
			}
		}
		
		private function createQualityPanel():void
		{
			if(!_qualityPanel){
				_qualityPanel = new QualityPanel();
			}
			if(!this.contains(_qualityPanel)){
				this.addChild(_qualityPanel);
				_qualityPanel.x = (this.width - 270)/2 + 50;
				_qualityPanel.y = (this.height - 206)/2;
			}
			_e.remove(SEvents.QUALITYPANEL_CLOSE,qualityClose);
			_e.listen(SEvents.QUALITYPANEL_CLOSE,qualityClose);
			_qualityPanel.visible = true;
			_qualityPanel.init();
			_qualityPanel.update();
			
		}
		
		
		private function createRoomPanel():void{
			if(!_selectRoomTypePanel){
				_selectRoomTypePanel = new SelectRoomTypePanel();
			}
			this.addChild(_selectRoomTypePanel);
			_selectRoomTypePanel.x = 0;
			_selectRoomTypePanel.y = 0;
			_selectRoomTypePanel.visible = true;
		}
	}
}

