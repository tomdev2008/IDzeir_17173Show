package
{
	import com._17173.flash.core.base.StageIniator;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.plugin.PluginManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.debug.DebuggerOutput_console;
	import com._17173.flash.player.ad_refactor.AdManager_refactor;
	import com._17173.flash.player.ad_refactor.filter.AdDataFilterSkipFrontPie;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerType;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.StatDelegate;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;
	import com._17173.flash.player.ui.PopupLayer;
	
	import flash.events.Event;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	/**
	 * 用于第三方聚合页的广告播放器,负责前贴片和贴片以及直播闪播等,在视频播放前出现的广告的控制.
	 * 可以通用做剥离出来的广告播放器用.
	 *  
	 * @author 庆峰
	 */	
	public class Pad extends StageIniator
	{
		
		private static const VR:String = "[广告播放器]";
		private static const VN:String = "2015.03.20 10:00";
		
		public function Pad()
		{
			super(true);
		}
		
		override protected function init():void {
			super.init();
			
			setupEnv();
			
			// set up all dependencies for ad mananger to work properly
			setupDependencies();
			
			// init
			_().initAll();
			// start stat Moudle
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_ADPALYER_COMPLET);
			// start ad manager
			_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_START_LOAD_AD_INFO);
			
			// fire resize event for init
			stage.dispatchEvent(new Event(Event.RESIZE));
			_(ContextEnum.EVENT_MANAGER).listen(PlayerEvents.BI_AD_COMPLETE, onAdComplet);
		}
		
		private function onAdComplet(obj:Object):void {
			//用户播放完广告，理解为正式开始看视频
			IStat(Context.getContext(ContextEnum.STAT)).stat(
				StatTypeEnum.BI, StatTypeEnum.EVENT_PLAY_REAL_START, {});
		}
		
		protected function setupEnv():void {
			// set up context menu for version checking
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			var items:Array = [];
			var item:ContextMenuItem = new ContextMenuItem("@17173视频", false, false);
			items.push(item);
			item = new ContextMenuItem("版本号:" + VR + " " + VN, false, false);
			items.push(item);
			menu.customItems = items;
			this.contextMenu = menu;
			
			// debugger
			Debugger.source = "pad";
			Debugger.output = new DebuggerOutput_console();
			
			Debugger.log(Debugger.INFO, "[pad]", "版本号:" + VR + " " + VN);
		}
		
		/**
		 * Till now, all parameters from url and loaderinfo(flashvars) has been write into context.variables
		 * so everything left to do is make sure business logic all over ad manager works fine
		 * eg: filters which denpend on player data, etc.
		 * 
		 * dependencies required: 
		 *   1. current player type (by flashvars)
		 *   2. debugger, eventmanager (by StageIniator or main class)
		 *   3. js delegate for js calls (by main class)
		 *   4. resize (by main class and hack for uimanager)
		 * 
		 * **** important **** 
		 *   1. _("type") should be set from flashvars, based on strings in PlayerType.as.
		 *   2. _("skipfp") -- skip ad front pie -- should be set from flashvars, 1/0 stands for true/false.
		 */		
		protected function setupDependencies():void {
			// context
			_(ContextEnum.PLUGIN_MANAGER, PluginManager, {});
			_(ContextEnum.STAT, StatDelegate);
			_(ContextEnum.AD_MANAGER, AdManager_refactor, [new AdDataFilterSkipFrontPie()]);
			_(ContextEnum.JS_DELEGATE, PadJsDelegate);
			
			// set player identity for runtime check to split differency between player and pad
			_("pad", true);
			
			_("cid", "");
			
			// skipfp == true && reference domain contains "v.17173.com", then the front pie ad will be skipped
			_("skipfp", (_("skipfp") == 1 && Util.refPage.indexOf("v.17173.com") != -1));
			
			// popup layer for layout
			var pop:PopupLayer = new PopupLayer();
			addChild(pop);
			_("adpopup", pop);
			_(ContextEnum.UI_MANAGER, UIManager);
			
			// resize layout
			stage.addEventListener(Event.RESIZE, function (e:Event):void {
				_(ContextEnum.EVENT_MANAGER).send(PlayerEvents.UI_RESIZE);
				
				if (_("type") == PlayerType.S_ZHANNEI) {
					var r:Object = {};
					r.width = stage.stageWidth;
					r.height = stage.stageHeight;
					_(ContextEnum.JS_DELEGATE).send("setVideoRegion", r);
				}
			});
		}
		
	}
}

import com._17173.flash.core.context.Context;
import com._17173.flash.core.context.IContextItem;
import com._17173.flash.core.util.Base64;
import com._17173.flash.core.util.JSBridge;
import com._17173.flash.core.util.Util;
import com._17173.flash.core.util.debug.Debugger;
import com._17173.flash.player.context.BusinessJSDelegate;
import com._17173.flash.player.ui.PopupLayer;

import flash.display.DisplayObject;
import flash.geom.Point;

class UIManager implements IContextItem{
	
	protected var _popupLayer:PopupLayer = null;
	
	public function get avalibleVideoWidth():Number {
		return _("stage").stageWidth;
	}
	
	public function get avalibleVideoHeight():Number {
		return _("stage").stageHeight;
	}
	
	public function get contextName():String {
		return "uiManager";
	}
	
	public function startUp(param:Object):void {
		_popupLayer = new PopupLayer();
		_popupLayer.name = "popup";
		Context.stage.addChild(_popupLayer);
	}
	
	public function popup(window:DisplayObject, point:Point = null, anim:Boolean = true):void {
		_popupLayer.popup(window, point, anim);
	}
	
	public function closePopup(window:DisplayObject):void {
		_popupLayer.closePopup(window);
	}
	
}



/**
 * JS dependency
 *  
 * @author 庆峰
 */
class PadJsDelegate extends BusinessJSDelegate {
	
	/**
	 * 判断是否有大前贴播放器
	 * 供点播站外播放器播放大前贴使用
	 */		
	public function checkCanShowDaQianTie():String {
		var re:String = "";
		var s:String = Context.variables["flashURL"];
		var jsBack:Boolean = JSBridge.addCall("supportA1", getCid(), null,
			function(value:Object):void {
				//					Debugger.log(Debugger.INFO, "站外大前贴测试0：" + value);
				var backStr:String = value as String;
				//					Debugger.log(Debugger.INFO, "站外大前贴测试：" + backStr);
				if (backStr && backStr != "") {
					re = backStr;
				} else {
					re = "";
				}
			}, false);
		if (!jsBack) {
			re = "";
		}
		//			Debugger.log(Debugger.INFO, "站外大前贴测试1：" + re);
		return re;
	}
	
	/**
	 * 根据当前flashURL的地址，截取出cid原始的数据
	 * 点播站外展示大前贴定位使用
	 */		
	private function getCid():String {
		var re:String = "";
		var url:String = Context.variables["flashURL"];
		//			Debugger.log(Debugger.INFO, "站外大前贴测试0111：" + url);
		if (url.indexOf("swf") != -1) {
			var tempArr:Array = url.split("/");
			if (Util.validateStr(tempArr[tempArr.length - 1] as String)) {
				re = (tempArr[tempArr.length - 1] as String).split(".")[0];
				if (Util.validateStr(re)) {
					//						Debugger.log(Debugger.INFO, "站外大前贴测试0112222：" + re);
					return re;
				}
			}
		}
		return re = Base64.encodeStr(Context.variables["cid"]);
	}
	
}