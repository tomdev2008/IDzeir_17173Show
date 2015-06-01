package com._17173.flash.show.base.module.video.push
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.module.video.base.push.PushManager;
	import com._17173.flash.show.base.module.video.base.push.PushVideoManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	
	public class PushVideo extends Sprite
	{
		private var _pointArray1:Array = [46,12,480,360,500,220,5,133];
		private var _pushManager:PushManager = new PushManager();
		private var _e:IEventManager = null;
		/**
		 * 声音条 
		 */	
		private var _volumePanel:VolumePanel = null;
		/**
		 * 右上角时间界面 
		 */		
		private var _rtopPanel:RightTopPanel = null;
		
		private var _micIndex:int = 0;
		
		public function PushVideo()
		{
			super();
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_e.listen(SEvents.SHOW_TIMER_PANEL, showTimerPanel);
			_pushManager.pushVideo.x = 0;
			_pushManager.pushVideo.y = 0;
			this.addChild(_pushManager.pushVideo);
		}

		public function get pushVideoManager():PushVideoManager
		{
			return _pushManager.pushVideoManager;
		}

		/**
		 * 麦序 
		 */
		public function get micIndex():int
		{
			return _micIndex;
		}

		/**
		 * @private 麦序 
		 */
		public function set micIndex(value:int):void
		{
			_micIndex = value;
		}

		/**
		 * 声音界面 
		 */
		public function set volumePanel(value:VolumePanel):void
		{
			_volumePanel = value;
		}
		/**
		 * 右上角显示 
		 */
		public function set rtopPanel(value:RightTopPanel):void
		{
			_rtopPanel = value;
		}
		
		public function showTimerPanel(data:Object):void{
			_rtopPanel.startPush();
		}
		
		
		/**
		 * 结束直播 
		 * 
		 */		
		public function hideCam():void{
			Debugger.log(Debugger.INFO,"(PushVideo)","清除推流画面");
			micIndex = 0;
			_pushManager.clear();
			hideRightTopPanel();
			this.visible = false;
			if(_volumePanel){
				_volumePanel.visible = false;
			}
		}
		
		/**
		 * 重连 
		 * 
		 */		
		public function videoRePush():void{
			Debugger.log(Debugger.INFO,"(PushVideo)重连");
			_pushManager.push();
		}
		
		/**
		 * 隐藏topPanel 
		 * 
		 */		
		private function hideRightTopPanel():void{
			if(_rtopPanel){
				_rtopPanel.visible = false;
				_rtopPanel.stop();
			}
		}
		/**
		 * 移动声音Panel
		 * 
		 */		
		private function moveVolumePanel():void
		{
			if(_volumePanel){
				var pointArray:Array = this["_pointArray"+micIndex] as Array;
				_volumePanel.x = pointArray[6] + pointArray[0];
				_volumePanel.y =pointArray[7] + pointArray[1];
			}
		}
		/**
		 * 移动topPanel
		 * 
		 */	
		private function moveTopPanel():void{
			if(_rtopPanel){
				var pointArray:Array = this["_pointArray"+micIndex] as Array;
				_rtopPanel.x = pointArray[0] + pointArray[2] - _rtopPanel.width ;
				_rtopPanel.y = pointArray[1] ;
			}
		}
		
		/**
		 * 移动 
		 * @param micIndex 麦序
		 * 
		 */		
		public function move(micIndex:int):void{
			Debugger.log(Debugger.INFO,"(PushVideo)","当前麦为"+this.micIndex,"目标麦为"+micIndex);
			this.micIndex = micIndex;
			var pointArray:Array = this["_pointArray"+micIndex] as Array;
			this.x = pointArray[0];
			this.y = pointArray[1];
			this.width = pointArray[2];
			this.height = pointArray[3];
			moveTopPanel();
//			TweenLite.to(this,0.5,{x:pointArray[0],y:pointArray[1],width:pointArray[2],height:pointArray[3]});
			moveVolumePanel();
		}
		
		/**
		 * 开始直播
		 * @param data
		 * 
		 */		
		public function startPush(data:Object):void
		{
			Debugger.log(Debugger.INFO,"(PushVideo)","开始直播");
			micIndex = data.torder;
			_pushManager.liveId = data.sliveId;
			_pushManager.attachCamera();
			move(micIndex);	
			this.visible = true;
			_rtopPanel.visible = true;
			_rtopPanel.showWaitPushName();
			_volumePanel.visible = true;
			_pushManager.push();
			
		}
	}
}