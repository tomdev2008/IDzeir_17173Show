package com._17173.flash.player.module.quiz
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.socket.ISocketManager;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.context.socket.SEnum;
	import com._17173.flash.player.module.quiz.data.QuizData;
	import com._17173.flash.player.module.quiz.ui.out.OutQuizPanel;
	import com.greensock.TweenLite;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * 站外竞猜
	 * 	包含普通竞猜和官方竞猜
	 */	
	public class QuizOut extends Sprite
	{
		
		private static const VER:String = "1.0.3";
		
		private var _outQuizPanel:OutQuizPanel = null;
		
		private var _qd:QuizDataRetriver = new QuizDataRetriver();
		
		/**
		 * 可提供给面板用的宽度 
		 */		
		private var _anchorWidth:int = 0;
		/**
		 * 可提供给面板用的高度 
		 */		
		private var _anchorHeight:int = 0;
		
		/**
		 * 当前模块是否处于激活状态 
		 */		
		private var _active:Boolean = false;
		/**
		 * 当前是否全屏 
		 */		
		private var _fs:Boolean = false;
		/**
		 * 是否只显示topbar,如果有任何点击或者全屏的行为或者5秒之后都会导致其变成false
		 */
		private var _onlyShowTopbar:Boolean = true;
		private var _onlyTopbarTimer:Timer = null;
		private var _panelTween:TweenLite = null;
		private var _perData:QuizData = null;
		private var _govData:QuizData = null;
		private var _panelMask:Sprite = null;
		
		public function QuizOut()
		{
			super();
			init();
		}
		
		/**
		 * 初始化 
		 */		
		protected function init():void {
			Debugger.log(Debugger.INFO, "[quiz]", "站外竞猜模块[版本:" + VER + "]初始化!");
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			//addEventListener();
			_active = true;
			//socket
			var service:ISocketManager = Context.getContext(ContextEnum.SOCKET_MANAGER) as ISocketManager;
			//监听服务器端发过来的竞猜状态变化数据
			service.listen(SEnum.R_QUIZ_CHANGE, onQuizChange);
			_onlyTopbarTimer = new Timer(5000,1);
			_onlyTopbarTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onOnlyTopbarTimerReach);
			
			//添加mask图层
			//panelMask
			_anchorHeight = Context.getContext(ContextEnum.UI_MANAGER)["avalibleVideoHeight"];
			_anchorWidth = Context.getContext(ContextEnum.UI_MANAGER)["avalibleVideoWidth"];
			_panelMask = new Sprite();
			_panelMask.graphics.beginGradientFill(GradientType.LINEAR, [0xff0000,0xffff00], [1,0.3], [0, 255]);
			_panelMask.graphics.drawRect(0, 0, _anchorWidth, 100);
			_panelMask.graphics.endFill();
			_panelMask.x = 0; _panelMask.y = _anchorHeight - 100;
			_panelMask.alpha = 0;
			//addChild(_panelMask);
		}
		
		private function onOnlyTopbarTimerReach(e:TimerEvent):void
		{
			//如果已经全屏之类的了 就不做修改了
			if (_onlyShowTopbar == false) return;
			_onlyTopbarTimer.stop();
			showAllPanel();
		}
		
		private function showAllPanel():void
		{
			//如果已经显示全部 就返回
			if (_onlyShowTopbar==false) return;
			_onlyShowTopbar = false;
			_panelTween = TweenLite.to(_outQuizPanel, 1, {"y": _anchorHeight - 100, "onComplete":function():void 
			{
				if (_panelMask.parent)
				{
					_panelMask.parent.removeChild(_panelMask);
				}
				_outQuizPanel.mask = null;
			}
			})
		}
				
		private function initData():void {
			Debugger.log(Debugger.INFO,"liveRoomId is" + Context.variables["liveRoomId"]);
			_qd.LoadQuzi(Context.variables["liveRoomId"], false, initUI, closeUI);
		}
		
		private function closeUI(e:Object):void {
			Debugger.log(Debugger.INFO,"closeUI once");
			_perData = null;
			_govData = null;
			if (_outQuizPanel) {
				_outQuizPanel.setQuizData(_perData, _govData);
			}
			onClose(null);
		}
		
		/**
		 * 从舞台移除 
		 * @param event
		 */		
		protected function onRemoved(event:Event):void {
			_active = false;
		}
		
		/**
		 * 添加到舞台 
		 * @param event
		 */		
		protected function onAdded(event:Event):void {
			_active = true;
			this.alpha = 0;
			TweenLite.to(this,0.3,{'alpha':1});
			initData();
		}
		
		/**
		 * 数据变化 暂时将这个作为一个timer来使用
		 *  
		 * @param data
		 */		
		private function onQuizChange(data:Object):void {
			//非激活状态下,数据抛弃,根据业务逻辑,这里可以要可以不要,甚至可以把数据缓存起来
			if (!_active) {
				return;
			}
			var obj:Object = {};
			obj["jcId"] = (data.ct.split(",")[0] as String).split(":")[1];
			obj["jcState"] = (data.ct.split(",")[1] as String).split(":")[1];
			var v:String = data.ct.split("value:")[1];
			if (v) {
				obj["value"] = JSON.parse(v);
			}
			renderUIByData(obj);
		}
		
		/**
		 * 初始化界面
		 */
		private function initUI(initObject:Array):void {
			Debugger.log(Debugger.INFO,"initUI 0 once");
			if (initObject.length == 0) {
				closeUI(null);
			} else {
				//后台返过来的竞猜状态数据,json字符串
				//var result:String = data.msg[0].ct;
	//			var initString:String  = '{"code":"000000","msg":"","obj":{"govguessinfo":[{"guessid":3,"createrid":null,"title":"官方竞猜标题1","startTime":null,"currency":5,"opentime":79798789,"state":1},{"guessid":3,"createrid":null,"title":"官方竞猜标题2","startTime":null,"currency":5,"opentime":79798789,"state":1}],	"guessinfo":[{"guessid":"竞猜ID","createrid":12345,"title":"竞猜标题","a":"左侧标题","b":"右侧标题","currency":"金币|银币[15:金币和银币，1：金币，5：银币]","opentime":"分钟","state":"竞猜状态[0:关闭，1:开启,2:流局,3:结算中]"}]}}';
	//			var result:String = initString;
	//			var initString2:String = '{"code":"000000","msg":"","obj":{"govguessinfo":[{"guessid":3,"createrid":null,"title":"官方竞猜标题1","startTime":null,"currency":5,"opentime":79798789,"state":1},{"guessid":3,"createrid":null,"title":"官方竞猜标题2","startTime":null,"currency":5,"opentime":79798789,"state":1}],"guessinfo":[{"guessid":"竞猜ID","createrid":12345,"title":"竞猜标题","a":"左侧标题","b":"右侧标题","currency":"金币|银币[15:金币和银币，1：金币，5：银币]","opentime":"分钟","state":"竞猜状态[0:关闭，1:开启,2:流局,3:结算中]"}]}}';
	//			var officialGuessString:String = '{"code":"000000","msg":"","obj":[{"id":0,"name":"条件1","jcGovId":"官方竞猜id","totalMoney":"押注总钱数","totalUserNum":"押注人数","currency":"币种"},{"id":1,"name":"条件2","jcGovId":3,"totalMoney":"199999","totalUserNum":"2342","currency":5},{"id":2,"name":"条件3","jcGovId":3,"totalMoney":"12312","totalUserNum":"34","currency":5}]}';
	//			var personalGuessString:String = '{"code":"000000|000001","msg":"失败原因（告知)","a":{"dealerid":"庄ID","userId":"庄创建者ID","odds":"比率","betcount":"投注额度","odds":"赔率","premium":"上庄底金"},"b":{"dealerid":"庄ID","userId":"庄创建者ID","odds":"比率","betcount":"投注额度","odds":"赔率","premium":"上庄底金"}}';
				//var initObject:Object =JSON.parse(initString);
				var govArray:Array = initObject.filter(
					function check(item:*, index:int, array:Array):Boolean
					{
						return item.type == 0;
					}
				);
				var perArray:Array = initObject.filter(function check(item:*, index:int, array:Array):Boolean{return item.type == 1;});
				
				var firstGovGuessItem:QuizData = null;
				var firstPerGuessItem:QuizData = null;
				
				if (govArray.length > 0)
				{
					var a:int = Math.random()*govArray.length;
					firstGovGuessItem = govArray[a] as QuizData;
				}
				if (perArray.length > 0)
				{
					var b:int = Math.random()*perArray.length;
					firstPerGuessItem = perArray[b] as QuizData;
				}
	
				if (!_outQuizPanel) {
					_outQuizPanel = new OutQuizPanel();
					_outQuizPanel.mask = _panelMask;
					addChild(_outQuizPanel);
					_onlyTopbarTimer.start();
				}
				if ( ((_perData)&&(firstPerGuessItem)&&(_perData.id == firstPerGuessItem.id))
					|| ((_govData)&&(firstGovGuessItem)&&(_govData.id == firstGovGuessItem.id)) ) 
				{
					
				}
				else
				{
					_outQuizPanel.setQuizData(firstGovGuessItem, firstPerGuessItem);
				}
				
				_outQuizPanel.addEventListener("close", onClose);
				_outQuizPanel.addEventListener(MouseEvent.CLICK, onQuizPanelClick);
				
				_perData = firstPerGuessItem;
				_govData = firstGovGuessItem;
				
				onFullscreenChange(_fs);
			}
		}
		
		/**
		 * 如果有点击事件 而且只显示topbar 就显示全部
		 */
		private function onQuizPanelClick(e:MouseEvent):void
		{
			if (_onlyShowTopbar == false) return;
			//_onlyShowTopbar = false;
			showAllPanel();
		}
		
		/**
		 * 面板关闭
		 * 当没有数据的时候 调用onClose 关闭竞猜 并让竞猜按钮消失  
		 * @param e
		 */		
		
		private function onClose(e:Object):void {
			this.alpha = 1;
			TweenLite.to(
				this,0.3,{'alpha':0,"onComplete":(e?removeQuizOut:function():void{
				dispatchEvent(new Event("close"))
			})}
			);
		}
		
		private function removeQuizOut():void
		{
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}
		/**
		 * 通过数据渲染UI
		 *  
		 * @param data
		 */		
		private function renderUIByData(data:Object):void {
			//			Debugger.log(Debugger.INFO, "[quiz] quizChangeFromServices:" + value);
			//推送信息例子，只有装数据改变的时候会有value参数
			//			value = 'jcId:22803,jcState:4,value:{"b":{"dealerid":22009,"userId":114894941,"odds":0.9,"premium":1000,"currency":1,"betcount":0,"jcSubject":"1","state":1,"currMoney":null,"lockMoney":null,"myAnswer":"2","playerAnswer":"3","oddstr":null,"masterName":null,"createTime":null}}';
			//竞猜关闭=0，竞猜开启=1，竞猜流局=2，竞猜结算中=3，官方竞猜开启=4，官方竞猜结算=5，官方竞猜流局=6，官方竞猜关闭=7
			var state:String;
			var quizId:String = data['jcId'];
			var jcState:String = data['jcState'];
			Debugger.log(Debugger.INFO,"jcState is" + jcState);
			switch (jcState) {
				//关闭
				/**
				 * 写入关闭竞猜的逻辑 -> 重新请求数据 并 显示
				 */
				case "0":
				case "2":
				case "3":
				case "5":
				case "6":
				case "7":
					initData();
					break;
				case "1":
					if (_perData) {
						_outQuizPanel.perId = quizId;
						} else {
							initData();
						}
					//initData();
					break;
				case "4":
					if (_govData) {
						_outQuizPanel.govId = quizId;
						} else {
							initData();
						}
					break;
//				break;
//				//开启
//				/**
//				 * 如果有更新数据 -> 重新请求数据 并 显示
//				 */
//				case "1":
//					break;
				default:
					initData();
					//						resetQuizData();
					//因为可能同时关闭多个竞猜，所以不能一次执行后就关闭ticker，因此改用次方法
					//setTimeout(doGetResult, getRandomTime(), _tempQuizID);
					break;
//				//流局
//				/**
//				 * 如果流局 重新请求数据并显示
//				 */
//				case "2":
//				//Ticker.tick(getRandomTime(), reGetQuizData);
//				//Ticker.tick(getRandomTime(), reGetUserInfo);
//				//					resetQuizData();
//				break;
//				//结算
//				/**
//				 * 如果结算 -> 重新请求数据并显示
//				 */
//				case "3":
//				//if (hasQuzi(_tempQuizID)) {
//				//_e.send(QuizEvents.QUZI_SETTLE_ACCOUNT, _tempQuizID);
//				//Ticker.tick(getRandomTime(), reGetQuizData);
//				//}
//				break;
//				//官方竞猜开启=4，官方竞猜结算=5，官方竞猜流局=6，官方竞猜关闭=7
//				/**
//				 * 官方竞猜开启
//				 */	
//				case "4":
//				break;
//				/**
//				 * 官方竞猜结算
//				 */
//				case "5":
//				break;
//				/**
//				 * 官方竞猜流局
//				 */
//				case "6":
//				break;
//				/**
//				 * 官方竞猜关闭
//				 */
//				case "7":
//				break;
			}
		}
		
		/**
		 * 更新全屏与否的逻辑
		 *  
		 * @param isFullscreen
		 */		
		public function onFullscreenChange(isFullscreen:Boolean):void {
			_anchorHeight = Context.getContext(ContextEnum.UI_MANAGER)["avalibleVideoHeight"];
			_anchorWidth = Context.getContext(ContextEnum.UI_MANAGER)["avalibleVideoWidth"];
			_fs = isFullscreen;
			
			//非激活状态,不更新UI
			if (!_active || !_outQuizPanel) return;
			
			updateUIPosition();
		}
		
		/**
		 * 用anchorHeight作为基础更新面板的实际位置
		 * 
		 * 面板的位置应该是
		 * 	Y:
		 * 		anchorHeight - 面板.height 
		 * 	X: 
		 * 		Context.stage.width - 面板.width
		 */		
		private function updateUIPosition():void {
			if (_fs) {
				if (_panelTween != null)
				{
					TweenLite.killTweensOf(_outQuizPanel);
				}
				_onlyShowTopbar = false;
				_outQuizPanel.mask = null;
				_outQuizPanel.x = _anchorWidth/2 - 900/2;
				_outQuizPanel.y = _anchorHeight - 240 + 8;
				_outQuizPanel.resize(_fs);
			} else {
				//初始状态定位
				if (_onlyShowTopbar)
				{
					_outQuizPanel.x = 0;
					_outQuizPanel.y = _anchorHeight - 100 + 80;
					_outQuizPanel.resize(_fs);
				}
				else
				{
					_outQuizPanel.x = 0;
					_outQuizPanel.y = _anchorHeight - 100;
					_outQuizPanel.resize(_fs);
				}
			}
		}
		
	}
}