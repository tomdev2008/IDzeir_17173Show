package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.CheckBox;
	import com._17173.flash.core.util.Util;
	
	public class QuizCheckBox extends CheckBox
	{
		public function QuizCheckBox(label:String="")
		{
			super(label);
			this.setSkin(new quizMultiSelectBtn());
		}
		
		override public function set label(value:String):void {
			super.label = "<FONT size='14' color='#ffffff' face='" + Util.getDefaultFontNotSysFont() + "'>" + value + "</FONT>";
		}
	}
}