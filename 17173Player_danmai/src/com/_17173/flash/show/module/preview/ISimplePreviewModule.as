package com._17173.flash.show.module.preview
{
	public interface ISimplePreviewModule
	{
		/**
		 * 显示摄像头 
		 * 
		 */		
		function showCamer(data:Object):void;
		/**
		 * 注册上麦消息 
		 * @param data
		 * 
		 */		
		function onPushData(data:Object):void;
		
		/**
		 * 重置预览模块 
		 * 
		 */		
		function resetPreview():void;
	}
}