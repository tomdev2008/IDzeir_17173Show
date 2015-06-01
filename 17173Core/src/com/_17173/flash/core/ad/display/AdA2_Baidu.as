package com._17173.flash.core.ad.display
{
	import com._17173.flash.core.ad.BaseAdDisplay;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.interfaces.IRendable;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	public class AdA2_Baidu extends BaseAdDisplay implements IRendable
	{
		private var _loader:Loader;
		private var _adTime:AdTimeComp = null;
		private var _totalTime:int = 15;
		private var _currentTime:int;
		private var _offsetH:Number = 35;//播放器高度偏移量
		
		public function AdA2_Baidu()
		{
			super();
			
			_adTime = new AdTimeComp();
			addChild(_adTime);
			addEventListener(Event.ADDED_TO_STAGE , addToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
		}
		
		private function addToStage(e:Event):void {
			_currentTime = 0;
//			resize(Context.stage.stage.width, Context.stage.stageHeight - _offsetH);
			_adTime.time = _totalTime;
			_adTime.soundUI = this;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.INIT, onBaiduAdInit);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.load(new URLRequest("http://cpro.baidu.com/cpro/ui/baiduLoader_as3.swf"));
			_loader.addEventListener(MouseEvent.CLICK,onAdClick);
			addChild(_loader);
			this.setChildIndex(_adTime, this.numChildren - 1);
		}
		
		private function removeFromStage(e:Event):void {
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.removeEventListener(MouseEvent.CLICK,onAdClick);
			_loader = null;
		}
		
		override public function set data(value:Array):void {
			if(value == null) return;
			_data = value;
			//取第一个开始
			_currentAdData = _data.shift();
		}
		
		public function get needUpdate():Boolean
		{
			return true;
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void {
			Debugger.log(Debugger.INFO, "[ad]", "百度联盟io错误!");
			onError({"url":"baidu", "type": "baidu"});
		}
		
		/**
		 * 百度广告加载完毕
		 * 该函数设置参数，并调用接口发出广告请求
		 */
		private function onBaiduAdInit(e : Event) : void {
			_loader.contentLoaderInfo.removeEventListener(Event.INIT, onBaiduAdInit);
			var w:Number = (_w && _w > 0) ? _w : Context.stage.stageWidth;
			var h:Number = (_h && _h > 0) ? _h : Context.stage.stageHeight - _offsetH;
			if (w < 430 || h < 350) {
				onError({"url":"baidu", "type":"小于百度广告默认宽高"});
				this.removeChild(_loader);
				return;
			}
			var param : Object = {};
			param.cpro_channel = getChannel();
			param.cpro_client = getClient();
			Debugger.log(Debugger.INFO, "[AD_baidu]" + param.cpro_client + "   url:" + getUrl());
			param.cpro_filters = ["多玩","178","爱拍","太平洋游戏网","yy"];
			param.cpro_url = getUrl();
			param.cpro_template = "baiduxml_tiepian_400_300";
			param.cpro_w = w;
			param.cpro_h = h;
			param.cpro_plan = 4;
			//param.参数名 = 参数值;
			(_loader.content as Object)["requestAdData"](baiduAdCallback, param);
			
			//曝光
			super.onAdShowPost();
			
		}
		
		private function getClient():String {
			var re:String;
			switch (Context.variables["type"]) {
				case "f1":
					re = "43067007_4_tp_cpr";
					break;
				case "f3":
					re = "43067007_3_tp_cpr";
					break;
				case "f5":
					re = "43067007_3_tp_cpr";
					break;
				default:
					re = "43067007_4_tp_cpr";
					break;
			}
			return re;
		}
		
		private function getChannel():String {
			var re:String;
			switch (Context.variables["type"]) {
				case "f1":
					re = "2";
					break;
				case "f3":
					re = "1";
					break;
				case "f5":
					re = "1";
					break;
				default:
					re = "2";
					break;
			}
			return re;
		}
		
		/**
		 * 回调函数，当广告显示完毕时，该回调函数将会被 调用，
		 * 可以在该函数内开启进度显示
		 */
		private function baiduAdCallback() : void {
			_isPlaying = true;
		}
		
		/**
		 *发送曝光 
		 * @param event
		 * 
		 */		
		override protected function onAdClick(event:MouseEvent):void {
			super.onAdClickPost();
		}
		
		/**
		 * 获取当前的url
		 * @return 
		 * 
		 */		
		private function getUrl():String {
			var temp:String = Util.refPage;
			var re:String = "17173.tv.sohu.com";
			if (Util.validateStr(temp) && temp.indexOf("http://") != -1) {
				re = temp;
			}
			return re;
		}
		
		public function update(time:int):void {
			if (_isPlaying || _error) {
				_currentTime += time;
				var s:int = _currentTime / 1000;
				var r:int = _totalTime - s;
				if (r <= 0) {
					_isPlaying = false;
					_error = false;
					onAdComplete();
				} else {
					if (_adTime) {
						_adTime.time = r;
					}
				}
			}
		}
		
		override public function resize(w:Number, h:Number):void {
			super.resize(w, h);
			if (_adTime) {
				_adTime.x = w - _adTime.width;
				_adTime.y = 0;
			}
			if (_loader &&　_loader.content) {
				_loader.content["setSize"](w, h);
			}
		}
	}
}