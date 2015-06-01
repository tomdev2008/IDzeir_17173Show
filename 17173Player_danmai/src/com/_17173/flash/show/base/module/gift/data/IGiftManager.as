package com._17173.flash.show.base.module.gift.data
{
	public interface IGiftManager
	{
		/**
		 *加载礼物数据 
		 * @param data
		 * 
		 */		
		function setupGiftInfo(data:Object):Boolean;
		
		/**
		 *获取所有礼物数据 
		 * @return 
		 * 
		 */		
		function getAllGiftData():Array;
		/**
		 *根据id获取礼物 
		 * @param id
		 * @return 
		 * 
		 */		
		function getGiftById(id:String):GiftData;
		
		/**
		 *根据类型获取礼物 
		 * @param type
		 * @return 
		 * 
		 */		
		function getGiftsByType(type:String):Array;
	}
}