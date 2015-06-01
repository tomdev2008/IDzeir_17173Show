package com._17173.flash.player.ui.comps
{
	public class OutLogo extends Logo
	{
		public function OutLogo()
		{
			super();
			url = "http://v.17173.com";
		}
		
		override public function get skinObject():Object {
			return {"logo":mc_logo};
		}
		
	}
}