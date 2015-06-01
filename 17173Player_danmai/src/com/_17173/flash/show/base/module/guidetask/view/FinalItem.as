package com._17173.flash.show.base.module.guidetask.view
{
	import com._17173.flash.show.base.module.guidetask.vo.GuideTaskVO;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.MouseEvent;
	
	public class FinalItem extends ItemSprite
	{
		public function FinalItem()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			_itemBeginUI = new Task_package();
			this.addChild(_itemBeginUI);
			
			_itemBeginUI.closebtn.visible = false;
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
		
		private function submitbtnClickHandler(event:MouseEvent):void
		{
			eventManager.send(SEvents.TASK_FINISHED,{"itemSprite":this,"taskfinish":true});
			eventManager.send(SEvents.TASK_GET_REWARD,{"taskId":GuideTaskVO.taskId,"final":true});
		}
	}
}