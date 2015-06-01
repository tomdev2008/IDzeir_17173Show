package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.util.Util;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * 竞猜结果
	 */	
	public class QuizResultPanel extends QuizBasePanel
	{
		private var _line1:Sprite;
		private var _line2:HGroup;
		private var _line3:HGroup;
		private var _line4:HGroup;
		private var _line5:HGroup;
		private var _line6:HGroup;
		private var _line7:HGroup;
		private var _line8:HGroup;
		private var _btn1_1:MovieClip;
		private var _btn1_2:MovieClip;
		private var _btn1_3:MovieClip;
		private var _label1_1:Label;
		private var _label1_2:Label;
		private var _label2_1:Label;
		private var _label2_2:Label;
		private var _label3_1:Label;
		private var _label3_2:Label;
		private var _label3_3:Label;
		private var _label3_3_c:Sprite;
		private var _label4_1:Label;
		private var _label4_2:Label;
		private var _label4_3:Label;
		private var _label4_4:Label;
		private var _label4_4_c:Sprite;
		private var _label5_1:Label;
		private var _label5_2:Label;
		private var _label5_3:Label;
		private var _label6_1:Label;
		private var _label6_2:Label;
		private var _label6_3:Label;
		private var _label7_1:Label;
		private var _label7_2:Label;
		private var _label7_3:Label;
		private var _label8_1:Label;
		private var _label8_2:Label;
		private var _label8_3:Label;
		private var _sp:Sprite;
		private var _data:Object;
		
		public function QuizResultPanel()
		{
			super();
		}
		
		public function setData(value:Object):void {
			_data = value["obj"];
			initContainer();
			resolveData(value);
			resizeLine1();
			resizeThis();
		}
		
		private function resolveData(data:Object):void {
			if (data) {
				_label1_1.text = getValue("winCondition", "");//赢方
				_label1_2.text = getValue("loseCondition", "");//输方
				_label2_2.text = getValue("totalIncomGold") + "金币    " + getValue("totalIncomSilver") + "银币";//本次总收入
				_line2.update();
				_label3_2.text = getValue("openJcInComeGold") + "金币    " + getValue("openJcInComeSilver") + "银币";//开启竞猜收入
				_line3.update();
				_label4_2.text = getValue("inJoinComeGold") + "金币    " + getValue("inJoinComeSilver") + "银币";//参与竞猜收入
				_line4.update();
				_label5_2.text = getValue("GoldCoin") + "金币";//我的总资产
				_label5_3.text = getRank(getValue("jinbiRank"));
				_line5.update();
				_label6_2.text = getValue2("gold", "data");//我的胜率
				_label6_3.text = getRank(getValue2("gold", "count"));
				_line6.update();
				_label7_2.text = getValue2("golda", "golda") + "金币";//我的总盈利
				_label7_3.text = getRank(getValue2("golda", "goldanum"));
				_line7.update();
				_label8_2.text = getValue2("goldb", "goldb") + "金币";//我的总亏损
				_label8_3.text = getRank(getValue2("goldb", "goldbnum"));
				_line8.update();
			}
		}
		
		/**
		 * 获取排行榜内容
		 * @param value
		 * @return 
		 * 
		 */		
		private function getRank(value:String):String {
			var temp:int = int(value);
			if (temp > 100 || temp == 0) {
				return "未上榜";
			} else {
				return "总排名" + value + "位";
			}
		}
		
		private function getValue(str:String, flag:String = "0"):String {
			if (Util.validateObj(_data, str)) {
				return _data[str];
			} else {
				return flag;
			}
		}
		
		private function getValue2(type:String, str:String):String {
			if (Util.validateObj(_data, type)) {
				if (Util.validateObj(_data[type], str)) {
					return _data[type][str];
				} else {
					return "0";
				}
			} else {
				return "0";
			}
		}
		
		override protected function init():void {
			this.titleStr = "竞猜结果";
			_w = 468;
			_h = 318;
			super.init();
		}
		
		override protected function drawOther():void {
			initLine1();
			initLine2();
			initLine3();
			initLine4();
			initLine5();
			initLine6();
			initLine7();
			initLine8();
			
			resizeThis();
		}
		
		private function initLine1():void {
			_line1 = new Sprite();
			
			_btn1_1 = new quizSuccess();
			_line1.addChild(_btn1_1);
			
			_label1_1 = new Label({"maxW":160});
			_label1_1.width = 160;
			setLabelFormat(_label1_1);
			_label1_1.textColor = 0xffffff;
			_line1.addChild(_label1_1);
			
			_btn1_2 = new quizVS();
			_line1.addChild(_btn1_2);
			
			_label1_2 = new Label({"maxW":160});
			_label1_2.width = 160;
			setLabelFormat(_label1_2);
			_label1_2.textColor = 0xffffff;
			_line1.addChild(_label1_2);
			
			_btn1_3 = new quizFail();
			_line1.addChild(_btn1_3);
			
			_sp = new Sprite();
			_sp.graphics.clear();
			_sp.graphics.beginFill(0x888888);
			_sp.graphics.drawRect(0, 0, _w - 2, 78);
			_sp.graphics.endFill();
			_sp.addChild(_line1);
			
			_container.addChild(_sp);
		}
		
		/**
		 * 布局line1
		 */		
		private function resizeLine1():void {
			var item:DisplayObject;
			var temp:int = 0;
			for (var i:int = 0; i < _line1.numChildren; i++) {
				item = _line1.getChildAt(i);
				item.x = temp;
				item.y = (_line1.height - item.height) / 2;
				temp = item.x + item.width + 10;
			}
		}
		
		private function initLine2():void {
			_line2 = new HGroup();
			
			_label2_1 = new Label({"maxW":160});
			_label2_1.width = 160;
			_label2_1.text = "你本次总收入：";
			setLabelFormat(_label2_1);
			_line2.addChild(_label2_1);
			
			_label2_2 = new Label({"maxW":160});
			_label2_2.width = _w;
			setLabelFormat(_label2_2);
			_label2_2.textColor = 0xefa21a;
			_line2.addChild(_label2_2);
			
			_container.addChild(_line2);
		}
		
		private function initLine3():void {
			_line3 = new HGroup();
			
			_label3_1 = new Label({"maxW":160});
			_label3_1.width = 160;
			_label3_1.text = "开启竞猜收入：";
			setLabelFormat(_label3_1);
			_line3.addChild(_label3_1);
			
			_label3_2 = new Label({"maxW":_w});
			_label3_2.width = _w;
			setLabelFormat(_label3_2);
			_label3_2.textColor = 0xefa21a;
			_line3.addChild(_label3_2);
//			_label3_3_c = new Sprite();
//			_label3_3_c.buttonMode = true;
//			_label3_3_c.mouseChildren = false;
//			_label3_3_c.useHandCursor = true;
//			_label3_3 = new Label();
//			_label3_3.width = 160;
//			setLabelFormat(_label3_3);
//			_label3_3.text = "查看详情";
//			_label3_3.textColor = 0x007eff;
//			_label3_3_c.addChild(_label3_3);
//			_container.addChild(_label3_3_c);
			
			_container.addChild(_line3);
		}
		
		private function initLine4():void {
			_line4 = new HGroup();
			
			_label4_1 = new Label();
			_label4_1.width = 160;
			_label4_1.text = "参加竞猜收入：";
			setLabelFormat(_label4_1);
			_line4.addChild(_label4_1);
			
			_label4_2 = new Label({"maxW":_w});
			_label4_2.width = _w;
			setLabelFormat(_label4_2);
			_label4_2.textColor = 0xefa21a;
			_line4.addChild(_label4_2);
			
//			_label4_3 = new Label();
//			_label4_3.width = 160;
//			_label4_3.text = "(已扣除5%佣金)";
//			setLabelFormat(_label4_3);
//			_line4.addChild(_label4_3);
			
			_label4_4_c = new Sprite();
			_label4_4_c.buttonMode = true;
			_label4_4_c.mouseChildren = false;
			_label4_4_c.useHandCursor = true;
			_label4_4 = new Label({"maxW":160});
			_label4_4.width = 160;
			setLabelFormat(_label4_4);
			_label4_4.text = "查看详情";
			_label4_4.textColor = 0x007eff;
			_label4_4_c.addChild(_label4_4);
			_label4_4_c.mouseChildren = false;
			_label4_4_c.mouseEnabled = true;
			_label4_4_c.addEventListener(MouseEvent.CLICK, detealClick);
			_container.addChild(_label4_4_c);
			
			_container.addChild(_line4);
		}
		
		protected function detealClick(event:MouseEvent):void
		{
			Util.toUrl("http://v.17173.com/live/ucenter/jctj_goQuizJspAction.action");
		}
		
		private function initLine5():void {
			_line5 = new HGroup();
			
			_label5_1 = new Label({"maxW":160});
			_label5_1.width = 160;
			_label5_1.text = "我的总资产：";
			setLabelFormat(_label5_1);
			_line5.addChild(_label5_1);
			
			_label5_2 = new Label({"maxW":160});
			_label5_2.width = 160;
			setLabelFormat(_label5_2);
			_label5_2.textColor = 0xefa21a;
			_line5.addChild(_label5_2);
			
			_label5_3 = new Label({"maxW":160});
			_label5_3.width = 160;
			_label5_3.text = "总排名";
			setLabelFormat(_label5_3);
			_container.addChild(_label5_3);
			
			_container.addChild(_line5);
		}
		
		private function initLine6():void {
			_line6 = new HGroup();
			
			_label6_1 = new Label({"maxW":160});
			_label6_1.width = 160;
			_label6_1.text = "我的胜率：";
			setLabelFormat(_label6_1);
			_line6.addChild(_label6_1);
			
			_label6_2 = new Label({"maxW":160});
			_label6_2.width = 160;
			setLabelFormat(_label6_2);
			_label6_2.textColor = 0xffffff;
			_line6.addChild(_label6_2);
			
			_label6_3 = new Label({"maxW":160});
			_label6_3.width = 160;
			setLabelFormat(_label6_3);
			_label6_3.text = "总排名";
			_container.addChild(_label6_3);
			
			_container.addChild(_line6);
		}
		private function initLine7():void {
			_line7 = new HGroup();
			
			_label7_1 = new Label({"maxW":160});
			_label7_1.width = 160;
			_label7_1.text = "我的总盈利：";
			setLabelFormat(_label7_1);
			_line7.addChild(_label7_1);
			
			_label7_2 = new Label({"maxW":160});
			_label7_2.width = 160;
			setLabelFormat(_label7_2);
			_label7_2.textColor = 0xefa21a;
			_line7.addChild(_label7_2);
			
			_label7_3 = new Label({"maxW":160});
			_label7_3.width = 160;
			_label7_3.text = "总排名";
			setLabelFormat(_label7_3);
			_container.addChild(_label7_3);
			
			_container.addChild(_line7);
		}
		private function initLine8():void {
			_line8 = new HGroup();
			
			_label8_1 = new Label({"maxW":160});
			_label8_1.text = "我的总亏损：";
			_label8_1.width = 160;
			setLabelFormat(_label8_1);
			_line8.addChild(_label8_1);
			
			_label8_2 = new Label({"maxW":160});
			_label8_2.width = 160;
			setLabelFormat(_label8_2);
			_label8_2.textColor = 0xefa21a;
			_line8.addChild(_label8_2);
			
			_label8_3 = new Label({"maxW":160});
			_label8_3.width = 160;
			setLabelFormat(_label8_3);
			_label8_3.text = "总排名";
			_container.addChild(_label8_3);
			
			_container.addChild(_line8);
		}
		
		/**
		 * sprite在直接获取这种布局宽度会有问题,所以使用其他方式获取
		 */		
		private function getLineWidth():int {
			var item:DisplayObject = _line1.getChildAt(_line1.numChildren - 1);
			return item.x + item.width;
		}
		
		public function resizeThis():void {
			if (_sp) {
				_sp.x = 0;
				_sp.y = 0;
			}
			if (_line1) {
				_line1.x = ((_w - 2) - getLineWidth()) / 2;
				_line1.y = (78 - _line1.height) / 2;
			}
			if (_line2) {
				_line2.x = 10;
				_line2.y = _sp.height + 10;
			}
			if (_line3) {
				_line3.x = _line2.x;
				_line3.y = _line2.y + _line2.height;
			}
			if (_line4) {
				_line4.x = _line2.x;
				_line4.y = _line3.y + _line3.height;
			}
			if (_line5) {
				_line5.x = _line2.x;
				_line5.y = _line4.y + _line4.height + 15;
			}
			if (_line6) {
				_line6.x = _line2.x;
				_line6.y = _line5.y + _line5.height;
			}
			if (_line7) {
				_line7.x = _line2.x;
				_line7.y = _line6.y + _line5.height;
			}
			if (_line8) {
				_line8.x = _line2.x;
				_line8.y = _line7.y + _line5.height;
			}
			if (_label4_4_c) {
				_label4_4_c.x = _w - _label4_4_c.width - 10;
				_label4_4_c.y = _line4.y + (_line4.height - _label4_4_c.height) / 2;
			}
			if (_label5_3) {
				_label5_3.x = _w - _label5_3.width - 10;
				_label5_3.y = _line5.y + (_line5.height - _label5_3.height) / 2;
			}
			if (_label6_3) {
				_label6_3.x = _w - _label6_3.width - 10;
				_label6_3.y = _line6.y + (_line6.height - _label6_3.height) / 2;
			}
			if (_label7_3) {
				_label7_3.x = _w - _label7_3.width - 10;
				_label7_3.y = _line7.y + (_line7.height - _label7_3.height) / 2;
			}
			if (_label8_3) {
				_label8_3.x = _w - _label8_3.width - 10;
				_label8_3.y = _line8.y + (_line8.height - _label8_3.height) / 2;
			}
		}
	}
}