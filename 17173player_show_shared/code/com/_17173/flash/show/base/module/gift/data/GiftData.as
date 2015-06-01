package com._17173.flash.show.base.module.gift.data
{
	/**
	 *礼物数据 
	 * @author zhaoqinghao
	 * 
	 */	
	public class GiftData
	{
		/**
		 *跑车 
		 */		
		public static const GIFT_TYPE_CAR:String = "2";
		/**
		 *花篮 
		 */		
		public static const GIFT_TYPE_FLOWER:String = "0";
		
		/**
		 *进场动画 
		 */		
		public static const GIFT_TYPE_ENTER:String = "3";
		
		/**
		 *普通 
		 */		
		public static const GIFT_TYPE_NORMAL:String = "1";
		
		/**
		 *带动画的小礼物 
		 */		
		public static const GIFT_TYPE_NORMAL_ANM:String = "3";
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
		private var _typeData:GiftTypeData = null;
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
			}
		}


		/**
		 *类型信息 
		 */
		public function get typeData():GiftTypeData
		{
			return _typeData;
		}

		/**
		 * @private
		 */
		public function set typeData(value:GiftTypeData):void
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