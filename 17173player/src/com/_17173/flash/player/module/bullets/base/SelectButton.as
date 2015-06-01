
package com._17173.flash.player.module.bullets.base
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SelectButton extends Sprite
	{
		
		public function SelectButton(btn:SimpleButton)
		{
			super();
			mouseChildren = false;
			this.addEventListener(MouseEvent.MOUSE_UP,reSet);
			this.addEventListener(MouseEvent.ROLL_OUT,reSet);
			_btn = btn;
			_status = [_btn.upState,_btn.downState,_btn.overState];
			this.addChild(_btn);
			this.buttonMode = true;
		}
		private var _status:Array = null;
		private var _btn:SimpleButton = null;
		private var _select:Boolean = false;
		
		
		public function get select():Boolean
		{
			return _select;
		}

		public function set select(value:Boolean):void
		{
			_select = value;
			reSet(null);
		}

		private function reSet(e:Event):void{
			if(_select){
				_btn.upState = _status[1];
			}else{
				_btn.upState = _status[0];
			}
		}
	}
}