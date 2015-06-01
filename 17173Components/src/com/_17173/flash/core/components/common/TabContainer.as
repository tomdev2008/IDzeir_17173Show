package com._17173.flash.core.components.common
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[Event(name="change", type="flash.events.Event")]
	/** 
	 * 带选项卡的显示容器
	 * @author idzeir
	 * 创建时间：2014-1-20 下午13:01:12
	 */
	public class TabContainer extends Sprite
	{
		protected var tabBar:TabBar;
		protected var viewStack:ViewStack;

		private var _showRule:Boolean;
		
		public function TabContainer()
		{
			super();
			addChildren();
		}
		
		protected function addChildren():void
		{
			tabBar=new TabBar();
			viewStack=new ViewStack();
			
			this.addChild(viewStack);
			this.addChild(tabBar);
		}
		
		/**
		 * 添加一个显示项 
		 * @param key 显示的唯一编号，不能重复
		 * @param label 标签名称
		 * @param graphic 显示项的内容
		 * 
		 */	
		public function addItem(key:String,label:String,graphic:DisplayObject):void
		{
			tabBar.addItem({label:label});
			viewStack.addItem(key,label,graphic);	
			
			if(!tabBar.hasEventListener(flash.events.Event.CHANGE))
			{
				tabBar.addEventListener(Event.CHANGE,onChange);
			}
			viewStack.y=tabBar.contentMaxHeight+3;
			drawRules()
		}
		
		/**
		 * 是否显示tabbutton和下面显示内容的分割线 
		 * @param bool
		 * 
		 */		
		public function set showRule(bool:Boolean):void
		{
			_showRule = bool;
			if(bool)
			{
				this.drawRules();
			}else{
				this.graphics.clear();
			}
		}
		
		protected function drawRules():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(0,0,0);
			
			this.graphics.beginFill(0x976ADD);
			this.graphics.drawRect(0,tabBar.contentMaxHeight - .5,viewStack.contentMaxWidth,1);
			
			this.graphics.beginFill(0x5a3ba5);			
			this.graphics.drawRect(0,tabBar.contentMaxHeight+.5,viewStack.contentMaxWidth,1);
		}
		
		protected function onChange(event:Event):void
		{
			viewStack.index=tabBar.index;
			if(this.hasEventListener(Event.CHANGE))
			{
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/**
		 * 指定tabContainer跳转到的显示位置
		 */
		public function get selectedIndex():uint
		{
			return this.tabBar.index;
		}
		
		/**
		 * addItem之后更新显示内容
		 */
		public function update():void
		{
			tabBar.dataProvider=viewStack.dataProvider;
			viewStack.y=tabBar.contentMaxHeight+3;
		}
	}
}