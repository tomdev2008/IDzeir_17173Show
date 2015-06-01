package com._17173.flash.show.base.module.animation.base
{
	import com._17173.flash.show.base.context.resource.IResourceData;

	public interface IAnimationPlay
	{
		/**
		 *每帧 
		 * 
		 */		
		function run():void;
		/**
		 *开始播放 
		 * 
		 */		
		function play(playEndCall:Function = null):void;
		/**
		 *移除 
		 * 
		 */		
		function remove():void;
		/**
		 *播放完毕 
		 * 
		 */		
		function playEnd():void;
		/**
		 *加载动画 
		 * 
		 */		
		function loadAnimation(loadEndCallBack:Function = null):void;
		/**
		 *加载完成 
		 * 
		 */		
		function loadCmp(data:IResourceData):void;
		/**
		 *动画类型 
		 * @return 
		 * 
		 */		
		function get type():String;
	}
}