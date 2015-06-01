package com._17173.flash.core.components.common
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	[Event(name="change", type="flash.events.Event")]
	/** 
	 * @author idzeir
	 * 创建时间：2014-1-23  下午2:53:44
	 */
	public class Slider extends SkinComponent
	{
		/**滑块*/		
		protected var _handle:Sprite;
		/**滑块背景*/
		protected var _back:Sprite;
		protected var _backClick:Boolean=true;
		
		/**slider当前的值*/
		protected var _value:Number=0;
		/**slider最大值*/
		protected var _max:Number=100;
		/**slider最小值*/
		protected var _min:Number=0;
		/**滑动条滑动类型*/
		protected var _orientation:String;
		
		static public const HORIZONTAL:String="horizontal";
		static public const VERTICAL:String="vertical";
		
		/**
		 * 构造函数
		 * @param orientation 滑块方向
		 * @param parent 父容器
		 * @param defaultHandler 滑动处理事件
		 * 
		 */	
		public function Slider(orientation:String,parent:DisplayObjectContainer=null,defaultHandler:Function=null)
		{
			this._orientation=orientation;
			super(parent);
			if(defaultHandler!=null)
			{
				this.addEventListener(Event.CHANGE,defaultHandler);
			}
			super.setSkin_Bg(null);
		}

		override protected function onInit():void
		{
			super.onInit();
			_back=new Sprite();
			_back.graphics.beginFill(/*0x6d5d87*/0x371C63,.6);
			_back.graphics.drawRect(0,0,10,10);
			_back.graphics.endFill();
			addChild(_back);
			
			_handle= new Sprite();
			_handle.mouseChildren = false;
			var skin:Sprite = this._orientation==HORIZONTAL?new Thumb_skin_h():new Thumb_skin_v();
			setSkin_Bg(skin);

			if (this._orientation == HORIZONTAL)
			{
				//_handle.scale9Grid = new Rectangle(4, 2, 38, 2);
				this.setSize(100, 10);
			}
			else
			{
				//_handle.scale9Grid = new Rectangle(2, 2, 4, 38);
				this.setSize(10, 100);
			}
			
			_handle.addEventListener(MouseEvent.MOUSE_DOWN,onDrag);
			_handle.buttonMode=true;
			_handle.useHandCursor=true;
			this.addChild(_handle);
			
			this.onResize();
		}
		/**
		 * 设置滚动条样式，会拉伸至当前滚动条大小 
		 * @param source
		 * 
		 */		
		override public function setSkin_Bg(source:DisplayObject):void
		{
			if(this.contains(_handle))this.removeChild(_handle);
			_handle.removeEventListener(MouseEvent.MOUSE_DOWN,onDrag);
			
			_handle = source as Sprite;
			_handle.addEventListener(MouseEvent.MOUSE_DOWN,onDrag);
			_handle.buttonMode=true;
			_handle.useHandCursor=true;
			_handle.mouseChildren = false;
			this.addChild(_handle);
			//_handle.removeChildren();
			//_handle.addChild(source);
		}
		/**
		 * 设置滑动条背景可见 
		 * @param bool
		 * 
		 */		
		public function set bglayerAlpha(alpha:Number):void
		{
			this._back.alpha = alpha;
		}
		
		override protected function onDrawRect():void
		{
			drawBack();
			drawHandle();
		}
		/**
		 * 绘制背景，匹配大小
		 */
		protected function drawBack():void
		{
			this._back.width=this._setWidth;
			this._back.height=this._setHeight;
			if(this._backClick)
			{				
				if(!this._back.hasEventListener(MouseEvent.MOUSE_DOWN))
				{
					this._back.addEventListener(MouseEvent.MOUSE_DOWN,onBackClick);
				}
			}else{
				this._back.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBackClick);
			}
		}
		
		/**
		 * 绘制滑块，匹配大小
		 */
		protected function drawHandle():void
		{
			if(this._orientation==HORIZONTAL)
			{
				_handle.width=_handle.height=_setHeight-2;				
			}else{
				_handle.width=_handle.height=_setWidth-2;
			}
			_handle.x=_handle.y=1;
			positionHandle();
		}
		
		/**
		 * 调整value值在minimum 到maximum之间
		 */
		protected function correctValue():void
		{
			if(_max>_min)
			{
				_value=Math.min(_value,_max);
				_value=Math.max(_value,_min);
			}else{
				_value=Math.max(_value,_max);
				_value=Math.min(_value,_min);
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * 在value,maximum,minimum更改或者slider改变大小，调整滑块的位置
		 */
		protected function positionHandle():void
		{
			var range:Number;
			if(this._orientation==HORIZONTAL)
			{
				range=_setWidth-_setHeight;
				_handle.x=(_value-_min)/(_max-_min)*range;
			}else{
				range=_setHeight-_setWidth;
				_handle.y=_setHeight-_setWidth-(_value-_min)/(_max-_min)*range;
			}			
		}
		
		/**
		 * 设置slider的范围和当前值 
		 * @param min slider的最小值
		 * @param max slider的最大值
		 * @param value slider的当前值
		 * 
		 */		
		public function setSliderParams(min:Number,max:Number,value:Number):void
		{
			this.minimum=min;
			this.maximum=max;
			this.value=value;
		}
		
		protected function onBackClick(event:MouseEvent):void
		{
			if(this._orientation==HORIZONTAL)
			{
				this._handle.x=mouseX-height/2;
				this._handle.x=Math.max(_handle.x,0);
				this._handle.x=Math.min(_handle.x,width-height);
				_value=_handle.x/(width-height)*(_max-_min)+_min;
			}else{				
				this._handle.y=mouseY-width/2;
				this._handle.y=Math.max(_handle.x,0);
				this._handle.y=Math.min(_handle.y,height-width);
				_value=(height-width-_handle.y)/(height-width)*(_max-_min)+_min;
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		protected function onDrag(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP,onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onSlide);
			
			if(_orientation==HORIZONTAL)
			{
				_handle.startDrag(false,new Rectangle(0,_handle.y,_setWidth-_setHeight,0));
			}else{
				_handle.startDrag(false,new Rectangle(_handle.x,0,0,_setHeight-_setWidth));
			}
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
		protected function onDrop(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onSlide);
			_handle.stopDrag();
		}
		
		protected function onSlide(e:MouseEvent):void
		{
			var oldValue:Number=_value;
			if(_orientation==HORIZONTAL)
			{
				_value=_handle.x/(width-_setHeight)*(_max-_min)+_min;
			}else{
				_value=(_setHeight-_setWidth-_handle.y)/(height-_setWidth)*(_max-_min)+_min;
			}
			if(_value!=oldValue)
			{
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 滑动条背景是否可点击 
		 * @param b
		 * 
		 */		
		public function set backClick(b:Boolean):void
		{
			_backClick=b;
			this.resize();
		}
		
		public function get backClick():Boolean
		{
			return this._backClick;
		}
		
		/**
		 * 滚动条当前值 
		 * @param value
		 * 
		 */		
		public function set value(value:Number):void
		{
			_value = value;
			correctValue();
			positionHandle();
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		/**
		 * 滚动条最小值 
		 * @param value
		 * 
		 */		
		public function set minimum(value:Number):void
		{
			_min = value;
			this.correctValue();
			this.positionHandle();
		}
		
		
		public function get minimum():Number
		{
			return _min;
		}
		
		/**
		 * 滚动条最大值 
		 * @param value
		 * 
		 */		
		public function set maximum(value:Number):void
		{
			_max = value;
			this.correctValue();
			this.positionHandle();
		}		
		
		public function get maximum():Number
		{
			return _max;
		}
	}
}