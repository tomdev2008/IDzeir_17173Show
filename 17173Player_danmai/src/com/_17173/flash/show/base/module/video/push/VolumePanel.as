package com._17173.flash.show.base.module.video.push
{
	import com._17173.flash.show.base.module.video.base.JSProxy;
	import com._17173.flash.show.base.module.video.base.push.VideoEquipmentManager;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * 音量条 
	 * @author qiuyue
	 * 
	 */	
	public class VolumePanel extends Sprite
	{
		/**
		 * 背景 
		 */			
		private var _volumeBar:VolumeBar = new VolumeBar;
		/**
		 * 声音条
		 */		
		private var _volumeColor:VolumeColor = new VolumeColor;
		/**
		 * mask 
		 */		
		private var _mask:Sprite = null;
		/**
		 *  计时器
		 */		
		private var _micTimer:Timer = null;
		
		public function VolumePanel()
		{
			super();
			this.addChild(_volumeBar);
			this.addChild(_volumeColor);
			_volumeBar.x = 0;
			_volumeBar.y = 0;
			_volumeColor.x = 3;
			_volumeColor.y = 3;
			_mask = new Sprite();
			_mask.graphics.beginFill(0xFF0000, 1);
			_mask.graphics.drawRect(0, 0, 7, 80);
			_mask.graphics.endFill();
			_mask.x = 3;
			_mask.y = 3;
			this.addChild(_mask);
			_volumeColor.mask = _mask;
			_volumeBar.volumeBtn.stop();
			_volumeBar.volumeBtn.visible = false;
			_micTimer = new Timer(128);
			_micTimer.addEventListener(TimerEvent.TIMER, micTimerHandler);
			_micTimer.start();
		}
		/**
		 *  当前声音
		 * @param e
		 * 
		 */		
		private function micTimerHandler(e:TimerEvent):void
		{
			var activityLevel:int;
			if(VideoEquipmentManager.getInstance().isPluginSelected){
				activityLevel = JSProxy.getInstance().volume;
			}else{
				activityLevel = VideoEquipmentManager.getInstance().getActivityLevel();
			}
			var number:int = (100-activityLevel) * 80 / 100;
			if(number >= 80)
				number = 80;
			if(number <=0)
				number = 0;
			_mask.y = 3 + number;
		}
//		/**
//		 * 关闭声音 
//		 * 
//		 */		
//		private function closeSound():void
//		{
//			_volumeBar.volumeBtn.gotoAndStop(2);
////			_volumeNumber = _mideaData.mic.gain;
////			_mideaData.mic.gain = 0;
//			CamManager.getInstance().updateGain(0);
//			_micTimer.reset();
//			_mask.y = 3 +100 * 80 / 100;
//		}
//		/**
//		 * 打开声音 
//		 * 
//		 */		
//		private function openSound():void
//		{
//			_volumeBar.volumeBtn.gotoAndStop(1);
//			CamManager.getInstance().updateGain(80);
////			_mideaData.mic.gain = 80;
//			_micTimer.start();
//		}
//		/**
//		 * click时间
//		 * @param e
//		 * 
//		 */		
//		private function volumeBtnClick(e:MouseEvent):void
//		{
//			if(_volumeBar.volumeBtn.currentFrame == 1){
//				closeSound();
//			}else{
//				openSound();
//			}
//		}
	}
}