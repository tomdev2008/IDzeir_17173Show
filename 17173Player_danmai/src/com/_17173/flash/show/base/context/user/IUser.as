package com._17173.flash.show.base.context.user
{
	
	import com._17173.flash.show.base.context.authority.IAuthorityData;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public interface IUser
	{
		
		/**
		 * 获取当前用户.
		 *  
		 * @return 当前用户的数据.
		 */		
		function get me():IUserData;
		/**
		 * 增加用户数据到缓存.
		 *  
		 * @param user
		 */		
		function addUser(user:IUserData):IUserData;
		/**
		 * 根据id获取用户数据.
		 *  
		 * @param id
		 * @return 
		 */		
		function getUser(id:String):IUserData;
		/**
		 * 通过数据生成一个用户.
		 *  
		 * @param data 用户数据
		 * @param _isWeak 用户是否为假人数据（只有用户列表请求和socket用户进入的才是真人）
		 */		
		function addUserFromData(data:Object,_isWeak:Boolean = true):IUserData;
		/**
		 * 说话用户都添加到用户列表里面 
		 * @param data
		 * @return 
		 * 
		 */		
		function addUserFormSpeaker(data:Object):IUserData;
		/**
		 * 根据id获取一个用户数据.
		 * 如果当前缓存中有该用户数据,则可以直接返回.
		 * 否则将向后台请求该用户的数据.
		 * 都是异步以回调的方式返回. 
		 * 
		 * @param id
		 * @param onGet
		 */		
//		function getUserAsync(id:String, onGet:Function):void;
		
		/**
		 * 初始化时候管理员列表 
		 * @return 
		 * 
		 */		
		function get adminList():Array;
		/**
		 * 初始化时候麦序列表 
		 * @return 
		 * 
		 */		
		function get micList():Array;
		
		/**
		 * 通过页数获取一批用户数据.
		 * 如果当前缓存中有该页数据,则直接返回.
		 * 否则将向后台请求该批次用户数据.
		 * 都以异步方式通过回调函数返回.返回数据为包含UserData的数组.
		 *  
		 * @param page
		 * @param onGet 回调函数返回.返回数据为包含UserData的数组.
		 */		
		function getUserBatchByPage(page:int, size:int):void;
		/**
		 * 当前是否有该用户数据.
		 *  
		 * @param id
		 * @return 
		 */		
		function hasUser(id:String):Boolean;
		/**
		 * 请求用户列表是否有下一页
		 * @return 
		 * 
		 */		
		function get hasNextPage():Boolean
		/**
		 * 根据一批用户id获取用户数据.
		 *  
		 * @param ids	需要获取的id列表
		 * @param onGet	回调函数会在获取完成后被调用,回调函数会得到所有已获取的数据
		 */		
//		function getUserBatch(ids:Array, onGet:Function):void;
		/**
		 * 在某个地方弹出用户操作卡. 
		 * 
		 * @param userID 要显示在卡上的用户id.
		 * @param stagePos 要显示在舞台上的位置.这里需要是stage上的绝对位置.
		 * @param filterList 需要过滤的类型 UserCardData.（SHOW_MIC_LIST、SHOW_TALK_list、SHOW_KICK_LIST、SHOW_MANGER_LIST）.
		 * @param isAuto 是否自动隐藏
		 */		
		function showCard(userID:String, stagePos:Point = null, filterList:Array = null,isAuto:Boolean = true):void;
		/**
		 * 自动隐藏用户卡 
		 * 
		 */		
		function autoHideCard():void;
		/**
		 * 用户页数.
		 *  
		 * @return 
		 */		
		function get page():int;
		/**
		 * 用户数.
		 *  
		 * @return 
		 */		
		function get count():int;
		/**
		 * 游客数
		 * 
		 * @return
		 */
		function get guestTotal():uint;
		/**
		 * 验证单人权限.
		 *  
		 * @param target
		 * @param action
		 * @return 
		 */		
		function validateAuthority(target:IUserData, action:String):IAuthorityData;
		/**
		 * 验证两人之间的权限.
		 *  
		 * @param target
		 * @param action
		 * @param to
		 * @return 
		 */		
		function validateAuthorityTo(target:IUserData, action:String, to:IUserData):IAuthorityData;
		
		/**
		 * 获取屏蔽私聊用户过滤字典
		 * @return 
		 * 
		 */		
		function get privateChatFilterDic():Dictionary;
		
		/**
		 * 添加屏蔽用户信息
		 * @param value
		 * 
		 */		
		function set privateChatFilterDic(value:Dictionary):void;
		/**
		 * 添加麦序用户 
		 * @param data 服务器返回的userInfo数据
		 * @return 
		 * 
		 */		
		function addMicUserFormatData(data:Object):IUserData;
		/**
		 * 移除麦序用户 
		 * @param value 用户id
		 * @return 
		 * 
		 */		
		function removeMicUseById(id:String):IUserData;
		
		/**
		 * 获取order数组
		 * @return 数组里的参数为UserData
		 * 
		 */		
		function orderArray():Array;
		
		/**
		 * 获取在哪个麦上 
		 * @param userId  用户id
		 * @return  1麦，2麦，3麦
		 * 
		 */		
		function getMicIndex(userId:String):int;
		
		/**
		 * 获取指定用户麦序状态数据 
		 * @param value 用户id
		 * @return value = 0（无状态）；value = 1(在麦序中)；value=2（直播中）;
		 * 
		 */		
		function getUserMicStatus(id:String):int;
		
		/**
		 * 返回一个新的UserData 
		 * @param data  IUserData需要的数据
		 * @return IUserData
		 * 
		 */		
		function createUserFromData(data:Object):IUserData;
		
		
	}
}