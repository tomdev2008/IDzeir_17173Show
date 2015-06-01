package com._17173.flash.core.ad.display
{
	import com._17173.flash.core.util.Util;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * 广告被屏蔽显示内容
	 */	
	public class AdErrorContent extends Sprite
	{
		private var _logo:MovieClip;
		private var _mainLabel:TextField;
		private var _label1:TextField;
		private var _label2:TextField;
		private var _label3:TextField;
		private var _label4:TextField;
		private var _label5:TextField;
		
		public function AdErrorContent()
		{
			super();
			init();
			addEvent();
			resize();
		}
		
		private function init():void {
			var bg:Sprite = new Sprite();
			
			bg.graphics.clear();
			bg.graphics.beginFill(0xff00ff, 0);
			bg.graphics.drawRect(0, 0, 320, 295);
			bg.graphics.endFill();
			addChild(bg);
			
			_logo = new mc_errorImage();
			addChild(_logo);
			
			var tf1:TextFormat = new TextFormat();
			tf1.font = Util.getDefaultFontNotSysFont();
			tf1.color = 0xffffff;
			tf1.size = 20;
			_mainLabel = new TextField();
			_mainLabel.text = "广告君表示播放不能...";
			setFormat(_mainLabel, tf1);
			addChild(_mainLabel);
			
			var tf2:TextFormat = new TextFormat();
			tf2.font = Util.getDefaultFontNotSysFont();
			tf2.color = 0xffffff;
			tf2.size = 20;
			_label1 = new TextField();
			_label1.text = "优质内容 + 高质量视频 = 高投入，";
			setFormat(_label1, tf2);
			addChild(_label1);
			
			_label2 = new TextField();
			_label2.text = "如果您喜欢这里，请支持一下我们。";
			setFormat(_label2, tf2);
			addChild(_label2);
			
			var tf3:TextFormat = new TextFormat();
			tf3.font = Util.getDefaultFontNotSysFont();
			
			_label3 = new TextField();
			_label3.htmlText = "<FONT SIZE='16' COLOR='#00ff00'>" + "<a href=\'event:back\'><u><FONT COLOR='#FDCD00'>如何解除广告屏蔽</FONT></u></a>" + "</FONT>";
			setFormat(_label3, tf3);
			addChild(_label3);
			
			_label4 = new TextField();
			_label4.htmlText = "<FONT SIZE='16' COLOR='#FFFFFF'>无法解除，请" + "<a href=\'event:back\'><u><FONT COLOR='#FDCD00'>反馈</FONT></u></a>" + "给我们</FONT>";
			setFormat(_label4, tf3);
			addChild(_label4);
		}
		
		private function setFormat(tx:TextField, tf:TextFormat):void {
			tx.autoSize = TextFieldAutoSize.LEFT;
			tx.selectable = false;
			if(tf) {
				tx.defaultTextFormat = tf;
				tx.setTextFormat(tf);
			}
		}
		
		private function addEvent():void {
			_label3.addEventListener(TextEvent.LINK, toCloseAD);
			_label4.addEventListener(TextEvent.LINK, onBack);
		}
		
		private function toCloseAD(evt:TextEvent):void {
			Util.toUrl("http://help.17173.com/news/05232014/112050337.shtml");
		}
		
		private function onBack(evt:TextEvent):void {
			Util.toUrl("http://help.17173.com/help/wenti.shtml");
		}
		
		private function resize():void {
			if (_logo && contains(_logo)) {
				_logo.x = (this.width - _logo.width) / 2;
				_logo.y = 0;
			}
			if (_mainLabel && contains(_mainLabel)) {
				_mainLabel.x = (this.width - _mainLabel.width) / 2;
				if (_logo) {
					_mainLabel.y = _logo.y + _logo.height + 20;
				} else {
					_mainLabel.y = 20;
				}
			}
			if (_label1 && contains(_label1)) {
				_label1.x = (this.width - _label1.width) / 2;
				if (_mainLabel) {
					_label1.y = _mainLabel.y + _mainLabel.height + 30;
				} else {
					_label1.y = 20;
				}
			}
			
			if (_label2 && contains(_label2)) {
				_label2.x = (this.width - _label2.width) / 2;
				if (_label1) {
					_label2.y = _label1.y + _label1.height - 5;
				} else {
					_label2.y = 20;
				}
			}
			
			if (_label3 && contains(_label3)) {
				_label3.x = (this.width - _label3.width) / 2;
				if (_label2) {
					_label3.y = _label2.y + _label2.height + 25;
				} else {
					_label3.y = 20;
				}
			}
			
			if (_label4 && contains(_label4)) {
				_label4.x = (this.width - _label4.width) / 2;
				if (_label3) {
					_label4.y = _label3.y + _label3.height;
				} else {
					_label4.y = 20;
				}
			}
		}
	}
}