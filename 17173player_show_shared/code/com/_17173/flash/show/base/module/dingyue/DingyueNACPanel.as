package com._17173.flash.show.base.module.dingyue
{
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 *普通的自动关闭板子 
	 * @author zhaoqinghao
	 * 
	 */	
	public class DingyueNACPanel extends DingyueBaseAutoClosePanel
	{
		
		protected var label:TextField = null;
		public function DingyueNACPanel(showTime:int=3, mouseStop:Boolean=false)
		{
			super(showTime, mouseStop);
		}
		
		protected function initbg():void{
			var bg:MovieClip = new BG_DyMsg();
			this.addChild(bg);
			this.width = bg.width;
			this.height = bg.height;
		}
		
		/**
		 *初始化板子 
		 * 
		 */		
		override protected function onInit():void{
			super.onInit();
			initbg();
			label = new TextField();
			label.mouseEnabled = false;
			label.width = 180;
			label.height = 70;
			label.x = 0;
			label.y = 0;
			this.addChild(label);
		}
		
		
		public function set title(value:String):void{
			label.htmlText = "<font color='#FFFFFF' size='18'>" + value + "</font>";
			reLabelPostion();
		}

		protected function reLabelPostion():void
		{
			label.x = (this.width - label.textWidth) / 2;
			label.y = (this.height - label.textHeight) / 2;
		}
	}
}