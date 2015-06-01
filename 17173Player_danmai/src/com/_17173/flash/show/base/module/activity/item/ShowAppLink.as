package com._17173.flash.show.base.module.activity.item
{
	
	import com._17173.flash.core.util.Util;
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ShowAppLink extends Sprite
	{
		public function ShowAppLink()
		{
			super();
			init();
			this.addEventListener(MouseEvent.ROLL_OVER,onOver);
		}
		
		private function init():void{
			var link:ShowApp = new ShowApp();
			this.addChild(link);
			this.mouseChildren = false;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK,onLink);
		}
		
		private function onOver(e:Event):void{
			this.addEventListener(MouseEvent.ROLL_OUT,onOut);
			TweenLite.to(this,.3,{y:445});
		}
		
		private function onOut(e:Event):void{
			this.removeEventListener(MouseEvent.ROLL_OUT,onOut);
			TweenLite.to(this,.3,{y:460});
		}
		
		protected function onLink(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			Util.toUrl("http://a.17173.com/tg/show/index.html");
		}
	}
}