package com._17173.flash.show.base.context.user
{
	public interface IUserData
	{
		/**
		 * 用户id 
		 * @return 
		 */		
		function get id():String;
		/**
		 * 用户靓号 
		 * @return 
		 * 
		 */		
		function get masterNo():String;
		/**
		 * 用户名称 
		 * @return 
		 */		
		function get name():String;
		/**
		 * 用户等级 
		 * @return 
		 */		
		function get level():int;
		/**
		 * 头像地址.
		 *  
		 * @return 
		 */		
		function get head():String;

		/**
		 *金币 
		 * @return 
		 * 
		 */		
		function get jinbi():int;
		/**
		 * 隐身状态 
		 * @return 
		 * 
		 */		
		function get hidden():Boolean
		/**
		 *乐豆 
		 * @return 
		 * 
		 */		
		function get jindou():int;
		/**
		 *艺人等级 
		 * @return 
		 * 
		 */		
		function get starLevel():String;
		/**
		 *富有 
		 * @return 
		 * 
		 */		
		function get richLevel():String;
			
		/**
		 * 用户类型.
		 *  
		 * @return 
		 */		
		function get type():int;
		/**
		 * 用户是否是代理 
		 * @return 
		 * 
		 */		
		function get agent():Boolean;
		/**
		 * 用户是否是经纪人（房主） 
		 * @return 
		 * 
		 */		
		function get broker():Boolean;
		/**
		 * 用户是否是助理（副房主） 
		 * @return 
		 * 
		 */		
		function get assistant():Boolean;
		/**
		 * 用户是否是艺人 (主播) 
		 * @return 
		 * 
		 */		
		function get artist():Boolean;
		/**
		 * 用户是否是房间管理员 
		 * @return 
		 * 
		 */		
		function get normalAdmin():Boolean;
		/**
		 * 是否登录用户
		 *  
		 * @return 
		 */		
		function get isLogin():Boolean;
		/**
		 * 标记用户是否为假人（只有用户列表请求下来的才是真人）
		 */
		function get isWeak():Boolean;
		/**
		 * 是否巡管
		 */		
		function get isAdmin():Boolean;
		/**
		 * 获取用户权限数组
		 */		
		function get role():Array;
		/**
		 * 获取vip等级
		 */		
		function get vip():int;
		
		/**
		 * 获取用户权限（权限判断中用）
		 */		
		function get auth():Array;
		
		/**
		 * 获取用户权限
		 */		
		function get userType():int;
		/** 
		 * 用户列表排序顺序
		 */		
		function get sortNum():Number;
		
		function set sortNum(value:Number):void;
		
		function get userIp():String;
		/**
		 *下个财富等级 
		 * @return 
		 * 
		 */		
		function get nextFanLevel():String;
		/**
		 *财富升级的差距 
		 * @return 
		 * 
		 */		
		function get fanOffset():String;
		/**
		 *主播等级 
		 * @return 
		 * 
		 */		
		function get nextMasterLevel():String;
		/**
		 * 主播升级的差距 
		 * @return 
		 * 
		 */		
		function get masterOffset():String;
		/**
		 *扩展信息 
		 * @return 
		 * 
		 */		
		function get extInfo():Object;
			
	}
}