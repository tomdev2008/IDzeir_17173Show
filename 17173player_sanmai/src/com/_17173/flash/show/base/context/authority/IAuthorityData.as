package com._17173.flash.show.base.context.authority
{
	public interface IAuthorityData
	{
		/**
		 * 是否有权限
		 */		
		function get can():Boolean;
		
		/**
		 * 权限的限制长度
		 */		
		function get limit():int;
	}
}