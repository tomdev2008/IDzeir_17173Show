package com._17173.flash.player.ui.stream.rec
{
	import com._17173.flash.core.util.Util;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class StreamOrgnizeRecommand extends BaseGridStreamRecommand
	{
		
		private static const TIP_BACK:String = "节目已结束！请关注下次开播！";
		private static const TIP_FORE:String = "节目尚未开始！请关注下次开播！";
		
		private var _container:Sprite = null;
		private var _nextLive:Sprite = null;
		private var _nextLiveBG:DisplayObject = null;
		
		private var _nextLiveRoomNameTF:TextField = null;
		private var _nextLiveMasterTF:TextField = null;
		private var _nextLiveTimeTF:TextField = null;
		private var _nextLiveTitleTF:TextField = null;
		private var _createdNextLiveView:Boolean = false;
		
		public function StreamOrgnizeRecommand()
		{
			super();
			
			_container = new Sprite();
			addChild(_container);
			
			_grid.rendererClass = StreamOrgnizeRecItem;
			_grid.maxColumn = 2;
			_grid.maxRow = 1;
			_grid.horizontalGap = 73;
			_grid.verticalGap = 73;
			_grid.itemWidth = 200;
			_grid.itemHeight = 110;
			
			_nextLive = new Sprite();
			_nextLive.visible = false;
			_nextLiveBG = new mc_orgRecBG();
			_nextLive.addChild(_nextLiveBG);
			
			var fmt:TextFormat = new TextFormat(Util.getDefaultFontNotSysFont(), 24, 0xCCCCCC);
			var tf:TextField = new TextField();
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.defaultTextFormat = fmt;
			tf.text = "推荐栏目";
			
			fmt = new TextFormat(Util.getDefaultFontNotSysFont(), 22, 0xFDCD00);
			fmt.align = TextFormatAlign.LEFT;
			_tf.defaultTextFormat = fmt;
			_container.addChild(_tf);
			if (_nextLive) {
				_container.addChild(_nextLive);
			}
			_container.addChild(tf);
			_container.addChild(_grid);
		}
		
		override protected function get foreText():String {
			return TIP_FORE;
		}
		
		override protected function get backText():String {
			return TIP_BACK;
		}
		
		override protected function onRecIncome(data:Object):void {
			var obj:Object = data.obj;
			if (obj.hasOwnProperty("program") && obj.program && obj.program.hasOwnProperty("masterName")) {
				updateNextLive(obj.program);
			} else {
				updateNextLive(null);
			}
			if (obj.hasOwnProperty("live") && obj.live) {
				onRecResult(obj.live);
			}
		}
		
		private function updateNextLive(data:Object):void {
			if (_nextLive) {
				if (data) {
					_nextLive.visible = true;
					
					updateNextLiveView();
					
					_nextLiveRoomNameTF.text = data.roomName;
					_nextLiveMasterTF.text = "主播: " + data.masterName;
					var d:Date = new Date();
					d.time = data.time * 1000;
					_nextLiveTimeTF.text = 
						Util.fillStr(String(d.month + 1), "0", 2) + "月"
						+ Util.fillStr(String(d.date), "0", 2) + "日"
						+ "\n"
						+ " " + Util.fillStr(String(d.hours), "0", 2)
						+ ":" + Util.fillStr(String(d.minutes), "0", 2);
					_nextLiveTitleTF.text = data.title;
				} else {
					_nextLive.visible = false;
				}
			}
		}
		
		private function updateNextLiveView():void {
			if (_nextLiveRoomNameTF == null) {
				_nextLiveRoomNameTF = packUpText();
				_nextLive.addChild(_nextLiveRoomNameTF);
			}
			if (_nextLiveMasterTF == null) {
				_nextLiveMasterTF = packUpText();
				_nextLive.addChild(_nextLiveMasterTF);
			}
			if (_nextLiveTimeTF == null) {
				_nextLiveTimeTF = packUpText();
				_nextLiveTimeTF.autoSize = TextFieldAutoSize.CENTER;
				_nextLiveTimeTF.multiline = true;
				_nextLive.addChild(_nextLiveTimeTF);
			}
			if (_nextLiveTitleTF == null) {
				_nextLiveTitleTF = packUpText();
				_nextLiveTitleTF.width = 130;
				_nextLiveTitleTF.multiline = true;
				_nextLiveTitleTF.wordWrap = true;
				_nextLive.addChild(_nextLiveTitleTF);
			}
			_createdNextLiveView = true;
			
			resizeNextLiveView();
		}
		
		private function packUpText():TextField {
			var fmt:TextFormat = new TextFormat(Util.getDefaultFontNotSysFont(), 14, 0xFFFFFF);
			var t:TextField = new TextField();
			t.selectable = false;
			t.mouseEnabled = false;
			t.autoSize = TextFieldAutoSize.LEFT;
			t.defaultTextFormat = fmt;
			return t;
		}
		
		override public function resize():void {
			_grid.resize(_container.width, avalibleHeight);
			_tf.width = _container.width;
			_tf.x = 0;
			_grid.x = 0;
			
			if (_nextLive) {
				_container.setChildIndex(_nextLive, 1);
			}
			
			var tmpH:Number = 0;
			for (var i:int = 0; i < _container.numChildren; i ++) {
				var child:DisplayObject = _container.getChildAt(i);
				child.y = tmpH + 12;
				tmpH = child.height + child.y;
			}
			
			resizeNextLiveView();
			
			_container.x = (avalibleWidth - _container.width) / 2;
			_container.y = (avalibleHeight - _container.height) / 2;
		}
		
		private function resizeNextLiveView():void {
			if (_createdNextLiveView == false) return;
			if (_nextLive == null) return;
			
			_nextLiveRoomNameTF.x = 15;
			_nextLiveMasterTF.x = 15;
			_nextLiveTitleTF.x = (_nextLiveBG.width - _nextLiveTitleTF.width - 15);
			_nextLiveTimeTF.x = _nextLiveTitleTF.x - 15 - _nextLiveTimeTF.width;
			
			_nextLiveRoomNameTF.y = 2;
			_nextLiveTimeTF.y = (_nextLiveBG.height - _nextLiveTimeTF.height) / 2;
			_nextLiveTitleTF.y = (_nextLiveBG.height - _nextLiveTitleTF.height) / 2;
			_nextLiveMasterTF.y = _nextLiveRoomNameTF.y + _nextLiveRoomNameTF.textHeight + 10;
		}
		
	}
}