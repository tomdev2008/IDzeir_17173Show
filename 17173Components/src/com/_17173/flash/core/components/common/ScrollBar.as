package com._17173.flash.core.components.common
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name="change", type="flash.events.Event")]
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-1-23  下午3:36:26
	 */
	public class ScrollBar extends SkinComponent
	{
		protected const DELAY_TIME:int=500;
		protected const REPEAT_TIME:int=100;
		protected const UP:String="up";
		protected const DOWN:String="down";
		
		protected var _upButton:Sprite;
		protected var _downButton:Sprite;
		protected var _scrollSlider:ScrollSlider;
		protected var _orientation:String;
		protected var _lineSize:int=1;
		protected var _delayTimer:Timer;
		protected var _repeatTimer:Timer;
		
		protected var _direction:String;
		protected var _shouldRepeat:Boolean=false;
		
		private var _policy:String;
		private var _enable:Boolean=true;

		static public const OFF:String="off";
		static public const ON:String="on";
		static public const AUTO:String="auto";
		
		/**
		 * 
		 * @param orientation 指定滑块滑动方向
		 * @param parent 指定父容器
		 * @param defaultHandler 滑块滑动处理事件
		 * 
		 */				
		public function ScrollBar(orientation:String,parent:DisplayObjectContainer=null,defaultHandler:Function=null)
		{
			this._orientation=orientation;
			super(parent);
			if(defaultHandler!=null)
			{
				this.addEventListener(Event.CHANGE,defaultHandler);
			}
			super.setSkin_Bg(null);
		}
		
		override public function setSkin_Bg(source:DisplayObject):void
		{
			this._scrollSlider.setSkin_Bg(source);
		}
		
		public function set bglayerAlpha(value:Number):void
		{
			this._scrollSlider.bglayerAlpha = value;
		}
		
		override protected function onInit():void
		{
			super.onInit();
			_scrollSlider=new ScrollSlider(_orientation,this,onChange);
			_upButton=new Sprite();
			_upButton.addEventListener(MouseEvent.MOUSE_DOWN,onUpClick);
			/*_upButton.width=10;
			_upButton.height=10;*/
			
			_downButton=new Sprite();
			_downButton.addEventListener(MouseEvent.MOUSE_DOWN,onDownClick);
			/*_downButton.width=10;
			_downButton.height=10;*/
			
			if(this._orientation==Slider.HORIZONTAL)
			{
				this.setSize(100,10);
			}else{
				this.setSize(10,100);
			}
			_delayTimer=new Timer(DELAY_TIME,1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onDelayComplete);
			
			_repeatTimer=new Timer(REPEAT_TIME);
			_repeatTimer.addEventListener(TimerEvent.TIMER,onRepeat);
			this.onResize();
		}
		
		public function setSliderParams(min:Number,max:Number,value:Number):void
		{
			this._scrollSlider.setSliderParams(min,max,value);
		}
		
		public function setThumbPercent(value:Number):void
		{
			this._scrollSlider.setThumbPercent(value);
			this.onDrawRect();
		}
		
		override protected function onDrawRect():void
		{
			super.onDrawRect();
			if(this._orientation==Slider.VERTICAL)
			{
				this._scrollSlider.x=0;
				this._scrollSlider.y=_upButton.height;
				this._scrollSlider.width=10;
				this._scrollSlider.height=this._setHeight-2*_upButton.height;
				this._downButton.x=0;
				this._downButton.y=_setHeight-_downButton.height;
			}else{
				this._scrollSlider.x=_upButton.width;
				this._scrollSlider.y=0;
				this._scrollSlider.width=this._setWidth-2*_upButton.width;
				this._scrollSlider.height=10;
				this._downButton.x=_setWidth-_downButton.width;
				this._downButton.y=0;
			}
			this._scrollSlider.resize();
			if(_scrollSlider.thumbPercent==1)
				_enable = false;
			else 
				_enable = true;
			
			displayBar();
		}
		
		private function displayBar():void
		{
			switch(this._policy)
			{
				case ScrollBar.OFF:
					visible=false;
					break;
				case ScrollBar.ON:
					visible=true;
					break;
				case ScrollBar.AUTO:
					visible=this._scrollSlider.thumbPercent<1;					
					break;
				default:
					visible=true;
					break;
			}			
		}
		
		public function get enable():Boolean
		{
			return _enable;
		}

		
		public function set value(v:Number):void
		{
			if(this._scrollSlider.value!=v)
			{
				this._scrollSlider.value=v;				
			}				
		}
		
		public function get value():Number
		{
			return this._scrollSlider.value;
		}
		
		public function set minimum(v:Number):void
		{
			this._scrollSlider.minimum=v;
		}
		
		public function get minimum():Number
		{
			return this._scrollSlider.minimum;
		}
		
		public function set maximum(v:Number):void
		{
			this._scrollSlider.maximum=v;
		}
		
		public function get maximum():Number
		{
			return this._scrollSlider.maximum;
		}
		
		public function set lineSize(value:int):void
		{
			this._lineSize=value;
		}
		
		public function get lineSize():int
		{
			return this._lineSize;
		}
		
		protected function onRepeat(event:TimerEvent):void
		{
			if(this._direction==UP)
			{
				goUp();
			}else{
				goDown();
			}
		}
		
		protected function onDelayComplete(event:TimerEvent):void
		{
			if(this._shouldRepeat)
			{
				this._repeatTimer.start();
			}
		}
		
		protected function onUpClick(event:MouseEvent):void
		{
			goUp();
			_shouldRepeat=true;
			this._direction=UP;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseGoUp);
		}
		
		protected function goUp():void
		{
			_scrollSlider.value-=_lineSize;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onDownClick(event:MouseEvent):void
		{
			goDown();
			_shouldRepeat=true;
			_direction=DOWN;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP,onMouseGoUp);
		}
		
		protected function onMouseGoUp(event:MouseEvent):void
		{
			_delayTimer.stop();
			_repeatTimer.stop();
			_shouldRepeat=false;
		}
		
		protected function goDown():void
		{
			_scrollSlider.value+=_lineSize;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onChange(e:Event):void
		{
			this.dispatchEvent(e);
		}
		
		/**
		 * 滚动条显示模式
		 * @param value auto,off,on
		 * 
		 */		
		public function set policy(value:String):void
		{
			_policy = value;
			this.resize();
		}
	}
}