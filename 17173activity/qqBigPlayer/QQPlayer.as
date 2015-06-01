package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.MovieClip;
	
	/**
	 * 与js的交互有3个接口
	 * 1、告知js用户点击了抽奖按钮
	 * 2、获取当前的抽奖次数，以及应该显示的竞猜结果
	 * 3、通知js 转盘已经转完
	 */
	/**
	 * setPrizeNumber(num,name)
	 * setRemainingTimes(times)
	 * doDraw 用户点击的抽奖按钮
	 * flashAlert
	 */
	
	public class QQPlayer extends MovieClip {
		private var panel:MovieClip = null;
		private var quadrant:MovieClip = null;
		private var awardButton:MovieClip = null;
		private var quadrantRunTimer:Timer = new Timer(100);
		private var showAlertDelayTimer:Timer = new Timer(100);
		private var quadrantCount:int = 0;
		private var t:TextField = new TextField();
		private var remainingTimes:int = 0;
		private var lottoButtonProxy:Sprite = new Sprite();
		private var beginSpeedDown:Boolean = false;
		private var speedDownCount:int = 0;
		//lastFrame为应该
		private var prizeNumber:int = 0;
		private var lastFrame:int = 0;
		private var speedDownArray:Array = new Array(2,2,2,2,2,3,3,3,3,4,4,5,5,5,5,5,5,5,5,5);
		private var speedArrayItorator:int = 0;
		
		public function QQPlayer():void {
			//检测舞台
			if (stage) {
				stageInited();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, stageInited);
			}
		}
		
		/**
		 * 舞台已初始化.
		 *  
		 * @param e
		 */		
		final private function stageInited(e:Event = null):void {
			if (hasEventListener(Event.ADDED_TO_STAGE)) {
				removeEventListener(Event.ADDED_TO_STAGE, stageInited);
			}
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			if (!ExternalInterface.available) {
				var interval:uint = setInterval(function () {
					if (ExternalInterface.available) {
						clearInterval(interval);
						init();
					}
				}, 200);
			} else {
				init();
			}
		}
		
		private function init():void {
			log("swf initialized");
			panel = getChildByName("myAwardPanel") as MovieClip;
			quadrant = panel.getChildByName("quadrantPiece") as MovieClip;
			quadrant.gotoAndStop(51);
			awardButton = panel.getChildByName("awardButton") as MovieClip;
			
			
			if (ExternalInterface.available) {
				ExternalInterface.addCallback("setPrizeNumber",setPrizeNumber);
				ExternalInterface.addCallback("resetPrizePanel",resetPrizePanel);
			}
			//			lottoButton.buttonMode = true;
			//			lottoButton.addEventListener(MouseEvent.CLICK, beginLotto);
			if (quadrant == null) {
				trace("error! quadrant is null!");
			}
			quadrantRunTimer.addEventListener(TimerEvent.TIMER, quadrantRun);
			showAlertDelayTimer.addEventListener(TimerEvent.TIMER, showAlertDelay);
			/**
			 * 新建lottoButtonProxy代理按钮动作
			 */
			lottoButtonProxy.x = 205; lottoButtonProxy.y = 205;
			lottoButtonProxy.graphics.clear();
			lottoButtonProxy.graphics.beginFill(0x000fff,0);
			//lottoButtonProxy.graphics.drawRect(0,0,110,110);
			lottoButtonProxy.graphics.drawCircle(0,0, 55);
			lottoButtonProxy.graphics.endFill();
			lottoButtonProxy.addEventListener(MouseEvent.CLICK,beginLotto);
			lottoButtonProxy.addEventListener(MouseEvent.MOUSE_DOWN, onLottoButtonDown);
			lottoButtonProxy.addEventListener(MouseEvent.MOUSE_OUT, onLottoButtonOut);
			lottoButtonProxy.addEventListener(MouseEvent.MOUSE_UP, onLottoButtonUp);
			lottoButtonProxy.addEventListener(MouseEvent.MOUSE_OVER, onLottoButtonOver);
			lottoButtonProxy.buttonMode = true;
			addChild(lottoButtonProxy);
		}
		
		private function onLottoButtonDown(e:MouseEvent):void {
			awardButton.gotoAndStop(3);
		}
		
		private function onLottoButtonOut(e:MouseEvent):void {
			awardButton.gotoAndStop(1);
		}
		
		private function onLottoButtonUp(e:MouseEvent):void {
			awardButton.gotoAndStop(4);
		}
		
		private function onLottoButtonOver(e:MouseEvent):void {
			awardButton.gotoAndStop(2);
		}
		/**
		 * 	 * setPrizeNumber(num,name)
		 * 如果获取到数据 那么显示数据 并通知js显示数据
		 */
		private function setPrizeNumber(num:int,name:String):void {
			prizeNumber = num;
			lastFrame = numToFrame(prizeNumber);
			beginSpeedDown = true;
			if (num == 0) {
				quadrantRunTimer.stop();
				showGetPrizeAlert();
				lottoButtonProxy.addEventListener(MouseEvent.CLICK, beginLotto);
				beginSpeedDown = false;
				speedArrayItorator = 0;
				speedDownCount = 0;
			}
		}
		
		private function numToFrame(num:int):int {
			if (num == 1) return 51;
			if (num == 2) return 1;
			if (num == 3) return 11;
			if (num == 4) return 21;
			if (num == 5) return 31;
			if (num == 6) return 41;
			return 51;
		}
		
		/**
		 *  重置中奖面板 用于用户没有登录的时候
		 */
		private function resetPrizePanel():void {
			quadrantRunTimer.stop();
			quadrant.gotoAndStop(51);
			lottoButtonProxy.addEventListener(MouseEvent.CLICK, beginLotto);
			beginSpeedDown = false;
			speedArrayItorator = 0;
			speedDownCount = 0;
		}
		/**
		 * setRemainingTimes(times)
		 */
		private function setRemainingTimes(times:int):void {
			return ;
			remainingTimes = times;
			var tf:TextFormat = new TextFormat();
			tf.color = 0xfff000;
			tf.size = 18;
			tf.bold = true;
			tf.align = TextFormatAlign.CENTER;
			//t.autoSize = TextFieldAutoSize.LEFT;
			t.text = times.toString(10);
			t.width = 30;
			t.setTextFormat(tf);
			t.x = 351; t.y = 495;
			if (!t.parent) {
				addChild(t);
			}
		}
		/**
		 * 点击竞猜按钮
		 * 开始转动
		 */
		private function beginLotto(e:MouseEvent):void {
			if (remainingTimes > 0) {
				remainingTimes --;
				setRemainingTimes(remainingTimes);
			}
			passClickToJS();
			quadrantRunTimer.start();
			lottoButtonProxy.removeEventListener(MouseEvent.CLICK, beginLotto);
			speedArrayItorator = 0;
			speedDownCount = 0;
		}
		
		/**
		 * 通知js用户点击了
		 */
		private function passClickToJS():void {
			if(ExternalInterface.available) { 
				ExternalInterface.call("doDraw"); 
			} 
		}
		
		/**
		 * 如果不减速就100ms转一次 否则就按照speedDownArray来转
		 */
		private function quadrantRun(e:TimerEvent):void {
			if (beginSpeedDown) {
				speedDownCount ++;
				if (speedDownCount==speedDownArray[speedArrayItorator]) {
					speedArrayItorator ++;
					speedDownCount = 0;
					quadrantRunOnce();
					/**
					 * 表明已经结束 那么停止转动 并且显示面板 按钮支持鼠标 同时初始化 变量
					 */
					if ((speedDownArray[speedArrayItorator]==5)&&(quadrant.currentFrame==lastFrame)) {
						showAlertDelayTimer.start();
					}
				} else {
				}
			} else {
				quadrantRunOnce();
			}
		}
		
		private function showAlertDelay(e:TimerEvent):void {
			showAlertDelayTimer.stop();
			quadrantRunTimer.stop();
			showGetPrizeAlert();
			lottoButtonProxy.addEventListener(MouseEvent.CLICK, beginLotto);
			beginSpeedDown = false;
			speedArrayItorator = 0;
			speedDownCount = 0;
		}
		
		/**
		 * 转盘转动一格
		 */
		private function quadrantRunOnce():void {
			quadrantCount++;
			quadrant.gotoAndStop((quadrantCount*10+1)%60);
		}
		
		/**
		 * 如果获取到数据
		 */
		private function showGetPrizeAlert():void {
			ExternalInterface.call("console.log", "预计调用flashAlert");
			if(ExternalInterface.available) { 
				ExternalInterface.call("console.log", "调用flashAlert");
				ExternalInterface.call("flashAlert"); 
			} 
		}
		
		private function onClick(e:Object):void {
			log(e.target + "|" + e.currentTarget);
		}
		
		private function log(content:String):void {
			if (ExternalInterface.available) {
				ExternalInterface.call("console.log", content);
			} else {
				trace(content);
			}
		}
		
	}
	
}
