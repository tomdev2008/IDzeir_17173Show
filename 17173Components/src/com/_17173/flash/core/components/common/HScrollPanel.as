package com._17173.flash.core.components.common
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/** 
	 * @author idzeir
	 * 创建时间：2014-3-20  下午3:03:23
	 */
	public class HScrollPanel extends ScrollPanel
	{
		public function HScrollPanel(parent:DisplayObjectContainer=null)
		{
			super(parent);
			this._vScrollbar.policy="off";
			this._hScrollbar.policy="on";	
		}
		
		/**
		 * 鼠标中键滚动处理 
		 * @param event
		 * 
		 */		
		protected function onWheel(event:MouseEvent):void
		{			
			this._hScrollbar.value-=event.delta*(this.deltaX)/50;
		}
		
		override protected function onDrawRect():void
		{
			super.onDrawRect();
			this.isWheel=this._hScrollbar.visible;
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
			}else if(!value&&this.hasEventListener(MouseEvent.MOUSE_WHEEL)){
				this.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
			}
		}
	}
}