package  com._17173.flash.show.base.module.gamelink
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GameLinkButton extends Button
	{
		private var _link:String = null;
		private var _iconsp:Sprite = null;
		private var _icon:DisplayObject = null;
		private var _key:String = null;
		private var _jk:String = null;
			
		public function GameLinkButton(label:String,icon:DisplayObject,link:String,jk:String)
		{
			_icon = icon;
			_link = link;
			_jk = jk;
//			onGetData();
			super("<font size='14' color='#63ACFF'>"+ label + "</font>", false);
			initSkin();
		}
		
		public function get key():String
		{
			return _key;
		}

		public function set key(value:String):void
		{
			_key = value;
		}
		
		private function onGetData():void{
//			http://show.17173.com/open/gogame.action?gt=0
			var showdata:ShowData = Context.variables["showData"] as ShowData;
			if(showdata.masterID !=null && int(showdata.masterID) > 0){
				var server:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
				var data:Object = {};
				server.http.getData(SEnum.domain + "/open/gogame.action?gt=" + _jk + "&",data,onSecc);
//			server.http.getData("http://show.17173.com/open/gogame.action?gt="+_jk+"&",data,onSecc);
			}
		
		}
		
		private function onSecc(data:Object):void
		{
			_link = data.url;
		}
		
		override protected function onInit():void{
			super.onInit();
			_iconsp = new Sprite();
			_iconsp.x = 11;
			_iconsp.y = 7;
			_iconsp.mouseChildren = _iconsp.mouseEnabled = false;
			this.addChild(_iconsp);
			_iconsp.addChild(_icon);
		}
		
		override protected function onShow():void{
			super.onShow();
			this.addEventListener(MouseEvent.CLICK,onClick);
		}
			
		
		override protected function onHide():void{
			super.onHide();
			this.removeEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(e:Event):void{
			var showdata:ShowData = Context.variables["showData"] as ShowData;
			if(showdata.masterID !=null && int(showdata.masterID) > 0){
				Util.toUrl(_link);
			}else{
				(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.LOGINPANEL_SHOW);
			}
		}
		
		private function initSkin():void{
			this.setSkin(new Bg_gameLink());
		}
		
		override protected function onRePostionLabel():void{
			super.onRePostionLabel();
			if(_labelTxt){
				this._labelTxt.x = 51;
			}
		}
	}
}