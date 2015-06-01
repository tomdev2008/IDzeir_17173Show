package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.CheckBox;
	import com._17173.flash.core.util.Util;
	
	import flash.events.Event;
	
	public class QuizRadioBtn extends CheckBox
	{
		public function QuizRadioBtn(label:String = "")
		{
			super(label);
			this.setSkin(new quizRadioBtn());
		}
		
		override public function set label(value:String):void {
			super.label = "<FONT size='14' color='#ffffff' face='" + Util.getDefaultFontNotSysFont() + "'>" + value + "</FONT>";
		}
		
		
		override protected function onMouseUp(e:Event):void{
			super.onMouseUp(e);
			if(selected){
				super.onMouseUp(e);
				selected = true;
			}else{
				super.onMouseUp(e);
			}
		}
	}
}