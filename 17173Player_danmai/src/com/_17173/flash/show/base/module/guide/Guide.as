package com._17173.flash.show.base.module.guide
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class Guide extends BaseModule
	{
		private var _elementArray:Array;
		private var _stepIndex:int=0;
		private var _em:IEventManager;

		public function Guide()
		{
			super();
			this.visible=false;
			initElement();
		}
		
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			//赋值配置
			Context.stage.addEventListener(Event.RESIZE, onStageResize);
			_em = Context.getContext(CEnum.EVENT) as IEventManager;
			
		}
		protected function onStageResize(event:Event):void 
		{
			for each(var element:Object in _elementArray)
			{
				UpdatePos(element);
			}
		}
		/**
		 * 初始化引导元素 
		 * 
		 */		
		private function initElement():void
		{
			_elementArray = new Array();
			_elementArray.push({content:new Guide_FLUI(),left:60,middle:-30,auto:true});
			_elementArray.push({content:new Guide_YRUI(),center:-300,top:382,auto:true});
			_elementArray.push({content:new Guide_DYUI(),center:50,top:460,auto:true});
			_elementArray.push({content:new Guide_LBUI(),left:50,top:180,auto:true});
			_elementArray.push({content:new Guide_LTUI(),center:210,top:620,auto:true});
			_elementArray.push({content:new Guide_LWUI(),center:-240,top:485,auto:true});
			_elementArray.push({content:new Guide_DTUI(),left:50,top:120,auto:true});
			_elementArray.push({content:new Guide_DZUI(),left:50,top:75,auto:true});
			_elementArray.push({content:new Guide_XXUI(),left:50,top:75,auto:true});
			
			addEventListeren();
			addStageAndUpdatePosition();
		}
		/**
		 * 添加监听器 
		 * 
		 */		
		private function addEventListeren():void
		{
			for each(var element:Object in _elementArray)
			{
				element.content.btn.addEventListener(MouseEvent.CLICK,btnClickHandler);
			}
		}
		
		/**
		 * 添加到舞台并且更新位置 
		 * 
		 */		
		private function addStageAndUpdatePosition():void
		{
			for each(var element:Object in _elementArray)
			{
				this.addChild(element.content);
				UpdatePos(element);
				element.content.visible=false;
			}
		}
		
		private function UpdatePos(element:Object):void {
			if(!element.auto)return;
			var baseWidth:int = Context.stage.stageWidth;
			var baseHeight:int = Context.stage.stageHeight;
			
			if(element.hasOwnProperty("center"))
			{				
				element.content.x = element.center + (baseWidth - element.content.width)/2;	
			}else
			{
				if(element.hasOwnProperty("left"))
					element.content.x = element.left;
				else if (element.hasOwnProperty("right"))
					element.content.x = baseWidth - element.right - element.content.width; 
				else
					element.content.x = 0;
			}
			if(element.hasOwnProperty("middle"))
			{
				element.content.y = element.middle + (baseHeight - element.content.height)/2;	
			}else
			{
				
				if (element.hasOwnProperty("top")) {
					element.content.y = element.top;
				} else if (element.hasOwnProperty("bottom")) {
					element.content.y = baseHeight - element.bottom - element.content.height;
				} else {
					element.content.y = 0;
				}
			}
		}
		
		private var _taskPoint:Point;
		/**
		 * 设置索引值对应对象的位置 
		 * @param value
		 * 
		 */		
		public function setPostionByIndex(value:int,point:Point):void
		{			
			if(value < _elementArray.length - 1 && point!=null)
			{
				switch(value)
				{
					case 0:
					{
						_taskPoint = point;
						_elementArray[value].content.y = point.y - _elementArray[value].content.height/2 - 40;
						_elementArray[value].auto = false;
						break;
					}
					case 4:
					{
//						if(point.y > 0 && Context.stage.stageWidth>0)
//						{
//							_elementArray[value].content.y = point.y + 188;
//							_elementArray[value].content.x = Context.stage.stageWidth - _elementArray[value].right - _elementArray[value].content.width; 
//							_elementArray[value].auto = false;
//						}
						_elementArray[value].top = point.y + 140;
						UpdatePos(_elementArray[value]);
						break;
					}
				}
			}
		}

		/**
		 * 关闭引导元素
		 * 进入下一个 
		 * @param event
		 * 
		 */		
		private function btnClickHandler(event:MouseEvent):void
		{
			//关闭新手任务，派发显示新任务列表事件
			if(_stepIndex == 0)
			{
				_em.send(SEvents.IS_SHOW_TASK,_taskPoint);
			}
			_stepIndex++;
			displayByIndex(_stepIndex);
		}
		/**
		 * 根据索引显示引导提示 
		 * @param value
		 * 
		 */		
		public function displayByIndex(value:int):void
		{			
			var user:User;
			_stepIndex = value;
			if(_stepIndex < _elementArray.length - 1)
			{
				//_em.send(SEvents.CHange_SCENE_DRAG,false);
				this.visible=true;
				for each(var element:Object in _elementArray)
				{
					element.content.visible=false;
					UpdatePos(element);
				}
				if(_stepIndex == 7)
				{
					//如果用户登录则显示登录信息
					user = Context.getContext(CEnum.USER) as User;
					if(user.me.isLogin)
						_elementArray[_stepIndex+1].content.visible=true;
					else
						_elementArray[_stepIndex].content.visible=true;
				}else
					_elementArray[_stepIndex].content.visible=true;				
			}else
			{
				this.visible=false; //完成隐藏模块
				//_em.send(SEvents.CHange_SCENE_DRAG,true);
				user = Context.getContext(CEnum.USER) as User;
				if(!user.me.isLogin)
					_em.send(SEvents.LOGINPANEL_SHOW);
			}
			//转发事件 写cooikes
			_em.send(SEvents.FLUSH_GUIDE_COOKIE,_stepIndex);
		}
	}
}