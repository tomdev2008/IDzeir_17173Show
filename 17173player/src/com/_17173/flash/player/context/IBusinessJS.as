package com._17173.flash.player.context
{
	public interface IBusinessJS
	{
		
		/**
		 * 监听js回调.
		 *  
		 * @param funcName 要接受回调的方法名
		 * @param flashCallback 回调到的方法
		 */		
		function listen(funcName:String, flashCallback:Function):void;
		/**
		 * 发送js数据.
		 *  
		 * @param funcName 要发送到的js方法
		 * @param data 要发送到js方法的参数
		 */		
		function send(funcName:String, data:Object = null, ns:String = null):void;
		
//		///////////////////////////////
//		//
//		// 播放相关接口
//		//
//		/////////////////////////////
//		/**
//		 * flash已经准备好可以接受js回调方法
//		 */
//		function ready():void;
//		/**
//		 * flash开始播放
//		 */
//		function play():void;
//		/**
//		 * flash播放结束
//		 */
//		function playEnd():void;
	}
}