package com._17173.flash.player.module.quiz
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.quiz.data.DealerData;
	import com._17173.flash.player.module.quiz.data.QuizData;
	import com._17173.flash.player.module.quiz.data.QuizUserData;
	import com._17173.flash.player.module.quiz.ui.QuizBetPanel;
	import com._17173.flash.player.module.quiz.ui.QuizCloseQuziPanel;
	import com._17173.flash.player.module.quiz.ui.QuizMainUI;
	import com._17173.flash.player.module.quiz.ui.QuizOfficialBetPanel;
	import com._17173.flash.player.module.quiz.ui.QuizResultPanel;
	import com._17173.flash.player.module.quiz.ui.QuizStartDealerPanel;
	import com._17173.flash.player.module.quiz.ui.QuizStopDealerPanel;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

	public class QuizManager extends EventDispatcher
	{
		private var _qd:QuizDataRetriver;
		private var _ui:QuizMainUI;
		private var _e:IEventManager;
		private var _quizDataArr:Array;
		private var _startDealerPanel:QuizStartDealerPanel;
		private var _closeQuizPanel:QuizCloseQuziPanel;
		private var _closeDealerPanel:QuizStopDealerPanel;
		private var _uiM:Object;
		private var _currentSelcetData:Object;
		private var _betPanel:QuizBetPanel;
		private var _resultPanel:QuizResultPanel;
		private var _tempQuizID:String;
		private var _quizUserInfo:QuizUserData;
		private var _userID:String;
		private var _currentTime:Number;
		private var _timeOne:Number
		private var _timeTwo:Number
		private var _timeThree:Number
		private var _officialBetPanle:QuizOfficialBetPanel;
		
		public function QuizManager()
		{
			init();
			addEventListeners();
//			quizChangeFromServices(null);
//			showErrorPanel("竞猜“标题标题”已经结束", null, false, "请耐心等待开奖结果，开奖通知请注意查收站内消息。");
		}
		
		private function init():void {
			_qd = new QuizDataRetriver();
			_quizDataArr = [];
			_e = Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager;
			_uiM = Context.getContext(ContextEnum.UI_MANAGER);
		}
		
		private function addEventListeners():void {
			_e.listen(QuizEvents.QUZI_PANEL_VISIBLE_CHANGE, panelVisibelChange);
			
			_e.listen(QuizEvents.QUIZ_SHOW_START_DEALER, showStartDealer);
			_e.listen(QuizEvents.QUZI_SHOW_BET_PANEL, getDealerDetailInfo);
			_e.listen(QuizEvents.QUZI_SHOW_OFFICIAL_QUZI_PANLE, showOfficialPanel);
			
			_e.listen(QuizEvents.QUIZ_GET_QUIZ_DATA, LoadQuzi);
			_e.listen(QuizEvents.QUIZ_GET_QUIZ_DATA_COMPLETE, getQuizDataComplete);
			_e.listen(QuizEvents.QUIZ_CURRENT_SELECTE_CHANGE, currentSelectChange);
			_e.listen(QuizEvents.QUIZ_CLOSE_QUIZ, closeQuiz);
			_e.listen(QuizEvents.QUIZ_CLOSE_QUIZ_DATA, closeQuizData);
			_e.listen(QuizEvents.QUIZ_START_DEALER_DATA, startDealerData);
			_e.listen(QuizEvents.QUIZ_CLOSE_DEALER, getDealerInfoByQuizID);
			_e.listen(QuizEvents.QUIZ_BET_DATA, betData);
			_e.listen(QuizEvents.QUZI_BET_OFFICIAL, betOfficial);
			
			_e.listen(QuizEvents.QUZI_CHANGE_FROM_SERVICES, quizChangeFromServices);
		}
		
		private function panelVisibelChange(data:Object):void {
			if (_ui) {
				_ui.mouseChildren = (data as String) == "hide";
				_ui.mouseEnabled = (data as String) == "hide";
			}
		}
		
		public function get ui():QuizMainUI
		{
			return _ui;
		}
		
		public function set ui(value:QuizMainUI):void
		{
			_ui = value;
			_ui.addEventListener(QuizEvents.QUIZ_ADD_QUIZ, addQuizEvent);
		}
		
		
		/**
		 * 获取竞猜数据
		 */		
		public function LoadQuzi(data:Object):void {
			_qd.LoadQuzi(Context.variables["roomID"], false, LoadQuizInfoSucess, loadQuizInfoFail);
//			_qd.getDealerInfoByQuizID("", getDealerInfoSuccess, getDealerInfoQuizFail);
		}
		
		/**
		 * 获取竞猜数据  成功
		 */		
		private function LoadQuizInfoSucess(data:Object):void {
			_e.send(QuizEvents.QUIZ_GET_QUIZ_DATA_COMPLETE, data);
		}
		
		
		/**
		 * 获取竞猜成功  失败
		 */		
		private function loadQuizInfoFail(data:Object):void {
			showErrorPanel("加载竞猜数据操作", data);
		}
		
		/**
		 * 获取竞猜成功
		 */		
		private function getQuizDataComplete(data:Object):void {
			if (!data || (data as Array).length <= 0) {
				_e.send(QuizEvents.QUIZ_HIDE_QUIZ_UI);
				_ui.quizData = [];
			} else {
				_e.send(QuizEvents.QUIZ_SHOW_QUIZ_UI);
				_quizDataArr = [];
				_quizDataArr = data as Array;
				_ui.quizData = _quizDataArr;
			}
			startUserQuiz();
		}
		
		/**
		 * 开始计算用户竞猜相关信息
		 */		
		private function startUserQuiz():void {
			setUserJoinQuiz();
			startTimer();
		}
		
		/**
		 * 获取做过庄竞猜
		 */		
		private function setUserJoinQuiz():void {
			var tempNum:int = 0;
			if (!Context.variables["quizUser"]) {
				return;
			}
			(Context.variables["quizUser"] as QuizUserData).joinArr = [];
			getInfo(tempNum);
			
			function getInfo(value:int):void {
				var item:QuizData = _quizDataArr[value] as QuizData;
				if (item.type == 1) {
					_qd.getDealerInfoByQuizID(item.id, setUserJoninSuccess, setUserJoninFail);
				} else {
					tempNum ++;
					if (tempNum < _quizDataArr.length) {
						getInfo(tempNum);
					} else {
						_e.send(QuizEvents.QUIZ_CURRENT_SELECTE_CHANGE, _ui.currentSelectData);
					}
				}
			}
			
			function setUserJoninSuccess(data:Object):void {
				if (!data) {
					return;
				} else {
					if (data.hasOwnProperty("obj") && data["obj"] && data["obj"].hasOwnProperty("jcBankerList")) {
						var temp:Array = data["obj"]["jcBankerList"];
						if (temp && temp.length > 0) {
							(Context.variables["quizUser"] as QuizUserData).addJoin((_quizDataArr[tempNum] as QuizData).id);
						}
					}
					tempNum ++;
					if (tempNum < _quizDataArr.length) {
						getInfo(tempNum);
					} else {
						_e.send(QuizEvents.QUIZ_CURRENT_SELECTE_CHANGE, _ui.currentSelectData);
					}
				}
			}
			
			function setUserJoninFail(data:Object):void {
				_e.send(QuizEvents.QUIZ_CURRENT_SELECTE_CHANGE, _ui.currentSelectData);
			}
		}
		
		private function startTimer():void {
			Ticker.stop(startQuizOne);
			Ticker.stop(startQuizTwo);
			Ticker.stop(startQuizThree);
			_userID = Context.getContext(ContextEnum.SETTING)["userID"];
			_currentTime = getTimer();
			switch (_quizDataArr.length) {
				case 1:
					if ((_quizDataArr[0] as QuizData).userID == _userID && (_quizDataArr[0] as QuizData).state == "1") {
						_timeOne = (_quizDataArr[0] as QuizData).runTime;
						if (_timeOne <= 95) {
							Ticker.tick(10 * 60 * 1000, startQuizOne);
						} else {
							startQuizOne();
						}
					}
					break;
				case 2:
					if ((_quizDataArr[0] as QuizData).userID == _userID && (_quizDataArr[0] as QuizData).state == "1") {
						_timeOne = (_quizDataArr[0] as QuizData).runTime;
						if (_timeOne <= 95) {
							Ticker.tick(10 * 60 * 1000, startQuizOne);
						} else {
							startQuizOne();
						}
					}
					if ((_quizDataArr[1] as QuizData).userID == _userID && (_quizDataArr[1] as QuizData).state == "1") {
						_timeTwo = (_quizDataArr[1] as QuizData).runTime;
						if (_timeTwo <= 95) {
							Ticker.tick(10 * 60 * 1000, startQuizTwo);
						} else {
							startQuizTwo();
						}
					}
					break;
				case 3:
					if ((_quizDataArr[0] as QuizData).userID == _userID && (_quizDataArr[0] as QuizData).state == "1") {
						_timeOne = (_quizDataArr[0] as QuizData).runTime;
						if (_timeOne <= 95) {
							Ticker.tick(10 * 60 * 1000, startQuizOne);
						} else {
							startQuizOne();
						}
					}
					if ((_quizDataArr[1] as QuizData).userID == _userID && (_quizDataArr[1] as QuizData).state == "1") {
						_timeTwo = (_quizDataArr[1] as QuizData).runTime;
						if (_timeTwo <= 95) {
							Ticker.tick(10 * 60 * 1000, startQuizTwo);
						} else {
							startQuizTwo();
						}
					}
					if ((_quizDataArr[2] as QuizData).userID == _userID && (_quizDataArr[2] as QuizData).state == "1") {
						_timeThree = (_quizDataArr[2] as QuizData).runTime;
						if (_timeThree <= 95) {
							Ticker.tick(10 * 60 * 1000, startQuizThree);
						} else {
							startQuizThree();
						}
					}
					break;
			}
		}
		
		private function startQuizOne():void {
			Ticker.stop(startQuizOne);
			var temp:Number = _timeOne + CurrentRuntime;
			showClosePanle(temp, 0);
		}
		
		private function startQuizTwo():void {
			Ticker.stop(startQuizTwo);
			var temp:Number = _timeTwo + CurrentRuntime;
			showClosePanle(temp, 1);
		}
		
		private function startQuizThree():void {
			Ticker.stop(startQuizThree);
			var temp:Number = _timeThree + CurrentRuntime;
			showClosePanle(temp, 2);
		}
		
		/**
		 * 获取当前flash执行的分钟数
		 */		
		private function get CurrentRuntime():int {
			var re:int = getTimer() / 60 / 1000;
			return re;
		}
		
		private function showClosePanle(value:Number, num:int):void {
			if (value <= 95) {
				switch (num) {
					case 0:
						Ticker.tick(10 * 60 * 1000, startQuizOne);
						break;
					case 1:
						Ticker.tick(10 * 60 * 1000, startQuizTwo);
						break;
					case 2:
						Ticker.tick(10 * 60 * 1000, startQuizThree);
						break;
				}
			} else {
				if (value == 105) {
					showClosePanel("结束竞猜  （每次竞猜只有2小时，请在15分钟内开奖）", num);
				} else if (value == 110) {
					showClosePanel("结束竞猜  （每次竞猜只有2小时，请在10分钟内开奖）", num);
				} else if (value == 115) {
					showClosePanel("结束竞猜  （每次竞猜只有2小时，请在5分钟内开奖）", num);
				} else if (value == 119) {
					showClosePanel("结束竞猜  （每次竞猜只有2小时，请在1分钟内开奖）", num);
				}
				switch (num) {
					case 0:
						Ticker.tick(60 * 1000, startQuizOne);
						break;
					case 1:
						Ticker.tick(60 * 1000, startQuizTwo);
						break;
					case 2:
						Ticker.tick(60 * 1000, startQuizThree);
						break;
				}
			}
		}
		
		/**
		 * 当前选中竞猜改变
		 */		
		private function currentSelectChange(data:Object):void {
			_currentSelcetData = data;
		}
		
		/**
		 * 统一派发显示错误提示面板
		 * @param value
		 * @param obj
		 * 
		 */		
		private function showErrorPanel(value:String, obj:Object, userDefault:Boolean = true, context:String = ""):void {
			var temp:String = "";
			if (userDefault) {
				if (Util.validateObj(obj, "msg")) {
					temp = value + "失败:" + obj["msg"];
				} else {
					temp = value + "失败";
				}
			} else {
				temp = value;
			}
			if (context != "") {
				temp = temp + ";" + context;
			}
			_e.send(QuizEvents.QUIZ_SHOW_ERROR_PANEL, temp);
		}
		
		/**
		 * 添加竞猜
		 */		
		private function addQuizEvent(evt:Event):void {
			var temp:int = 0;
			var item:QuizData;
			for (var i:int = 0; i < _quizDataArr.length; i++) {
				item = _quizDataArr[i] as QuizData;
				if (item.type == 1) {
					temp++;
				}
			}
			if (temp < 3) {
				_e.send(QuizEvents.QUIZ_SHOW_START_QUIZ);
			} else {
				showErrorPanel("本房间竞猜已满！", null, false);
			}
		}

		/**
		 * 显示上庄面板
		 */		
		private function showStartDealer(evt:Event):void {
			if (!checkLogin()) {
				return;
			}
			//重新获取用户数据
			reGetUserInfo();
			
			if (!checkStartDealerAuth()) {
				return;
			}
			if (!_startDealerPanel) {
				_startDealerPanel = new QuizStartDealerPanel();
			}
			_startDealerPanel.setData(_currentSelcetData);
			if (_currentSelcetData) {
				_uiM.popup(_startDealerPanel, new Point(((Context.stage.stageWidth - _startDealerPanel.width) / 2), ((Context.stage.stageHeight - _startDealerPanel.height) / 2)));
			}
		}
		
		/**
		 * 根据当前用户的钱数和竞猜的投注类型判断用户是否有上庄权限
		 */		
		private function checkStartDealerAuth():Boolean {
			var re:Boolean = false;
			var obj:Object = Context.variables["userInfo"];
			var quziData:QuizUserData = Context.variables["quizUser"];
			var data:QuizData = _currentSelcetData as QuizData;
			if (data.state == "3") {
				re = false;
				showErrorPanel("竞猜已经进入结算,请等待...", null, false);
				return re;
			}
			if (quziData.openAU) {
				if (quziData.role == QuizUserData.QUIZ_ADMIN) {
					re = false;
					showErrorPanel("管理权限无法参与竞猜！", null, false);
					return re;
				}
			}
			if (data.userID == Context.getContext(ContextEnum.SETTING)["userID"]) {
				re = false;
				showErrorPanel("竞猜开启者无法参与竞猜！", null, false);
				return re;
			}
			if (!obj) {
				showErrorPanel("权限错误，无法开猜", null, false);
				re = false;
				return re;
			} else {
				switch (data.currency) {
					case 1: 
						if (int(obj["jinbi"]) < quziData.premium) {
							re = false;
							showErrorPanel("对不起，您的账户余额不足" + quziData.premium + "金币，无法开启竞猜。", null, false);
						} else {
							re = true;
						}
						break;
					case 5:
						if (int(obj["yinbi"]) < quziData.premium) {
							re = false;
							showErrorPanel("对不起，您的账户余额不足" + quziData.premium + "银币，无法开启竞猜。", null, false);
						} else {
							re = true;
						}
						break;
					case 15:
						if (int(obj["jinbi"]) < quziData.premium && int(obj["yinbi"]) < quziData.premium) {
							re = false;
							showErrorPanel("对不起，您的账户余额不足" + quziData.premium + "金币（银币），无法开启竞猜。", null, false);
						} else {
							re = true;
						}
						break;
				}
			}
			return re;
		}
		
		/**
		 * 向后端发送上庄信息
		 */		
		private function startDealerData(data:Object):void {
			_tempQuizID = data["quizID"];
			_qd.startDealer(data["quizID"], data["victor"], data["odds"], data["currency"], data["premium"], startDealerSuccess, startDealerFail);
		}
		
		private function startDealerSuccess(data:Object):void {
			showErrorPanel("恭喜，你已经成功上庄。", null, false);
			reGetUserInfo();
			startUserQuiz();
		}
		
		private function startDealerFail(data:Object):void {
			showErrorPanel("上庄操作", data);
			
			//上庄错误，重新请求竞猜的用户权限信息，因为权限信息里包含上庄的底金最小限额
			Context.getContext(ContextEnum.DATA_RETRIVER).getUserQuizState(Context.variables["liveRoomId"], onGetQuizStateSucc, onGetQuizStateFail);
		}
		
		private function onGetQuizStateSucc(data:Object):void {
			var _quizUser:QuizUserData = new QuizUserData();
			_quizUser.resolveData(data);
			Context.variables["quizUser"] = _quizUser;
		}
		
		private function onGetQuizStateFail(data:Object):void {
		}
		
		/**
		 * 关闭竞猜事件
		 */		
		private function closeQuiz(evt:Event):void {
			var data:QuizData = _currentSelcetData as QuizData;
			if (data.state == "3") {
				showErrorPanel("竞猜已经进入结算,请等待...", null, false);
			} else if (data.state == "1") {
				showClosePanel();
			}
		}
		
		/**
		 * 显示关闭竞猜面板
		 */		
		private function showClosePanel(title:String = "", num:int = -1):void {
			var tempData:Object = _currentSelcetData;
			if (num != -1) {
				tempData = _quizDataArr[num];
			}
			//最多三个竞猜，所以需要每次都是新的
			_closeQuizPanel = new QuizCloseQuziPanel();
			_closeQuizPanel.setData(tempData);
			if (title != "") {
				_closeQuizPanel.titleStr = title;
			}
			if (_currentSelcetData) {
				_uiM.popup(_closeQuizPanel);
			}
		}
		
		/**
		 * 关闭竞猜数据请求
		 */		
		private function closeQuizData(data:Object):void {
			_qd.closeQuiz(data["quizID"], data["victor"], closeQuizSuccess, closeQuizFail);
		}
		
		/**
		 * 关闭竞猜成功
		 */		
		private function closeQuizSuccess(data:Object):void {
//			showErrorPanel("关闭竞猜成功！", null, false);
		}
		
		/**
		 * 关闭竞猜失败
		 */		
		private function closeQuizFail(data:Object):void {
			showErrorPanel("关闭竞猜操作", data);
		}
		
		/**
		 * 根据竞猜id获取某人所有的庄信息
		 */		
		private function getDealerInfoByQuizID(data:Object):void {
			_qd.getDealerInfoByQuizID(_currentSelcetData["id"], getDealerInfoSuccess, getDealerInfoQuizFail);
		}
		
		/**
		 * 根据竞猜id获取某人所有的庄信息  失败
		 */		
		private function getDealerInfoQuizFail(data:Object):void {
			showErrorPanel("获取庄信息操作", data);
		}
		
		/**
		 * 根据竞猜id获取某人所有的庄信息  成功
		 */		
		private function getDealerInfoSuccess(data:Object):void {
			if (!data) {
				return;
			}
			if (!_closeDealerPanel) {
				_closeDealerPanel = new QuizStopDealerPanel();
			}
			if (data["code"] == "000000") {
				_closeDealerPanel.setData(data);
				_uiM.popup(_closeDealerPanel, new Point(((Context.stage.stageWidth - _closeDealerPanel.width) / 2), ((Context.stage.stageHeight - _closeDealerPanel.height) / 2)));
			} else {
				showErrorPanel("您的庄已经押满!", null, false);
			}
		}
		
		/**
		 * 获取当前庄的投注信息
		 */		
		private function getDealerDetailInfo(data:Object):void {
			_e.send(QuizEvents.QUIZ_CURRENT_SELECTE_CHANGE, _ui.currentSelectData);
			if (checkBetAuth((data as DealerData).userID)) {
				//重新获取用户数据
				reGetUserInfo();
				_qd.getDealerDetailInfo((data as DealerData).id, getDealerDetailSuccess, getDealerDetailFail);
			}
		}
		
		/**
		 * 验证是否可以投注
		 * @param id
		 * @return 
		 * 
		 */		
		private function checkBetAuth(id:String):Boolean {
			var re:Boolean = false;
			var userID:String = Context.getContext(ContextEnum.SETTING)["userID"];
			if (id == userID) {
				re = false;
				showErrorPanel("不能投注自己的庄!", null, false);
			} else {
				re = true;
			}
			return re;
		}
		
		private function getDealerDetailSuccess(data:Object):void {
			showBetPanel(data);
		}
		
		private function getDealerDetailFail(data:Object):void {
			showErrorPanel("获取庄详细信息操作", data);
		}
		
		/**
		 * 显示投注界面
		 */	
		private function showBetPanel(data:Object):void {
			if (!checkLogin()) {
				return;
			}
			if (!_betPanel) {
				_betPanel = new QuizBetPanel();
			}
			var temp:Object;
			if (data.hasOwnProperty("code") && data["code"] == "000000") {
				temp = data["obj"];
			}
			_betPanel.setData(temp);
			if (Util.validateObj(temp, "dealerid")) {
				_uiM.popup(_betPanel, new Point(((Context.stage.stageWidth - _betPanel.width) / 2), ((Context.stage.stageHeight - _betPanel.height) / 2)));
			}
		}
		
		private function betData(data:Object):void {
			_qd.betData(data["dealerID"], data["money"], betSuccess, betDealerFail);
		}
		
		/**
		 * 押注 数据请求 成功
		 */
		private function betSuccess(data:Object):void {
			showErrorPanel("恭喜，你已经成功投注", null, false, "请耐心等待比赛结果!!");
			reGetUserInfo();
			_e.send(QuizEvents.QUIZ_CURRENT_SELECTE_CHANGE, _ui.currentSelectData);
		}
		
		/**
		 * 押注 数据请求  失败
		 */	
		private function betDealerFail(data:Object):void {
			showErrorPanel("投注操作", data);
			_e.send(QuizEvents.QUIZ_CURRENT_SELECTE_CHANGE, _ui.currentSelectData);
		}
		
		/**
		 * 获取某竞猜的结果
		 */		
		private function getResultData(id:String):void {
			_qd.getQuizReslut(id, resultSuccess, resultFail);
//			_qd.getQuizReslut("11221", resultSuccess, resultFail);
		}
		
		private function resultSuccess(data:Object):void {
			//当code不为000000的情况下，就可以认为用户并没有参加当前结束的竞猜
			if (!data || !data.hasOwnProperty("code") || data["code"] != "000000") {
				return;
			}
			reGetUserInfo();
			_resultPanel = new QuizResultPanel();
			_resultPanel.setData(data);
			_uiM.popup(_resultPanel, new Point(((Context.stage.stageWidth - _resultPanel.width) / 2), ((Context.stage.stageHeight - _resultPanel.height) / 2)));
		}
		
		private function resultFail(data:Object):void {
//			showErrorPanel("获取竞猜结果操作", data);
		}
		
		/**
		 * 后台推送竞猜（庄）改变
		 */		
		private function quizChangeFromServices(value:String):void {
			Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:" + value);
			//推送信息例子，只有装数据改变的时候会有value参数
//			value = 'jcId:22803,jcState:4,value:{"b":{"dealerid":22009,"userId":114894941,"odds":0.9,"premium":1000,"currency":1,"betcount":0,"jcSubject":"1","state":1,"currMoney":null,"lockMoney":null,"myAnswer":"2","playerAnswer":"3","oddstr":null,"masterName":null,"createTime":null}}';
//			value = 'jcId:4116,jcState:4,value:{"jcGovConInfos":[{"id":4943,"name":"发的更广泛","jcGovId":4116,"totalMoney":2,"totalUserNum":1,"currency":5,"sortNum":1,"odds":0.0},{"id":4944,"name":"飞个","jcGovId":4116,"totalMoney":0,"totalUserNum":0,"currency":5,"sortNum":2,"odds":0.0},{"id":4945,"name":"过放电","jcGovId":4116,"totalMoney":0,"totalUserNum":0,"currency":5,"sortNum":3,"odds":0.0}]}';
			var state:String;
			_tempQuizID = (value.split(",")[0] as String).split(":")[1];
			state = (value.split(",")[1] as String).split(":")[1];
			switch (state) {
				//关闭
				case "0":
					if (hasQuzi(_tempQuizID)) {
//						resetQuizData();
						//因为可能同时关闭多个竞猜，所以不能一次执行后就关闭ticker，因此改用次方法
						setTimeout(doGetResult, getRandomTime(), _tempQuizID);
					}
					break;
				//开启
				case "1":
					if (hasQuzi(_tempQuizID)) {
//						Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:庄信息改变竞猜id：" + _tempQuizID);
						//默认庄信息改变会推送庄的数据
						try {
							var tempValue:String = (value.split("value:")[1] as String);
							if (Util.validateStr(tempValue)) {
								var obj:Object = JSON.parse(tempValue);
								if (_tempQuizID == _ui.currentSelectData["id"] && obj) {
//									Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:庄信息改变:使用推送数据");
									_e.send(QuizEvents.QUIZ_PULL_DEALER_DATA, obj);
									startUserQuiz();
								}
							} else {
//								Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:庄信息改变:使用推送数据 直接赋值为空");
								_e.send(QuizEvents.QUIZ_PULL_DEALER_DATA, null);
								startUserQuiz();
							}
						} catch (e:Error) {
//							Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:庄信息改变:没有推送数据，重新请求");
							Ticker.tick(getRandomTime(), doGetQuizInfo);
						}
					} else {
//						Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:有新竞猜");
						Ticker.tick(getRandomTime(), doGetQuizInfo);
					}
					break;
				//流局
				case "2":
					Ticker.tick(getRandomTime(), reGetQuizData);
					Ticker.tick(getRandomTime(), reGetUserInfo);
//					resetQuizData();
					break;
				//结算
				case "3":
					if (hasQuzi(_tempQuizID)) {
						_e.send(QuizEvents.QUZI_SETTLE_ACCOUNT, _tempQuizID);
						Ticker.tick(getRandomTime(), reGetQuizData);
					}
					break;
				//官方竞猜开启
				case "4": 
					if (hasQuzi(_tempQuizID)) {
//						Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:庄信息改变竞猜id：" + _tempQuizID);
						//默认庄信息改变会推送庄的数据
						try {
							var tempValue1:String = (value.split("value:")[1] as String);
							if (Util.validateStr(tempValue1)) {
								var obj1:Object = JSON.parse(tempValue1);
								if (_tempQuizID == _ui.currentSelectData["id"] && obj1) {
//									Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:庄信息改变:使用推送数据");
									_e.send(QuizEvents.QUIZ_PULL_OFFICIAL_DEALER_DATA, obj1);
									startUserQuiz();
								}
							} else {
//								Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:庄信息改变:使用推送数据 直接赋值为空");
								_e.send(QuizEvents.QUIZ_PULL_OFFICIAL_DEALER_DATA, null);
								startUserQuiz();
							}
						} catch (e:Error) {
//							Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:庄信息改变:没有推送数据，重新请求");
							Ticker.tick(getRandomTime(), doGetQuizInfo);
						}
					} else {
//						Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:有新竞猜");
						Ticker.tick(getRandomTime(), doGetQuizInfo);
					}
					break;
				//官方竞猜结算
				case "5": 
					_e.send(QuizEvents.QUZI_SETTLE_ACCOUNT, _tempQuizID);
					break;
				//官方竞猜流局
				case "6": 
//					Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:官方竞猜流局id：" + _tempQuizID);
					if (hasQuzi(_tempQuizID)) {
						//因为可能同时关闭多个竞猜，所以不能一次执行后就关闭ticker，因此改用次方法
						setTimeout(officialClose, getRandomTime(), _tempQuizID);
					}
					break;
				//官方竞猜关闭
				case "7":
//					Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:官方竞猜关闭id：" + _tempQuizID);
					if (hasQuzi(_tempQuizID)) {
						//因为可能同时关闭多个竞猜，所以不能一次执行后就关闭ticker，因此改用次方法
						setTimeout(officialClose, getRandomTime(), _tempQuizID);
					}
					break;
				//官方竞猜在开启中改名字等操作
				case "8":
//					Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:官方竞猜其它状态改变：" + _tempQuizID);
					Ticker.tick(getRandomTime(), doGetQuizInfo);
					break;
			}
		}
		
		/**
		 * 重新获取竞猜数据 
		 */		
		private function reGetQuizData():void {
			_e.send(QuizEvents.QUIZ_GET_QUIZ_DATA);
		}
		
		/**
		 * 推送后执行的获取结果方法
		 */		
		private function doGetResult(value:String):void {
			getResultData(value);
			reGetQuizData();
		}
		
		private function officialClose(value:String):void {
			var tiltle:String = "";
			for (var i:int = 0; i < _quizDataArr.length; i++) {
				if ((_quizDataArr[i] as QuizData).id == value) {
					tiltle = (_quizDataArr[i] as QuizData).title;
					break;
				}
			}
			reGetQuizData();
			checkUserJoinOfficial(value, tiltle);
		}
		
		/**
		 * 推送后执行后重新获取竞猜数据
		 */		
		private function doGetQuizInfo():void {
			Ticker.stop(doGetQuizInfo);
			reGetQuizData();
		}
		
		/**
		 * 根据当前结束的id重新赋值竞猜信息
		 */		
		private function resetQuizData():void {
			var temp:Array = new Array();
			for (var i:int = 0; i < _quizDataArr.length; i++) {
				if ((_quizDataArr[i] as QuizData).id != _tempQuizID) {
					temp.push(_quizDataArr[i]);
				}
			}
			_quizDataArr = temp;
			getQuizDataComplete(_quizDataArr);
		}
		
		
		/**
		 * 检查是否已经存在这个竞猜
		 */		
		private function hasQuzi(value:String):Boolean {
			var re:Boolean = false;
			if (!_quizDataArr || _quizDataArr.length == 0) {
				return re;
			}
			for (var i:int = 0; i < _quizDataArr.length; i++) {
				if ((_quizDataArr[i] as QuizData).id == value) {
					re = true;
					break;
				}
			}
			return re;
		}
		
		/**
		 * 获取一个1-3秒的随机数
		 */		
		private function getRandomTime():int {
			return (int(Math.random() * 3) + 1) * 1000;
		}
		
		/**
		 * 重新获取用户信息（金币、银币）
		 */		
		private function reGetUserInfo():void {
//			_e.send(PlayerEvents.BI_USER_INFO_CHANGE);
		}
		
		/**
		 * 判断是否已经登录，如果没登录就弹出提示登录窗口
		 * @return 
		 * 
		 */		
		public function checkLogin():Boolean {
			var re:Boolean = false;
			if (Context.getContext(ContextEnum.SETTING)["userLogin"]) {
				re = true;
			} else {
				Context.getContext(ContextEnum.SETTING).login();
				re = false;
			}
			return re;
		}
		
		private function showOfficialPanel(obj:Object):void {
			if (!checkLogin()) {
				return;
			}
			if (!_officialBetPanle) {
				_officialBetPanle = new QuizOfficialBetPanel();
			}
			_officialBetPanle.titleStr = (_currentSelcetData as QuizData).title;
			_officialBetPanle.currency = (_currentSelcetData as QuizData).currency;
			_officialBetPanle.odds = (_currentSelcetData as QuizData).odd;
			_officialBetPanle.minMoney = (_currentSelcetData as QuizData).minMoney;
			_officialBetPanle.maxMoney = (_currentSelcetData as QuizData).maxMoney;
			_officialBetPanle.setData(obj as Array);
			_uiM.popup(_officialBetPanle, new Point(((Context.stage.stageWidth - _officialBetPanle.width) / 2), ((Context.stage.stageHeight - _officialBetPanle.height) / 2)));
		}
		
		/**
		 * 投注官方竞猜
		 */		
		private function betOfficial(data:Object):void {
			_qd.betOfficialDealerByQuiz(data.id, Context.variables["liveRoomId"], data.money, betOfficialSuccess, betOfficialFail);
		}
		
		private function betOfficialSuccess(data:Object):void {
			_uiM.closePopup(_officialBetPanle);
			showErrorPanel("恭喜你，投注成功!", null, false, "请耐心等待比赛结果!!");
		}
		
		private function betOfficialFail(data:Object):void {
			_uiM.closePopup(_officialBetPanle);
			showErrorPanel("投注操作", data);
		}
		
		/**
		 * 验证用户是否参与官方竞猜,如果参与弹出提示结果,未参与不处理
		 * @param value
		 * @param title
		 * 
		 */		
		private function checkUserJoinOfficial(value:String, title:String):void {
			Debugger.log(Debugger.INFO, "[quiz] 验证是否参与竞猜:官方竞猜关闭id：" + _tempQuizID + "  " + title);
			_qd.checkJoinOfficialQuiz(value, 
				function back(data:Object):void{
					if (title != "") {
						showErrorPanel("竞猜“"+ title +"”已经结束", null, false, "请耐心等待开奖结果，开奖通知请注意查收站内消息。");
					}
				},
				null);
		}
		
	}
	
}