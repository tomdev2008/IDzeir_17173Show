package com._17173.flash.show.base.module.guidetask.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.module.guidetask.vo.GuideTaskVO;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ChatItem extends ItemSprite
	{
		public function ChatItem()
		{
			super();
			this.eventManager.listen(SEvents.CHAT_RESIZE,chatResizeHandler);
		}
			
		private function chatResizeHandler():void
		{
			if(index>2)
				updateDisplayList();
		}
		
		override protected function createChildren():void
		{
			_itemEndUI = new Task_chat_end();
			_itemBeginUI = new Task_chat_begin();
			_itemBeginUI.submitbtn.addEventListener(MouseEvent.CLICK, submitbtnClickHandler);
			_itemBeginUI.closebtn.addEventListener(MouseEvent.CLICK, closebtnClickHandler);
			
			
			_itemTip1UI = new Task_chat_tip1();
			_itemTip2UI = new Task_chat_tip2();
			_itemTip3UI = new Task_chat_tip3();
			_itemTip4UI = new Task_chat_tip4();
			
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
					vx = baseWidth/2 - 230;
					offsetObj = this.drawCusGraphic(vx,420,115,24);
					
					_itemTip1UI.y = 444 + offsetObj.offsetY;
					_itemTip1UI.x = vx + 50 - _itemTip1UI.width/2 + offsetObj.offsetX;
					_itemTip1UI.visible=true;
					
					
					eventManager.listen(SEvents.TASK_CHAT_CLICK_MASTER,onClickMaster);
					
					break;
				}
				case 2:
				{
					offsetObj = this.drawCusGraphic(_cardPoint.point.x + 1,_cardPoint.point.y + 125,185,24,_maskSprite,false);
					_itemTip2UI.y = _cardPoint.point.y + 205 - _itemTip2UI.height;
					_itemTip2UI.x = _cardPoint.point.x + 187;
					_itemTip2UI.visible=true;
					
					eventManager.listen(SEvents.USER_CARD_PUBLIC_CHAT_TO,chatToMaster);
					
					break;
				}
				case 3:
				{
					vx = baseWidth/2 + 310;
					offsetObj = this.drawCusGraphic(vx,GuideTaskVO.chatHeight + 97,246,58);
					
					_itemTip3UI.y = GuideTaskVO.chatHeight + 99 - _itemTip3UI.height + offsetObj.offsetY;
					_itemTip3UI.x = vx + 150 - _itemTip3UI.width/2 + offsetObj.offsetX;
					_itemTip3UI.visible=true;
					
					eventManager.listen(SEvents.TASK_CHAT_TXT_CHANGE,chatInputChange);
					break;
				}
				case 4:
				{
					vx = baseWidth/2 + 310;
					offsetObj = this.drawCusGraphic(vx,GuideTaskVO.chatHeight + 97,305,58);
					
					_itemTip4UI.y = GuideTaskVO.chatHeight + 99 - _itemTip4UI.height + offsetObj.offsetY;
					_itemTip4UI.x = vx + 305 - _itemTip4UI.width/2  + offsetObj.offsetX;
					_itemTip4UI.visible=true;
					
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
		
		private var _cardPoint:Object;
		private var _maskSprite:Sprite;
		private function onClickMaster(data:Object):void
		{
			eventManager.remove(SEvents.TASK_CHAT_CLICK_MASTER,onClickMaster);
			_cardPoint = data;
			_itemTip1UI.visible=false;
			
			_maskSprite = new Sprite();
			Context.stage.addChild(_maskSprite);
			_maskSprite.addChild(_itemTip2UI);
			Context.stage.addEventListener(MouseEvent.MOUSE_UP,stopStageMouseUpEvent,false,10);
			Context.stage.addEventListener(MouseEvent.CLICK,stopStageMouseUpEvent,false,10);
			Context.stage.addEventListener(MouseEvent.MOUSE_DOWN,stopStageMouseUpEvent,false,10);
			
			this.index = 2;
			/** 更新显示列表 **/
			updateDisplayList();
		}
		
		private function stopStageMouseUpEvent(event:MouseEvent):void
		{
			event.preventDefault();
			event.stopImmediatePropagation();
			event.stopPropagation();
		}
		
		private function chatToMaster(data:Object):void
		{
			eventManager.remove(SEvents.USER_CARD_PUBLIC_CHAT_TO,chatToMaster);
			
			this.index = 3;
			/** 更新显示列表 **/
			updateDisplayList();
			
			Context.stage.removeChild(_maskSprite);
			Context.stage.removeEventListener(MouseEvent.MOUSE_UP,stopStageMouseUpEvent);
			Context.stage.removeEventListener(MouseEvent.CLICK,stopStageMouseUpEvent);
			Context.stage.removeEventListener(MouseEvent.MOUSE_DOWN,stopStageMouseUpEvent);
		}
		
		private function chatInputChange(data:Object):void
		{
			eventManager.remove(SEvents.TASK_CHAT_TXT_CHANGE,chatInputChange);
			
			_itemTip3UI.visible=false;
			
			this.index = 4;
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
				_itemTip4UI.visible=false;
				_itemEndUI.visible=true;
				_itemEndUI.txt.text = String(itemData.award);
				
				this.index = 0;
				/** 更新显示列表 **/
				updateDisplayList();
			}
		}
	}
}