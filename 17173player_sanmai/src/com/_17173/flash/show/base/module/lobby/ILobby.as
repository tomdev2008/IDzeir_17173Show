package com._17173.flash.show.base.module.lobby
{
	public interface ILobby
	{
		function get lock():Boolean;
		
		function show():void;
		
		function hiden():void
		/**
		 * 设置大厅游戏房间数据 
		 * @param value
		 * 
		 */		
		function set gInfo(value:Object):void;
		/**
		 * 设置大厅娱乐房间数据 
		 * @param value
		 * 
		 */		
		function set vInfo(value:Object):void;
		
		function get isHiden():Boolean;
	}
}