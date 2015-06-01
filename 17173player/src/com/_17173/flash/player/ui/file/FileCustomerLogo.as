package com._17173.flash.player.ui.file
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.ui.comps.OutLogo;
	
	import flash.events.MouseEvent;
	
	public class FileCustomerLogo extends OutLogo
	{
		public function FileCustomerLogo()
		{
			super();
			this.buttonMode = true;
			url = "http://v.17173.com";
		}
		
		override protected function onClick(event:MouseEvent):void {
			Util.toUrl(url);
		}
	}
}