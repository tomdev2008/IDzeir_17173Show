package com._17173.flash.show.base.module.guidetask.view
{
	import com._17173.flash.show.base.components.common.plugbutton.PlugButton;
	import com._17173.flash.show.base.module.task.TaskButton;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class QuitTipItem extends ItemSprite
	{
		private var _continueTipUI:MovieClip;
		public function QuitTipItem()
		{
			super();
		}
		
		override protected function createChildren():void{
			
			_continueTipUI = new Task_continue_tip();
			this.addChild(_continueTipUI);
			_continueTipUI.visible=false;
			
			updateDisplayList();
			
			eventManager.listen(SEvents.PLUGBUTTON_ADDED,function(data:Object):void{
				if(data is TaskButton){
					var point:Point = (data as PlugButton).localToGlobal(new Point(data.x,data.y));
					_continueTipUI.y = point.y - _continueTipUI.height + 30;
					_continueTipUI.x = 56;
					_continueTipUI.visible=true;
				}
			});
		}
		/**
		 * 更新显示列表 
		 * 
		 */		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			this.graphics.clear();
//			this.graphics.beginFill(0,0.4);
//			this.graphics.drawRect(0,0,baseWidth,baseHeight);
//			this.graphics.endFill();
			
//			_continueTipUI.x = 56;
//			_continueTipUI.y = 350 - _continueTipUI.height/2;
		}
	}
}