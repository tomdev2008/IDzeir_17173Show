package com._17173.flash.show.base.module.stat.base
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.module.stat.IStat;
	import com._17173.flash.show.model.CEnum;

	public class StatData
	{
		
		private var _type:String = null;
		private var _data:Object = null;
		
		public function StatData(type:String, data:Object)
		{
			_type = type;
			_data = data;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function send():void {
			if (!_type) return;
			
			var stat:IStat = Context.getContext(CEnum.STAT) as IStat;
			stat.stat(type, data);
		}

	}
}