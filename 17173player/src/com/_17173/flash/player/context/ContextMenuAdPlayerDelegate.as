package com._17173.flash.player.context
{
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;

	public class ContextMenuAdPlayerDelegate extends ContextMenuDelegate
	{
		public function ContextMenuAdPlayerDelegate()
		{
			super();
		}
		
		override protected function getCustomMenuItems():Array {
			var contexts:Array = [];
			var item:ContextMenuItem = new ContextMenuItem(_vt, false, false);
			contexts.push(item);
			item = new ContextMenuItem("版本号:" + _vr + " " + _vn, false, false);
			contexts.push(item);
			item = new ContextMenuItem("", true, false);
			contexts.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onQuestion);
			item = new ContextMenuItem("视频信息");
			contexts.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onVideoInfo);
			return contexts;
		}
		
	}
}