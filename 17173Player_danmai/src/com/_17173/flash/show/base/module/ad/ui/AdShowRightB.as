package com._17173.flash.show.base.module.ad.ui
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.module.ad.base.AdType;
	import com._17173.flash.show.model.CEnum;
	
	import flash.events.MouseEvent;

	public class AdShowRightB extends AdShowRight
	{
		public function AdShowRightB()
		{
			super();
		}
		
		override protected function closeClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			this.dispose();
			event.stopPropagation();
			(Context.getContext(CEnum.EVENT) as IEventManager).send("ad_close_type",AdType.SHOW_RIGHT);
		}
	}
}