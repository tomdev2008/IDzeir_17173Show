package com._17173.flash.core.components.common
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-1-23  下午4:16:48
	 */
	public class VScrollPanel extends ScrollPanel
	{
		public function VScrollPanel(parent:DisplayObjectContainer=null)
		{
			super(parent);
			this._vScrollbar.policy="auto";
			this._hScrollbar.policy="off";			
		}
		
		public function sliderSkin(source:DisplayObject):void
		{
			this._vScrollbar.setSkin_Bg(source);
		}
		
		/**
		 * 鼠标中键滚动处理 
		 * @param event
		 * 
		 */		
		protected function onWheel(event:MouseEvent):void
		{			
			this._vScrollbar.value-=event.delta*(this.deltaY)/50;
		}
		
		override protected function onDrawRect():void
		{
			super.onDrawRect();
			this.isWheel=this._vScrollbar.visible;
		}
		
		/**
		 * 显示滑动条的时候添加鼠标滑轮滚动事件 
		 * @param value
		 * 
		 */		
		private function set isWheel(value:Boolean):void
		{
			if(value&&!this.hasEventListener(MouseEvent.MOUSE_WHEEL))
			{				
				this.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
				this.graphics.beginFill(0xff0000,0);
				this.graphics.drawRect(0,0,this.width,this.height);
				this.graphics.endFill();
			}else if(!value&&this.hasEventListener(MouseEvent.MOUSE_WHEEL)){
				this.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
				this.graphics.clear();
			}
		}
	}
}