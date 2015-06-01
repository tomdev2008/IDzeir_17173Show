package com._17173.flash.show.base.context.layer
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public interface IUIManager
	{
		/**
		 *初始化场景 
		 * @param scene
		 * 
		 */		
		function initializeScene(scene:DisplayObject):void;
		/**
		 *抛出面板 
		 * @param panel 面板 
		 * @param panelPos 位置 空则为居中
		 * 
		 */		
		function popupPanel(panel:DisplayObject,panelPos:Point = null):void;
		/**
		 * 弹出提示 
		 * @param title 提示title
		 * @param showHtmlText 提示文字
		 * @param iconType 显示icon类型（默认为不显示）,调用Alert.ICON_STATE_FAIL或Alert.ICON_STATE_SUCC设置.
		 * @param $btnType 显示按钮（默认为不显示）,调用Alert.BTN_OK或Alert.BTN_CANCEL设置,需要显示两个按钮则Alert.BTN_OK|Alert.BTN_CANCEL.
		 * @param okCallFunction 点击确定按钮回调
		 * @param cancelCallFunction 点击取消按钮回调
		 * 
		 */		
		function popupAlert(title:String,showHtmlText:String,iconType:int = -1,$btnType:int = -1,okCallFunction:Function = null,cancelCallFunction:Function = null,okLabel:String = null,cancelLabel:String = null):void;
		/**
		 *弹出面板提示 
		 * @param panel
		 * 
		 */		
		function popupAlertPanel(panel:DisplayObject):void;
		/**
		 *移除面板 
		 * @param panel
		 * 
		 */		
		function removePanel(panel:DisplayObject):void;
		/**
		 * 注册tooltip 
		 * @param dsObj 注册显示对象
		 * @param htmlText 显示文本
		 * 
		 */		
		function registerTip(dsObj:DisplayObject,htmlText:String):void;
		/**
		 *注册tooltip1 
		 * @param dsObj 注册显示对象
		 * @param showDsObj 显示提示
		 * 
		 */		
		function registerTip1(dsObj:DisplayObject,showDsObj:DisplayObject):void;
		/**
		 *销毁 tooltip 
		 * @param dsObj
		 * 
		 */		
		function destroyTip(dsObj:DisplayObject):void;
		/**
		 * 获取场景上空余的可用空间坐标位置.
		 *  
		 * @return 
		 */		
		function get sceneRect():Rectangle;
		/**
		 * 添加Stage点击的处理事件 
		 * @param handler 参数为MouseEvent类型
		 * 
		 */		
		function addAction(handler:Function):void;
		/**
		 * 删除Stage点击的处理事件 
		 * @param handler 参数为MouseEvent类型
		 * 
		 */
		function removeAction(handler:Function):void;
		
		/**
		 *添加引导 
		 * @param guide
		 * 
		 */		
		function addGuide(guide:DisplayObject):void;
		/**
		 *取消引导 
		 * @param guide
		 * 
		 */		
		function removeGuide(guide:DisplayObject):void;
	}
}