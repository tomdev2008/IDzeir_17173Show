package com._17173.flash.show.base.module.preview
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * 推流模块 
	 * @author qiuyue
	 * 
	 */	
	public class PreviewModule extends BaseModule implements IPreviewModule
	{
		private var _e:IEventManager = null;		
		private var _camPreview:PreviewPanel = null;
		
		private var _point:Point = null;
		
		public function PreviewModule()
		{
			super();
			_version = "0.0.1";
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			this.visible = false;
		}
		
		protected override function onAdded(event:Event):void{
			_camPreview = new PreviewPanel();
			_camPreview.show();
			_camPreview.changeBtnName(this.visible);
			this.addChild(_camPreview);
			if(_point){
				this.x = _point.x;
				this.y = _point.y - this.height - 10;
			}
			_e.listen(SEvents.SEND_VIDEO_DATA,hide);
		}
		
		private function hide(data:Object):void{
			this.visible = false;	
			if(_camPreview){
				_camPreview.changeBtnName(false);
			}
		}
		
		public function resetPreview():void{
			if(_camPreview){
				_camPreview.resetPanel();
			}
		}
		/**
		 * 显示摄像头 
		 * 
		 */		
		public function showCamer(data:Object):void{
			
			if(!(this.parent is Sprite)){
				(data[1] as Sprite).addChild(this);
			}
			if(_camPreview){
				_camPreview.updateBtn();
			}
			_point = data[0] as Point;
			this.x = _point.x;
			this.y = _point.y - this.height - 10;
			if(this.visible){
				this.visible = false;
				if(_camPreview){
					_camPreview.changeBtnName(false);
				}
			}else{
				this.visible = true;
				if(_camPreview){
					_camPreview.changeBtnName(true);
				}
			}
		}
		/**
		 * 注册上麦消息 
		 * @param data
		 * 
		 */		
		public function onPushData():void{
			if(Context.variables.showData.camInit){
				this.visible = false;
				if(_camPreview){
					_camPreview.changeBtnName(false);
				}
			}
		}
	}
}