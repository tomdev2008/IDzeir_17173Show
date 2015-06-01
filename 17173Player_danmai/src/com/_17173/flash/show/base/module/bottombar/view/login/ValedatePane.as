package com._17173.flash.show.base.module.bottombar.view.login
{
	import com._17173.flash.core.components.common.LinkText;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.JSBridge;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	public class ValedatePane extends Sprite
	{
		private var _valedataTf:TextField = null;
		private var _bitmap:Bitmap = null;
		private var _valeSp:Sprite = null;
		private var _changeTf:TextField;
		private var _url:String = null;
		private var _ref:String = null;
		public function ValedatePane()
		{
			super();
			this.graphics.beginFill(0x000000,.01);
			this.graphics.drawRect(0,0,241,40);
			this.graphics.endFill();
			init();
		}
		
		private function init():void{
			var ui:IUIManager = Context.getContext(CEnum.UI) as IUIManager;
			var lc:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var txtbg:MovieClip = new Login_Input_Bg();
			txtbg.x = 0;
			txtbg.width = 141;
			txtbg.mouseChildren = false;
			this.addChild(txtbg);
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0x9774C6;
			textFormat.size = 14;
			textFormat.font = FontUtil.f;
			
			_valedataTf = new TextField();
			_valedataTf.defaultTextFormat = textFormat;
			_valedataTf.setTextFormat(textFormat);
			_valedataTf.type = TextFieldType.INPUT;
			_valedataTf.x = 2;
			_valedataTf.y = 4;
			_valedataTf.height = 30;
			_valedataTf.width = 140;
			this.addChild(_valedataTf);
			
			_valeSp = new Sprite();
			_valeSp.mouseEnabled = false;
			_valeSp.mouseChildren = false;
			_valeSp.graphics.beginFill(0xffffff,1);
			_valeSp.graphics.drawRect(0,0,82,34);
			_valeSp.graphics.endFill();
			_valeSp.x = 150;
			this.addChild(_valeSp);
			
			_bitmap = new Bitmap();
			_valeSp.addChild(_bitmap);
			
			
			//找回密码
			textFormat = new TextFormat();
			textFormat.color = 0x8B7D98;
			textFormat.size = 12;
			_changeTf = new TextField();
			_changeTf.x = _valeSp.x + _valeSp.width + 7;
			_changeTf.y = 15;
			_changeTf.width = 45;
			_changeTf.text = lc.get("login_val_change","bottom");
			_changeTf.height = 25;
			_changeTf.width = _changeTf.textWidth + 4;
			_changeTf.height = _changeTf.textHeight + 4;
			_changeTf.selectable = false;
			_changeTf.tabEnabled = false;
			_changeTf.defaultTextFormat = textFormat;
			_changeTf.setTextFormat(textFormat);
			_changeTf.multiline = false;
			//点击弹出找回密码
			var change:LinkText = new LinkText(_changeTf);
			change.tabEnabled = false;
			change.addEventListener(MouseEvent.CLICK,onchangeBitmapClick);
			ui.registerTip(change,lc.get("login_val_change_tip","bottom"));
			this.addChild(change);
			_valedataTf.addEventListener(FocusEvent.FOCUS_OUT,onFocusOut);
		}
		/**
		 *加载验证码 
		 * @param url 验证码地址
		 * @param ref 刷新地址
		 * 
		 */		
		public function load(url:String,ref:String):void{
			_url = url;
			_ref = ref;
			loadData();
		}
		/**
		 *加载图片 
		 * @param appStr
		 * 
		 */		
		private function loadBitmap(appStr:Object):void{
			var resouce:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			resouce.loadResource(_url+appStr.url,onLoaded);
			Debugger.log(Debugger.INFO, "[验证码]", "请求验证码", _url);
		}
		
		private function onFocusOut(e:FocusEvent):void{
			var code:String = _valedataTf.text;
			if(code.length == 0){
				return;
			}
			JSBridge.addCall("showFlash.setCaptcha",code);
		}
		
		/**
		 *请求验证码地址 
		 * 
		 */		
		private function loadData():void{
			var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			var data:Object = {};
			data.refresh = "1";
			data.result = "json";
			server.http.getData(_ref,null,loadBitmap,onFail);
		}
		
		private function onFail(obj:Object):void{
			if(obj && obj.url){
				loadBitmap(obj)
			}
		}
		/**
		 *换一张 
		 * @param e
		 * 
		 */		
		private function onchangeBitmapClick(e:MouseEvent):void{
			//请求http
			loadData();
		}
		
		private function onLoaded(data:IResourceData):void{
			var bitmap:Bitmap = data.source as Bitmap;
			_bitmap.bitmapData = bitmap.bitmapData;
			_bitmap.width = 86;
			_bitmap.height = 37;
			Debugger.log(Debugger.INFO, "[验证码]", "验证码返回成功");
		}
		
		public function get code():String{
			return _valedataTf.text;
		}
	}
}