package com._17173.flash.player.module.quiz.ui.QuizControlBar
{
	import com._17173.flash.core.components.common.Label;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.module.quiz.QuizDataRetriver;
	import com._17173.flash.player.module.quiz.QuizEvents;
	import com._17173.flash.player.module.quiz.data.DealerData;
	import com._17173.flash.player.module.quiz.data.QuizData;
	import com._17173.flash.player.module.quiz.ui.QuizMainUI;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class QuizUIBottomBar extends Sprite
	{
		private var _leftItem:QuizUIBottomBarLeftItem;
		private var _rightItem:QuizUIBottomBarRightItem;
		private var _vs:MovieClip;
		private var _con:Sprite;
		private var _data:QuizData;
		private var _qd:QuizDataRetriver;
		private var _label:Label;
		private var _tf:TextFormat;
		private var _e:IEventManager;
		//结算状态
		private var _isSettle:Boolean;
		private var _w:Number;
		private var _leftTitle:String;
		private var _rightTitle:String;
		private var _quizOfficial:QuizUIOfficialBottom;
		private var _officialData:Array;
		
		public function QuizUIBottomBar()
		{
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			_w = Context.stage.stageWidth;
			super();
			init();
			addListen();
			resize();
		}
		
		private function init():void {
			_qd = new QuizDataRetriver();
			
			initMainUI();
			initLable();
		}
		
		private function addListen():void {
			_e.listen(QuizEvents.QUIZ_CURRENT_SELECTE_CHANGE, getDealer);
			_e.listen(QuizEvents.QUZI_SETTLE_ACCOUNT, quizSettle);
			_e.listen(QuizEvents.QUIZ_PULL_DEALER_DATA, dealerStateChange);
			_e.listen(QuizEvents.QUIZ_PULL_OFFICIAL_DEALER_DATA, dealerOfficialStateChange);
			_e.listen(PlayerEvents.UI_RESIZE, resize);
		}
		
		private function initMainUI():void {
			_con = new Sprite();
			addChild(_con);
			
			_leftItem = new QuizUIBottomBarLeftItem();
			_con.addChild(_leftItem);
			
			_rightItem = new QuizUIBottomBarRightItem();
			_con.addChild(_rightItem);
			
			_vs = new quizVS2();
			_con.addChild(_vs);
			_con.visible = false;
			
			_quizOfficial = new QuizUIOfficialBottom();
			addChild(_quizOfficial);
			_quizOfficial.visible = false;
		}
		
		private function initLable():void {
			_tf = new TextFormat();
			_tf.size = 20;
			_tf.color = 0x888888;
			_tf.font = Util.getDefaultFontNotSysFont();
			
			_label = new Label({"maxW":400});
			_label.text = "竞猜内容正在努力向您跑来，请稍候...";
			_label.width = 400;
			
			_label.selectable = false;
			_label.autoSize = TextFieldAutoSize.LEFT;
			_label.defaultTextFormat = _tf;
			_label.setTextFormat(_tf);
			addChild(_label);
		}
		
		/**
		 * 获取当前竞猜的最优庄
		 */		
		public function getDealer(value:Object):void {
			try {
				if (!value || (_data && value.hasOwnProperty("id") && _data.id == String(value["id"]))) {
//					Debugger.log(Debugger.INFO, "[quiz] 不重新获取数据");
					return;
				}
//				Debugger.log(Debugger.INFO, "[quiz] 重新获取数据");
				doGetDealer(value);
				
			} catch(e:Error) {
				
			}
		}
		
		private function doGetDealer(value:Object):void {
			_data = value as QuizData;
			_isSettle = _data.state == "3";
			if (!_isSettle) {
				if (_data.type == 0) {
					_qd.getOfficialDealerByQuiz(_data.id, getOfficialDealerSuccess, getDealerFail);
				} else {
					_leftTitle = _data.leftTitle;
					_rightTitle = _data.rightTitle;
					_qd.getDealerByQuiz(_data.id, getDealerSuccess, getDealerFail);
				}
			} else {
				_label.visible = true;
				_con.visible = false;
				_quizOfficial.visible = false;
				quizSettle(_data.id);
			}
		}
		
		/**
		 * 当前为结算状态，显示结算提示
		 */		
		private function quizSettle(data:Object):void {
//			Debugger.log(Debugger.INFO, "[quiz] uiBottomBar:执行结算");
			if (_data.id == (data as String)) {
				_isSettle = true;
				
				_label.visible = true;
				_label.text = "竞猜正在结算中,请稍等...";
				_con.visible = false;
				resizeLabel(_w);
			}
		}
		
		/**
		 * 庄状态改变
		 */		
		private function dealerStateChange(data:Object):void {
			if (!data) {
//				Debugger.log(Debugger.INFO, "[quiz] uiBottomBar:传递过来无数据");
				doGetDealer(_data);
			} else {
//				Debugger.log(Debugger.INFO, "[quiz] uiBottomBar:使用传递过来的数据");
				if (!data) {
//					Debugger.log(Debugger.INFO, "[quiz] uiBottomBar:传递过来的数据wei kong");
					_leftItem.setData(_leftTitle, _data.currency.toString());
					_rightItem.setData(_rightTitle, _data.currency.toString());
				} else {
					if (data.hasOwnProperty("a")) {
//						Debugger.log(Debugger.INFO, "[quiz] uiBottomBar" + data["a"]);
						_leftItem.setData(data["a"]);
					} else {
//						Debugger.log(Debugger.INFO, "[quiz] uiBottomBar a:erro");
						if (data.hasOwnProperty("af") && data["af"]) {
							_leftItem.setData(data["af"]);
							_leftItem.setDealerFull();
						} else {
							_leftItem.setData(_leftTitle, _data.currency.toString());
						}
					}
					if (data.hasOwnProperty("b")) {
//						Debugger.log(Debugger.INFO, "[quiz] uiBottomBar" + data["b"]);
						_rightItem.setData(data["b"]);
					} else {
//						Debugger.log(Debugger.INFO, "[quiz] uiBottomBar b:erro");
						if (data.hasOwnProperty("bf") && data["bf"]) {
							_rightItem.setData(data["bf"]);
							_rightItem.setDealerFull();
						} else {
							_rightItem.setData(_rightTitle, _data.currency.toString());
						}
					}
				}
			}
		}
		
		/**
		 * 直接推送官方竞猜数据
		 */		
		private function dealerOfficialStateChange(data:Object):void {
			if (!data) {
//				Debugger.log(Debugger.INFO, "[quiz] uiBottomBar:官方竞猜传递过来无数据");
				doGetDealer(_data);
			} else {
//				Debugger.log(Debugger.INFO, "[quiz] uiBottomBar:官方竞猜使用传递过来的数据");
				if (!data) {
//					Debugger.log(Debugger.INFO, "[quiz] uiBottomBar:官方竞猜传递过来的数据wei kong");
				} else {
					if (data.hasOwnProperty("jcGovConInfos") && data["jcGovConInfos"]) {
//						Debugger.log(Debugger.INFO, "[quiz] uiBottomBar:官方竞猜传递过来的数据有正确的竞猜数据");
						var tempArr:Array = data["jcGovConInfos"] as Array;
						setOfficialData(tempArr);
					} else {
//						Debugger.log(Debugger.INFO, "[quiz] uiBottomBar:官方竞猜传递过来的数据吴正确的竞猜数据，重新请求");
						doGetDealer(_data);
					}
				}
			}
		}
		
		private function getOfficialDealerSuccess(data:Object):void {
			if (!data) {
				
			} else {
				if (data.hasOwnProperty("obj")) {
					var tempArr:Array = data["obj"] as Array;
					setOfficialData(tempArr);
				}
			}
		}
		
		/**
		 * 给官方竞猜赋值
		 */		
		private function setOfficialData(value:Array):void {
			_officialData = [];
			for (var i:int = 0; i < value.length; i++) {
				var item:DealerData = new DealerData();
				item.resolveData(value[i]);
				_officialData.push(item);
			}
			_quizOfficial.odd = (_data as QuizData).odd;
			_quizOfficial.setData(_officialData);
			_label.visible = false;
			_con.visible = false;
			_quizOfficial.visible = true;
			resize();
		}
		
		private function getDealerSuccess(data:Object):void {
			if (!data) {
				_leftItem.setData(_leftTitle, _data.currency.toString());
				_rightItem.setData(_rightTitle, _data.currency.toString());
			} else {
				if (data["code"] == "000000") {
					if (data.hasOwnProperty("obj") && data["obj"].hasOwnProperty("a")) {
						_leftItem.setData(data["obj"]["a"]);
					} else {
						if (data.hasOwnProperty("obj") && data["obj"].hasOwnProperty("af") && data["obj"]["af"]) {
							_leftItem.setData(data["obj"]["af"]);
							_leftItem.setDealerFull();
						} else {
							_leftItem.setData(_leftTitle, _data.currency.toString());
						}
					}
					if (data.hasOwnProperty("obj") && data["obj"].hasOwnProperty("b")) {
						_rightItem.setData(data["obj"]["b"]);
					} else {
						if (data.hasOwnProperty("obj") && data["obj"].hasOwnProperty("bf") && data["obj"]["bf"]) {
							_rightItem.setData(data["obj"]["bf"]);
							_rightItem.setDealerFull();
						} else {
							_rightItem.setData(_rightTitle, _data.currency.toString());
						}
					}
				} else {
					quizSettle(_data.id);
					return;
				}
			}
			_label.visible = false;
			_con.visible = true;
			_quizOfficial.visible = false;
			
			resize();
		}
		
		private function getDealerFail(data:Object):void {
			if (data && data.hasOwnProperty("code") && data["code"] == "000012") {
				getDealerSuccess(null);
			} else {
				_label.text = "竞猜内容正在努力向您跑来，请稍候...";
				_label.visible = true;
				_con.visible = false;
				_quizOfficial.visible = false;
			}
		}
		
		private function drawBG(w:Number, isFull:Boolean = false):void {
			this.graphics.clear();
			if (isFull) {
				this.graphics.beginFill(0x303030, 0.8);
			} else {
				this.graphics.beginFill(0x303030);
			}
			this.graphics.drawRect(0, 0, w, QuizMainUI.BOTTOM_BAR_HEIGHT);
			this.graphics.endFill();
		}
		
		private function resizeMainUI(w:Number):void {
			if (_leftItem) {
				_leftItem.x = 0;
				_leftItem.y = 0;
			}
			
			if (_vs) {
				_vs.x = _leftItem.width;
				_vs.y = 15;
			}
			
			if (_rightItem) {
				_rightItem.x = _vs.x + _vs.width;
				_rightItem.y = 0;
			}
			
			_con.x = (w - _con.width) / 2;
			_con.y = (QuizMainUI.BOTTOM_BAR_HEIGHT - _con.height) / 2 - 5;
			
			if (_quizOfficial && _quizOfficial.visible) {
//				var tempX:int = (_w - _quizOfficial.width) / 2;
//				if (tempX > 10) {
//					_quizOfficial.x = tempX;
//				} else {
//					_quizOfficial.x = 10;
//				}
				_quizOfficial.x = 0;
				_quizOfficial.y = (QuizMainUI.BOTTOM_BAR_HEIGHT - int(_quizOfficial.height)) / 2;
			}
		}
		
		private function resizeLabel(w:Number):void {
			if (_label) {
				_label.x = (w - _label.width) / 2;
				_label.y = (QuizMainUI.BOTTOM_BAR_HEIGHT - _label.height) / 2;
			}
		}
		
		public function resize(evt:Event = null):void {
			var isFull:Boolean = Context.getContext(ContextEnum.SETTING)["isFullScreen"];
			if (isFull) {
				_w = 760;
			} else {
				_w = Context.stage.stageWidth;
			}
			drawBG(_w , isFull);
			resizeMainUI(_w);
			resizeLabel(_w);
		}
	}
}