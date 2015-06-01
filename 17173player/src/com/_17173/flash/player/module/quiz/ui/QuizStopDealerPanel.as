package com._17173.flash.player.module.quiz.ui
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.components.common.HGroup;
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.components.common.VGroup;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.quiz.QuizDataRetriver;
	import com._17173.flash.player.module.quiz.QuizEvents;
	import com._17173.flash.player.module.quiz.data.DealerData;
	import com._17173.flash.player.module.quiz.ui.QuizGroup.QuizGroup;
	import com._17173.flash.player.module.quiz.ui.QuizGroup.QuizGroupItem;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * 结束庄
	 */	
	public class QuizStopDealerPanel extends QuizBasePanel
	{
		private var _line1:HGroup;
		private var _line2:HGroup;
		private var _line3:HGroup;
		private var _line4:VGroup;
		private var _line5:HGroup;
		private var _line6:HGroup;
		private var _group:QuizGroup;
		private var _label2_1:Label;
		private var _label2_2:Label;
		private var _label3_1:Label;
		private var _label3_2:Label;
		private var _label4_1:Label;
		private var _label4_2:Label;
		private var _cancel:Button;
		private var _moreLabel:Label;
		private var _dataArr:Array;
		private var _row:int;
		private var _line:int;
		private var _groupRowHeight:int = 32;
		private var _userInfo:Object;
		private var _confirmPanel:Sprite;
		private var _label5_1:Label;
		private var _label5_2:Label;
		private var _label5_3:Label;
		private var _submitBtn:Button;
		private var _cancelStopBtn:Button;
		private var _btnLine:HGroup;
		private var _stopDelaerID:String;
		private var _stopBtnFlag:Button;
		private var _qd:QuizDataRetriver;
		private var _e:IEventManager;
		private var _totalGoldCoin:Number;
		private var _totalSilverCoin:Number;
		
		public function QuizStopDealerPanel()
		{
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			super();
		}
		
		public function setData(value:Object):void {
			_dataArr = new Array();
			_totalGoldCoin = value["obj"]["totalGoldCoin"];
			_totalSilverCoin = value["obj"]["totalSilverCoin"];
			var temp:Array = value["obj"]["jcBankerList"];
			var item:DealerData;
			for (var i:int = 0; i < temp.length; i++) {
				item = new DealerData();
				item.resolveData(temp[i]);
				_dataArr.push(item);
			}
			_row = 5;
			_line = _dataArr.length;
			init();
			initContainer();
			setUserInfo();
		}
		
		override protected function init():void {
			this.titleStr = "停止下注";
			_w = 532;
			_h = 346;
			super.init();
		}
		
		override protected function addListener():void {
			super.addListener();
			_e.listen(PlayerEvents.BI_USER_INFO_GETED, setUserInfo);
			_e.listen(QuizEvents.QUZI_SHOW_STOP_DEALER_CONFIRM, showConfirm);
		}
		
		private function setUserInfo(data:Object = null):void {
			_userInfo = Context.variables["userInfo"];
			_label2_2.text = _userInfo["jinbi"] + "金币     " + _userInfo["yinbi"] + "银币";
			_label3_2.text = _totalGoldCoin + "金币     " + _totalSilverCoin + "银币";
			resizeThis();
		}
		
		override protected function drawOther():void {
			if (!_dataArr) {
				return;
			}
			if (_line && _line > 1) {
				_h = _h + (_line - 1) * _groupRowHeight;
				this.height = _h;
			}
			
			initLine1();
			initLine2();
			initLine3();
			initLine4();
			initLine5();
			initLine6();
			initConfirmPanel();
			
			resizeThis();
		}
		
		private function initLine1():void {
			_line1 = new HGroup();
			
			_group = new QuizGroup(_line, _row);
			initGroup();
			_line1.addChild(_group);
			
			_container.addChild(_line1);
		}
		
		private function initGroup():void {
			var title:QuizGroupItem = new QuizGroupItem(["底金","玩家已押注","获胜方","胜率"], _group.width);
			_group.addChild(title);
			title.y = (_groupRowHeight - title.height) / 2;
			var item:QuizGroupItem;
			for (var i:int = 0; i < _dataArr.length; i++) {
				var temp:DealerData = _dataArr[i];
				item = new QuizGroupItem([temp.premium, temp.betcount, temp.title, "1:"+temp.odds, temp.id], _group.width, true);
				_group.addChild(item);
				item.y = ((_groupRowHeight - title.height) / 2) + (_groupRowHeight * (i + 1));
			}
		}
		
		private function initLine2():void {
			_line2 = new HGroup();
			
			_label2_1 = new Label({"maxW":95});
			setLabelFormat(_label2_1);
			_label2_1.text = "您当前账户:";
			_label2_1.width = 95;
			_line2.addChild(_label2_1);
			
			_label2_2 = new Label({"maxW":500});
			_label2_2.width = 500;
			setLabelFormat(_label2_2);
			_label2_2.textColor = 0xefa21a;
			_line2.addChild(_label2_2);
			
			_container.addChild(_line2);
		}
		
		private function initLine3():void {
			_line3 = new HGroup();
			
			_label3_1 = new Label({"maxW":85});
			setLabelFormat(_label3_1);
			_label3_1.text = "锁定底金:";
			_label3_1.width = 85;
			_line3.addChild(_label3_1);
			
			_label3_2 = new Label({"maxW":_w});
			_label3_2.width = _w;
			setLabelFormat(_label3_2);
			_label3_2.textColor = 0xefa21a;
			_line3.addChild(_label3_2);
			
			_container.addChild(_line3);
		}
		
		private function initLine4():void {
			_line4 = new VGroup();
			_line4.gap = -1;
			
			_label4_1 = new Label({"maxW":450});
			setLabelFormat(_label4_1);
			_label4_1.text = "本轮竞猜尚未结束，底金将会继续锁定，直到本局结束后，将结算金额";
			_label4_1.width = 450;
			_line4.addChild(_label4_1);
			
			_label4_2 = new Label({"maxW":200});
			setLabelFormat(_label4_2);
			_label4_2.text = "（底金±竞猜结果）返还。";
			_label4_2.width = 200;
			_line4.addChild(_label4_2);
			
			_container.addChild(_line4);
		}
		
		private function initLine5():void {
			_line5 = new HGroup();
			
			_cancel = new Button();
			_cancel.setSkin(new quizCancelBtn());
			_cancel.width = 68;
			_cancel.height = 28;
			_cancel.addEventListener(MouseEvent.CLICK, cancelClick);
			_line5.addChild(_cancel);
			
			_container.addChild(_line5);
		}
		
		private function initLine6():void {
			_line6 = new HGroup();
			
			_line6.graphics.clear();
			_line6.graphics.beginFill(0x000000);
			_line6.graphics.drawRect(0, 0, _group.width - 2, _groupRowHeight);
			_line6.graphics.endFill();
			_line6.buttonMode = true;
			_line6.addEventListener(MouseEvent.MOUSE_OVER, moreOverHander);
			_line6.addEventListener(MouseEvent.MOUSE_OUT, moreOutHander);
			_line6.addEventListener(MouseEvent.CLICK, moreClickHander);
			
			_moreLabel = new Label();
			setLabelFormat(_moreLabel);
			_moreLabel.text = "更多>";
			_moreLabel.mouseEnabled = false;
			_moreLabel.textColor = 0xffffff;
			_line6.addChild(_moreLabel);
			_moreLabel.x = (_line6.width - _moreLabel.width) / 2;
			_moreLabel.y = (_line6.height - _moreLabel.height) / 2;
			
			_container.addChild(_line6);
		}
		
		private function initConfirmPanel():void {
			_confirmPanel = new Sprite();
			
			_label5_1 = new Label({"maxW":450});
			setLabelFormat(_label5_1);
			_label5_1.text = "确定停止此次竞猜？";
			_label5_1.width = 450;
			_confirmPanel.addChild(_label5_1);
			
			_label5_2 = new Label({"maxW":450});
			setLabelFormat(_label5_2);
			_label5_2.text = "停止后其它用户不能参与此次竞猜，竞猜已";
			_label5_2.width = 450;
			_confirmPanel.addChild(_label5_2);
			
			_label5_3 = new Label({"maxW":450});
			setLabelFormat(_label5_3);
			_label5_3.text = "经参与待竞猜结束后按结果返还。";
			_label5_3.width = 450;
			_confirmPanel.addChild(_label5_3);
			
			_btnLine = new HGroup();
			_btnLine.gap = 10;
			
			_submitBtn = new Button();
			_submitBtn.setSkin(new quizSubmitBtn());
			_submitBtn.width = 68;
			_submitBtn.height = 28;
			_submitBtn.addEventListener(MouseEvent.CLICK, submitClick);
			_btnLine.addChild(_submitBtn);
			
			_cancelStopBtn = new Button();
			_cancelStopBtn.setSkin(new quizCancelBtn());
			_cancelStopBtn.width = 68;
			_cancelStopBtn.height = 28;
			_cancelStopBtn.addEventListener(MouseEvent.CLICK, cancelStopClick);
			_btnLine.addChild(_cancelStopBtn);
			
			_confirmPanel.addChild(_btnLine);
			_confirmPanel.visible = false;
			_container.addChild(_confirmPanel);
		}
		
		private function moreOverHander(evt:MouseEvent):void {
			_moreLabel.textColor = 0xefa21a;
		}
		
		private function moreOutHander(evt:MouseEvent):void {
			_moreLabel.textColor = 0xffffff;
		}
		
		private function moreClickHander(evt:MouseEvent):void {
			Util.toUrl("http://v.17173.com/live/ucenter/jctj_goQuizJspAction.action?m=goQuizJsp&type=2");
		}
		
		private function cancelClick(evt:MouseEvent):void {
			onCloseClick(null);
		}
		
		private function setState(value:Boolean):void {
			if (value) {
				_line1.visible = true;
				_line2.visible = true;
				_line3.visible = true;
				_line4.visible = true;
				_line5.visible = true;
				_line6.visible = true;
				_confirmPanel.visible = false;
			} else {
				_line1.visible = false;
				_line2.visible = false;
				_line3.visible = false;
				_line4.visible = false;
				_line5.visible = false;
				_line6.visible = false;
				_confirmPanel.visible = true;
			}
		}
		
		private function showConfirm(data:Object):void {
			if (data) {
				_stopDelaerID = data["id"] as String;
				_stopBtnFlag = data["dis"] as Button;
				setState(false);
			}
		}
		
		/**
		 * 确定停止某庄
		 */		
		private function submitClick(evt:MouseEvent):void {
			if (Util.validateStr(_stopDelaerID)) {
				if (!_qd) {
					_qd = new QuizDataRetriver();
				}
				_qd.stopDealer(_stopDelaerID, stopDealerSuccess, stopDealerFail);
			}
			_stopBtnFlag.disabled = true;
			setState(true);
		}
		
		/**
		 * 停止某个庄 数据请求 成功
		 */
		private function stopDealerSuccess(data:Object):void {
//			showErrorPanel("您的竞猜已经停止，用户不可再押注。", null, false);
		}
		
		/**
		 * 停止某个庄 数据请求  失败
		 */	
		private function stopDealerFail(data:Object):void {
			if (Util.validateObj(data, "msg")) {
				_e.send(QuizEvents.QUIZ_SHOW_ERROR_PANEL, "停庄操作失败：" +　data["msg"]);
			} else {
				_e.send(QuizEvents.QUIZ_SHOW_ERROR_PANEL, "停庄操作失败");
			}
		}
		
		private function cancelStopClick(evt:MouseEvent):void {
			setState(true);
		}
		
		private function resizeThis():void {
			if (_line1) {
				_line1.x = (_w - _group.width) / 2;
				_line1.y = 20;
			}
			if (_line6) {
				_line6.x = _line1.x + 2;
				_line6.y = _line1.y + _line1.height + 2;
			}
			if (_line2) {
				_line2.x = _line1.x;
				_line2.y = _line6.y + _line6.height + 10;
			}
			if (_line3) {
				_line3.x = _line2.x + 14;
				_line3.y = _line2.y + _line2.height + 5;
			}
			if (_line4) {
				_line4.x = _line1.x;
				_line4.y = _line3.y + _line3.height + 10;
			}
			if (_line5) {
				_line5.x = (_w - 68) / 2;
				_line5.y = _line4.y + _line4.height + 15;
			}
			resizeConfirmPanel();
		}
		
		private function resizeConfirmPanel():void {
			if (_confirmPanel) {
				_confirmPanel.x = (_w - _confirmPanel.width) / 2;
				_confirmPanel.y = (_container.height - _confirmPanel.height) / 2;
			}
			if (_label5_1) {
				_label5_1.x = 0;
				_label5_1.y = 0;
			}
			if (_label5_2) {
				_label5_2.x = 0;
				_label5_2.y = _label5_1.height + 2;
			}
			if (_label5_3) {
				_label5_3.x = 0;
				_label5_3.y = _label5_2.y + _label5_2.height + 2;
			}
			if (_btnLine) {
				_btnLine.x = (_confirmPanel.width - 146) / 2;
				_btnLine.y = _label5_3.y + _label5_3.height + 50;
			}
		}
		
	}
}