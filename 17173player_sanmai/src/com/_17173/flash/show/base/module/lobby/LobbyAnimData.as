package com._17173.flash.show.base.module.lobby
{
	import com._17173.flash.show.base.components.common.data.AnimData;
	
	public class LobbyAnimData extends AnimData
	{
		public function LobbyAnimData()
		{
			super();
		}
		
		public function deepCopy():LobbyAnimData {
			var ad:LobbyAnimData = new LobbyAnimData();
			for (var key:String in this) {
				ad[key] = this[key];
			}
			ad.x = x;
			ad.y = y;
			ad.offsetX = offsetX;
			ad.offsetY = offsetY;
			if(bd!=null){
				ad.bd = bd.clone();
			}
			return ad;
		}
		
		public function dispose():void
		{
			if(bd!=null){
				bd.dispose();
			}
			bd = null;
		}
	}
}