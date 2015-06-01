package com._17173.flash.show.base.module.lobby
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.layer.IUIManager;
	import com._17173.flash.show.base.context.module.BaseModule;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.ShowData;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	
	public class LobbyModule extends BaseModule
	{
		private var _lock:Boolean = false;		
		private var _row:uint = 4;
		
		private var _gdata:Object;
		private var _vdata:Object;
		
		private var _box:Sprite;		
		private var _vBox:Sprite;
		private var _gBox:Sprite;		
		private var _bglayer:Sprite;
		private var closeBut:Button;
		
		private var _vMoreTxt:LobbyText;
		private var _gMoreTxt:LobbyText;
		
		private var _isHidden:Boolean = true;		
		
		private var _local:ILocale;
		private var _roomCard:Array;
		
		public function LobbyModule()
		{
			super();
			_version = "0.0.1";
			//this.mouseChildren = false;
			this.visible = false;
			this.addEventListener(MouseEvent.MOUSE_OVER,overHandler);
			this.addEventListener(MouseEvent.MOUSE_OUT,overHandler);
			_bglayer = new Sprite();
			this.addChild(_bglayer);
			_box = new Sprite();
			this.addChild(_box);
			
			_vBox = new Sprite();
			_gBox = new Sprite();
			_box.addChild(_vBox);
			_box.addChild(_gBox);
			
			_local = Context.getContext(CEnum.LOCALE) as ILocale;
			var _vTxt:LobbyText = new LobbyText();
			_vTxt.htmlText = "<font size='20' color='#ffffff'>"+_local.get("vTitle","lobby")+"</font>";
			_box.addChild(_vTxt);
			_vBox.y = _vTxt.y + _vTxt.height + 5;
			/*
			var _gTxt:LobbyText = new LobbyText();
			_gTxt.y = 300;
			_gTxt.htmlText = "<font size='24' color='#ffffff'>"+_local.get("gTitle","lobby")+"</font>";
			_box.addChild(_gTxt);
			_gBox.y = _gTxt.y + _gTxt.height + 5;*/
			
			_bglayer.graphics.beginFill(0x000000,.8);
			_bglayer.graphics.drawRect(0,0,870,600);
			_bglayer.graphics.endFill();
			//_bglayer.addChild(Utils.getURLGraphic("assets/img/lobbyBg.jpg",true,1920,909));
			
			closeBut = new Button("",false);
			closeBut.setSkin(new LobbyCloseButton());
			closeBut.width = closeBut.height = 14;
			this.addChild(closeBut);
			closeBut.addEventListener(MouseEvent.CLICK,function():void
			{
				hiden();
			});
			
			_vMoreTxt = new LobbyText();
			//_gMoreTxt = new LobbyText();
			_vMoreTxt.mouseEnabled = true;
			//_gMoreTxt.mouseEnabled = true;
			_vMoreTxt.htmlText = "<a href='event:myText'><font size='14' color='#ffffff'>"+_local.get("more","lobby")+"</font></a>"
			//_gMoreTxt.htmlText = "<a href='event:myText'><font size='14' color='#ffffff'>"+_local.get("more","lobby")+"</font></a>";
			/*_vMoreTxt.addEventListener(MouseEvent.CLICK,function():void
			{
			Util.toUrl(_local.get("vmoreUrl","lobby"));
			});
			_gMoreTxt.addEventListener(MouseEvent.CLICK,function():void
			{
			Util.toUrl(_local.get("gmoreUrl","lobby"));
			});*/
			_vMoreTxt.addEventListener(TextEvent.LINK,function():void
			{
				Util.toUrl(_local.get("vmoreUrl","lobby"));
			});
			/*_gMoreTxt.addEventListener(TextEvent.LINK,function():void
			{
				Util.toUrl(_local.get("gmoreUrl","lobby"));
			});*/
			
			createRoomCard();
		}
		/**
		 * 生成默认的10*2卡片 
		 */		
		private function createRoomCard():void
		{
			_roomCard = [[],[]];
			for(var i:uint = 0 ; i<12;i++)
			{
				_roomCard[0].push(new VRoomCard());
				//_roomCard[1].push(new GRoomCard());
			}
		}
		
		protected function overHandler(event:MouseEvent):void
		{
			var tar:PreVideoAnimation = event.target as PreVideoAnimation;
			if(tar)
			{
				switch(event.type)
				{
					case MouseEvent.MOUSE_OVER:
						tar.play();
						break;
					case MouseEvent.MOUSE_OUT:
						tar.stop();
						break;
				}
			}
		}
		
		override protected function onAdded(event:Event):void
		{
			Debugger.log(Debugger.INFO, "大厅加载完成初始化舞台大小：", stage.stageWidth+" X "+stage.stageHeight);					
			//stage.addEventListener(Event.RESIZE,onResize);	
			//onResize();
			if(!this._isHidden)
			{
				show();
			}else{
				hiden();
			}
		}
		
		protected function onResize(event:Event=null):void
		{
			return;
			var rect:Rectangle = (Context.getContext(CEnum.UI) as IUIManager).sceneRect;
			//两边留关闭按钮宽度，并且四线3格减去一个间距
			var left:Number = 2 * this.closeBut.width;
			_row = Math.max(1, uint((rect.width - left - 10) / 323));
			this.closeBut.visible = _row > 1;
			this.update();
		}
		
		override protected function onRemove(event:Event):void
		{
			trace("删除");
			stage.removeEventListener(Event.RESIZE,onResize);
		}
		
		public function get lock():Boolean
		{
			return _lock;
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			_lock = value;
		}
		
		public function show():void
		{
			this._isHidden = false;
			TweenMax.killChildTweensOf(this);
			this.x = -this.width;
			this.visible = true;
			TweenMax.to(this, .5, {x: 48, onComplete:onComplete,onCompleteParams:[true]});
		}
		
		public function hiden():void
		{
			this._isHidden = true;
			TweenMax.killChildTweensOf(this);
			TweenMax.to(this, .5, {x: -this.width, onComplete:onComplete,onCompleteParams:[false]});
		}
		
		/**
		 * 动画播放完毕 
		 * @param bool
		 * 
		 */		
		private function onComplete(bool:Boolean):void
		{	
			this.visible = bool;
		}
		
		/**
		 * 设置游戏直播大厅的数据 
		 * @param value
		 */		
		public function set gInfo(value:Object):void
		{			
			this._gdata = value;
			var gcards:Array = this._roomCard[1];
			for(var i:uint = 0 ;i < gcards.length;i++)
			{
				if(this._gdata&&this._gdata.length>i)
				{
					(gcards[i] as GRoomCard).info = this._gdata[i];
					(gcards[i] as GRoomCard).visible = true;
				}else{
					(gcards[i] as GRoomCard).visible = false;
				}
			}
		}
		
		public function get gInfo():Object
		{
			return _gdata;
		}
		
		/**
		 * 设置娱乐直播大厅数据 
		 * @param value
		 */		
		public function set vInfo(value:Object):void
		{
			this._vdata = value;
			var showData:ShowData = Context.variables["showData"];
			//排除用户当前在的房间
			for(var i:uint = 0;i<this._vdata.length;i++)
			{
				var d:Object = this._vdata[i];
				if(Utils.validate(d,"masterId")&&d.masterId == showData.ownerID)
				{
					this._vdata.splice(i,1);
					break;
				}
			}
			
			var vcards:Array = this._roomCard[0];
			for(i = 0;i < vcards.length;i++)
			{
				if(this._vdata&&this._vdata.length>i)
				{
					(vcards[i] as VRoomCard).info = this._vdata[i];
					(vcards[i] as VRoomCard).visible = true;
				}else{
					(vcards[i] as VRoomCard).visible = false;
				}
			}
			this.update();
		}
		
		public function get vInfo():Object
		{
			return this._vdata;
		}
		
		
		/**
		 * 模块当前显示状态 
		 * @return 
		 */		
		public function get isHiden():Boolean
		{			
			return this._isHidden;
		}
		
		/**
		 * 根据显示宽度，更新每行的个数 
		 */		
		private function update():void
		{
			//_gBox.removeChildren();
			_vBox.removeChildren();
			for(var i:uint = 0;i<12;i++)
			{
				/*var gcard:GRoomCard = _roomCard[1][i];
				gcard.x = 330*i;					
				_gBox.addChild(gcard);
				if(!this.contains(_gMoreTxt))this.addChild(this._gMoreTxt);*/
				
				var vcard:VRoomCard = _roomCard[0][i];
				vcard.x = 203*(i%_row);
				vcard.y = 160*(Math.floor(i/_row));
				_vBox.addChild(vcard);
				if(!this.contains(_vMoreTxt))this.addChild(this._vMoreTxt);				
			}
			
			var rect:Rectangle = (Context.getContext(CEnum.UI) as IUIManager).sceneRect;
			_bglayer.x = 0;
			_bglayer.y = 0;
			_bglayer.width = 870;
			_bglayer.height = 600;
			
			_box.x = (this.width - _box.width) >> 1;
			_box.y = 50;
			
			closeBut.x = _bglayer.width - closeBut.width - 10;
			closeBut.y = 10;
			
			_vMoreTxt.x = _box.x + _box.width - _vMoreTxt.width - 5;
			_vMoreTxt.y = _box.y + 7;
			/*_gMoreTxt.x = _box.x + _box.width - _gMoreTxt.width - 5;
			_gMoreTxt.y = _box.y + 315;*/
		}
	}
}