package com._17173.flash.show.base.module.gift.data
{
	public class GiftTypeInfo
	{
		private var _id:String;
		private var _name:String;
		private var _order:int;
		private var _status:String;
		public function GiftTypeInfo(data:Object)
		{
			with(data){
				_id = typeId;
				_name = typeName;
				_order = sort;
				_status = isShow;
			}
		}

		public function get status():String
		{
			return _status;
		}

		public function get order():int
		{
			return _order;
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