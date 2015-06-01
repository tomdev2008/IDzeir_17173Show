package com._17173.flash.core.skin
{
	
	import flash.display.DisplayObjectContainer;
	
	public interface ISkinManager
	{
		
		/**
		 * 发出事件通知由controller中的控件进行接收.
		 * 只有被attach过的item才会收到这个事件
		 *  
		 * @param event
		 * @param data
		 */		
		function notify(event:String, data:Object):void;
		/**
		 * 在controller中增加一个新的ISkinItem配置,以用于之后进行使用.
		 * add进去的配置,将会在attach的时候才初始化.
		 *  
		 * @param prototype
		 * 
		 */		
		function addSkinConfig(prototype:SkinObjectPrototype):void;
		/**
		 * 验证ui元素是否在当前皮肤配置中存在 
		 * 
		 * @param name
		 * @return 
		 */		
		function hasSkinConfig(name:String):Boolean;
		/**
		 * 验证item是否存在.
		 *  
		 * @param name
		 * @return 
		 * 
		 */		
		function hasSkin(name:String):Boolean;
		/**
		 * 获取指定的ui元素。
		 * 如果缓存中已有，直接取出。
		 * 如果没有，初始化并关联到缓存中，并返回。 
		 * 
		 * @param name
		 * @return 
		 */		
		function getSkin(name:String, create:Boolean = false):ISkinObject;
		/**
		 * 将指定的skinobject附加到指定的显示对象上。
		 * 并返回结果（被attach的skinitem） 
		 * 
		 * @param item
		 * @param parent
		 * @return 
		 */		
		function attachSkin(item:ISkinObject, parent:DisplayObjectContainer, num:int = -1):ISkinObject;
		/**
		 * 将指定名称的skinobject附加到指定的显示对象上。
		 * 并返回结果（被attach的skinitem） 
		 * 
		 * @param item
		 * @param parent
		 * @return 
		 */		
		function attachSkinByName(name:String, parent:DisplayObjectContainer, num:int = -1):ISkinObject;
		/**
		 * 移除skinobject
		 *  
		 * @param item
		 * @return 
		 */		
		function deattachSkin(item:ISkinObject):ISkinObject;
		/**
		 * 移除指定名称的skinobject
		 *  
		 * @param name
		 * @return 
		 */		
		function deattachSkinByName(name:String):ISkinObject;
		/**
		 * 当整体ui变动时，处理并更新ui元素的布局信息。 
		 */		
		function resize():void;
		
	}
}