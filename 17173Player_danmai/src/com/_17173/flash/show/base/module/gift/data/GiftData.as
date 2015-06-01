package com._17173.flash.show.base.module.gift.data
{
	/**
	 *礼物数据 
	 * @author zhaoqinghao
	 * 
	 */	
	public class GiftData
	{
		private var _id:String = null;
		private var _name:String = null;
		/**
		 *图片资源地址 
		 */		
		private var _iconPath:String = null;
		/**
		 *价格 
		 */		
		private var _price:int = 0;
		/**
		 *swf地址 
		 */		
		private var _swfPath:String = null;
		/**
		 *礼物类型 
		 */		
		private var _giftType:int = 0;
		/**
		 *是否可用 
		 */		
		private var _status:String = null;
		private var _luckNum:String = null;
		private var _typeData:GiftTypeInfo = null;
		private var _showGroup:Boolean = false;
		private var _showType:int = 0;
		
		public function GiftData(data:Object)
		{
			//解析
			with(data){
				_id = giftId;
				_name = giftName;
				_price = price;
				_iconPath = smallPic;
				_swfPath = bigPic;
				_giftType = giftType;
				_status = status;
				_luckNum = maxMultiple;
				_showGroup = coeffectPower;
				_showType = displayType;
			}
		}


		public function get showType():int
		{
			return _showType;
		}

		public function set showType(value:int):void
		{
			_showType = value;
		}

		public function get showGroup():Boolean
		{
			return _showGroup;
		}

		public function set showGroup(value:Boolean):void
		{
			_showGroup = value;
		}

		public function get luckNum():String
		{
			return _luckNum;
		}

		public function set luckNum(value:String):void
		{
			_luckNum = value;
		}

		/**
		 *类型信息 
		 */
		public function get typeData():GiftTypeInfo
		{
			return _typeData;
		}

		/**
		 * @private
		 */
		public function set typeData(value:GiftTypeInfo):void
		{
			_typeData = value;
		}

		public function get status():String
		{
			return _status;
		}

		public function get type():int
		{
			return _giftType;
		}

		public function get swfPath():String
		{
			return _swfPath;
		}

		public function get price():int
		{
			return _price;
		}

		public function get iconPath():String
		{
			return _iconPath;
		}

		public function get name():String
		{
			return _name;
		}

		public function get id():String
		{
			return _id;
		}

	}
}