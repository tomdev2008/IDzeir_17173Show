package com._17173.flash.player.module.bullets
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SelectColorItem extends Sprite
	{
		/**
		 *选择颜色组件 
		 * 
		 */		
		public function SelectColorItem($skin:Class)
		{
			super();
			this.mouseChildren = false;
			skin = new $skin() as DisplayObject;
			if(skin is MovieClip){
				(skin as MovieClip).gotoAndStop(0);
			}
			this.addChild(skin);
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			this.addEventListener(MouseEvent.MOUSE_UP,onUp);
			this.addEventListener(MouseEvent.ROLL_OUT,onUp);
		}
		
		protected var skin:DisplayObject = null;
		/**
		 *颜色值 
		 */		
		private var _colorValue:uint = 0x000000;
		/**
		 *显示颜色 
		 */		
		private var _showColor:Shape = null;
		/**
		 *是否选择 
		 */		
		private var _select:Boolean = false;
		
		/**
		 *点击 
		 * @param e
		 * 
		 */		
		private function onDown(e:Event):void{
			(skin as MovieClip).gotoAndStop(2);
		}
		
		private function onUp(e:Event):void{
			(skin as MovieClip).gotoAndStop(1);
		}
		/**
		 *设置颜色 
		 * @param cValue
		 * 
		 */		
		public function setColor(cValue:uint):void{
			_colorValue = cValue;
			updateColor();
		}
		
		
		public function getColorByNum():uint{
			return _colorValue;
		}
		/**
		 *获取16进制 
		 * @return 
		 * 
		 */		
		public function getColorByString():String{
			return checkLen(_colorValue.toString(16));
		}
		
		/**
		 *检查是否位数不足 
		 * @param str
		 * @return 
		 * 
		 */		
		private function checkLen(str:String):String{
			while(str.length < 6){
					str = "0" + str;
			}
			return str;
		}
		
		protected function updateColor():void{
			if(_showColor){
				if(_showColor.parent){
					_showColor.parent.removeChild(_showColor);
				}
				_showColor = null;
			}
			
			_showColor = new Shape();
			_showColor.graphics.beginFill(_colorValue);
			_showColor.graphics.drawRect(1,1,this.width-2,this.height-2);
			_showColor.graphics.endFill();
			this.addChild(_showColor);
		}
		
		
		public function set select(sl:Boolean):void{
			this._select = sl;
			updateSelect();
		}
		
		private function updateSelect():void{
			if(_select){
				(skin as MovieClip).gotoAndStop(2);
			}else{
				(skin as MovieClip).gotoAndStop(1);
			}
		}
	}
}