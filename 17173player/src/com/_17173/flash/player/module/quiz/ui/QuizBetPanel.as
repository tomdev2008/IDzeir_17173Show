package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.quiz.QuizEvents;
	import com._17173.flash.player.module.quiz.data.DealerData;
	import com._17173.flash.player.module.quiz.ui.QuizGroup.QuizGroup;
	import com._17173.flash.player.module.quiz.ui.QuizGroup.QuizGroupItem;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class QuizBetPanel extends QuizBasePanel
	{
		private var _line1:HGroup;
		private var _line2:HGroup;
		private var _line3:HGroup;
		private var _line4:HGroup;
		private var _line5:VGroup;
		private var _line6:HGroup;
		private var _group:QuizGroup;
		private var _label2_1:Label;
		private var _label2_2:Label;
		private var _label3_1:Label;
		private var _label3_2:Label;
		private var _label4_1:Label;
		private var _label4_2:Label;
		private var _label5_1:Label;
		private var _label5_2:Label;
		private var _submit:Button;
		private var _cancel:Button;
		private var _groupRowHeight:int = 32;
		private var _data:DealerData;
		private var _userInfo:Object;
		
		public function QuizBetPanel()
		{
			super();
		}
		
		override protected function init():void {
			this.titleStr = "我要竞猜";
			_w = 432;
			_h = 386;
			super.init();
		}
		
		override protected function addListener():void {
			super.addListener();
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).listen(PlayerEvents.BI_USER_INFO_GETED, setUserInfo);
		}
		
		private function setUserInfo(data:Object = null):void {
			_userInfo = Context.variables["userInfo"];
			if (_data.currency == "1") {
				_label2_2.text = _userInfo["jinbi"] + "金币";
			} else  {
				_label2_2.text = _userInfo["yinbi"] + "银币";
			}
			_line5.update();
			resizeThis();
		}
		
		public function setData(value:Object):void {
			_data = new DealerData();
			_data.resolveData(value);
			initContainer();
			_label3_2.text = int((_data.premium / Number(_data.odds) - _data.betcount)).toString();
			setUserInfo();
		}
		
		override protected function drawOther():void {
			if (!_data) {
				return;
			}
			initLine1();
			initLine2();
			initLine3();
			initLine4();
			initLine5();
			initLine6();
			
			resizeThis();
		}
		
		private function initLine1():void {
			_line1 = new HGroup();
			
			_group = new QuizGroup(1, 4, 412);
			initGroup();
			_line1.addChild(_group);
			
			_container.addChild(_line1);
		}
		
		private function initGroup():void {
			var title:QuizGroupItem = new QuizGroupItem(["最多投入","已投入","获胜方","赔率"], _group.width);
			_group.addChild(title);
			title.y = (_groupRowHeight - title.height) / 2;
			//最多可投入
			var betNum:int = _data.premium / Number(_data.odds);
			var item:QuizGroupItem = new QuizGroupItem([betNum,_data.betcount,_data.title, "1:" + _data.odds], _group.width);
			_group.addChild(item);
			item.y = ((_groupRowHeight - title.height) / 2) + _groupRowHeight;
		}
		
		private function initLine2():void {
			_line2 = new HGroup();
			
			_label2_1 = new Label();
			setLabelFormat(_label2_1);
			_label2_1.text = "您当前账户:";
			_label2_1.width = 95;
			_line2.addChild(_label2_1);
			
			_label2_2 = new Label();
			setLabelFormat(_label2_2);
			_label2_2.width = _w;
			_label2_2.textColor = 0xefa21a;
			_line2.addChild(_label2_2);
			
			_container.addChild(_line2);
		}
		
		private function initLine3():void {
			_line3 = new HGroup();
			
			_label3_1 = new Label({"maxW":125});
			setLabelFormat(_label3_1);
			_label3_1.text = "本庄最多剩余:";
			_label3_1.width = 125;
			_line3.addChild(_label3_1);
			
			_label3_2 = new Label();
			setLabelFormat(_label3_2);
			_label3_2.width = 180;
			_label3_2.textColor = 0xefa21a;
			_line3.addChild(_label3_2);
			
			_container.addChild(_line3);
		}
		
		private function initLine4():void {
			_line4 = new HGroup();
			
			_label4_1 = new Label();
			setLabelFormat(_label4_1);
			_label4_1.text = "我要投入:";
			_label4_1.width = 95;
			_line4.addChild(_label4_1);
			
			_label4_2 = new Label();
			setLabelFormat(_label4_2, true);
			_label4_2.restrict = "0-9";
			_label4_2.width = 120;
			_label4_2.height = 30;
			_label4_2.addEventListener(Event.CHANGE, betChangeHandler);
			var lb:QuizTextBG = new QuizTextBG(120, 30);
			lb.addItem(_label4_2);
			_line4.addChild(lb);
			
			_container.addChild(_line4);
		}
		
		
		private function initLine5():void {
			_line5 = new VGroup();
			_line5.gap = -1;
			
			_label5_1 = new Label({"maxW":450});
			setLabelFormat(_label5_1);
			_label5_1.text = '比率1:2，投入5000，如果"获胜方"获胜，则盈利,9700';
			_label5_1.width = 450;
			_line5.addChild(_label5_1);
			
			_label5_2 = new Label({"maxW":400});
			setLabelFormat(_label5_2);
			_label5_2.text = '如果"获胜方"失败，则损失5000';
			_label5_2.width = 400;
			_line5.addChild(_label5_2);
			
			_container.addChild(_line5);
		}
		
		private function initLine6():void {
			_line6 = new HGroup();
			_line6.valign = HGroup.MIDDLE;
			
			_submit = new Button();
			_submit.setSkin(new quizSubmitBtn());
			_submit.width = 68;
			_submit.height = 28;
			_submit.addEventListener(MouseEvent.CLICK, submitClick);
			_submit.disabled = true;
			_line6.addChild(_submit);
			
			_cancel = new Button();
			_cancel.setSkin(new quizCancelBtn());
			_cancel.width = 68;
			_cancel.height = 28;
			_cancel.addEventListener(MouseEvent.CLICK, cancelClick);
			_line6.addChild(_cancel);
			
			_container.addChild(_line6);
		}
		
		private function cancelClick(evt:MouseEvent):void {
			onCloseClick(null);
		}
		
		private function submitClick(evt:MouseEvent):void {
			var obj:Object = {
				"dealerID":_data.id,
				"money":_label4_2.text
			};
			(Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager).send(QuizEvents.QUIZ_BET_DATA, obj);
			onCloseClick(null);
		}
		
		private function betChangeHandler(evt:Event):void {
			if (_label4_2.text.length > 0 && ( Number(_label4_2.text) <= Number(_label3_2.text) ) && ( Number(_label4_2.text) <= Number(_label2_2.text.slice(0, _label2_2.text.length - 2)) )) {
				_submit.disabled = false;
			} else {
				_submit.disabled = true;
			}
		}
		
		private function resizeThis():void {
			if (_line1) {
				_line1.x = (_w - _group.width) / 2;
				_line1.y = 20;
			}
			if (_line2) {
				_line2.x = _line1.x + 20;
				_line2.y = _line1.y + _line1.height + 15;
			}
			if (_line3) {
				_line3.x = _line1.x + 7;
				_line3.y = _line2.y + _line2.height + 15;
			}
			if (_line4) {
				_line4.x = _line1.x + 35;
				_line4.y = _line3.y + _line3.height + 15;
			}
			if (_line5) {
				_line5.x = _line4.x + 20;
				_line5.y = _line4.y + _line4.height + 15;
			}
			if (_line6) {
				_line6.x = (_w - 150) / 2;
				_line6.y = _line5.y + _line5.height + 30;
			}
		}
		
	}
	
	
}