package com._17173.flash.show.base.module.userlist.view
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	/**
	 * 游客数量显示框 
	 * @author idzeir
	 * 
	 */	
	public class GuestBox extends Button
	{
		private var _e:IEventManager;

		private var bg:MovieClip;
		
		public function GuestBox()
		{
			bg = new MovieClip();
			bg.graphics.beginFill(0x3B004A);
			bg.graphics.drawRect(0,0,176,32);
			bg.graphics.endFill();
			this.setSkin(bg);
			
			mouseEnabled = false;
			
			total(0);
			_e = (Context.getContext(CEnum.EVENT) as IEventManager);
			_e.listen(SEvents.UPDATE_GUEST_COUNT,total);
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			total((Context.getContext(CEnum.USER) as IUser).guestTotal)
		}
		
		private function total(value:uint):void
		{
			if(value>=0)
			{
				this.label = "<font color='#A198AF' size='12'>游客 <font color='#D79C00'>"+value+"</font> 人</font>"
			}
		}
		
	}
}