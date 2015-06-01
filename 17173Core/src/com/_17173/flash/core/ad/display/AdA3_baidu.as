package com._17173.flash.core.ad.display
{
	import com._17173.flash.core.ad.interfaces.IAdData;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AdA3_baidu extends AdA3
	{
		
		private static const BAIDU_W:int = 430;
		private static const BAIDU_H:int = 350;
		
		private static const URL:String = "http://cpro.baidu.com/cpro/ui/baiduLoader_as3.swf";
		
		public function AdA3_baidu()
		{
			super();
		}
		
		override protected function loadSWF(ad:IAdData):void {
			try {
				var loader:LoaderProxy = new LoaderProxy();
				var option:LoaderProxyOption = new LoaderProxyOption(
					URL, 
					LoaderProxyOption.FORMAT_SWF, 
					LoaderProxyOption.TYPE_ASSET_LOADER, 
					onSWFLoaded, 
					function (d:Object):void {
						onError({"url":ad.url, "type":ad ? ad.type : ""});
					});
				option.onAvaliable = onBaiduInit;
				option.allowSecurityCheck = false;
				loader.load(option);
			} catch (e:Error) {
				onError({"url":ad.url, "type":ad ? ad.type : ""});
			}
		}
		
		protected function onBaiduInit(loader:Object):void {
			var u:String = getUrl();
			var param : Object = {};
			param.cpro_channel = getChannel();
			param.cpro_client = getClient();
			Debugger.log(Debugger.INFO, "[AD_baidu]" + param.cpro_client + "   url:" + u);
			param.cpro_filters = ["多玩","178","爱拍","太平洋游戏网","yy"];
			param.cpro_url = u;
			param.cpro_template = "baiduxml_tiepian_400_300";
			param.cpro_w = BAIDU_W;
			param.cpro_h = BAIDU_H;
			param.cpro_plan = 4;
			//param.参数名 = 参数值;
			//成功回调
			loader["content"]["requestAdData"](markPlaying, param);
		}
		
		private function getClient():String {
			var re:String;
			var obj:Object = Context.variables;
			var type:String = Context.variables["type"];
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
					re = "3";
					break;
				case "f3":
					re = "2";
					break;
				case "f5":
					re = "2";
					break;
				default:
					re = "3";
					break;
			}
			return re;
		}
		
		/**
		 * 获取当前的url
		 * @return 
		 */		
		private function getUrl():String {
			var temp:String = Context.variables["refPage"];
			var re:String = "17173.tv.sohu.com";
			if (Util.validateStr(temp) && temp.indexOf("http://") != -1) {
				re = temp;
			}
			return re;
		}
		
		override protected function onAdded(event:Event):void {
			if (_ad) {
				_ad = null;
				data = [_currentAdData];
			}
			super.onAdded(event);
		}
		
		override protected function onRemoved(event:Event):void {
			if (_ad) {
				(_ad as Object).unloadAndStop();
				_adLayer.removeChild(_ad);
				_ad = null;
			} else {
				super.onRemoved(event);
			}
		}
		/**
		 *只统计点击，不做跳转 
		 * 
		 */		
		override protected function onAdClick(event:MouseEvent):void {
			onAdClickPost();
		}
		
		override public function get width():Number {
			return BAIDU_W;
		}
		
		override public function get height():Number {
			return BAIDU_H;
		}
		
		override public function resize(w:Number, h:Number):void {
			super.resize(w, h);
			
			if (_ad) {
				_adLayer.x = (_bg.width - (width * _ad.scaleX)) / 2;
				_adLayer.y = (_bg.height - (height * _ad.scaleY)) / 2;
			}
		}
	}
}