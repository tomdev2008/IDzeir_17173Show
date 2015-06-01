package com._17173.flash.show.base.module.guidetask.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.MouseEvent;
	
	
	public class RenameItem extends ItemSprite
	{
		public function RenameItem()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			_itemEndUI = new Task_rename_end();
			_itemBeginUI = new Task_rename_begin();
			
			_itemBeginUI.submitbtn.addEventListener(MouseEvent.CLICK, submitbtnClickHandler);
			_itemBeginUI.closebtn.addEventListener(MouseEvent.CLICK, closebtnClickHandler);
			
			_itemTip1UI = new Task_rename_tip1();
			_itemTip2UI = new Task_rename_tip2();
			_itemTip3UI = new Task_rename_tip3();
			
			super.createChildren();
			updateDisplayList();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			this.graphics.clear();
			switch(this.index)
			{
				case 0:
				{
					this.graphics.beginFill(0,0.5);
					this.graphics.drawRect(0,0,baseWidth,baseHeight);
					this.graphics.endFill();
					
					if(_itemBeginUI)
					{
						_itemBeginUI.x = ~~((baseWidth - _itemBeginUI.width)/2);
						_itemBeginUI.y = ~~((baseHeight - _itemBeginUI.height)/2);
					}
					
					if(_itemEndUI)
					{
						_itemEndUI.x = ~~((baseWidth - _itemEndUI.width)/2);
						_itemEndUI.y = ~~((baseHeight - _itemEndUI.height)/2);
					}
					
					break;
				}
				case 1:
				{
					
					this.drawCusGraphic(0,60,50,58,null,false);
					
					_itemTip1UI.y = 80 - _itemTip1UI.height/2;
					_itemTip1UI.x = 50;
					_itemTip1UI.visible=true;
					
					eventManager.listen(SEvents.USERINFO_CLICK,onOpenUserPanel);
					break;
				}
				case 2:
				{
					this.drawCusGraphic(137,62,123,33,null,false);
					
					_itemTip2UI.y = 100;
					_itemTip2UI.x = 200 - _itemTip2UI.width/2;;
					_itemTip2UI.visible=true;
					
					eventManager.listen(SEvents.TASK_RENAME_TXT_CHANGE,changeName);
					break;
				}
				case 3:
				{
					this.drawCusGraphic(137,62,210,33,null,false);
					
					_itemTip3UI.y = 100;
					_itemTip3UI.x = 315 - _itemTip3UI.width/2;;
					_itemTip3UI.visible=true;
					
					//					eventManager.listen(SEvents.TASK_RENAME_SUCCESS,changeNameSuccess);
					break;
				}
			}
			
		}
		
		
		override protected function cancle():void
		{
			_itemBeginUI.visible=true;
		}
		
		private function submitbtnClickHandler(event:MouseEvent):void
		{
			_itemBeginUI.visible=false;
			/* 显示第一个提示 */
			this.index = 1;
			/** 更新显示列表 **/
			updateDisplayList();
		}
		
		private function closebtnClickHandler(event:MouseEvent):void
		{
			_itemBeginUI.visible=false;
			this.showAlert();
		}
		/**
		 * 打开显示列表 
		 * 
		 */		
		private function onOpenUserPanel():void
		{
			eventManager.remove(SEvents.USERINFO_CLICK,onOpenUserPanel);
			_itemTip1UI.visible=false;
			
			this.index = 2;
			/** 更新显示列表 **/
			updateDisplayList();
			
			Context.stage.addEventListener(MouseEvent.MOUSE_UP,stopStageMouseUpEvent,false,10);
		}
		
		private function stopStageMouseUpEvent(event:MouseEvent):void
		{
			event.preventDefault();
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
		private function changeName(data:Object):void
		{
			eventManager.remove(SEvents.TASK_RENAME_TXT_CHANGE,changeName);
			_itemTip2UI.visible=false;
			
			this.index = 3;
			/** 更新显示列表 **/
			updateDisplayList();
		}
		
		/**
		 * 更新数据 
		 * @param value
		 * 
		 */		
		override public function updateItemData(value:Object):void
		{
			super.updateItemData(value);
			
			if(this.itemData.getAward == "NO" && itemData.done == "DONE")
			{
				_itemTip3UI.visible=false;
				_itemEndUI.visible=true;
				_itemEndUI.txt.text = String(itemData.award);
				
				this.index = 0;
				/** 更新显示列表 **/
				updateDisplayList();
				
				Context.stage.removeEventListener(MouseEvent.MOUSE_UP,stopStageMouseUpEvent);
			}
		}
	}
}