package com._17173.flash.show.base.module.animation.base
{
	import com._17173.flash.show.base.context.resource.IResourceData;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;

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
		/**
		 *装在数据 
		 * @param apath
		 * @param atype
		 * @param layer
		 * 
		 */
		function setup(apath:String,atype:String,layer:IAnimactionLayer):void;
		/**
		 *是否已经返回池中 
		 * @param value
		 * 
		 */		
		function set returned(value:Boolean):void;
		/**
		 *是否已经返回池中 
		 * @param value
		 * 
		 */	
		function get returned():Boolean;
		
		/**
		 *动画数据 
		 * @param data
		 * 
		 */		
		function set data(data:Object):void;
		/**
		 *动画数据 
		 * @param data
		 * 
		 */
		function get data():Object;
		
		/**
		 *是否加载了 
		 * @return 
		 * 
		 */		
		function get loaded():Boolean;
		function set loaded(value:Boolean):void;
		/**
		 *动画 
		 * @return 
		 * 
		 */		
		function get mc():*;
		function set mc(value:*):void;
		
		
		/**
		 *前景效果 
		 */
		function get bfEffect():Sprite;
		
		/**
		 * @private
		 */
		function set bfEffect(value:Sprite):void;
		
		/**
		 *背景效果 
		 */
		function get bgEffect():Sprite;
		
		
		/**
		 * @private
		 */
		 function set bgEffect(value:Sprite):void;
		 
		 function get loading():Boolean;
		 
		 function set loading(value:Boolean):void;
		 
		 function returnObj():void;
		 
		 /**
		  *加载失败 
		  * @return 
		  * 
		  */		 
		 function get loadFail():Boolean;
		 
		 function set loadFail(value:Boolean):void;
		 
		 function getBmp():Bitmap;
		 
		 /**
		  *mc特殊坐标 
		  * @return 
		  * 
		  */		 
		 function get mcY():int;
		 
		 function set mcY(value:int):void;
		 /**
		  *mc特殊坐标 
		  * @return 
		  * 
		  */
		 function get mcX():int;
		 
		 function set mcX(value:int):void;
		 
		 
		 /**
		  *资源图 
		  * @return 
		  * 
		  */		 
		 function get bmp():Bitmap;
		 
		 function set bmp(value:Bitmap):void;
		 
		 function toStopEnd():void;
	}
}