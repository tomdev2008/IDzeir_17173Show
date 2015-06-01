package com._17173.flash.show.base.module.gift.view
{
	import com._17173.flash.core.components.common.DropDownList;
	
	public class GiftDownList extends DropDownList
	{
		public function GiftDownList(dir:String="down", maxline:uint=0, itemRender:Class=null)
		{
			super(dir, maxline, itemRender);
		}
		
		/**
		 * 子类继承重绘划入背景 
		 * 
		 */		
		override protected function drawBackground():void
		{			
			overBg.graphics.beginFill(0x4C118A,.01);
			overBg.graphics.drawRect(0,0,_width,20);
			overBg.graphics.endFill();	
			//设置关闭时默认背景颜色
			setBackground(0x4c118a,.01);
		}
	}
}