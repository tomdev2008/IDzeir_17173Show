package com._17173.flash.show.base.module.guidetask.view
{
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.MouseEvent;

	public class UndoneItem extends ItemSprite
	{
		public function UndoneItem()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			_itemBeginUI = new Task_reward_alert();
			this.addChild(_itemBeginUI);
			
			_itemBeginUI.closebtn.addEventListener(MouseEvent.CLICK, closebtnClickHandler);
			_itemBeginUI.submitbtn.addEventListener(MouseEvent.CLICK, submitbtnClickHandler);
			
			updateDisplayList();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			this.graphics.beginFill(0,0.5);
			this.graphics.drawRect(0,0,baseWidth,baseHeight);
			this.graphics.endFill();
			
			if(_itemBeginUI)
			{
				_itemBeginUI.x = ~~((baseWidth - _itemBeginUI.width)/2);
				_itemBeginUI.y = ~~((baseHeight - _itemBeginUI.height)/2);
			}
			
		}
		
		override protected function cancle():void
		{
			_itemBeginUI.visible=true;
		}
		
		
		private function submitbtnClickHandler(event:MouseEvent):void
		{
			eventManager.send(SEvents.TASK_GOON,{"itemSprite":this});
		}
		
		private function closebtnClickHandler(event:MouseEvent):void
		{
			_itemBeginUI.visible=false;
			this.showAlert();
		}
	}
}