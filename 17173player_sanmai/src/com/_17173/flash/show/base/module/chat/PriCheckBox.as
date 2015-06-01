package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.CheckBox;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PriCheckBox extends CheckBox
	{
		public function PriCheckBox(label:String="", fontColor:uint=9141656)
		{
			super(label, fontColor);			
			this.removeChild(_labelTf);			
		}
		
		override public function addSkinUI(disp:DisplayObject, index:int=-1):void
		{
			super.addSkinUI(disp,index);
			this.setSize(disp.width,disp.height);
		}
		
		override protected function onOver(e:Event):void
		{
			this.addEventListener(MouseEvent.ROLL_OUT,onOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		override protected function onOut(e:Event):void
		{
			this.removeEventListener(MouseEvent.ROLL_OUT,onOut);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		override protected function onMouseDown(e:Event):void
		{
			selected = !selected;
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
		
		override protected function onMouseUp(e:Event):void{
			
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
		}
	}
}