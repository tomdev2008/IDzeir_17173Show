package com._17173.flash.show.base.module.video.push
{
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.context.Context;
	import flash.utils.Timer;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.display.Sprite;
	
	
	/**
	 * 右上角Panel 
	 * @author qiuyue
	 * 
	 */	
	public class RightTopPanel extends Sprite
	{
		/**
		 * 背景 
		 */		
		private var _waitPushIcon:WaitPushIcon = null;
		/**
		 * 文本显示
		 */		
		private var _textField:TextField = null;
		/**
		 * 开始直播的时间
		 */		
		private var _timeNumber:Number = 0;
		/**
		 * 计时器 
		 */		
		private var _timer:Timer = null;
		public function RightTopPanel()
		{
			super();
			_waitPushIcon = new WaitPushIcon();
			this.addChild(_waitPushIcon);
			_textField = new TextField();
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xFFFFFF;
			textFormat.size = 12;
			_textField.defaultTextFormat = textFormat;
			this.addChild(_textField);
			_textField.x =18;
			_textField.y = 0;
			_textField.width = 52;
			_textField.height = 18;
			_textField.selectable = false;
			_textField.mouseEnabled = false;
			_textField.text = Context.getContext(CEnum.LOCALE).get("waitUpMic", "camModule");
		}
		/**
		 * 更新时间显示 
		 * @param e
		 * 
		 */		
		private function updateTimer():void
		{
			_timeNumber += 1000;
			_textField.text = Util.timerFormat(_timeNumber);
		}
		/**
		 * 显示等待状态 
		 * 
		 */		
		public function showWaitPushName():void
		{
			_textField.text = Context.getContext(CEnum.LOCALE).get("waitUpMic", "camModule");
		}
		
		public function showMicUp():void{
			_textField.text = Context.getContext(CEnum.LOCALE).get("qualityInfoText", "camModule");
		}
		/**
		 * 开始计算推流时间 
		 * 
		 */		
		public function startPush():void{
			_timeNumber = 0;
			Ticker.tick(1000,updateTimer,-1);
		}
		
		public function stop():void{
			Ticker.stop(updateTimer);
			_textField.text = "";
		}
	}
}