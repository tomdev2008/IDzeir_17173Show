package com._17173.flash.player.ui.comps
{
	import com._17173.flash.player.model.RedirectData;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.ui.stream.extra.ExtraUIItemEnum;
	import com._17173.flash.player.ui.stream.extra.IExtraUIItem;
	
	import flash.events.MouseEvent;

	/**
	 * 直播站外logo
	 */
	public class StreamOutLogo extends OutLogo implements IExtraUIItem
	{
		public function StreamOutLogo()
		{
			super();
			this.buttonMode = true;
			url = "http://v.17173.com/live";
		}
		
		public function refresh(isFullScreen:Boolean=false):void {
			
		}
		
		override protected function onClick(event:MouseEvent):void {
			//回链
			var r:RedirectData = new RedirectData();
			r.click_type = RedirectDataAction.CLICK_TYPE_REDIRECTION;
			r.action = RedirectDataAction.ACTION_BACK_LOGO;
			r.send();
		}
		
		public function get side():Boolean {
			return ExtraUIItemEnum.SIDE_LEFT;
		}
		
		override public function get skinObject():Object {
			return {"logo":mc_outLogo};
		}
		
	}
}