package com._17173.flash.show.base.module.guidetask.view
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.module.guidetask.GuideManager;
	import com._17173.flash.show.base.module.guidetask.vo.GuideTaskVO;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ItemSprite extends Sprite
	{
		private var _itemData:ItemData;
		private var _index:int=0;

		public var _itemBeginUI:MovieClip;
		public var _itemEndUI:MovieClip;
		
		public var _itemTip1UI:MovieClip;
		public var _itemTip2UI:MovieClip;
		public var _itemTip3UI:MovieClip;
		public var _itemTip4UI:MovieClip;
		
		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

		public function ItemSprite()
		{
			super();
			
			this.addEventListener(Event.ADDED_TO_STAGE,function itemAddToStage(event:Event):void
			{
				createChildren();
			});
			Context.stage.addEventListener(Event.RESIZE,function(event:Event):void{
				updateDisplayList();
			});
			
		}
		
		public function setItemData(value:Object):void
		{
			if(value==null)return;
			
			_itemData = new ItemData();
			if("subTaskId" in value)
				_itemData.subTaskId = value.subTaskId;
			if("subTaskName" in value)
				_itemData.subTaskName = value.subTaskName;
			if("subTaskName" in value)
				_itemData.done = value.done;
			if("subTaskName" in value)
				_itemData.award = Number(value.award);
			if("subTaskName" in value)
				_itemData.subTaskShowQuickButton = Number(value.subTaskShowQuickButton);
			if("subTaskName" in value)
				_itemData.getAward = value.getAward;
				
		}
		
		public function updateItemData(value:Object):void
		{
			if(value.subTaskId != _itemData.subTaskId)return;
			
			_itemData.award = value.award;
			_itemData.getAward = value.getAward;
			_itemData.done = value.done;
		}
		
		public function get itemData():ItemData
		{
			return _itemData;
		}
		
		private var _baseWidth:Number;

		public function set baseWidth(value:Number):void
		{
			_baseWidth = value;
		}

		
		public function get baseWidth():Number
		{
			return _baseWidth;
		}
		
		private var _baseHeight:Number;

		public function set baseHeight(value:Number):void
		{
			_baseHeight = value;
		}

		
		public function get baseHeight():Number
		{
			return _baseHeight;
		}
		
		public function get eventManager():IEventManager
		{
			return Context.getContext(CEnum.EVENT)as IEventManager;
		}
		
		public function drawCusGraphic(vx:int,vy:int,w:int,h:int,display:Sprite=null,absoult:Boolean=true):Object
		{
			if(display == null)display=this;
			
			var offsetX:Number;
			var offsetY:Number;
			
			offsetX = GuideManager.backgourdnLayer.x - (Context.stage.stageWidth - Math.floor(GuideManager.backgourdnLayer.width)) / 2;
			offsetY = GuideManager.backgourdnLayer.y - 10;
			if(absoult)
			{
				vx += offsetX;
				vy += offsetY;
			}
			display.graphics.clear();
			display.graphics.beginFill(0,0.7);
			display.graphics.drawRect(0,0,baseWidth,baseHeight);
			display.graphics.lineStyle(1,0xEC28BD);
			display.graphics.drawRect(vx,vy,w,h);
			display.graphics.endFill();
			
			return {"offsetX":offsetX,"offsetY":offsetY};
		}
		
		private var _alertUI:MovieClip;
		public function showAlert():void
		{
			if(_alertUI==null)
			{
				_alertUI = new Task_quit_alert();
				_alertUI.submitbtn.addEventListener(MouseEvent.CLICK, submitbtnClickHandler);
				_alertUI.canclebtn.addEventListener(MouseEvent.CLICK, canclebtnClickHandler);
				_alertUI.closebtn.addEventListener(MouseEvent.CLICK, canclebtnClickHandler);
				
				_alertUI.radiobtn1.gotoAndStop(2);
				_alertUI.radiobtn2.gotoAndStop(1);
				
				_alertUI.radiobtn1.addEventListener(MouseEvent.CLICK, radiobtn1ClickHandler);
				_alertUI.radiobtn2.addEventListener(MouseEvent.CLICK, radiobtn2ClickHandler);
			}
			this.addChild(_alertUI);
			
			baseWidth = Context.stage.stageWidth;
			baseHeight = Context.stage.stageHeight;
			
			_alertUI.x = ~~((baseWidth - _alertUI.width)/2);
			_alertUI.y = ~~((baseHeight - _alertUI.height)/2);
		}
		
		private var _giveUp:Boolean=false;
		private function submitbtnClickHandler(event:MouseEvent):void
		{
			var e:IEventManager = Context.getContext(CEnum.EVENT) as IEventManager;
			e.send(SEvents.TASK_QUIT,{"giveup":_giveUp,"itemSprite":this});
		}
		
		private function canclebtnClickHandler(event:MouseEvent):void
		{
			cancle();
			this.removeChild(_alertUI);
		}
		
		private function radiobtn1ClickHandler(event:MouseEvent):void
		{
			_giveUp=false;
			_alertUI.radiobtn1.gotoAndStop(2);
			_alertUI.radiobtn2.gotoAndStop(1);
		}
		
		private function radiobtn2ClickHandler(event:MouseEvent):void
		{
			_giveUp=true;
			_alertUI.radiobtn1.gotoAndStop(1);
			_alertUI.radiobtn2.gotoAndStop(2);
		}
		
		/**
		 * 创建显示列表 
		 * 
		 */		
		protected function createChildren():void
		{
			if(this.itemData.getAward == "NO")
			{
				_itemEndUI.txt.text = String(itemData.award);
				this.addChild(_itemEndUI);
				
				var that:* = this;
				_itemEndUI.submitbtn.addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void{
					eventManager.send(SEvents.TASK_FINISHED,{"itemSprite":that});
					
					eventManager.send(SEvents.TASK_GET_REWARD,{"taskId":GuideTaskVO.taskId,"subTaskId":itemData.subTaskId});
				});
			}
			
			if(this.itemData.done == "DONE")return;
			this.addChild(_itemBeginUI);
			
			_itemEndUI.visible=false;
			
			if(_itemTip1UI!=null)
			{
				this.addChild(_itemTip1UI);
				_itemTip1UI.visible=false;
			}
			
			if(_itemTip2UI!=null)
			{
				this.addChild(_itemTip2UI);
				_itemTip2UI.visible=false;
			}
			
			if(_itemTip3UI!=null)
			{
				this.addChild(_itemTip3UI);
				_itemTip3UI.visible=false;
			}
			
			if(_itemTip4UI!=null)
			{
				this.addChild(_itemTip4UI);
				_itemTip4UI.visible=false;
			}
		}
		
		/**
		 * 更新列表 
		 * 
		 */        
		protected function updateDisplayList():void{
			
			this.graphics.clear();
			baseWidth = Context.stage.stageWidth;
			baseHeight = Context.stage.stageHeight;
		}
		
		protected function cancle():void{}
	    }
}
class ItemData{
	public var subTaskId:String;
	public var subTaskName:String;
	public var done:String; //"DONE" | "UNDONE"
	public var award:Number; //50
	public var subTaskShowQuickButton:Number; //1 | 0
	public var getAward:String; //"NO" | "YES"
	public function ItemData():void
	{
		
	}
}