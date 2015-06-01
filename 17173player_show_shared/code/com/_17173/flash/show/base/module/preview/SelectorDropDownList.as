package com._17173.flash.show.base.module.preview
{
	import com._17173.flash.core.components.common.DropDownList;
	
	import flash.events.Event;

	/**
	 * 选择摄像头和麦克风的下拉列表
	 * @author qiuyue
	 * 
	 */	
	public class SelectorDropDownList extends DropDownList
	{
		public static const ITEM_HEIGHT:int = 25;
		public static const ITEM_WIDTH:int = 180;
		/**
		 * 背景 
		 */		
		public var bg:VideoListBackGround = new VideoListBackGround();
		public function SelectorDropDownList(dir:String="down", maxline:uint=5, itemRender:Class=null)
		{
			super(dir, maxline, itemRender);
		}
		override protected function onAdded(event:Event):void
		{
			super.onAdded(event);
			this.addChildAt(bg,0);
			bg.mouseEnabled = false;
			bg.height = ITEM_HEIGHT; 
			this.width = ITEM_WIDTH;
		}
		override protected function drawBackground():void
		{
			overBg.graphics.beginFill(0xAAAAAA,1);
			overBg.graphics.drawRect(0,0,ITEM_WIDTH,ITEM_HEIGHT);
			overBg.graphics.endFill();	
		}
	
		
	}
}