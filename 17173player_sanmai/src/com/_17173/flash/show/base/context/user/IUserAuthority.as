package com._17173.flash.show.base.context.user
{
	import com._17173.flash.show.base.context.authority.IAuthorityData;

	public interface IUserAuthority
	{
		function validateAuthority(target:IUserData, action:String):IAuthorityData;
		
		function validateAuthorityTo(target:IUserData, action:String, to:IUserData):IAuthorityData;
	}
}