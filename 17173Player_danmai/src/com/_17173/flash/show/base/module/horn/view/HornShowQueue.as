package com._17173.flash.show.base.module.horn.view
{
	import com._17173.flash.core.util.time.Ticker;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 *可以继续放入的事件
	 */	
	[Event(name="allowPush", type="flash.events.Event")]
	
	/**
	 *广播队列 
	 * @author yexianhui
	 */	
	public class HornShowQueue extends Sprite
	{
		/**
		 *遮罩 
		 */		
		private var msk:Sprite;
		
		/**
		 *间隔 
		 */		
		private static const _GAP:int = 2;
		
		/**
		 *速度 
		 */		
		private static const SPEED:int = 2;
		
		/**
		 *alpha变量 
		 */		
		private static const ALPHA_OFFSET:Number = .1;
		
		/**
		 *延时 
		 */		
		private var pauseTime:int = 1000;
		
		/**
		 *设置缓存中排队的数量 
		 * @param $value
		 */		
		public function set waitCount($value:int):void
		{
			pauseTime = $value < 3 ? 5000:1000;
		}

		private var _width:int = 0;
		override public function get width():Number
		{
			return _width;
		}
		
		private  var _height:int = 0;
		override public function get height():Number
		{
			return _height;
		}
		
		private var _allowPush:Boolean = true;
		/**
		 *是否允许继续放入 
		 * @return 
		 */		
		public function get allowPush():Boolean
		{
			return _allowPush;
		}
		
		private function setAllowPush($value:Boolean):void
		{
			if(_allowPush == $value) return;	
			_allowPush = $value;
			if(_allowPush)
			{
				dispatchEvent(new Event("allowPush"));
			}
		}
		
		/**
		 *设置尺寸 
		 * @param $w
		 * @param $h
		 */		
		public function setSize($w:int, $h:int):void
		{
			_width = $w;
			_height = $h;
			
			const BG_COLOR:uint = 0x332D39;
			redraw(this.graphics, _width, _height, BG_COLOR,.6);
			redraw(msk.graphics, _width, _height, 0x0);
			this.mask = msk;
		}
		
		/**
		 *重绘 
		 * @param $g
		 * @param $w
		 * @param $h
		 * @param $color
		 */		
		private function redraw($g:Graphics, $w:int, $h:int, $color:uint, $alpha:Number = 1.0):void
		{
			$g.clear();
			$g.beginFill($color, $alpha);
			$g.drawRect(0, 0, $w, $h);
			$g.endFill();
		}
		
		public function HornShowQueue()
		{
			super();
			visible = false;
			msk = new Sprite();
			this.addChild(msk);
		}
		
		/**
		 *加入队列 
		 * @param $item
		 */		
		public function push($item:DisplayObject):DisplayObject
		{
			$item.x = _width;
			this.addChild($item);
			play(true);
			setAllowPush(false);
			return $item;
		}
		
		/**
		 *移除一个 
		 * @return 
		 */		
		public function pull($item:DisplayObject):DisplayObject
		{
			HornShowItem.recycle($item as DisplayObjectContainer);
			this.removeChild($item);
			if(this.numChildren < 2)
			{
				play(false);
			}
			return $item;
		}
		
		/**
		 *播放 
		 * @param $flag
		 */		
		public function play($flag:Boolean):void
		{
			if(visible == $flag) return;
			visible = $flag;
			visible ? Ticker.tick(1, onTick, -1) : Ticker.stop(onTick);
		}
		
		/**
		 *暂停时的时间 
		 */		
		private var pauseTimer:int;
		
		/**
		 *tick 
		 */		
		private function onTick():void
		{
			var item:DisplayObject;
			if(pauseTimer > 0)
			{
				if(getTimer() - pauseTimer >= pauseTime)
				{
					item = getChildAt(1);
					item.alpha -= ALPHA_OFFSET;
					if(item.alpha <= 0)
					{
						pull(this.getChildAt(1));
						pauseTimer = 0;
					}
				}
			}
			
			var lastPos:int;
			var nextPos:int;
			for (var i:int = 1; i < this.numChildren; i++) 
			{
				item = this.getChildAt(i);
				var tempx:int = item.x - SPEED;
				if(tempx <= nextPos)
				{
					tempx = nextPos;
					if(pauseTimer == 0)
					{
						pauseTimer = getTimer();
					}
				}
				item.x = tempx;
				nextPos += Math.ceil(item.width) + _GAP;
				lastPos = item.x + Math.ceil(item.width);
			}
			
			setAllowPush(width > lastPos);
		}
	}
}