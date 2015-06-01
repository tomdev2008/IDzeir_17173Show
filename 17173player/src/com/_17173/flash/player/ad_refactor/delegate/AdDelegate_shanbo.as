package com._17173.flash.player.ad_refactor.delegate
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	
	/**
	 * 点播页闪播广告
	 *  
	 * @author 庆峰
	 */	
	public class AdDelegate_shanbo extends BaseAdDelegate
	{
		public function AdDelegate_shanbo()
		{
			super();
		}
		
		override protected function init():void {
			if (_data) {
				Debugger.log(Debugger.INFO, "[ad]", "闪播初始化!");
				_(ContextEnum.JS_DELEGATE).send("videoQuickPlay", _data);
				
				var obj:Object = {};
				obj["ads_code"] = "8";//bi统计中的闪播广告类型
				obj["is_replay"] = "0";//不是重复播放
				IStat(Context.getContext(ContextEnum.STAT)).stat(
					StatTypeEnum.BI, StatTypeEnum.EVENT_AD_SHOW, obj);
			}
		}
		
	}
}