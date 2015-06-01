package com._17173.flash.show.base.module.preview
{
	/**
	 * CamModule接口 
	 * @author qiuyue
	 * 
	 */	
	public interface IPreviewModule
	{
		/**
		 * 显示摄像头 
		 * 
		 */		
		function showCamer(data:Object):void;
		/**
		 * 注册上麦消息 
		 * 
		 */		
		function onPushData():void;
		
		/**
		 * 重置预览模块 
		 * 
		 */		
		function resetPreview():void;
	}
}