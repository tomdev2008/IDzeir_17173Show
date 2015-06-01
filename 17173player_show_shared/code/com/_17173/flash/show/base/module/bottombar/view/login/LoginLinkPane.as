package com._17173.flash.show.base.module.bottombar.view.login
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class LoginLinkPane extends Sprite
	{
		private var _links:Array = null;
		private var _linkqq:Button = null;
		private var _linksina:Button = null;
		public function LoginLinkPane()
		{
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			//一键登录
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0x8b7d98;
			textFormat.size = 12;
			var tmp:TextField = new TextField();
			tmp.x = 0;
			tmp.y = 5;
			tmp.width = 62;
			tmp.height = 25;
			tmp.defaultTextFormat = textFormat;
			tmp.setTextFormat(textFormat);
			tmp.text = lc.get("login_link_labe","bottom");
			tmp.mouseEnabled = false;
			tmp.tabEnabled = false;
			this.addChild(tmp);
			super();
			_links = [];
			
			var line:MovieClip = new Login_Line1();
			line.x = -41;
			line.y = 0;
			this.addChild(line);
			
			_linkqq = new Button();
			_linkqq.setSkin(new Login_Link_qq())
			_linkqq.x = 0;
			_linkqq.y = 34;
			_linkqq.buttonMode = true;
			_linkqq.mouseChildren = false;
			_linkqq.addEventListener(MouseEvent.CLICK,onClickqq);
			this.addChild(_linkqq);
			
			_linksina = new Button();
			_linksina.setSkin(new Login_Link_sina())
			_linksina.x = 0;
			_linksina.y = 90;
			_linksina.buttonMode = true;
			_linksina.mouseChildren = false;
			_linksina.addEventListener(MouseEvent.CLICK,onClicksina);
			this.addChild(_linksina);
			
			//sohu
			_links.push(new LoginLinkIcon("open-platform-sohu",new Login_Icon_Sohu()));
			//玩
			_links.push(new LoginLinkIcon("open-platform-ww37",new Login_Icon_Play()));
			//百度
			_links.push(new LoginLinkIcon("open-platform-baidu",new Login_Icon_Baidu()));
			//人人
			_links.push(new LoginLinkIcon("open-platform-renren",new Login_Icon_Renren()));
			//豆瓣
			_links.push(new LoginLinkIcon("open-platform-douban",new Login_Icon_Douban()));
			var tips:Array = [lc.get("link_sohu","bottom"),lc.get("link_37wan","bottom"),lc.get("link_baidu","bottom"),lc.get("link_renren","bottom"),lc.get("link_douban","bottom")];
			var link:LoginLinkIcon;
			var len:int = _links.length;
			for (var i:int = 0; i < len; i++) 
			{
				link = _links[i];
				link.tabEnabled = false;
				link.x = i * 25 + 10;
				link.y = 145;
				link.addEventListener(MouseEvent.CLICK,onLinkClick);
				ui.registerTip(link,tips[i]);
				this.addChild(link);
			}
		}
		
		private function onLinkClick(e:Event):void{
			var link:LoginLinkIcon = e.currentTarget as LoginLinkIcon;
			//调用js
			JSBridge.addCall("showFlash.loginDirectly", link.linkType);
			Debugger.log(Debugger.INFO, "[js]", "快捷登录调用js");
		}
		
		
		private function onClickqq(e:Event):void{
			JSBridge.addCall("showFlash.loginDirectly", "open-platform-qq");
			Debugger.log(Debugger.INFO, "[js]", "快捷登录调用js");
		}
		
		private function onClicksina(e:Event):void{
			JSBridge.addCall("showFlash.loginDirectly", "open-platform-weibo");
			Debugger.log(Debugger.INFO, "[js]", "快捷登录调用js");
		}
	}
}