package com._17173.flash.player.module.quiz
{
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.DataRetriver;
	import com._17173.flash.player.module.quiz.data.QuizData;
	
	import flash.net.URLVariables;
	
	public class QuizDataRetriver extends DataRetriver
	{
		/**
		 * 获取竞猜信息
		 */
		private static const QUIZ_GET_QUIZ_INFO:String = "http://v.17173.com/live/jc_getAllGuessInfo.action";
		/**
		 * 关闭竞猜
		 */		
		private static const QUIZ_CLOSE_QUIZ:String = "http://v.17173.com/live/jc_finishGuess.action";
		/**
		 * 上庄
		 */		
		private static const QUIZ_START_DEALER:String = "http://v.17173.com/live/jc_beDealer.action";
		/**
		 * 停止某装
		 */		
		private static const QUIZ_STOP_DEALER:String = "http://v.17173.com/live/jc_finishDealer.action";
		/**
		 * 根据竞猜id获取某人的所有庄信息
		 */		
		private static const QUIZ_GET_DEALER_BY_QUIZ:String = "http://v.17173.com/live/jc_dealerInfoUnGuess.action";
		/**
		 * 投注
		 */		
		private static const QUIZ_BET_DATA:String = "http://v.17173.com/live/jc_bet.action";
		/**
		 * 获取某个庄的详细信息
		 */		
		private static const QUZI_GET_DELAER_DETAIL_BY_ID:String = "http://v.17173.com/live/jc_dealerInfo.action";
		/**
		 * 某场竞猜的结果
		 */		
		private static const QUZI_RESULT_DATA:String = "http://v.17173.com/live/jc_accountGuess.action";
		/**
		 * 根据竞猜id获取最优庄信息
		 */		
		private static const QUIZ_GET_DEALER_BY_QUIZ_ID:String = "http://v.17173.com/live/jc_bestDealerInfos.action";
		/**
		 * 根据竞猜id获取官方竞猜具体数据
		 */		
		private static const QUIZ_GET_OFFICIAL_DEALER_BY_QUIZ_ID:String = "http://v.17173.com/live/jc_govJingCaiConInfos.action";
		/**
		 * 投注官方竞猜
		 */		
		private static const QUIZ_BET_OFFICIAL_DEALER_BY_QUIZ_ID:String = "http://v.17173.com/live/jc_govBet.action";
		/**
		 * 判断用户是否参与某官方竞猜
		 */		
		private static const QUIZ_CHECK_JOIN_OFFICIAL_QUIZ:String = "http://v.17173.com/live/jc_hasBetOnJcGov.action";
		
		public function QuizDataRetriver()
		{
			super.startUp(null);
		}
		
		/**
		 * 加载竞猜数据
		 */		
		public function LoadQuzi(roomID:String, needTrueTime:Boolean, onSuccess:Function, onFail:Function):void {
			var url:String = QUIZ_GET_QUIZ_INFO;
			//jc_getAllGuessInfo
			var v:URLVariables = new URLVariables();
			v.decode("liveroomId=" + roomID);
			//			v.decode("liveroomId=" + "1");
			v.decode("realtime=" + needTrueTime);
			v.decode("type=3");
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code") && data["code"] == "000000") {
						if (onSuccess != null) {
							onSuccess(retriverQuziInfo(data));
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		/**
		 * 解析竞猜数据
		 */	
		private function retriverQuziInfo(value:Object):Array {
			var re:Array = [];
			Debugger.log(Debugger.INFO,"json data is" + JSON.stringify(value));
			if (Util.validateObj(value, "obj")) {
				var temp:Array = [];
				if (value["obj"].hasOwnProperty("govguessinfo")){
					temp = value["obj"]["govguessinfo"];
					if (temp) {
						for (var j:int = 0; j < temp.length; j++) {
							var item:QuizData = new QuizData();
							item.resolveData(temp[j]);
							item.type = 0;
							if (item.id != "") {
								re.push(item);
							}
						}
					}
				}
				if (value["obj"].hasOwnProperty("guessinfo")) {
					temp = value["obj"]["guessinfo"];
					if (temp) {
						for (var i:int = 0; i < temp.length; i++) {
							var item1:QuizData = new QuizData();
							item1.resolveData(temp[i]);
							item1.type = 1;
							if (item1.id != "") {
								re.push(item1);
							}
						}
					}
				}
			}
			Debugger.log(Debugger.INFO,"data length is" + re.length);
			return re;
		}
		
		public function closeQuiz(quizID:String, victor:String, onSuccess:Function, onFail:Function):void {
			var url:String = QUIZ_CLOSE_QUIZ;
			var v:URLVariables = new URLVariables();
			v.decode("guessId=" + quizID);
			v.decode("victor=" + victor);
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code") && data["code"] == "000000") {
						if (onSuccess != null) {
							onSuccess(data);
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		/**
		 * 上庄
		 * @param quizID 竞猜id
		 * @param victor 胜方
		 * @param odds 比率
		 * @param currency 货币类型
		 * @param premium 底金
		 * @param onSuccess
		 * @param onFail
		 * 
		 */		
		public function startDealer(quizID:String, victor:String, odds:String, currency:String, premium:String, onSuccess:Function, onFail:Function):void {
			var url:String = QUIZ_START_DEALER;
			var v:URLVariables = new URLVariables();
			v.decode("guessId=" + quizID);
			v.decode("victor=" + victor);
			v.decode("odds=" + odds);
			v.decode("currency=" + currency);
			v.decode("premium=" + premium);
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code") && data["code"] == "000000") {
						if (onSuccess != null) {
							onSuccess(data);
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		/**
		 * 获取某人在某个竞猜下的所有庄信息
		 * @param quizID
		 * @param onSuccess
		 * @param onFail
		 * 
		 */		
		public function getDealerInfoByQuizID(quizID:String, onSuccess:Function, onFail:Function, size:int = 3):void {
			var url:String = QUIZ_GET_DEALER_BY_QUIZ;
			var v:URLVariables = new URLVariables();
			v.decode("guessId=" + quizID);
			v.decode("pageSize=" + size);
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code")) {
						if (onSuccess != null) {
							onSuccess(data);
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, validateGetDealerInfo, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		/**
		 * 判断接口正确性. 
		 * @param data
		 * @return 
		 */		
		protected function validateGetDealerInfo(data:Object):Boolean {
			if (data && data.hasOwnProperty("code")) {
				return true;
			}
			return false;
		}
		
		/**
		 * 停止当前庄
		 * @param dealerID 庄id
		 * @param onSuccess
		 * @param onFail
		 * 
		 */		
		public function stopDealer(dealerID:String, onSuccess:Function, onFail:Function):void {
			var url:String = QUIZ_STOP_DEALER;
			var v:URLVariables = new URLVariables();
			v.decode("dealerId=" + dealerID);
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code") && data["code"] == "000000") {
						if (onSuccess != null) {
							onSuccess(data);
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		/**
		 * 获取某个庄的详细信息
		 * @param dealerID
		 * @param onSuccess
		 * @param onFail
		 * 
		 */		
		public function getDealerDetailInfo(dealerID:String, onSuccess:Function, onFail:Function):void {
			var url:String = QUZI_GET_DELAER_DETAIL_BY_ID;
			var v:URLVariables = new URLVariables();
			v.decode("dealerId=" + dealerID);
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code") && data["code"] == "000000") {
						if (onSuccess != null) {
							onSuccess(data);
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		/**
		 * 投注接口
		 * @param dealerID
		 * @param money
		 * @param onSuccess
		 * @param onFail
		 * 
		 */		
		public function betData(dealerID:String, money:String, onSuccess:Function, onFail:Function):void {
			var url:String = QUIZ_BET_DATA;
			var v:URLVariables = new URLVariables();
			v.decode("dealerId=" + dealerID);
			v.decode("money=" + money);
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code") && data["code"] == "000000") {
						if (onSuccess != null) {
							onSuccess(data);
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		/**
		 * 获取某竞猜的结果
		 * @param dealerID
		 * @param money
		 * @param onSuccess
		 * @param onFail
		 * 
		 */		
		public function getQuizReslut(quizID:String, onSuccess:Function, onFail:Function):void {
			var url:String = QUZI_RESULT_DATA;
			var v:URLVariables = new URLVariables();
			v.decode("guessId=" + quizID);
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code") && data["code"] == "000000") {
						if (onSuccess != null) {
							onSuccess(data);
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		/**
		 * 根据竞猜id获取最优庄信息
		 * @param quizID
		 * @param onSuccess
		 * @param onFail
		 * 
		 */		
		public function getDealerByQuiz(quizID:String, onSuccess:Function, onFail:Function):void {
			var url:String = QUIZ_GET_DEALER_BY_QUIZ_ID;
			var v:URLVariables = new URLVariables();
			v.decode("guessId=" + quizID);
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code") && data["code"] == "000000") {
						if (onSuccess != null) {
							onSuccess(data);
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		/**
		 * 根据id获取官方竞猜的具体信息
		 * @param quizID
		 * @param onSuccess
		 * @param onFail
		 * 
		 */		
		public function getOfficialDealerByQuiz(quizID:String, onSuccess:Function, onFail:Function):void {
			var url:String = QUIZ_GET_OFFICIAL_DEALER_BY_QUIZ_ID;
			var v:URLVariables = new URLVariables();
			v.decode("guessId=" + quizID);
//			v.decode("guessId=" + "3");
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code") && data["code"] == "000000") {
						if (onSuccess != null) {
							onSuccess(data);
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		/**
		 * 根据id获取官方竞猜的具体信息
		 * @param quizID
		 * @param onSuccess
		 * @param onFail
		 * 
		 */		
		public function betOfficialDealerByQuiz(quizID:String, roomID:String, money:Number, onSuccess:Function, onFail:Function):void {
			var url:String = QUIZ_BET_OFFICIAL_DEALER_BY_QUIZ_ID;
			var v:URLVariables = new URLVariables();
			v.decode("govJcConId=" + quizID);
			v.decode("liveroomId=" + roomID);
			v.decode("money=" + money);
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code") && data["code"] == "000000") {
						if (onSuccess != null) {
							onSuccess(data);
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
		public function checkJoinOfficialQuiz(quizID:String, onSuccess:Function, onFail:Function):void {
			var url:String = QUIZ_CHECK_JOIN_OFFICIAL_QUIZ;
			var v:URLVariables = new URLVariables();
			v.decode("guessId=" + quizID);
			packupLoader(url, 
				function (data:Object):void {
					if (data.hasOwnProperty("code") && data["code"] == "000000") {
						if (onSuccess != null) {
							onSuccess(data);
						}
					} else {
						if (onFail != null) {
							onFail(data);
						}
					}
				}, LoaderProxyOption.FORMAT_JSON, v, null, null, 
				function(data:Object):void {
					if (onFail != null) {
						onFail(data);
					}
				});
		}
		
	}
}