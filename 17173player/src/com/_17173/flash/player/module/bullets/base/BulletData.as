package com._17173.flash.player.module.bullets.base
{
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.core.util.SimpleObjectPool;
	

	public class BulletData
	{
		
		private static const drt:int = 6000;
		private static const STYLE_D:String = "#b#s#l#";
		
		private var _isSteady:Boolean = false;
		private var _textColor:uint = 0xFFFFFF;
		private var _textSize:int = 14;
		private var _steadyX:Number = 0;
		private var _steadyY:Number = 0;
		
		private var _duration:int = 0;
		private var _speed:int = 120;
		private var _content:String = "";
		private var _type:String = null;
		private var _userName:String = null;
		private var _userID:Number = 0;
		private var _masterNick:String = null;
		private var _toMasterNick:String = null
		
		public function BulletData()
		{
			_type = BulletConfig.BULLETTYPE_NORMAL;
		}

		public function get masterNick():String
		{
			return _masterNick;
		}

		public function set masterNick(value:String):void
		{
			_masterNick = value;
		}

		public function get toMasterNick():String
		{
			return _toMasterNick;
		}

		public function set toMasterNick(value:String):void
		{
			_toMasterNick = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get isSteady():Boolean
		{
			return _isSteady;
		}

		public function set isSteady(value:Boolean):void
		{
			_isSteady = value;
		}

		public function get textColor():uint
		{
			return _textColor;
		}

		public function set textColor(value:uint):void
		{
			_textColor = value;
		}

		public function get textSize():int
		{
			return _textSize;
		}

		public function set textSize(value:int):void
		{
			_textSize = value;
		}

		public function get steadyX():Number
		{
			return _steadyX;
		}

		public function set steadyX(value:Number):void
		{
			_steadyX = value;
		}

		public function get steadyY():Number
		{
			return _steadyY;
		}

		public function set steadyY(value:Number):void
		{
			_steadyY = value;
		}
		
		public function get content():String
		{
			return _content;
		}
		
		public function set content(value:String):void
		{
			_content = value;
		}
		
		public function get speed():int
		{
			return _speed;
		}
		
		public function set speed(value:int):void
		{
			_speed = value;
		}
		
		public function get duration():int
		{
			return _duration;
		}
		
		public function set duration(value:int):void
		{
			_duration = value;
		}
		
		public function get userName():String
		{
			return _userName;
		}
		
		public function set userName(value:String):void
		{
			_userName = value;
		}

		public function toObject():Object {
			var obj:Object = {};
			
//			obj.isSteady = _isSteady;
			obj.content = _content;
			obj.style = getStyle();
//			obj.steadyX = _steadyX;
//			obj.steadyY = _steadyY;
//			obj.textColor = _textColor;
//			obj.textSize = _textSize;
//			obj.duration = _duration;
//			obj.type = _type;
			return obj;
		}
		
		public static function fromObject(object:Object):BulletData {
			var bd:BulletData = SimpleObjectPool.getPool(BulletData).getObject() as BulletData;
			bd.content = HtmlUtil.encodeHtml(object.content);
			if(object.hasOwnProperty("masterNick") && object.masterNick){
				bd.masterNick = HtmlUtil.encodeHtml(object.masterNick);
			}else{
				bd.masterNick = null;
			}
			if(object.hasOwnProperty("toMasterNick") && object.toMasterNick){
				bd.toMasterNick = HtmlUtil.encodeHtml(object.toMasterNick);
			}else{
				bd.toMasterNick = null;
			}
			bd.userID = object.userId;
			bd.setStyle(object.style);
			if (bd.userID > 0) {
				bd.userName = object.userName;
			}else{
				bd.userName = null
			}
			if (bd.content.length > 20) {
				bd.speed = 80;
			} else if (bd.content.length > 30) {
				bd.speed = 100;
			} else if (bd.content.length > 40) {
				bd.speed = 120;
			}
			return bd;
		}
		
		
		public function getStyle():String{
			var style:String = "";
			style += textColor + STYLE_D;
			style += textSize + STYLE_D;
			style += type ;
			return style;
		}
		
		public function setStyle(style:String):void{
			if(style == null){
				textColor =  0xFFFFFF;
				textSize =  BulletConfig.BULLET_FONTSIZE_24;
				type = BulletConfig.BULLETTYPE_NORMAL
			}else{
				var styles:Array = style.split(STYLE_D);
				textColor = uint(styles[0]);
				textSize = int(styles[1]);
				type = String(styles[2]);
			}
		}
		/**
		 *应用设置样式 
		 * 
		 */		
		public function updateConfig():void{
			_textColor = BulletConfig.getInstance().bulletFontColor;
			_textSize = BulletConfig.getInstance().bulletFontSize;
			_type = BulletConfig.getInstance().bulletFontType;
		}

		public function get userID():Number
		{
			return _userID;
		}

		public function set userID(value:Number):void
		{
			_userID = value;
		}

		
	}
}