package com._17173.flash.player.ui.stream.rec
{
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.model.RedirectData;
	import com._17173.flash.player.model.RedirectDataAction;
	import com._17173.flash.player.ui.comps.Pic;
	import com._17173.flash.player.ui.comps.grid.GridItemRenderer;
	
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 直播前后推荐单个子项. 
	 * @author shunia-17173
	 */	
	public class StreamPersonalRecItem extends GridItemRenderer
	{
		
		private static const PIC_WIDTH:int = 160;
		private static const PIC_HEIGHT:int = 90;
		
		private var _pic:Pic = null;
		private var _btn:DisplayObject = null;
		private var _watchingTF:TextField = null;
		private var _userPic:Pic = null;
		private var _userNameTF:TextField = null;
		private var _titleTF:TextField = null;
		private var _watching:DisplayObject = null;
		private var _borader:Shape = null;
		
		private var _picURL:String = null;
		private var _link:String = null;
		private var _userName:String = null;
		private var _userPicURL:String = null;
		private var _watchNum:String = null;
		private var _title:String = null;
		
		public function StreamPersonalRecItem()
		{
			super();
			
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, PIC_WIDTH, PIC_HEIGHT);
			graphics.endFill();
			
			_pic = new Pic();
			_pic.width = PIC_WIDTH;
			_pic.height = PIC_HEIGHT;
			_pic.showBorder = true;
			_pic.showBackground = true;
			_pic.borderColor = 0xFFFFFF;
			_pic.borderAlpha = 0.2;
			_pic.borderThickness = 1;
			_pic.backgroundColor = 0;
			_pic.backgroundAlpha = 0;
			addChild(_pic);
			
			var shape:Shape = new Shape();
			var m:Matrix = new Matrix();
			m.createGradientBox(PIC_WIDTH, 14, -90 * Math.PI / 180);
			shape.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [1, 0], [0, 255], m);
			shape.graphics.drawRect(0, 0, PIC_WIDTH, 14);
			shape.graphics.endFill();
			shape.x = 0;
			shape.y = _pic.height - shape.height;
			addChild(shape);
			
			_btn = new mc_perRecBtn();
			addChild(_btn);
			
			_watching = new mc_recWatching();
			addChild(_watching);
			
			_watchingTF = packTextField();
			addChild(_watchingTF);
			
			_userNameTF = packTextField();
			addChild(_userNameTF);
			
			_userPic = new Pic();
			_userPic.width = 30;
			_userPic.height = 30;
			_userPic.showBorder = true;
			_userPic.borderColor = 0xFFFFFF;
			_userPic.borderAlpha = 0.2;
			addChild(_userPic);
			
			_titleTF = packTextField();
			addChild(_titleTF);
			
//			_borader = new Shape();
//			_borader.graphics.beginFill(0, 0);
//			_borader.graphics.lineStyle(1, 0xFFFFFF, 0.2);
//			_borader.graphics.drawRect(0, 0, PIC_WIDTH, PIC_HEIGHT);
//			_borader.graphics.endFill();
//			addChild(_borader);
			
			buttonMode = true;
			useHandCursor = true;
		}
		
		private function packTextField():TextField {
			var fmt:TextFormat = new TextFormat(Util.getDefaultFontNotSysFont());
			var tf:TextField = new TextField();
			tf.selectable = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.textColor = 0xCCCCCC;
			tf.mouseEnabled = false;
			tf.defaultTextFormat = fmt;
			addChild(tf);
			return tf;
		}
		
		override public function set data(value:Object):void {
			super.data = value;
			init();
		}
		
		protected function init():void {
			_picURL = _data.hasOwnProperty("pic") ? _data.pic : null;
			if (_picURL) {
				_pic.content = _picURL;
			}
			_link = _data.hasOwnProperty("url") ? _data.url : null;
			if (_link) {
				addEventListener(MouseEvent.CLICK, onClick);
			}
			_userName = Util.validateStr(_data.masterName) ? HtmlUtil.decodeHtml(_data.masterName) : _data.masterName;
			_watchNum = _data.userCount;
			_userPicURL = _data.cover;
			_title = Util.validateStr(_data.liveTitle) ? HtmlUtil.decodeHtml(_data.liveTitle) : _data.liveTitle;
			
			updateWathingNum();
			_userNameTF.text = _userName;
			Util.shortenText(_userNameTF, 130);
			_titleTF.text = _title;
			Util.shortenText(_titleTF, PIC_WIDTH);
			
			_userPic.content = _userPicURL;
			
			resize();
		}
		
		private function updateWathingNum():void {
			var i:int = 0;
			var l:int = _watchNum.length % 3;
			var arr:Array = [];
			while (i != _watchNum.length) {
				var s:String = _watchNum.substr(i, l);
				if (Util.validateStr(s)) {
					arr.push(s);
				}
				i += l;
				l = 3;
			}
			_watchNum = arr.join(",");
			_watchingTF.text = _watchNum + "  人";
		}
		
		public function resize():void {
			_watching.x = 4;
			_watching.y = PIC_HEIGHT - _watching.height;
			
			_watchingTF.x = _watching.x + _watching.width + 3;
			_watchingTF.y = PIC_HEIGHT - _watchingTF.textHeight;
			
			_userPic.x = PIC_WIDTH - _userPic.width;
			_userPic.y = 83;
			
			_userNameTF.y = PIC_HEIGHT;
			_userNameTF.x = PIC_WIDTH - _userPic.width - _userNameTF.width - 3;
			
			_titleTF.x = (PIC_WIDTH - _titleTF.width) / 2;
			_titleTF.y = _userNameTF.y + _userNameTF.textHeight + 5;
		}
		
		protected function onClick(event:MouseEvent):void {
			if (Util.validateStr(_link)) {
				var redirect:RedirectData = new RedirectData();
				redirect.click_type = RedirectDataAction.CLICK_TYPE_REDIRECTION;
				redirect.action = RedirectDataAction.ACTION_BACK_RECOMMAND;
				redirect.url = _link;
				redirect.send();
			}
		}
		
	}
}