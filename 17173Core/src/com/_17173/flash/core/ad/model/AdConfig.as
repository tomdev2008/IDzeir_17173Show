package com._17173.flash.core.ad.model
{
	public class AdConfig
	{
		
		private var _A1:AdData = null;
		private var _A2:AdData = null;
		private var _A3:AdData = null;
		private var _A4:AdData = null;
		private var _A5:AdData = null;
		
		public function AdConfig()
		{
		}

		/**
		 * 大前贴数据 
		 */
		public function get A1():AdData
		{
			return _A1;
		}

		/**
		 * @private
		 */
		public function set A1(value:AdData):void
		{
			_A1 = value;
		}

		/**
		 * 前贴数据 
		 */
		public function get A2():AdData
		{
			return _A2;
		}

		/**
		 * @private
		 */
		public function set A2(value:AdData):void
		{
			_A2 = value;
		}

		/**
		 * 暂停数据 
		 */
		public function get A3():AdData
		{
			return _A3;
		}

		/**
		 * @private
		 */
		public function set A3(value:AdData):void
		{
			_A3 = value;
		}

		/**
		 * 下底数据 
		 */
		public function get A4():AdData
		{
			return _A4;
		}

		/**
		 * @private
		 */
		public function set A4(value:AdData):void
		{
			_A4 = value;
		}

		/**
		 * 挂角数据 
		 */
		public function get A5():AdData
		{
			return _A5;
		}

		/**
		 * @private
		 */
		public function set A5(value:AdData):void
		{
			_A5 = value;
		}


	}
}