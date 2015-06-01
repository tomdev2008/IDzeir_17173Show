package com._17173.flash.show.base.module.lobby
{
	
	public class VRoomCard extends RoomCard
	{
		private var ani:PreVideoAnimation;
		private var _nickName:LobbyText;
		
		private var _userCount:LobbyText;
		
		
		public function VRoomCard()
		{
			super();
			this.addChildren();	
		}
		
		private function addChildren():void
		{
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,177,313,43);
			this.graphics.endFill();
			
			this.ani = new PreVideoAnimation();
			this._nickName = new LobbyText();
			
			this._userCount = new LobbyText();
			this._nickName.mouseEnabled = this._userCount.mouseEnabled = false;
		}
		
		override public function get url():String
		{
			return _data.liveUrl;
		}
		
		override protected function update():void
		{
			this.removeChildren();
			ani.roomUrl = url;
			ani.urls = [_data.picUrl];
			this.addChild(ani);
			
			this._nickName.htmlText = "<font color='#444444' size='14'>"+_data.nickName+"</font>";
			this.addChild(this._nickName);
			this._nickName.x = 10;
			this._nickName.y = 177+10;
			
			this._userCount.htmlText = "<font color='#727272' size='14'>"+String(_data.userCount).replace(/(\d)(?=(\d{3})+($|\.))/ig,"$1,")+"人</font>";
			this.addChild(this._userCount);
			_userCount.y = 177+10;
			_userCount.x = 313 - _userCount.width - 5;
			
			var ucm:UserCountCmp = new UserCountCmp();
			ucm.x = _userCount.x - ucm.width - 5;
			ucm.y = 177 + 14;
			this.addChild(ucm);
		}
	}
}