package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com.greensock.TweenMax;
	
	import flash.events.MouseEvent;
	
	public class ToolGroup extends HGroup
	{
		public var index:int = 0;
		protected var ilocal:ILocale;
		protected var scrolling:Boolean = true;
		
		public function ToolGroup()
		{
			super();
			ilocal = Context.getContext(CEnum.LOCALE) as ILocale;
			this.valign = HGroup.MIDDLE;
			this.left = 240;
			this.top = 8;
			addChildren();
			
			//var bg:ChatToolBglayer = new ChatToolBglayer();
			//bg.mouseEnabled = false;
			//this.addRawChildAt(bg,0);
			this.addEventListener(MouseEvent.ROLL_OVER,overHandler);
			this.addEventListener(MouseEvent.ROLL_OUT,overHandler);
			
			this.alpha = 0;
		}
		
		protected function addChildren():void
		{
			var clearBut:ChatToolButton = new ChatToolButton(ilocal.get("clear", "chatPanel"),function():void
			{
				(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.CLEAR_CHAT_MSG,index);
			});
			var noScrollBut:ChatToolButton = new ChatToolButton(ilocal.get("noScroll", "chatPanel"),function():void
			{
				scrolling = !scrolling;
				noScrollBut.selected = !scrolling;
				(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.LOCK_CHAT_SCROLL,index);
				noScrollBut.label = ilocal.get(!scrolling ? "canScroll" : "noScroll", "chatPanel");
			});
			
			clearBut.setSkin(new ClearMsgSkin1_8())
			noScrollBut.setSkin(new ScrollMsgSkin1_8());
			
			addChild(clearBut);
			addChild(noScrollBut);	
		}
		
		protected function overHandler(event:MouseEvent):void
		{
			switch(event.type)
			{
				case MouseEvent.ROLL_OUT:
					hiden();
					break;
				case MouseEvent.ROLL_OVER:
					Ticker.stop(disappear);
					break;
			}
		}
		
		public function hiden():void
		{
			Ticker.stop(disappear);
			Ticker.stop(appear);
			Ticker.tick(500,disappear);
		}
		
		public function show():void
		{
			Ticker.stop(disappear);
			Ticker.stop(appear);
			Ticker.tick(1,appear,1,true);
		}
		
		private function appear():void
		{
			TweenMax.killTweensOf(this);
			this.visible = true;
			TweenMax.to(this,.5,{"alpha":1,"onComplete":onComplete,"onCompleteParams":[true]});
		}
		
		private function disappear():void
		{
			TweenMax.killTweensOf(this);
			TweenMax.to(this,.5,{"alpha":0,"onComplete":onComplete,"onCompleteParams":[false]});
		}
		
		private function onComplete(value:Boolean):void
		{
			this.visible = value
		}
	}
}
