package com._17173.flash.player.ui.comps.controlbar
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	
	import flash.display.DisplayObject;

	public class FileSeoVideoControlBar extends ControlBar
	{
		public function FileSeoVideoControlBar()
		{
			super();
		}
		
		override public function get height():Number
		{
			return 60;
		}
		
		/**
		 * 刷新left内部布局
		 */		
		override protected function leftResize():void {
			var d:DisplayObject=null;
			var i:int=0;
			var tmp:int=10;
			for (i; i < _left.numChildren; i++)
			{
				d=_left.getChildAt(i);
				if (d)
				{
					//刷新自己内部布局
					if(d is IExtraUIItem){
						(d as IExtraUIItem).refresh(Context.getContext(ContextEnum.SETTING).isFullScreen);
					}
					d.x = tmp;
					d.y = (height + _progressBar.display.height - d.height) / 2;
					tmp += d.width + 15;
				}
			}
		}
		
		/**
		 * 刷新right内部布局
		 */
		override protected function rightResize():void {
			var d:DisplayObject=null;
			var i:int=0;
			var tmp:int=10;
			for (i; i < _right.numChildren; i++)
			{
				d=_right.getChildAt(i);
				if (d)
				{
					//刷新自己内部布局
					if(d is IExtraUIItem){
						(d as IExtraUIItem).refresh(Context.getContext(ContextEnum.SETTING).isFullScreen);
					}
					d.x = _bg.width - tmp - d.width;
					d.y = (height + _progressBar.display.height - d.height) / 2;
					if (i == 0) {
						tmp += d.width + 5;
					} else {
						tmp += d.width + 35;
					}
				}
			}
		}
		
	}
}