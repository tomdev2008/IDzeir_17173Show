package com._17173.flash.show.base.module.dingyue
{
	import com._17173.flash.core.components.base.BasePanel;
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class DingyuePanel extends BasePanel
	{
		private var _face:Sprite = null;
		private var _label0:TextField = null;
		private var _label1:TextField = null;
		private var _label2:TextField = null;
		private var _facesp:Sprite = null;
		private var _btnGoto:Button = null;
		/**
		 *{nickname:XXXX,masterId:XXXXX,userImg:XXXXX,liveUrl:XXXXXX} 
		 */		
		private var _data:Object = null;

		public function DingyuePanel()
		{
			super();
			setSkin_Bg(new Bg_Dingyuetx());
			setSkin_Close(new Btn_DyClose);
			setSkin_line(null);
			this.width = 332;
			this.height = 150;
		}

		override protected function onInit():void
		{
			super.onInit();
			titleStr = "<font size='12' color='#757575'>直播关注提醒</font>";
			initFace();
			initContext();
		}

		private function initFace():void
		{
			_face = new Sprite();
			_face.x = 23;
			_face.y = 48;
			_face.mouseChildren = false;
			_face.buttonMode = true;
			_face.addEventListener(MouseEvent.CLICK,onGoto);
			this.addChild(_face);

			_btnGoto = new Button();
			_btnGoto.setSkin(new Btn_Weiguan());
			_btnGoto.x = 205;
			_btnGoto.y = 105;
			_btnGoto.mouseChildren = false;
			this.addChild(_btnGoto);
		}
		
		override protected function onRePostionTitle():void{
			super.onRePostionTitle();
			if(title){
				title.x = 10;
				title.y = 7;
				this.addChild(title);
			}
		}

		private function initContext():void
		{
			_label0 = new TextField();
			_label0.x = 117;
			_label0.y = 46;
			_label0.width = 200;
			_label0.height = 20;
			_label0.htmlText = "<font color='#757575'>您关注的艺人：</font>";
			_label0.mouseEnabled = false;
			this.addChild(_label0);
			
			_label1 = new TextField();
			_label1.x = 117+80;
			_label1.y = 46;
			_label1.width = 200;
			_label1.height = 20;
			_label1.selectable = false;
			_label1.addEventListener(MouseEvent.CLICK,onGoto);
			this.addChild(_label1);

			_label2 = new TextField();
			_label2.x = 117;
			_label2.y = 63;
			_label2.width = 200;
			_label2.height = 20;
			_label2.htmlText = "<font color='#757575'>正在直播，快来围观吧！</font>";
			_label2.mouseEnabled = false;
			this.addChild(_label2);
		}

		/**
		 *
		 *
		 */
		override protected function onShow():void
		{
			super.onShow();
			rePostion();
			_btnGoto.addEventListener(MouseEvent.CLICK, onGoto);
		}

		override protected function onHide():void
		{
			clear();
			onRead();
		}

		
		override protected function onResize(e:Event=null):void{
			rePostion();
		}

		/**
		 * 去主播房间
		 * @param e
		 *
		 */
		private function onGoto(e:Event):void
		{
			//去直播间
			Util.toUrl(_data.liveUrl);
			
			onRead();
			
			hide();
		}
		/**
		 *标记已阅 
		 * 
		 */
		private function onRead():void
		{
			(Context.getContext(CEnum.SERVICE)).http.getData(SEnum.SUB_READ,{subid:_data.masterId},function onOK(data:Object):void{});
		}

		/**
		 *定位
		 *
		 */
		public function rePostion():void
		{
			this.x = Context.stage.stageWidth - this.width;
			this.y = Context.stage.stageHeight - this.height;
		}
		
		/**
		 *设置数据
		 *
		 */
		public function setDate(data:Object):void
		{
			_data = data;
			//头像
			if (_facesp && _facesp.parent)
			{
				_facesp.removeChild(_facesp);
			}
			
			(Context.getContext(CEnum.SOURCE) as IResourceManager).loadResource(data.userImg, function(value:IResourceData):void
			{
				_facesp = new Sprite();
				var bitmap:Bitmap = value.newSource as Bitmap;
				var ws:Number = 80/bitmap.width;
				var hs:Number = 80/bitmap.height;
				bitmap.scaleX = ws;
				bitmap.scaleY = hs;
				_facesp.addChild(bitmap);
				_face.addChild(_facesp);
			});
			//提示
			_label1.htmlText = "<font color='#FFC400'><a href='event:onGoto()'>"+data.nickname+"</font></a>";
		}


		private function clear():void
		{

		}
	}
}
