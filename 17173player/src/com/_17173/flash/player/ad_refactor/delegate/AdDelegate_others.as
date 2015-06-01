package com._17173.flash.player.ad_refactor.delegate
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.ad_refactor.AdType;

	/**
	 * 非前贴或者大前贴的其他广告逻辑
	 *  
	 * @author 庆峰
	 */	
	public class AdDelegate_others extends BaseAdDelegate
	{
		
		private var _delegates:Object = null;
		
		public function AdDelegate_others()
		{
			_delegates = {};
		}
		
		/**
		 * 启动其它广告 
		 */		
		override protected function init():void {
			initAd(AdType.ZANTING, AdDelegate_zanting);
//			initAd(AdType.ZANTING_BANNER, AdDelegate_zantingbanner);
			initAd(AdType.XIADI, AdDelegate_xiadi);
			initAd(AdType.GUAJIAO, AdDelegate_guajiao);
		}
		
		protected function initAd(type:String, cls:Class):void {
			if (_data.hasOwnProperty(type) && _data[type]) {
				Debugger.log(Debugger.INFO, "[ad]", "[" + type + "]广告已启动!");
				// 首先得有数据
				var delegate:IAdDelegate = _delegates.hasOwnProperty(type) ? _delegates[type] : new cls();
				delegate.data = _data[type];
			} else {
				Debugger.log(Debugger.INFO, "[ad]", "没有[" + type + "]广告类型!");
			}
		}
		
		override public function dispose():void {
			super.dispose();
			
			for (var k:String in _delegates) {
				_delegates[k].dispose();
			}
		}
		
	}
}