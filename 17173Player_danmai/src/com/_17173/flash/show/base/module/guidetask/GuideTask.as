package com._17173.flash.show.base.module.guidetask
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.module.guidetask.view.ChatItem;
	import com._17173.flash.show.base.module.guidetask.view.FinalItem;
	import com._17173.flash.show.base.module.guidetask.view.GiftItem;
	import com._17173.flash.show.base.module.guidetask.view.ItemSprite;
	import com._17173.flash.show.base.module.guidetask.view.LoginItem;
	import com._17173.flash.show.base.module.guidetask.view.QuitTipItem;
	import com._17173.flash.show.base.module.guidetask.view.RechargeItem;
	import com._17173.flash.show.base.module.guidetask.view.RenameItem;
	import com._17173.flash.show.base.module.guidetask.view.SubsItem;
	import com._17173.flash.show.base.module.guidetask.view.UndoneItem;
	import com._17173.flash.show.base.module.guidetask.vo.GuideTaskVO;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	public class GuideTask extends BaseModule
	{
        private var _taskList:Array;
		
		public static const SCENE_WIDTH:int = 1920;
		public static const SCENE_HEIGHT:int = 1000;
		
		public function GuideTask()
		{
			super();
			
			this.graphics.lineStyle(0.1,0,0);
			this.graphics.drawRect(0,0,SCENE_WIDTH,SCENE_HEIGHT);
		}
		
		
		private var _index:int=0;
		private function runTaskByIndex(index:int):void
		{
			GuideManager.runningGuide=true;//新手引导任务是否正在运行
			_index = index;
			switch(index)
			{
				case 0:
				{
					var loginItem:LoginItem = new LoginItem();
					if(_taskList!=null && _taskList.length>0)
					loginItem.setItemData(_taskList[_index]);
					this.addChild(loginItem);
					break;
				}
				case 1:
				{
					var renameItem:RenameItem = new RenameItem();
						renameItem.setItemData(_taskList[_index]);
					this.addChild(renameItem);
					break;
				}
				case 2:
				{
					var chatItem:ChatItem = new ChatItem();
						chatItem.setItemData(_taskList[_index]);
					this.addChild(chatItem);
					break;
				}
				case 3:
				{
					var subsItem:SubsItem = new SubsItem();
						subsItem.setItemData(_taskList[_index]);
					this.addChild(subsItem);
					break;
				}
				case 4:
				{
					var giftItem:GiftItem = new GiftItem();
						giftItem.setItemData(_taskList[_index]);
					this.addChild(giftItem);
					break;
				}
				case 5:
				{
					var rechangeItem:RechargeItem = new RechargeItem();
						rechangeItem.setItemData(_taskList[_index]);
					this.addChild(rechangeItem);
					break;
				}
			}
		}
		/**
		 * 检测任务状态 
		 * 
		 */		
		private function checkTaskState():void
		{
			for(var i:int=_index,len:int=_taskList.length; i < len; i++)
			{
				if(_taskList[i].done == "UNDONE" || _taskList[i].getAward == "NO"){
					runTaskByIndex(i);
					break;
				}
			}
		}
		/**
		 * 延迟开始任务 
		 * 
		 */		
		private function delayTask():void
		{
			Ticker.tick(8000, function ():void{
				runTaskByIndex(0);
			});
		}
		/**
		 * 设置任务数据 
		 * @param value
		 * 
		 */		
		public function startGuideTask():void
		{
			if(GuideTaskVO.masterTaskList)
			   _taskList = GuideTaskVO.masterTaskList;
			
			var e:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			e.listen(SEvents.TASK_FINISHED,taskFinish);
			e.listen(SEvents.TASK_QUIT,taskQuit);
			e.listen(SEvents.TASK_GOON,taskGonon);
			
			var user:User = Context.getContext(CEnum.USER) as User;
			if(user.me.isLogin)
			{
				if(GuideTaskVO.taskStatus == "UNDONE")
				{
					this.addChild(new UndoneItem());
				}
				else if(GuideTaskVO.taskStatus == "OPEN")
					delayTask();
				else if(GuideTaskVO.finalAward == "NO" && GuideTaskVO.taskStatus == "DONE")
					getFinalReward();
			}else{
				delayTask();
			}
		}
		/**
		 * 继续任务 
		 * 
		 */		
		public function continueGuideTask():void
		{
			if(_quiteTipItem && this.contains(_quiteTipItem))
				this.removeChild(_quiteTipItem);
			
			Ticker.stop(showTipTicker);
			
			if(GuideTaskVO.masterTaskList)
				_taskList = GuideTaskVO.masterTaskList;
			this.visible=true;
//			runTaskByIndex(_index);
//			checkTaskState();
			var user:User = Context.getContext(CEnum.USER) as User;
			if(user.me.isLogin)
			{
				if(GuideTaskVO.taskStatus == "UNDONE")
				{
					this.addChild(new UndoneItem());
				}
				else if(GuideTaskVO.taskStatus == "OPEN")
					checkTaskState();
				else if(GuideTaskVO.finalAward == "NO" && GuideTaskVO.taskStatus == "DONE")
					getFinalReward();
			}else{
				runTaskByIndex(0);
			}
		}
		/**
		 * 更新任务 
		 * @param data
		 * 
		 */		
		public function updateTask(data:Object):void
		{
			var itemSprite:ItemSprite = this.getChildAt(0) as ItemSprite;
			itemSprite.updateItemData(data);
		}
		/**
		 * 最终奖励界面 
		 * 
		 */		
		private function getFinalReward():void
		{
			var finalItem:FinalItem = new FinalItem();
			this.addChild(finalItem);
		}
		
		
		private function taskGonon(data:Object):void
		{
			this.removeChild(data.itemSprite);
			checkTaskState();
		}
		/**
		 * 
		 * @param data
		 * 
		 */		
		private function taskFinish(data:Object):void
		{
			if("taskfinish" in data && data["taskfinish"])
			{
				GuideManager.runningGuide=false;//新手引导任务是否正在运行
				this.parent.removeChild(this);
			}else
			{
				_index++;
				this.removeChild(data.itemSprite);
				data.itemSprite = null;
				
				if(_index<_taskList.length)
					checkTaskState();
				else
					getFinalReward();
			}
		} 
		

		/**
		 *  
		 * @param data
		 * 
		 */	
		private var _quiteTipItem:QuitTipItem;
		private function taskQuit(data:Object):void
		{
			GuideManager.runningGuide=false;//新手引导任务是否正在运行
			if(!data.giveup){
				this.removeChild(data.itemSprite);
				data.itemSprite = null;
				
				if(_quiteTipItem==null)
					_quiteTipItem = new QuitTipItem();
				
				this.addChild(_quiteTipItem);
				Ticker.tick(5000,showTipTicker);
			}
		}
		
		private function showTipTicker():void
		{
			this.visible=false;
			if(this.contains(_quiteTipItem))
				this.removeChild(_quiteTipItem);
		}
	}
}