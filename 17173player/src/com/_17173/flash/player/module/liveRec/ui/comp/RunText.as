package com._17173.flash.player.module.liveRec.ui.comp
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.time.Ticker;
	
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 跑马灯组件 
	 * @author 安庆航
	 * 原理：有两个textFiled，两个首位相接的移动，当前一个完全移出显示区域，就将它放在后一个textfiled的后面，循环次操作
	 * 经反复测试，发现1毫秒移动0.5像素，看着稍微舒服点
	 */	
	public class RunText extends Sprite
	{
		public static const SHOW_WIDTH:int = 150;
		private var offset:Number = 0.6;
		private var defaultColor:Number = 0xffffff;
		private var yelloColor:Number = 0xffaf00;
		//第一个文字 		
		private var tf1:TextField = null;
		//第二个文字 
		private var tf2:TextField = null;
		private var _mask:Sprite = null;
		private var _url:String = "";
		private var _format:TextFormat = null;
		
		public function RunText()
		{
			super();
			
			addListeners();
		}
		
		private function addListeners():void {
			//			addEventListener(MouseEvent.ROLL_OVER, mouseRollOver);
			//			addEventListener(MouseEvent.ROLL_OUT, mouseRollOut);
			addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
		public function mouseRollOver(evt:MouseEvent):void {
			stopRun();
			this.buttonMode = true;
			this.useHandCursor = true;
			this.mouseChildren = false;
			if (tf1) {
				tf1.textColor = yelloColor;
			}
			if (tf2) {
				tf2.textColor = yelloColor;
			}
		}
		
		public function mouseRollOut(evt:MouseEvent):void {
			this.buttonMode = false;
			this.useHandCursor = false;
			this.mouseChildren = false;
			stopRun();
			doRun();
			if (tf1) {
				tf1.textColor = defaultColor;
			}
			if (tf2) {
				tf2.textColor = defaultColor;
			}
		}
		
		/**
		 * 跳转到对应的url地址
		 */		
		private function mouseClick(evt:MouseEvent):void {
			if (Util.validateStr(_url)) {
				if (Context.stage.displayState == StageDisplayState.NORMAL) {
					
				} else {
					Context.stage.displayState = StageDisplayState.NORMAL;
				}
				Util.toUrl(_url);
			}
		}
		
		/**
		 * 初始化tf，如果文字长度超过显示区域就初始化两个tf
		 * @param title
		 * @param url
		 * 
		 */		
		public function init(title:String, url:String, useDefault:Boolean = false):void {
			_url = url;
			if (!useDefault) {
//				title = "直播间正在直播《" + title + "》";
				title = "《" + title + "》玩家/美女正在直播中..."
			}
			
			_format = new TextFormat();
			_format.size = 12;
			_format.font = Util.getDefaultFontNotSysFont();
			
			tf1 = new TextField();
			tf1.text = title;
			tf1.selectable = false;
			tf1.autoSize = TextFieldAutoSize.LEFT;
			tf1.textColor = defaultColor;
			tf1.defaultTextFormat = _format;
			tf1.setTextFormat(_format);
			addChild(tf1);
			
			if (checkWidth()) {
				tf2 = new TextField();
				tf2.text = title;
				tf2.autoSize = TextFieldAutoSize.LEFT;
				tf2.textColor = defaultColor;
				tf2.selectable = false;
				addChild(tf2);
				tf2.x = tf1.width + 2;
				tf2.defaultTextFormat = _format;
				tf2.setTextFormat(_format);
				doRun();
			}
			_mask = new Sprite();
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawRect(0, 0, RunText.SHOW_WIDTH, tf1.height);
			_mask.graphics.endFill();
			addChild(_mask);
			this.mask = _mask;
		}
		
		/**
		 * 检查文字宽度是否超过要显示的宽度 
		 * @return true: 超过 false: 不超过
		 * 
		 */		
		private function checkWidth():Boolean {
			if (tf1.textWidth > RunText.SHOW_WIDTH) {
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * 开始运行跑马灯
		 */		
		private function doRun():void {
			if (checkWidth()) {
				Ticker.tick(1, startRun, 0, true);
			}
		}
		
		/**
		 * 实现首位相接，并且当第一个完全移出后排到第二个后面
		 */		
		private function startRun():void {
			if (tf1.x < tf2.x) {
				//如果tf1在前面，tf1每次向左移动固定距离，同时移动tf2的坐标
				tf1.x -= offset;
				tf2.x = tf1.x + tf1.width + 2;
			} else {
				//如果tf2在前面，tf2每次向左移动固定距离，同时移动tf1的坐标
				tf2.x -= offset;
				tf1.x = tf2.x + tf2.width + 2;
			}
			
			if (tf1.x <= -tf1.textWidth){
				//如果tf1移出显示区域，把tf1放到tf2之后
				tf1.x = tf2.x + tf2.width + 2;
			}
			
			if (tf2.x <= -tf2.textWidth){
				//如果tf2移出显示区域，把tf2放到tf1之后
				tf2.x = tf1.x + tf1.width + 2;
			}
		}
		
		public function stopRun():void {
			Ticker.stop(startRun);
		}
	}
}