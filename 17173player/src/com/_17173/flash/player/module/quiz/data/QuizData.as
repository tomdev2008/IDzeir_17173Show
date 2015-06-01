package com._17173.flash.player.module.quiz.data
{
	/**
	 * 竞猜数据
	 * @author 安庆航
	 * 
	 */	
	public class QuizData
	{
		//竞猜id
		private var _id:String;
		//开启竞猜用户id
		private var _userID:String;
		//竞猜标题
		private var _title:String;
		//货币类型
		private var _currency:int;
		//竞猜已经开启过的时间
		private var _runTime:Number;
		//左边标题
		private var _leftTitle:String;
		//左边庄数据
		private var _leftDealerData:DealerData;
		//右边标题
		private var _rightTitle:String;
		//右边庄数据
		private var _rightDealerData:DealerData;
		//官方竞猜用的dealer数组
		private var _dealers:Vector.<DealerData> = null;
		//当前竞猜的状态
		private var _state:String;
		//0:官方竞猜 1：用户竞猜
		private var _type:int;
		//官方竞猜计算抽水的比率
		private var _odd:Number;
		
		private var _givenOdd:Number;
		
		private var _minMoney:Number;
		
		private var _maxMoney:Number;
		
		public function QuizData()
		{
			init();
		}
		
		public function init():void {
			_id = "";
			_userID = "";
			_title = "";
			_currency = 1;
			_runTime = 0;
			_leftTitle = "";
			_leftDealerData = null;
			_rightTitle = "";
			_rightDealerData = null;
			_state = "1";
			_type = 1;
			_odd = 0;
			_minMoney = 1;
			_maxMoney = 1000000000;
			_givenOdd = 0;
		}
		
		public function addDealer(value:DealerData):void {
			_dealers.push(value);
		}
		
		public function getDealer(id:String):DealerData {
			for each (var d:DealerData in _dealers) {
				if (d.id == id) {
					return d;
				}
			}
			return null;
		}
		
		public function get dealders():Vector.<DealerData> {
			return _dealers;
		}
		
		public function resolveData(value:Object):void {
			if (value.hasOwnProperty("guessid")) {
				_id = value["guessid"];
			}
			if (value.hasOwnProperty("odds"))
			{
				_givenOdd = value['odds'];
			}
			if (value.hasOwnProperty("createrid")) {
				_userID = value["createrid"];
			}
			if (value.hasOwnProperty("title")) {
				_title = value["title"];
			}
			if (value.hasOwnProperty("a")) {
				_leftTitle = value["a"];
			}
			if (value.hasOwnProperty("b")) {
				_rightTitle = value["b"];
			}
			if (value.hasOwnProperty("currency")) {
				_currency = int(value["currency"]);
			}
			if (value.hasOwnProperty("opentime")) {
				_runTime = value["opentime"];
			}
			if (value.hasOwnProperty("state")) {
				_state = value["state"];
			}
			if (value.hasOwnProperty("waterRates")) {
				_odd = value["waterRates"] / 100;
				if (_odd > 1) {
					_odd = 1;
				}
			}
			if (value.hasOwnProperty("moneyMin")) {
				_minMoney = value["moneyMin"]
			}
			if (value.hasOwnProperty("moneyMax")) {
				_maxMoney = value["moneyMax"]
			}
			if (!_leftTitle && !_rightTitle) {
				_dealers = new Vector.<DealerData>();
			}
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
		
		public function get userID():String
		{
			return _userID;
		}
		
		public function set userID(value:String):void
		{
			_userID = value;
		}
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			_title = value;
		}
		
		public function get currency():int
		{
			return _currency;
		}
		
		public function set currency(value:int):void
		{
			_currency = value;
		}
		
		public function get runTime():Number
		{
			return _runTime;
		}
		
		public function set runTime(value:Number):void
		{
			_runTime = value;
		}
		
		public function get leftTitle():String
		{
			return _leftTitle;
		}
		
		public function set leftTitle(value:String):void
		{
			_leftTitle = value;
		}
		
		public function get leftDealerData():DealerData
		{
			return _leftDealerData;
		}
		
		public function set leftDealerData(value:DealerData):void
		{
			_leftDealerData = value;
		}
		
		public function get rightTitle():String
		{
			return _rightTitle;
		}
		
		public function set rightTitle(value:String):void
		{
			_rightTitle = value;
		}
		
		public function get rightDealerData():DealerData
		{
			return _rightDealerData;
		}
		
		public function set rightDealerData(value:DealerData):void
		{
			_rightDealerData = value;
		}
		
		/**
		 * 竞猜状态
		 * 0:关闭，1:开启,2:流局,3:结算中
		 */		
		public function get state():String
		{
			return _state;
		}
		
		public function set state(value:String):void
		{
			_state = value;
		}
		/**
		 * 竞猜类型
		 * 0:官方竞猜 1：用户竞猜
		 */
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}
		/**
		 * 官方竞猜计算抽水的比率
		 */
		public function get odd():Number
		{
			return _odd;
		}
		
		public function set odd(value:Number):void
		{
			_odd = value;
		}
		/**
		 * 官方竞猜最小投注数额
		 */
		public function get minMoney():Number
		{
			return _minMoney;
		}
		
		public function set minMoney(value:Number):void
		{
			_minMoney = value;
		}
		/**
		 * 官方竞猜最大投注数额
		 */
		public function get maxMoney():Number
		{
			return _maxMoney;
		}
		
		public function set maxMoney(value:Number):void
		{
			_maxMoney = value;
		}


	}
}