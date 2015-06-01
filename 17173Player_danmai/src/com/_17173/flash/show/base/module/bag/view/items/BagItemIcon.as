package com._17173.flash.show.base.module.bag.view.items
{
	import flash.display.MovieClip;

	/**
	 *背包item icon（即将到期标志）
	 * @author yeah
	 */	
	public class BagItemIcon extends BagItemPart
	{
		public function BagItemIcon()
		{
			super();
			mouseEnabled = mouseChildren = false;
		}
		
		override public function get autoAlign():Boolean
		{
			return false;
		}
		
		override protected function onRender():void
		{
			super.onRender();
			
			if(data.expireSoon == 1)
			{
				if(!expireIcon)
				{
					expireIcon = new BagItemExpire(); 
					expireIcon.x = width - expireIcon.width;
				}
				
				if(!expireIcon.parent)
				{
					this.addChild(expireIcon);
				}
			}
			else if(expireIcon&&expireIcon.parent)
			{
				expireIcon.parent.removeChild(expireIcon);
			}
		}
		
		/**
		 *即将到期标志 
		 */		
		private var expireIcon:MovieClip;
		
		override public function get width():Number
		{
			return 160;
		}
	}
}