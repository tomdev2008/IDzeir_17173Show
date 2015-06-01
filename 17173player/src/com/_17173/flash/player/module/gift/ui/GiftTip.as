package com._17173.flash.player.module.gift.ui
{
	import com._17173.flash.core.util.Util;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 鼠标滑过礼物图标显示的tip
	 * 数据实际上是后台发过来的object
	 *  
	 * @author shunia-17173
	 */	
	public class GiftTip extends Sprite
	{
		
		private var _data:Object = null;
		private var _position:Point = null;
		private var _tfGiftInfo:TextField = null;
		private var _tfGiftSend:TextField = null;
		//暂时取消此行内容,但是后台已经添加可以设置说明的地方,与产品沟通暂时不需要开放
		private var _tfTipInfo:TextField = null;
		//可以上本直播间的提示
		private var _tfTipExplainLocal:TextField = null;
		//可以上全部直播间的提示
		private var _tfTipExplainGloable:TextField = null;
		//private var _chongTip:mc_chongTip = null;
		
		// 可以上本房间跑道的金币数
		private static const G_MIN_LOCAL:int = 800;
		// 可以上全局跑道的金币数
		private static const G_MIN_GLOBAL:int = 5000;
		private static const C_DESC_GB:String = "金币";
		private static const C_DESC_GD:String = "金豆";
		private static const C_DESC_YB:String = "银币";
		private static const C_DESC_YD:String = "银豆";
		
		private static const T_COLOR_G:uint = 0xFECE00;
		private static const T_COLOR_Y:uint = 0xD6D6D6;
		
		private var _config:Object = null;
		
		public function GiftTip()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
			
			_tfGiftInfo = packTextField();
			_tfGiftSend = packTextField();
			_tfTipExplainLocal = packTextField();
			_tfTipExplainGloable = packTextField();
			
//			_chongTip = new mc_chongTip();
//			_chongTip.buttonMode = true;
//			_chongTip.addEventListener(MouseEvent.CLICK, onChongTipClick);
//			_chongTip.x = 100;
//			_chongTip.y = 3;
//			_chongTip.name = "chongTip";
//			addChild(_chongTip);
		}
		
		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
			
			// 根据数据创建相应的配置信息,主要是每行的文字内容
			_config = createConfig(_data);
			// 根据配置设置实际的文字内容和样式
			updateTextFields(_config);
			resize();
		}
		
		private function createConfig(data:Object):Object {
			var conf:Object = {};
			if (data.currency == 1) {
				// 是否使用金币
				//_chongTip.visible = true;
				conf.desc1 = C_DESC_GB;
				conf.desc2 = C_DESC_GD;
				conf.color = T_COLOR_G;
				conf.reward = data.itemPrice / 2;
			} else {
				// 是否使用银币
				//_chongTip.visible = false;
				conf.desc1 = C_DESC_YB;
				conf.desc2 = C_DESC_YD;
				conf.color = T_COLOR_Y;
				conf.reward = data.itemPrice;
			}
			
			if (data.comment) {
				// comment字段可以覆盖默认的描述文字,每一句用 '|' 分隔开
				conf.lines = String(data.comment).split("|");
			} else {
				conf.lines = 
					[
						data.itemName + "(" + data.itemPrice + conf.desc1 + "/个)",
						"对方获得" + conf.reward + "个" + conf.desc2,
						data.currency == 1 ? 
							"一次性送" + getNum(data.itemPrice, G_MIN_LOCAL) + "个，本频道跑道展示！" : "",
						data.currency == 1 ? 
							"一次性送" + getNum(data.itemPrice, G_MIN_GLOBAL) + "个，全服跑道展示，炫富神器喔！" : ""
					];
			}
			
			return conf;
		}
		
		private function onChongTipClick(e:Event):void {
			Util.toUrl("http://v.17173.com/live/ucenter/payment.action");
		}
		
		private function updateTextFields(config:Object):void {
			var texts:Array = [_tfGiftInfo, _tfGiftSend, _tfTipExplainLocal, _tfTipExplainGloable];
			var content:String = null;
			while (texts.length) {
				var t:TextField = texts.shift();
				t.textColor = config.color;
				content = config.lines.shift();
				if (content) {
					t.text = content;
					t.visible = true;
				} else {
					t.text = "";
					t.visible = false;
				}
			}
			_tfTipExplainLocal.y = _tfTipExplainGloable.y = 2;
		}
		
		/**
		 * 上跑道的总金币数对礼物价值取余,算出需要送多少个礼物才能上跑道
		 *  
		 * @param value
		 * @param min
		 * @return 
		 */		
		private function getNum(value:Number, min:int):String {
			var temp:Number = Math.ceil(min / value);
			return temp.toString();
		}
		
		public function resize():void {
			var tempY:Number = 2;
			for (var i:int = 0; i < this.numChildren; i++) {
				var item:DisplayObject = this.getChildAt(i);
				if ((item.visible)&&(item.name != "chongTip")) {
					item.x = 2;
					item.y = tempY;
					tempY = item.y + item.height + 2;
				}
			}
			var btm:Number = tempY + 4;
			
			graphics.clear();
			graphics.lineStyle(1, _config.color);
			graphics.beginFill(0x444444, 0.8);
			graphics.drawRect(0, 0, width + 4, btm);
			graphics.endFill();
			
			//留箭头空
			graphics.moveTo(((width)/2)-6,btm);
			graphics.lineStyle(1,0x444444);
			graphics.lineTo(((width)/2)+6,btm);
			
			//箭头
			graphics.moveTo(((width)/2)-6,btm);
			graphics.lineStyle(1, _config.color);
			graphics.lineTo(((width)/2),btm + 6);
			graphics.lineTo(((width)/2)+6,btm);
			
		}

		public function set position(value:Point):void
		{
			_position = value;
			var tx:Number = _position.x - width / 2;
			if (tx < 0) {
				tx = 0;
			}
			x = tx;
			y = _position.y - height - 3;
		}
		
		private function packTextField():TextField {
			var fmt:TextFormat = new TextFormat(null, 12, 0xb9b9b9);
			var tf:TextField = new TextField();
			tf.defaultTextFormat = fmt;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			addChild(tf);
			return tf;
		}
	}
}