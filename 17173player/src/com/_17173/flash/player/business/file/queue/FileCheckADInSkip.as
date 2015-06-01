package com._17173.flash.player.business.file.queue
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.net.loaders.LoaderProxy;
	import com._17173.flash.core.net.loaders.LoaderProxyOption;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.model.PlayerType;


	public class FileCheckADInSkip extends FileState
	{
		public function FileCheckADInSkip()
		{
			super();
		}
		override public function enter():void {
//			if (Context.variables["type"] != Settings.PLAYER_TYPE_FILE_ZHANWAI) {
			if (Context.variables["type"] != PlayerType.F_ZHANWAI) {
				complete();
				return;
			}
			var currentDomain:String = "";
			if (Util.validateStr(Util.refPage)) {
				currentDomain = Util.refPage;
			} else {
				currentDomain = Context.variables["refer"];
			}
			if (Util.validateStr(currentDomain) && currentDomain.indexOf("http://") == -1) {
				currentDomain = "http://" + currentDomain;
			}
			if (!Util.validateStr(currentDomain)) {
				complete();
				return;
			}
			var url:String = "";
			if (Context.variables["debug"]) {
				url = "http://v.17173.com/x/filterList-test.json";
			} else {
				url = "http://v.17173.com/x/filterList.json";
			}
			try {
				var loader:LoaderProxy = new LoaderProxy();
				var option:LoaderProxyOption = new LoaderProxyOption(
					url, LoaderProxyOption.FORMAT_JSON, LoaderProxyOption.TYPE_FILE_LOADER, 
					function (data:Object):void {
						var list:Array = [];
						if (data.hasOwnProperty("list") && data["list"]) {
							list = data["list"];
							if (list && list.length > 0) {
								for (var i:int = 0; i < list.length; i++) {
									if (currentDomain == list[i]) {
										transcationData["adIsInSkipList"] = true;
										complete();
										return;
									}
								}
								transcationData["adIsInSkipList"] = false;
							} else {
								transcationData["adIsInSkipList"] = false;
							}
						}
						complete();
					}, function (d:Object):void {
						transcationData["adIsInSkipList"] = false;
						complete();
					});
				loader.load(option);
			} catch (e:Error) {
				transcationData["adIsInSkipList"] = false;
				complete();
			}
		}
	}
}

