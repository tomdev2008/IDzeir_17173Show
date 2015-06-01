package com._17173.flash.show.base.module.guidetask.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.MouseEvent;

	public class SubsItem extends ItemSprite
	{
		public function SubsItem()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			_itemEndUI = new Task_subs_end();
			_itemBeginUI = new Task_subs_begin();
			
			_itemBeginUI.submitbtn.addEventListener(MouseEvent.CLICK, submitbtnClickHandler);
			_itemBeginUI.closebtn.addEventListener(MouseEvent.CLICK, closebtnClickHandler);
			
			_itemTip1UI = new Task_subs_tip1();
			
			super.createChildren();
			updateDisplayList();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			this.graphics.clear();
			
			var vx:Number;
			var offsetObj:Object;
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
					vx = baseWidth/2 - 55;
					offsetObj = this.drawCusGraphic(vx,427,95,30);
					
					_itemTip1UI.y = 458 + offsetObj.offsetY;
					_itemTip1UI.x = vx + 40 - _itemTip1UI.width/2 + offsetObj.offsetX;
					_itemTip1UI.visible=true;
					
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
		 * 更新数据 
		 * @param value
		 * 
		 */		
		override public function updateItemData(value:Object):void
		{
			super.updateItemData(value);
			
			if(this.itemData.getAward == "NO" && itemData.done == "DONE")
			{
				_itemTip1UI.visible=false;
				_itemEndUI.visible=true;
				_itemEndUI.txt.text = String(itemData.award);
				
				this.index = 0;
				/** 更新显示列表 **/
				updateDisplayList();
				
			}
		}

	}
}