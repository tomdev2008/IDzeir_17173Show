package com._17173.flash.core.components.common
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-1-23  下午3:27:54
	 */
	public class ScrollSlider extends Slider
	{
		
		private var _thumbPercent:Number=1;
		
		/** 缓动过程中的目标位置*/
		protected var _desValue:Number=0;
		
		public function ScrollSlider(orientation:String, parent:DisplayObjectContainer=null, defaultHandler:Function=null)
		{
			super(orientation, parent);
			if(defaultHandler!=null)
			{
				this.addEventListener(Event.CHANGE,defaultHandler);
			}
		}
		
		override protected function onInit():void
		{
			super.onInit();
			this.setSliderParams(1,1,0);
			this.backClick=true;
			this.resize();
		}
		
		override protected function drawHandle():void
		{			
			var size:Number;
			if(this._orientation==HORIZONTAL)
			{
				size=Math.round(this._setWidth*_thumbPercent);
				size=Math.max(this._setHeight,size);
				_handle.width = Math.max(size-2,10);
				//_handle.width=size-2;
				//_handle.height=_setHeight-2;				
			}else{
				size=Math.round(_setHeight*_thumbPercent);
				size=Math.max(_setWidth,size);
				//_handle.width=_setWidth-2;
				//_handle.height=size-2;
				_handle.height = Math.max(size-2,10);
			}
			//_handle.x=_handle.y=1;
			this.positionHandle();
		}
		
		override protected function positionHandle():void
		{
			var range:Number;			
			if(this._orientation==HORIZONTAL)
			{
				range=_back.width-_handle.width;
				_handle.x=(_value-_min)/(_max-_min)*range;
				_handle.y=(_back.height-_handle.height)*.5+_back.y;
			}else{
				range=_back.height-_handle.height;
				_handle.x=(_back.width-_handle.width)*.5+_back.x;
				_handle.y=(_value-_min)/(_max-_min)*range;	
			}
		}
		
		/**
		 * 设置滑块尺寸的百分百 
		 * @param value
		 * 
		 */		
		public function setThumbPercent(value:Number):void
		{
			this._thumbPercent=Math.min(value,1);
			this.resize()
		}
		
		override protected function onBackClick(event:MouseEvent):void
		{
			this._desValue=valueUnderPoint(mouseX,mouseY);			
			
			if(!this.hasEventListener(Event.ENTER_FRAME))
			{
				this.addEventListener(Event.ENTER_FRAME,moveHandle);
			}
		}	
		
		private function moveHandle(e:Event):void
		{
			var disValue:Number=_desValue-_value;
			if(_value==this._max&&disValue==0){
				removeEventListener(Event.ENTER_FRAME,moveHandle);
				_value=_max;
				_desValue = 0;
			}else if(Math.abs(disValue)<2){
				removeEventListener(Event.ENTER_FRAME,moveHandle);
				_value=_desValue;	
				_desValue = 0;
			}else{
				_value+=disValue*.3;				
			}
			this.dispatchEvent(new Event(Event.CHANGE));
			correctValue();
			positionHandle();
		}
		
		/**
		 * 计算指定坐标的value值 
		 * @param xPos
		 * @param yPos
		 * @return 
		 * 
		 */		
		private function valueUnderPoint(xPos:Number,yPos:Number):Number
		{
			var valueRange:Number=_max-_min;
			var ratio:Number=0;
			if(this._orientation==HORIZONTAL)
			{
				ratio=(xPos-_back.x)/(_back.width-_back.height);
			}else{
				ratio=(yPos-_back.y)/(_back.height-_back.width);
			}
			return _min+valueRange*ratio;
		}
		
		override protected function onDrag(event:MouseEvent):void
		{
			if(this.hasEventListener(Event.ENTER_FRAME))
			{
				this.removeEventListener(Event.ENTER_FRAME,moveHandle);
			}
			
			stage.addEventListener(MouseEvent.MOUSE_UP,onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onSlide);
			if(this._orientation==HORIZONTAL)
			{
				_handle.startDrag(false,new Rectangle(0,_handle.y,this._setWidth-_handle.width,0));
			}else{
				_handle.startDrag(false,new Rectangle(_handle.x,0,0,this._setHeight-_handle.height));
			}
			event.stopPropagation();
			event.stopImmediatePropagation();
		}
		
		override protected function onSlide(e:MouseEvent):void
		{
			var oldValue:Number=_value;
			if(this._orientation==HORIZONTAL)
			{
				if(_setWidth==_handle.width)
				{
					_value=_min;
				}else{
					_value=_handle.x/(_setWidth-_handle.width)*(_max-_min)+_min;
				}
			}else{
				if(_setHeight==_handle.height)
				{
					_value=_min;
				}else{
					_value=_handle.y/(_setHeight-_handle.height)*(_max-_min)+_min;
				}
			}
			if(_value!=oldValue)
			{
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/** 滑块显示百分比*/
		public function get thumbPercent():Number
		{
			return this._thumbPercent;
		}
	}
}