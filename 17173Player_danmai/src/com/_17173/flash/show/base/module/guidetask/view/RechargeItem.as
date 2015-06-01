package com._17173.flash.show.base.module.guidetask.view
{
	import com._17173.flash.core.util.Cookies;
	import com._17173.flash.show.base.module.stat.base.StatTypeEnum;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.MouseEvent;
	
	public class RechargeItem extends ItemSprite
	{
		public function RechargeItem()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			_itemEndUI = new Task_recharge_end();
			_itemBeginUI = new Task_recharge_begin();
			_itemBeginUI.submitbtn.addEventListener(MouseEvent.CLICK, submitbtnClickHandler);
			_itemBeginUI.closebtn.addEventListener(MouseEvent.CLICK, closebtnClickHandler);
			
			super.createChildren();
			updateDisplayList();;
		}
		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			this.graphics.clear();
			
			var vx:Number;
			
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
			}
		}
		
		override protected function cancle():void
		{
			_itemBeginUI.visible=true;
		}
		
		private function submitbtnClickHandler(event:MouseEvent):void
		{
//			_itemBeginUI.visible=false;
//			eventManager.send(SEvents.TASK_QUIT,{"giveup":false,"itemSprite":this});
			
			
			Utils.toUrlAppedTime(SEnum.URL_MONEY);
			eventManager.send(SEvents.BI_STAT, {"type":StatTypeEnum.BI, "event":StatTypeEnum.CHONGZHI, "data":getTaskBI(StatTypeEnum.CHONGZHI)});
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
				if(_itemBeginUI.visible)
					_itemBeginUI.visible=false;
				_itemEndUI.visible=true;
				_itemEndUI.txt.text = String(itemData.award);
				
				this.index = 0;
				/** 更新显示列表 **/
				updateDisplayList();
				
			}
		}
		
		private function getTaskBI(str:String,event_val:int = 0):Object{
			var cookie:String = readCookie();
			var obj:Object = new Object();
			obj.preevent = cookie;
			obj.currevent = str;
			if(event_val > 0){
				obj.event_val = event_val;
			}
			wirteCookie(str);
			return obj;
		}
		
		private function wirteCookie(str:String):void{
			var cookie:Cookies = new Cookies("shared", "/");
			cookie.put("taskBI", str, true);
			cookie.close();
		}
		
		private function readCookie():String{
			var cookie:Cookies = new Cookies("shared", "/");
			if (cookie && cookie.get("taskBI")) {
				var task:Object = cookie.get("taskBI");
				if(task){
					return (task as String);
				}
			}
			return "";
		}
	}
}