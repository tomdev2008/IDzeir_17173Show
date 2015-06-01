package com._17173.flash.show.base.utils
{
	import com._17173.flash.core.context.Context;
	
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * 右键菜单Util,用来创建和处理右键菜单相关逻辑.
	 *  
	 * @author shunia-17173
	 */	
	public class ContextMenuUtil
	{
		
		private static var _contextMenu:ContextMenu = null;
		
		public function ContextMenuUtil()
		{
		}
		
		/**
		 * 获取当前应用中的右键菜单.
		 *  
		 * @return 
		 */		
		public static function getContextMenu():ContextMenu {
			if (_contextMenu == null) {
				_contextMenu = new ContextMenu();
				_contextMenu.hideBuiltInItems();
				
				var item:ContextMenuItem = new ContextMenuItem(Context.variables["version"], false, false);
				_contextMenu.customItems.push(item);
				_contextMenu.customItems.push(logMenuitem);
			}
			return _contextMenu;
		}
		
		private static function get logMenuitem():ContextMenuItem{
			var s:String = "显示Log";
			var item:ContextMenuItem = new ContextMenuItem(s,true,true);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,onLogSelect);
			return item;
		}
		
		private static function  onLogSelect(e:ContextMenuEvent):void{
			ShortCutUtil.onShowConsole();
		}
		
	}
}