package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.CheckBox;
	
	import flash.display.DisplayObject;
	
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
	}
}