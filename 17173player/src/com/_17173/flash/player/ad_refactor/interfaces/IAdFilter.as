package com._17173.flash.player.ad_refactor.interfaces
{
	import com._17173.flash.player.ad_refactor.AdData_refactor;
	
	public interface IAdFilter
	{
		
		function filter(data:AdData_refactor):Boolean;
		
	}
}