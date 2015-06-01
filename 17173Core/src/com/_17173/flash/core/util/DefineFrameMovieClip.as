package com._17173.flash.core.util
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 *
	 * 统一帧频动画类
	 * @author zhaoqinghao
	 *
	 */
	public class DefineFrameMovieClip extends Sprite
	{
		private var _mc:MovieClip = null;
		/**
		 *动画的帧频
		 */
		private var _mcFrameRate:int = 0;
		/**
		 *当前
		 */
		private var _cFrame:int = 1;
		private var _enterCount:int = 0;
		private var _sFrameRate:int = 0;
		private var _step:int = 0;
		private var _begin:int = -1;
		private var _end:int = -1;
		private var _autoStop:Boolean = false;

		/**
		 *  统一帧频动画类
		 * @param mc 动画类
		 * @param mcFrameRate 动画帧频
		 * @param stageFrameRate 舞台帧频
		 *
		 */
		public function DefineFrameMovieClip(mc:MovieClip, mcFrameRate:int, stageFrameRate:int = 30):void
		{
			super();
			_mc = mc;
			this.addChild(_mc);
			_mc.gotoAndStop(0);
			_mcFrameRate = mcFrameRate;
			_sFrameRate = stageFrameRate;
			//计算step 最小为1;
			_step = Math.max(1, Math.ceil(stageFrameRate / mcFrameRate));
		}

		/**
		 *开始播放
		 * @param autoStop 是否自动停止
		 *
		 */
		public function play(autoStop:Boolean = false):void
		{
			_cFrame = 1;
			_enterCount = 0;
			_autoStop = autoStop;
			this.addEventListener(Event.ENTER_FRAME, enterFrame);
		}

		/**
		 *停止
		 * @param toframe 停止时跳到帧
		 *
		 */
		public function stop(toframe:int = -1):void
		{
			if (toframe > 0)
			{
				_mc.gotoAndStop(toframe);
			}
			clearLoop();
			this.removeEventListener(Event.ENTER_FRAME, enterFrame);
		}

		/**
		 *循环播放
		 * @param begin
		 * @param end
		 *
		 */
		public function loop(begin:int, end:int):void
		{
			_begin = begin;
			_end = end;
			play(false);
		}


		private function clearLoop():void
		{
			_begin = -1;
			_end = -1;
		}

		/**
		 *逐帧
		 * @param e
		 *
		 */
		private function enterFrame(e:Event):void
		{
			_mc.gotoAndStop(_cFrame);
			_enterCount++;
			_cFrame = Math.floor(_enterCount / _step);
			if (_begin > -1 && _end > -1)
			{
				if(_cFrame > _end){
					_cFrame = _begin;
					_enterCount =(_step * _begin);
				}
			}
			if (_cFrame > _mc.totalFrames)
			{
				//自动停止
				_cFrame = 1;
				_enterCount = 0;
				if (_autoStop)
				{
					stop();
				}
			}
			
		}

		/**
		 *资源
		 * @return
		 *
		 */
		public function get mc():MovieClip
		{
			return _mc;
		}
	}
}
