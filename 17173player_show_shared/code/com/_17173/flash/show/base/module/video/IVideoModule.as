package com._17173.flash.show.base.module.video
{
	/**
	 * LiveModule 接口 
	 * @author qiuyue
	 * 
	 */	
	public interface IVideoModule
	{
		/**
		 * 修改声音状态  开麦，闭麦
		 * @param obj
		 * 
		 */		
		function changeSoundStatus(obj:Object):void;
		/**
		 * 更新数据 Socket 15 
		 * @param order 麦序
		 */		
		function onLiveData(order:int):void;
		/**
		 * 关闭拉流 
		 * @param order
		 * 
		 */		
		function endVideo(order:int):void;
		
		/**
		 * 声音改变 
		 * @param data
		 * 
		 */		
		function onLiveVolumeChange(data:Object):void;
		
		/**
		 * 移动 
		 * @param data
		 * 
		 */		
		function move(data:Object):void;
		
		/**
		 * 开始推流
		 * @param data
		 * 
		 */		
		function onPushData(data:Object):void;

		/**
		 * 隐藏 推流界面 
		 * 
		 */		
		function hideCam():void;

		/**
		 * 是否显示Loading 
		 * @param data
		 * 
		 */		
		function isShowLoading(data:Object):void;
		
		/**
		 * 重联 
		 * @param data
		 * 
		 */		
		function videoRePush(data:Object):void;
		
		/**
		 * 更新麦上数据 
		 * @param order
		 * 
		 */		
		function updateVideoData(order:int):void;
		
		
		/**
		 * 重连 
		 * @param data
		 * 
		 */		
		function liveConnect(data:Object):void;
		
		/**
		 * 清理Video画面 
		 * @param data
		 * 
		 */		
		function clearLiveVideo(data:Object):void;
		
		/**
		 * 用户离开房间 
		 * @param data
		 * 
		 */		
		function onUserExit(data:Object):void;
		
		/**
		 * 用户进入房间 
		 * @param data
		 * 
		 */		
		function onUserEnter(data:Object):void;
		
		/**
		 * 更新名字 
		 * @param data
		 * 
		 */		
		function updateName(data:Object):void;
		
		/**
		 * 数据已经准备好
		 * 
		 */		
		function onReady():void;
		
	}
}