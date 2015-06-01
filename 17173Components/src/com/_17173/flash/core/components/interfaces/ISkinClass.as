package com._17173.flash.core.components.interfaces
{

	public interface ISkinClass
	{
		/**
		 *更新skin状态 
		 * @param info
		 * 
		 */		
		function updateSkinState(info:Object):void;
		/**
		 *更换皮肤 
		 * @param skinInfo
		 * 
		 */		
		function set skin(skinInfo:Object):void;
		/**
		 *获取皮肤 
		 * @return 
		 * 
		 */		
		function get skin():Object;
		/**
		 *获取类型 
		 * @return 
		 * 
		 */		
		function get skinClassType():String;
		/**
		 *销毁 
		 * 
		 */		
		function destroySkin():void;
		/**
		 *皮肤重定位 
		 * 
		 */		
		function rePostion():void;
		/**
		 *重置大小 
		 * 
		 */		
		function resize():void;
		/**
		 *皮肤被添加到舞台 
		 * 必须调用父类方法
		 */		
		function onShow():void;
		/**
		 *皮肤被移除舞台 
		 * 必须调用父类方法
		 */		
		function onHide():void;
	}
	
}