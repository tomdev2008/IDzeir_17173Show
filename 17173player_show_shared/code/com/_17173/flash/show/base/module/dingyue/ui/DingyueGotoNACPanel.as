package com._17173.flash.show.base.module.dingyue.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.show.base.module.dingyue.DingyueNACPanel;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DingyueGotoNACPanel extends DingyueNACPanel
	{
		private var btnGoto:Button;
		private var _callback:Function;
		public function DingyueGotoNACPanel(gotoBack:Function, showTime:int=3, mouseStop:Boolean=true)
		{
			_callback = gotoBack;
			super(showTime, mouseStop);
			initBtn();
		}
		
		private function initBtn():void{
			btnGoto = new Button("查看");
			btnGoto.x = 63;
			btnGoto.y = 57;
			btnGoto.width = 65;
			btnGoto.height = 30;
			this.addChild(btnGoto);
			btnGoto.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		override protected function reLabelPostion():void
		{
			label.x = (this.width - label.textWidth) / 2;
			label.y = 20;
		}
		
		private function onClick(e:Event):void{
			if(_callback != null){
				_callback();
			}
		}
	}
}