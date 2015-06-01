package com._17173.flash.player.module.quiz.data
{
	/**
	 * 庄数据
	 * @author 安庆航
	 * 
	 */	
	public class DealerData
	{
		//庄家id
		private var _id:String;
		//开庄用户id
		private var _userID:String;
		//比率
		private var _odds:String;
		//投注额度
		private var _betcount:Number;
		//标题
		private var _title:String;
		//底金
		private var _premium:Number;
		//金币类型
		private var _currency:String;
		//庄锁定的钱数
		private var _lockMoney:Number;
		//总数,目前只是给官方竞猜做计算用
		private var _total:Number = 0;
		
		public function DealerData()
		{
			init();
		}
		
		public function init():void {
			id = "";
			userID = "";
			odds = "";
			betcount = 0;
			currency = "1";
			_lockMoney = 0;
			_premium = 0;
		}
		
		public function resolveData(data:Object):void {
			if (!data) {
				return;
			}
			if (data.hasOwnProperty("dealerid")) {
				_id = data["dealerid"];
			}
			if (data.hasOwnProperty("userId")) {
				_userID = data["userId"];
			}
			if (data.hasOwnProperty("odds")) {
				_odds = data["odds"];
			}
			if (data.hasOwnProperty("betcount")) {
				_betcount = data["betcount"];
			}
			if (data.hasOwnProperty("premium")) {
				_premium = data["premium"];
			}
			if (data.hasOwnProperty("playerAnswer")) {
				_title = data["playerAnswer"];
			}
			if (data.hasOwnProperty("currency")) {
				_currency = data["currency"];
			}
			if (data.hasOwnProperty("lockMoney")) {
				_lockMoney = data["lockMoney"];
			}
			if (data.hasOwnProperty("id")) {
				_id = data["id"];
			}
			if (data.hasOwnProperty("totalMoney")) {
				_betcount = data["totalMoney"];
			}
			if (data.hasOwnProperty("name")) {
				_title = data["name"];
			}
		}
		
		/**
		 * 庄家id
		 */		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
		
		/**
		 * 开庄用户id
		 */
		public function get userID():String
		{
			return _userID;
		}
		
		public function set userID(value:String):void
		{
			_userID = value;
		}
		
		/**
		 * 比率
		 */		
		public function get odds():String
		{
			return _odds;
		}
		
		public function set odds(value:String):void
		{
			_odds = value;
		}
		
		/**
		 * 投注额度
		 */		
		public function get betcount():Number
		{
			return _betcount;
		}
		
		public function set betcount(value:Number):void
		{
			_betcount = value;
		}
		/**
		 * 标题
		 */
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			_title = value;
		}
		
		/**
		 * 底金
		 */		
		public function get premium():Number
		{
			return _premium;
		}
		
		public function set premium(value:Number):void
		{
			_premium = value;
		}
		
		public function get currency():String
		{
			return _currency;
		}
		
		public function set currency(value:String):void
		{
			_currency = value;
		}
		
		public function get lockMoney():Number
		{
			return _lockMoney;
		}
		
		public function set lockMoney(value:Number):void
		{
			_lockMoney = value;
		}

		public function get total():Number
		{
			return _total;
		}

		public function set total(value:Number):void
		{
			_total = value;
		}
		
		
	}
}