package com._17173.flash.player.context
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.model.PlayerEvents;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;

	/**
	 * 右键菜单 
	 * @author shunia-17173
	 * 
	 */	
	public class ContextMenuDelegate implements IContextItem
	{
		
		private static var _context:ContextMenu = null;
		
		protected var _vr:String = "";
		protected var _vn:String = "";
		protected var _vt:String = "";
		
		public function ContextMenuDelegate()
		{
		}
		
		protected function onMouseClick(event:Event):void {
			var target:Sprite = Context.stage.getChildAt(0) as Sprite;
			if (target && target.contextMenu != _context) {
				target.contextMenu = _context;
			}
		}
		
		protected static function onCopyVideoLinkItemSelect(event:ContextMenuEvent):void {
			Clipboard.generalClipboard.clear();
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, Context.variables["flashURL"]);
		}
		
		protected static function onCopyLinkItemSelect(event:ContextMenuEvent):void {
			Clipboard.generalClipboard.clear();
//			var fix:String = Context.variables["lv"] ? "" : "?t=" + Global.videoData.playedTime;
			var fix:String = Context.variables["lv"] ? "" : "?t=" + (Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data.playedTime;
			Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, Context.variables["url"] + fix);
		}
		
		protected static function onQuestion(event:ContextMenuEvent):void {
//			navigateToURL(new URLRequest("http://help.17173.com/help/wenti.shtml"), "_blank");
			Util.toUrl("http://help.17173.com/help/wenti.shtml");
		}
		
		protected static function onVideoInfo(event:ContextMenuEvent):void {
//			Global.eventManager.send(PlayerEvents.UI_SHOW_VIDEO_INFO);
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(PlayerEvents.UI_SHOW_VIDEO_INFO);
		}
		
		public function get contextName():String {
			// TODO Auto Generated method stub
			return ContextEnum.CONTEXT_MENU;
		}
		
		public function startUp(param:Object):void {
			Context.stage.addEventListener(Event.ENTER_FRAME, onMouseClick);
			
			_vn = param["vn"];
			_vr = param["vr"];
			_vt = param["vt"];
			
			_context = new ContextMenu();
			_context.hideBuiltInItems();
			_context.customItems = getCustomMenuItems();
		}
		
		protected function getCustomMenuItems():Array {
			var contexts:Array = [];
			var item:ContextMenuItem = new ContextMenuItem(_vt, false, false);
			contexts.push(item);
			item = new ContextMenuItem("版本号:" + _vr + " " + _vn, false, false);
			contexts.push(item);
			item = new ContextMenuItem("", true, false);
			contexts.push(item);
			if (!Context.variables["lv"]) {
				item = new ContextMenuItem("复制视频地址", true);
				contexts.push(item);
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onCopyVideoLinkItemSelect)
			};
			item = new ContextMenuItem("复制播放页地址");
			contexts.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onCopyLinkItemSelect);
			item = new ContextMenuItem("问题反馈");
			contexts.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onQuestion);
			item = new ContextMenuItem("视频信息");
			contexts.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onVideoInfo);
			return contexts;
		}
		
	}
}