package com._17173.flash.player.ad_refactor.delegate
{
	/**
	 * 广告逻辑代理类基类
	 *  
	 * @author 庆峰
	 */	
	public class BaseAdDelegate implements IAdDelegate
	{
		
		protected var _data:Object = null;
		protected var _onComplete:Function = null;
		protected var _onError:Function = null;
		
		public function BaseAdDelegate()
		{
		}
		
		public function set onError(value:Function):void
		{
			_onError = value;
		}
		
		public function set onComplete(value:Function):void
		{
			_onComplete = value;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
			
			init();
		}
		
		protected function init():void {
			// override
		}
		
		public function dispose():void
		{
			_data = null;
		}
		
		protected function complete(result:Object = null):void {
			if (_onComplete != null) {
				_onComplete.apply(null, [result]);
			}
		}
		
		protected function error(info:Object = null):void {
			if (_onError != null) {
				_onError.apply(null, [info]);
			}
		}
		
	}
}