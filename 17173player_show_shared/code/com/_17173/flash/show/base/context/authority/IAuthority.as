package com._17173.flash.show.base.context.authority
{
	/**
	 * 用户权限接口
	 *  
	 * @author 安庆航
	 */	
	public interface IAuthority
	{
		/**
		 * 根据权限数据判断是否可以获得thing指定的事件权限.
		 *  
		 * @param user
		 * @param thing
		 * @return 
		 */		
		function getAuthorityInfo(user:Array, thing:String):Object;
		
	}
}