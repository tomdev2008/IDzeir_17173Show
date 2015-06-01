package com._17173.flash.show.base.module.userlist.view
{
	public interface IUserList
	{
		/**
		 * 初始化标识  显示到舞台后才=true 
		 */	
		function get inited():Boolean;
		
		/**
		 * 当前的显示状态 
		 * @return 
		 */	
		function get isShow():Boolean
	}
}