package com._17173.flash.show.base.module.gameact
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.net.IServiceProvider;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	
	public class LinkEgg extends Sprite
	{
		public function LinkEgg()
		{
			super();
			init();
//			this.graphics.beginFill(0xff0000)
//			this.graphics.drawRect(0,0,200,300);
//			this.graphics.endFill();
				
		}
		
		protected var path:String = "http://173eggs.yanfabei.com/GoldEggs.swf";
		private var mc:DisplayObject;
		private var closeBtn:Button;
		
		private function init():void{
			var ui:IResourceManager = Context.getContext(CEnum.SOURCE) as IResourceManager;
			ui.loadResource(path,onLoaded);
//			var loader:Loader = new Loader();
//			loader.load(new URLRequest(path));
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,oncomplete);
		}
		
		protected function oncomplete(event:Event):void
		{
			// TODO Auto-generated method stub
			try{
				mc = event.currentTarget.content;
				getData();
			}catch(e:Error){
				Debugger.log(Debugger.INFO, "[egg]", "egg游戏加载错误，地址"+e.message);	
			}
		}
		
		private function onLoaded(data:IResourceData):void
		{
			// TODO Auto Generated method stub
			if(data && data.source){
				mc = data.source;
				getData();
//				onSend();
			}else{
				Debugger.log(Debugger.INFO, "[egg]", "egg游戏加载错误，地址"+path);				
			}
		}		
		
		
		private function getData():void{
			var s:IServiceProvider = Context.getContext(CEnum.SERVICE) as IServiceProvider;
			s.http.getData(SEnum.GET_EGGGAME_INFO,{gt:3},onOK,onErro);
		}
		
		private function onErro(data:Object):void
		{
			// TODO Auto Generated method stub
			Debugger.log(Debugger.INFO, "[egg]", "egg游戏信息错误，地址");	
		}
		
		private function onOK(data:Object):void
		{
			// TODO Auto Generated method stub
			var  info:String = data.args;
			//发送数据
			if(mc.hasOwnProperty("getData")){
				mc["getData"](info);
				this.addChild(mc);
			}
			initClose();
		}
		
		private function initClose():void{
			closeBtn = new Button();
			closeBtn.setSkin(new Act_closeBtn_egg());
			closeBtn.width = 24;
			closeBtn.height = 25.5;
			closeBtn.x = 200 - closeBtn.width;
			closeBtn.y = - 25;
			closeBtn.addEventListener(MouseEvent.CLICK,onClick);
			this.addChild(closeBtn);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(this.parent){
				this.parent.removeChild(this);
			}
		}		
		
		public function onSend():void{
			var con:LocalConnection = new LocalConnection();
			con.addEventListener(StatusEvent.STATUS, onStatus);  
			con.send("eggdata","getData","gameid=11&uid=102682189&nickname=cnwujn1&extraparam=none&sn=824209169346124592239993&sign=6ce1115cdb0da3a62c6cf9552a8653df&platformid=show");
			
		}
		
		protected function onStatus(event:StatusEvent):void
		{
			// TODO Auto-generated method stub
			switch (event.level) {  
				case "status":  
					trace("LocalConnection.send() succeeded");  
					break;  
				case "error":  
					trace("LocalConnection.send() failed");  
					break;  
			}  
		}
		
	}
}