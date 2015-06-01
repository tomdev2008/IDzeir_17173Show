package com._17173.flash.show.base.module.lobby
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.utils.Utils;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class GRoomCard extends RoomCard
	{		
		private var _tagName:LobbyText;
		/**
		 * 用户人数 
		 */		
		private var _viewSum:LobbyText;
		/**
		 * 主播昵称 
		 */		
		private var _userName:LobbyText;
		/**
		 * 房间标题 
		 */		
		private var _title:LobbyText;
		/**
		 * 用户头像 
		 */		
		private var _userImg:Sprite;
		
		private var _black:Sprite;
		
		private var ani:PreVideoAnimation;
		
		public function GRoomCard()
		{
			super();			
			this.addChildren();			
		}
		
		private function addChildren():void
		{
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0,177,313,43);
			this.graphics.endFill();			
			
			this._tagName = new LobbyText();
			this._tagName.textColor = 0xffcf00;
			this._viewSum = new LobbyText();
			this._userName = new LobbyText();
			this._title = new LobbyText();
			this._userImg = new Sprite();
			this._black = new VideoBottomBg();;
			this.ani = new PreVideoAnimation();
			
			this._tagName.mouseEnabled = this._viewSum .mouseEnabled = this._userName.mouseEnabled =this._title.mouseEnabled = this._userImg.mouseEnabled = this._black.mouseEnabled = false;
		}
		
		override public function get url():String
		{
			return _data["url"];
		}
		
		override protected function update():void
		{
			super.update();			
			this.removeChildren();					
			ani.roomUrl = url;
			//ani.autoPlay = true;
			ani.urls = _data.bigSnapshots;		
			this.addChild(ani);
			this._black.y = 177 - this._black.height;
			this.addChild(this._black);
			
			if(Util.validateStr(this._data["tagName"]))
			{
				_tagName.text = this._data["tagName"];
				_tagName.x = _tagName.y = 5;
				var bg:Shape = new Shape();
				bg.graphics.beginFill(0x000000,.6);
				bg.graphics.drawRect(_tagName.x - 3,_tagName.y - 3,_tagName.width+4,_tagName.height+4);
				bg.graphics.endFill();
				bg.x = bg.y = 2;
				this.addChild(bg);
				this.addChild(_tagName);
			}	
			
			var ucm:UserCountCmp = new UserCountCmp();
			
			this._viewSum.textColor = 0xffffff;
			this._viewSum.htmlText = "<font size='14'>"+_data["viewSum"]+"人</font>";
			this._viewSum.x = 2;
			this._viewSum.y = 177 - this._viewSum.height;
			
			ucm.x = 5;
			ucm.y = this._viewSum.y+5;
			
			this._viewSum.x = ucm.x+ucm.width + 3;
			this.addChild(ucm);
			this.addChild(_viewSum);
			
			var face:DisplayObject = Utils.getURLGraphic(_data["userImg"],true,46,46);			
			_userImg.addChild(face);
			_userImg.graphics.clear();
			_userImg.graphics.beginFill(0xffffff);
			_userImg.graphics.drawRect(0,0,face.width+4,face.height+4);
			_userImg.graphics.endFill();
			face.x = face.y = 2;
			_userImg.x = 313 - _userImg.width;
			_userImg.y = 177 - _userImg.height +10;
			this.addChild(_userImg);
			
			this._userName.text = _data["userName"];
			this._userName.y = this._viewSum.y;
			this._userName.textColor = 0xffffff;
			this._userName.x = _userImg.x - 10 - this._userName.width;
			this.addChild(_userName);
			
			this._title.htmlText = "<font color='#ffaf00'>["+_data["gameName"]+"]</font> " +""+_data["liveTitle"];
			this._title.x = 10;
			this._title.y = 177+10;
			this.addChild(this._title);
		}
	}
}