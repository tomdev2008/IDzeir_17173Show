package com._17173.flash.show.base.context.authority
{
	/**
	 * 用户权限返回数据
	 * can：是否有权限
	 * limit：权限的限制长度
	 */	
	public class AuthorityData implements IAuthorityData
	{
		private var _can:Boolean = false;
		private var _limit:int = -1;
		
		public function AuthorityData()
		{
		}
		
		/**
		 * 是否有权限
		 */		
		public function get can():Boolean
		{
			return _can;
		}

		public function set can(value:Boolean):void
		{
			_can = value;
		}

		/**
		 * 限制变量
		 */		
		public function get limit():int
		{
			return _limit;
		}

		public function set limit(value:int):void
		{
			_limit = value;
		}


	}
}