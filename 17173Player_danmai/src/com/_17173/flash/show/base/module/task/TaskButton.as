package com._17173.flash.show.base.module.task
{
	import com._17173.flash.show.base.components.common.plugbutton.PlugButton;
	
	import flash.display.DisplayObject;
	
	public class TaskButton extends PlugButton
	{
		public function TaskButton(eventType:String,skin:DisplayObject, label:String="", btnOrder:int=-1, isSelect:Boolean=false)
		{
			super(eventType, label, btnOrder, isSelect);
			this.setSkin(skin);
		}
	}
}