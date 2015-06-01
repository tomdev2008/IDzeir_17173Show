package com._17173.flash.show.base.module.video.push
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Base64;
	import com._17173.flash.core.components.common.IconButton;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.module.video.base.push.BaseVideo;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import com._17173.flash.show.base.module.preview.PNGEncoder;
	import com._17173.flash.show.base.module.video.base.push.VideoEquipmentManager;
	
	
	/**
	 * 拍照模块 
	 * @author qiuyue
	 * 
	 */	
	public class PhotoPanel extends Sprite
	{
		private var _e:IEventManager = null;
		private var _s:IServiceProvider = null;
		
		/**
		 * 拍照按钮 
		 */		
		private var _photoBtn:IconButton = null;
		
		/**
		 * 取消拍照按钮 
		 */		
		private var _photoCancelBtn:IconButton = null;
		
		/**
		 * 上传按钮 
		 */		
		private var _uploadBtn:IconButton = null;
		
		/**
		 *视频界面 
		 */		
		private var _baseVideo:BaseVideo = null;
		/**
		 * 拍照数据 
		 */		
		private var _bitMapData:BitmapData = null;
		
		/**
		 * 数据载体 
		 */		
		private var _bitMap:Bitmap = null;
		/**
		 * 照相背景 
		 */
		private var _photoBackGround:BackGround = new BackGround();
		
		/**
		 * video背景 
		 */		
		private var _videoBackGround:BackGround = new BackGround();
	
		public function PhotoPanel(){
			super();
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_s = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			_e.listen(SEvents.SEND_VIDEO_DATA,updateVideoData);
			_e.listen(SEvents.PHOTO_SHOW_MESSAGE,showMessage);
			
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0,0,520,390);
			this.graphics.endFill();

			this._photoBackGround.x = 307;
			this._photoBackGround.y = 50;
			this._photoBackGround.width = 184;
			this._photoBackGround.height = 142;
			this.addChild(_photoBackGround);
			
			
			this._videoBackGround.x = 32;
			this._videoBackGround.y = 128;
			this.addChild(_videoBackGround);
			
			_baseVideo = new BaseVideo();
			_baseVideo.x = 37;
			_baseVideo.y = 134;
			_baseVideo.width = 261;
			_baseVideo.height = 197;
			this.addChild(_baseVideo);
			
			_photoBtn = new IconButton(new PhotoIcon, Context.getContext(CEnum.LOCALE).get("photo", "photoModule"));
			_photoBtn.x = 361;
			_photoBtn.y = 226;
			_photoBtn.addEventListener(MouseEvent.CLICK, photo);
			this.addChild(_photoBtn);
			_photoCancelBtn = new IconButton(new PhotoCancel, Context.getContext(CEnum.LOCALE).get("photoCancel", "photoModule"));
			_photoCancelBtn.x = 361;
			_photoCancelBtn.y = 266;
			_photoCancelBtn.addEventListener(MouseEvent.CLICK, photoCancel);
			this.addChild(_photoCancelBtn);
			_uploadBtn = new IconButton(new PhotoUpload, Context.getContext(CEnum.LOCALE).get("upload", "photoModule"));
			_uploadBtn.x = 361;
			_uploadBtn.y = 306;
			_uploadBtn.addEventListener(MouseEvent.CLICK, upload);
			this.addChild(_uploadBtn);
		}
		
		/**
		 * 更新 BaseVideo捕获的Camer 
		 * @param data
		 * 
		 */		
		private function updateVideoData(data:Object):void{
			if(VideoEquipmentManager.getInstance().isPluginSelected){
				_baseVideo.video.attachCamera(VideoEquipmentManager.getInstance().pluginCamera);
			}else{
				_baseVideo.video.attachCamera(VideoEquipmentManager.getInstance().camera);
			}
		}
		
		/**
		 * 显示照相界面 
		 * @param data
		 * 
		 */		
		private function showMessage(data:Object):void{
			this.visible = true;
		}
		
		/**
		 * 拍照 
		 * @param e
		 * 
		 */		
		private function photo(e:MouseEvent):void{
			_bitMapData = _baseVideo.capture();
			if(!_bitMap){
				_bitMap = new Bitmap(_bitMapData, "auto", true);
				_bitMap.width = 176;
				_bitMap.height = 135;
				_bitMap.x = 312;
				_bitMap.y = 54;
				
			}else
			{
				_bitMap.bitmapData = _bitMapData;
			}
			
			if(!this.contains(_bitMap)){
				this.addChild(_bitMap);
			}
			
		}
		
		/**
		 * 取消拍照 
		 * @param e
		 * 
		 */		
		private function photoCancel(e:MouseEvent):void{
			_e.send(SEvents.PHOTO_HIDE_MESSAGE);
			this.visible = false;
		}
		
		/**
		 * 上传 
		 * @param e
		 * 
		 */		
		private function upload(e:MouseEvent):void{
			var ba:ByteArray = PNGEncoder.encode(_bitMapData);
			var str:String = Base64.encode(ba);
			_s.http.postData(SEnum.domain + "/pc_capture.action",{"file":str},succ,fail);
		}
		
		private function succ(data:Object):void{
			trace();
		}
		
		private function fail(data:Object):void{
			trace();
		}
	}
}