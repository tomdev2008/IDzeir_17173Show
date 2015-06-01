package com._17173.flash.show.base.module.guidetask.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.module.guidetask.GuideManager;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.MouseEvent;
	
	public class GiftItem extends ItemSprite
	{
		public function GiftItem()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			_itemEndUI = new Task_gift_end();
			_itemBeginUI = new Task_gift_begin();
			
			_itemBeginUI.submitbtn.addEventListener(MouseEvent.CLICK, submitbtnClickHandler);
			_itemBeginUI.closebtn.addEventListener(MouseEvent.CLICK, closebtnClickHandler);
			
			
			_itemTip1UI = new Task_gift_tip2();
			_itemTip2UI = new Task_gift_tip1();
			_itemTip2UI.backbtn.addEventListener(MouseEvent.CLICK, backbtnClickHandler);
			
			super.createChildren();
			updateDisplayList();
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			this.graphics.clear();
			
			var vx:Number;
			var offsetObj:Object;
			var sceneMaxH:Number=710;
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
					/** 如果当前屏幕高度小于最小设置高度则计算高度 让礼物可见 **/
					if(baseHeight < sceneMaxH)
					{
						GuideManager.backgourdnLayer.x = (Context.stage.stageWidth - Math.floor(GuideManager.backgourdnLayer.width)) / 2;
						GuideManager.backgourdnLayer.y = baseHeight - sceneMaxH - 10;
					}
					
					
					vx = baseWidth/2 - 239;
					offsetObj = this.drawCusGraphic(vx,557,503,60);
					
					_itemTip1UI.y = 545 - _itemTip1UI.height + offsetObj.offsetY;
					_itemTip1UI.x = baseWidth/2 - _itemTip1UI.width/2 + offsetObj.offsetX + 10;
					_itemTip1UI.visible=true;
					
					eventManager.listen(SEvents.TASK_GIFT_CHOSE,onChoseGift);
					break;
				}
				case 2:
				{
					/** 如果当前屏幕高度小于最小设置高度则计算高度 让赠送可见 **/
					if(baseHeight < sceneMaxH)
					{
						GuideManager.backgourdnLayer.x = (Context.stage.stageWidth - Math.floor(GuideManager.backgourdnLayer.width)) / 2;
						GuideManager.backgourdnLayer.y = baseHeight - sceneMaxH - 10;
					}
					
					vx = baseWidth/2 + 30;
					offsetObj = this.drawCusGraphic(vx,618,86,35);
					
					_itemTip2UI.y = 618 - _itemTip2UI.height  + offsetObj.offsetY;
					_itemTip2UI.x = vx + 40 - _itemTip2UI.width/2  + offsetObj.offsetX;
					_itemTip2UI.visible=true;
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
		 * 返回上一步 
		 * @param event
		 * 
		 */		
		private function backbtnClickHandler(event:MouseEvent):void
		{
			_itemTip2UI.visible=false;
			/* 显示第一个提示 */
			this.index = 1;
			/** 更新显示列表 **/
			updateDisplayList();
		}
		
		private function onChoseGift():void
		{
			eventManager.remove(SEvents.TASK_GIFT_CHOSE,onChoseGift);
			
			_itemTip1UI.visible=false;
			
			this.index = 2;
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
				_itemTip2UI.visible=false;
				_itemEndUI.visible=true;
				_itemEndUI.txt.text = String(itemData.award);
				/** 重置背景高度 **/
				GuideManager.backgourdnLayer.x = (Context.stage.stageWidth - Math.floor(GuideManager.backgourdnLayer.width)) / 2;
				GuideManager.backgourdnLayer.y = 10;
				
				this.index = 0;
				/** 更新显示列表 **/
				updateDisplayList();
			}
		}
	}
}