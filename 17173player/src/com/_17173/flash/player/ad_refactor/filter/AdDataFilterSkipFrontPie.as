package com._17173.flash.player.ad_refactor.filter
{
	import com._17173.flash.player.ad_refactor.AdData_refactor;
	import com._17173.flash.player.ad_refactor.AdType;
	import com._17173.flash.player.ad_refactor.interfaces.IAdFilter;
	
	public class AdDataFilterSkipFrontPie implements IAdFilter
	{
		public function AdDataFilterSkipFrontPie()
		{
		}
		
		public function filter(data:AdData_refactor):Boolean
		{
			// 是前贴广告并且skipfp属性为真,则表示跳过前贴广告
			return data.type == AdType.QIANTIE && _("skipfp");
		}
	}
}