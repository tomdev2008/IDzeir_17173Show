package com._17173.flash.core.ad.display
{
	import com._17173.flash.core.ad.interfaces.IAdDisplay;
	import com._17173.flash.core.ad.model.AdData;
	import com._17173.flash.core.util.time.Ticker;
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * 直播下底广告,为文字,无素材.
	 *  
	 * @author shunia-17173
	 */	
	public class StreamAdA4 extends Sprite implements IAdDisplay
	{
		
		/**
		 * 固定高宽.
		 * 宽度约等于15个字符串(默认字号)的宽度.
		 * 高度约等于默认字号的高度. 
		 */		
		private static const W:int = 180;
		private static const H:int = 22;
		
		/**
		 * 广告数据 
		 */		
		private var _data:Array = null;
		/**
		 * 广告显示对象 
		 */		
		private var _ads:Vector.<StreamOneLineAd> = null;
		/**
		 * 当前广告轮换的index 
		 */		
		private var _index:int = 0;
		/**
		 * mask 
		 */		
		private var _mask:Sprite = null;
		/**
		 * 上一条 
		 */		
		private var _lastAd:DisplayObject = null;
		
		public function StreamAdA4()
		{
			super();
			
			graphics.beginFill(0xffffff, 0);
			graphics.drawRect(0, 0, W, H);
			graphics.endFill();
			
			_mask = new Sprite();
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xff00ff, 0);
			_mask.graphics.drawRect(0, 0, W, H);
			_mask.graphics.endFill();
			addChild(_mask);
			this.mask = _mask;
			addEventListener(Event.ADDED_TO_STAGE, addToStage);
		}
		
		private function addToStage(evt:Event):void {
			//显示并启动动画
			show();
		}
		
		public function set data(value:Array):void {
			if (value && value.length) {
				_data = value;
				_ads = new Vector.<StreamOneLineAd>();
				//创建广告显示对象
				create();
				
				dispatchEvent(new Event("adComplete"));
			}
		}
		
		/**
		 * 多条广告上下切换 
		 */		
		private function show():void {
			var ad:StreamOneLineAd = _ads[_index];
			//切换
			switchAd(ad);
			//防止index越界
			_index ++;
			if (_index >= _ads.length) {
				_index = 0;
			}
			//如果有下一条才更新
			if (hasNext()) {
				Ticker.tick(600, function ():void {
					_lastAd = ad;
					//每两分钟更新一次
					Ticker.tick(120000, show, 0);
				});
			}
		}
		
		/**
		 * 切换广告 
		 * @param ad
		 */		
		private function switchAd(ad:DisplayObject):void {
			ad.x = (W - ad.width) / 2;
			if (_lastAd) {
				ad.y = -ad.height;
				//移掉上一个
				TweenLite.to(_lastAd, 0.5, {"y":H + 5, "onComplete":function (d:DisplayObject):void {
					if (d && d.parent) {
						d.parent.removeChild(d);
					}
				}, "onCompleteParams":[_lastAd]});
				//加入下一个
				TweenLite.to(ad, 0.5, {"y":(H - ad.height) / 2});
			} else {
				ad.y = (H - ad.height) / 2;
			}
			
			addChild(ad);
		}
		
		/**
		 * 是否有下条广告 
		 * 当广告总长度大于等于2个是才算有下条
		 * @return 
		 */		
		private function hasNext():Boolean {
			return _ads.length > 1;
		}
		
		/**
		 * 根据广告数据创建广告显示对象 
		 */		
		private function create():void {
			for each (var data:AdData in _data) {
				//存到一个队列里
				_ads.push(createOneLineAd(data));
			}
		}
		
		/**
		 * 根据广告数据创建一个文字链
		 *  
		 * @param data
		 * @return 
		 */		
		private function createOneLineAd(data:AdData):StreamOneLineAd {
			var ad:StreamOneLineAd = new StreamOneLineAd();
			
			ad.text = data.url;
			ad.url = data.jumpTo;
			
			return ad;
		}
		
		public function get data():Array {
			return _data;
		}
		
		public function get display():DisplayObject {
			return this;
		}
		
		override public function get height():Number {
			return H;
		}
		
		public function resize(w:Number, h:Number):void {
			
		}
		
		public function dispose():void
		{
			
		}
		
		public function get error():Boolean {
			return false;
		}
		
		public function get sourceData():Array {
			return null;
		}
		
	}
}