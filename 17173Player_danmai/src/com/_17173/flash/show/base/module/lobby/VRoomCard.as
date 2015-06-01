package com._17173.flash.show.base.module.lobby
{
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.base.utils.Utils;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextFormat;

	public class VRoomCard extends RoomCard
	{
		private var ani:PreVideoAnimation;
		private var _nickName:Label;

		private var _level:BitmapMovieClip;

		private var _userCount:LobbyText;

		private var _startTime:LobbyText;
		private var _black:Sprite;

		private const BASE_URL:String = "assets/img/level/";

		public function VRoomCard()
		{
			super();
			this.addChildren();
		}

		private function addChildren():void
		{
			this.graphics.beginFill(0xcccccc);
			this.graphics.drawRect(0, 102, 183, 35);
			this.graphics.endFill();

			this.ani = new PreVideoAnimation();
			this._nickName = new Label({maxW: 150});
			this._nickName.defaultTextFormat = new TextFormat(FontUtil.f, 14, 0xffffff, true);

			this._userCount = new LobbyText();
			_startTime = new LobbyText();
			this._black = new VideoBottomBg();
			;
			this._black.mouseEnabled = this._startTime.mouseEnabled = this._nickName.mouseEnabled = this._userCount.mouseEnabled = false;
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

			this._black.width = 183;
			this._black.height = 30;
			this._black.y = 102 - this._black.height;
			this.addChild(this._black);

			this._nickName.htmlText = "<font color='#ffffff' size='14'>" + _data.nickName + "</font>";
			this.addChild(this._nickName);
			this._nickName.x = 5;
			this._nickName.y = 102 - this._nickName.height;
			
			if(!_level)
			{
				_level = new BitmapMovieClip();
			}
			var _sType:String = Number(_data.masterLevel) > 25 ? ".swf" : ".png";
			_level.url = BASE_URL + "lv" + _data.masterLevel + _sType;
			//_level = Utils.getURLGraphic(BASE_URL + "lv" + _data.masterLevel + ".png", true, 30, 16) as Sprite;
			this._level.mouseEnabled = false;
			_level.x = this.width - _level.width - 2;
			_level.y = 102 - _level.height;
			this.addChild(_level);

			this._userCount.htmlText = "<font color='#727272' size='12'>" + String(_data.userCount).replace(/(\d)(?=(\d{3})+($|\.))/ig, "$1,") + "</font>";
			this.addChild(this._userCount);
			_userCount.y = 102 + 8;
			_userCount.x = 5;

			var start:String = "未";
			if (_data.liveStatus == 1)
			{
				var date:Date = new Date(_data["startTime"]);
				start = Util.fillStr(String(date.hours),"0",2)+ ":" + Util.fillStr(String(date.minutes),"0",2) + " ";
			}
			this._startTime.htmlText = "<font color='#727272' size='12'>" + start + "开播</font>";
			_startTime.y = _userCount.y;
			_startTime.x = this.width - _startTime.width - 5;
			this.addChild(_startTime);
		}
	}
}