package com._17173.flash.player.module.quiz.data
{
	import com._17173.flash.core.context.Context;

	/**
	 * 竞猜用户权限
	 * @author 安庆航
	 * 
	 */	
	public class QuizUserData
	{
		/**
		 * 管理员
		 */		
		public static const QUIZ_ADMIN:int = 2;
		/**
		 * 普通主播 
		 */		
		public static const QUZI_ANCHORS:int = 7;
		/**
		 * 签约主播
		 */		
		public static const QUZI_ANCHORS_MAIN:int = 6;
		//用户id
		private var _id:String;
		//开启竞猜权限
		private var _openAU:Boolean;
		//开启竞猜错误信息
		private var _openMes:String;
		//上庄权限
		private var _dealerAU:Boolean;
		//下注权限
		private var _bet:Boolean;
		//参加过的竞猜
		private var _joinArr:Array;
		//主播的等级  2：巡官、 7普通、6签约
		private var _role:int;
		//允许的上庄最低值
		private var _premium:int;
		
		public function QuizUserData()
		{
			init();
		}
		
		private function init():void {
			_id = Context.variables["uid"];
			_joinArr = [];
			_openAU = false;
			_openMes = "";
			_dealerAU = false;
			_bet = false;
			_role = 7;
			_premium = 1000;
		}
		
		/**
		 * 解析数据
		 */		
		public function resolveData(value:Object):void {
			if (!value) {
				return;
			} else {
				if (value.hasOwnProperty("code")) {
					if (value["code"] == "000001") {
						return;
					}
				}
				var temp:Object;
				if (value.hasOwnProperty("obj")) {
					temp = value["obj"];
				} else {
					return;
				}
				if (temp.hasOwnProperty("open")) {
					if (temp["open"].hasOwnProperty("is")) {
						_openAU = temp["open"]["is"] == "true";
					}
					if (temp["open"].hasOwnProperty("role")) {
						_role = temp["open"]["role"];
					}
				}
				if (temp.hasOwnProperty("dealerMap") && temp["dealerMap"].hasOwnProperty("is")) {
					_dealerAU = temp["dealerMap"]["is"] == "true";
				}
				if (temp.hasOwnProperty("betMap") && temp["betMap"].hasOwnProperty("is")) {
					_dealerAU = temp["betMap"]["is"] == "true";
				}
				if (temp.hasOwnProperty("minPremuim")) {
					_premium = temp["minPremuim"];
				}
			}
		}
		
		/**
		 * 添加参与的竞猜
		 */		
		public function addJoin(value:String):void {
			if (_joinArr.indexOf(value) == -1) {
				_joinArr.push(value);
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

		public function get openAU():Boolean
		{
			return _openAU;
		}

		public function set openAU(value:Boolean):void
		{
			_openAU = value;
		}

		public function get openMes():String
		{
			return _openMes;
		}

		public function set openMes(value:String):void
		{
			_openMes = value;
		}

		public function get dealerAU():Boolean
		{
			return _dealerAU;
		}

		public function set dealerAU(value:Boolean):void
		{
			_dealerAU = value;
		}

		public function get bet():Boolean
		{
			return _bet;
		}

		public function set bet(value:Boolean):void
		{
			_bet = value;
		}

		public function get joinArr():Array
		{
			return _joinArr;
		}
		/**
		 * 主播的等级  2：巡官、 7普通、6签约
		 */
		public function get role():int
		{
			return _role;
		}

		public function set role(value:int):void
		{
			_role = value;
		}

		public function set joinArr(value:Array):void
		{
			_joinArr = value;
		}
		/**
		 * 允许的上庄最低值
		 */
		public function get premium():int
		{
			return _premium;
		}


	}
}