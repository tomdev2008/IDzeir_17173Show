package com._17173.flash.show.base.model
{
	import com._17173.flash.core.util.SimpleObjectPool;
	import com._17173.flash.show.base.utils.Utils;

	/**
	 *消息基本数据
	 * @author zhaoqinghao<br>
	 * 请使用静态方法获取该对象实例
	 */	
	public class MessageVo
	{
		private var _sName:String = null;
		private var _sid:String = null;
		private var _sNo:String = null;
		private var _tName:String = null;
		private var _tid:String = null;
		private var _tNo:String = null;
		private var _msg:String = null;
		private var _giftPicPath:String = null;
		private var _giftSwfPath:String = null;
		private var _giftSwfPath1:String = null;
		private var _giftName:String = null;
		private var _giftId:String = null;
		private var _giftCount:String = null;
		private var _time:String = null;
		private var _url:String = null;
		private var _giftType:String = null;
		private var _roomId:String = null;
		private var _showCenter:int = 0;
		private var _giftKey:String = null;
		private var _isSpecialGift:int = 0;
		public function MessageVo()
		{
			
		}

		/**
		 *礼物动画链接类 
		 */
		public function get giftKey():String
		{
			return _giftKey;
		}

		/**
		 * @private
		 */
		public function set giftKey(value:String):void
		{
			_giftKey = value;
		}

		public function get giftSwfPath1():String
		{
			return _giftSwfPath1;
		}

		public function set giftSwfPath1(value:String):void
		{
			_giftSwfPath1 = value;
		}

		/**
		 *是否显示彩条 
		 * @return 
		 * 
		 */		
		public function get isSpecialGift():int
		{
			return _isSpecialGift;
		}

		public function set isSpecialGift(value:int):void
		{
			_isSpecialGift = value;
		}

		public function get showCenter():int
		{
			return _showCenter;
		}

		public function set showCenter(value:int):void
		{
			_showCenter = value;
		}

		public function get roomId():String
		{
			return _roomId;
		}

		public function set roomId(value:String):void
		{
			_roomId = value;
		}

		public function get giftType():String
		{
			return _giftType;
		}

		public function set giftType(value:String):void
		{
			_giftType = value;
		}

		public static function getMsgVo(data:Object):MessageVo{
			var msv:MessageVo = SimpleObjectPool.getPool(MessageVo).getObject();
			msv.setupMsg(data);
			return msv;
		}
		
		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		public function get time():String
		{
			return _time;
		}

		public function set time(value:String):void
		{
			_time = value;
		}
		
		public function get timestamp():String
		{
			return _time;
		}

		public function get giftCount():String
		{
			return _giftCount;
		}

		public function set giftCount(value:String):void
		{
			_giftCount = value;
		}

		public function get giftId():String
		{
			return _giftId;
		}

		public function set giftId(value:String):void
		{
			_giftId = value;
		}

		public function get giftName():String
		{
			return _giftName;
		}

		public function set giftName(value:String):void
		{
			_giftName = value;
		}

		public function get giftSwfPath():String
		{
			return _giftSwfPath;
		}

		public function set giftSwfPath(value:String):void
		{
			_giftSwfPath = value;
		}

		public function get giftPicPath():String
		{
			return _giftPicPath;
		}

		public function set giftPicPath(value:String):void
		{
			_giftPicPath = value;
		}

		public function get msg():String
		{
			return _msg;
		}

		public function set msg(value:String):void
		{
			_msg = value;
		}

		public function get tid():String
		{
			return _tid;
		}

		public function set tid(value:String):void
		{
			_tid = value;
		}

		public function get tNo():String
		{
			return _tNo;
		}

		public function set tNo(value:String):void
		{
			_tNo = value;
		}

		public function get tName():String
		{
			return Utils.formatToString(_tName);
		}

		public function set tName(value:String):void
		{
			_tName = value;
		}

		public function get sNo():String
		{
			return _sNo;
		}

		public function set sNo(value:String):void
		{
			_sNo = value;
		}

		public function get sid():String
		{
			return _sid;
		}

		public function set sid(value:String):void
		{
			_sid = value;
		}

		public function get sName():String
		{
			return Utils.formatToString(_sName);
		}

		public function set sName(value:String):void
		{
			_sName = value;
		}

		private function setupMsg(data:Object):void{
			_sName = p(_sName,data,"userName");
			_sid = p(_sid,data,"userId");
			_sNo = p(_sNo,data,"userNo");
			_tid = p(_tid,data,"toUserId");
			_tName = p(_tName,data,"toUserName");
			_tNo = p(_tNo,data,"toUserNo");
			_msg = p(_msg,data,"msg");
			_giftPicPath = p(_giftPicPath,data,"giftIcon");
			_giftSwfPath = p(_giftSwfPath,data,"giftPath");
			_giftSwfPath1 = p(_giftSwfPath1,data,"giftPath1");
			_giftName = p(_giftName,data,"giftName");
			_giftId = p(_giftId,data,"giftId");
			_giftCount = p(_giftCount,data,"giftCount");
			_time = p(_time,data,"time");
			_url = p(_url,data,"url");
			_giftType = p(_giftType,data,"giftType");
			_roomId = p(_roomId,data,"roomId");
			_giftKey = p(_giftKey,data,"giftIdentity");
			_showCenter = p(_showCenter,data,"isInConsole");
			_isSpecialGift = p(_isSpecialGift,data,"isSpecialGift");
		}
		
		private function p(value:*, data:Object, key:String, replace:Boolean = false):* {
			if (data.hasOwnProperty(key)) {
				return data[key];
			}else{
				return value;
			}
		}
		
		public function returnObj():void{
			reset();
			SimpleObjectPool.getPool(MessageVo).returnObject(this);
		}
		
		public function clone():MessageVo{
			var ms:MessageVo = SimpleObjectPool.getPool(MessageVo).getObject();;
			ms.sName = _sName;
			ms.sid = _sid;
			ms.sNo = _sNo;
			ms.tid = _tid;
			ms.tName = _tName;
			ms.tNo = _tNo;
			ms.msg = _msg;
			ms.msg = _msg
			ms.giftPicPath = _giftPicPath;
			ms._giftCount = _giftCount;
			ms._giftSwfPath = _giftSwfPath;
			ms.giftSwfPath1 = _giftSwfPath1;
			ms.giftName = _giftName;
			ms.giftId = _giftId;
			ms.time = _time;
			ms.url = _url;
			ms.giftType = _giftType;
			ms.roomId = _roomId;
			ms.giftKey = _giftKey;
			ms.isSpecialGift = _isSpecialGift;
			ms.showCenter = _showCenter;
			return ms;
		}
		
		private function reset():void{
			_sName = null;
			_sid = null;
			_sNo = null;
			_tid = null;
			_tName = null;
			_tNo = null;
			_msg = null;
			_giftPicPath = null;
			_giftSwfPath = null;
			_giftName = null;
			_giftId = null;
			_giftCount = null;
			_time = null;
			_url = null;
		}
	}
}