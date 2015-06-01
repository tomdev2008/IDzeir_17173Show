package com._17173.flash.show.base.module.guidetask.view
{
	import com._17173.flash.show.base.module.guidetask.vo.GuideTaskVO;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	public class LoginItem extends ItemSprite
	{
		private var _loginBeginUI:MovieClip;
		private var _loginEndUI:MovieClip;
		public function LoginItem()
		{
			super();
		}
		
		override protected function createChildren():void
		{
			if(this.itemData ==null || this.itemData.done == "UNDONE")
			{
				_loginBeginUI = new Task_login_begin();
				this.addChild(_loginBeginUI);
				_loginBeginUI.txt.text = "5";
				
				_loginBeginUI.submitbtn.addEventListener(MouseEvent.CLICK, submitbtnClickHandler);
				_loginBeginUI.closebtn.addEventListener(MouseEvent.CLICK, closebtnClickHandler);
			}else if(this.itemData.getAward == "NO")
			{
				_loginEndUI = new Task_login_end();
				this.addChild(_loginEndUI);
				_loginEndUI.txt.text = String(itemData.award);
				
				var that:* = this;
				_loginEndUI.submitbtn.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void{
					eventManager.send(SEvents.TASK_FINISHED,{"itemSprite":that});
					
					eventManager.send(SEvents.TASK_GET_REWARD,{"taskId":GuideTaskVO.taskId,"subTaskId":itemData.subTaskId});
				});
			}
			updateDisplayList();
		}
		/**
		 * 更新显示列表 
		 * 
		 */		
		override protected function updateDisplayList():void
		{
			super.updateDisplayList();
			
			this.graphics.clear();
			this.graphics.beginFill(0,0.5);
			this.graphics.drawRect(0,0,baseWidth,baseHeight);
			this.graphics.endFill();
			
			if(_loginBeginUI)
			{
				_loginBeginUI.x = ~~((baseWidth - _loginBeginUI.width)/2);
				_loginBeginUI.y = ~~((baseHeight - _loginBeginUI.height)/2);
			}
			
			if(_loginEndUI)
			{
				_loginEndUI.x = ~~((baseWidth - _loginEndUI.width)/2);
				_loginEndUI.y = ~~((baseHeight - _loginEndUI.height)/2);
			}
		}
		
		
		override protected function cancle():void
		{
			_loginBeginUI.visible=true;
		}
			
		
		private function submitbtnClickHandler(event:MouseEvent):void
		{
			//打开登录
			eventManager.send(SEvents.LOGINPANEL_SHOW);
		}
		
		private function closebtnClickHandler(event:MouseEvent):void
		{
			if(this.itemData ==null)
			{
				eventManager.send(SEvents.TASK_QUIT,{"giveup":false,"itemSprite":this});
			}else{
				_loginBeginUI.visible=false;
				this.showAlert();
			}
		}
	}
}