package com._17173.flash.show.base.module.video.live
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * 声音组件 
	 * @author qiuyue
	 * 
	 */	
	public class LiveVolumePanel extends Sprite
	{
		private var _e:IEventManager = null;
		/**
		 * 麦序 
		 */		
		private var _index:int = 1;
		
		/**
		 * 声音组件 
		 */		
		private var _volume:LiveVolumeBar = null;
		
		/**
		 * 静音按钮 
		 */		
		private var _volumeMute:VolumeMuteBtn = null;
		
		/**
		 * 暂停 
		 */		
		private var _pauseBtn:LivePauseBtn = null;
		/**
		 * 是否可以点击暂停
		 */		
		private var _isClick:Boolean = false;
		
		public function LiveVolumePanel(index:int){
			super();
			_index = index;
			_e = Context.getContext(CEnum.EVENT) as IEventManager;
			_e.listen(SEvents.CHANGE_MUTE_STATE,changeMuteState);
			_volume = new LiveVolumeBar(_index);
			_volume.x = 0;
			_volume.y = 0;
			this.addChild(_volume);
			_volumeMute = new VolumeMuteBtn();
			_volumeMute.x = -5;
			_volumeMute.y = 10;
			_volumeMute.stop();
			_volumeMute.buttonMode = true;
			_volumeMute.addEventListener(MouseEvent.CLICK,mute);
			this.addChild(_volumeMute);
			_pauseBtn = new LivePauseBtn();
			_pauseBtn.x = -3;
			_pauseBtn.y = 30;
			_pauseBtn.stop();
			_pauseBtn.gotoAndStop(1);
			_pauseBtn.buttonMode = true;
			_pauseBtn.addEventListener(MouseEvent.CLICK,pause);
			this.addChild(_pauseBtn);
			
		}
		
		/**
		 * 音量值 
		 */
		public function get volumeNumber():int
		{
			return _volume.volumeNumber;
		}
		
		public function get pauseState():Boolean{
			return _pauseBtn.currentFrame == 1;
		}

		/**
		 * 是否可以点击暂停 
		 * @param bool
		 * 
		 */		
		public function updateBtnMouse(bool:Boolean):void{
			this._pauseBtn.mouseEnabled = bool;
		}
		/**
		 * 还原pauseBtn 
		 * 
		 */		
		public function resetPauseBtn():void{
			this._pauseBtn.gotoAndStop(1);
		}
		
		private function pause(e:MouseEvent):void{
			if(_pauseBtn.currentFrame == 1){
				_pauseBtn.gotoAndStop(2);
			}else{
				_pauseBtn.gotoAndStop(1);
			}
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.LIVE_PAUSE,_index);
		}
		
		
		private function changeMuteState(data:Object):void{
			if(data.index == _index){
				if(data.volumeNumber <= 0){
					_volumeMute.gotoAndStop(2);
				}else{
					_volumeMute.gotoAndStop(1);
				}
			}
			
//			if(_volumeMute.currentFrame != 1){
//				_volumeMute.gotoAndStop(1);
//			}
		}
		/**
		 * 静音 
		 * @param e
		 * 
		 */		
		private function mute(e:MouseEvent):void{
			if(_volumeMute.currentFrame == 1){
				_volumeMute.gotoAndStop(2);
				_volume.isMute(false);
			}else{
				_volumeMute.gotoAndStop(1);
				_volume.isMute(true);
			}
		}
		
		
	}
}