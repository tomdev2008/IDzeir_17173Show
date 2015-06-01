package com._17173.flash.core.util
{
	import com._17173.flash.core.context.Context;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	public class Util
	{
		public function Util()
		{
		}
		
		/**
		 * 当前系统所使用的默认字体 
		 */		
		private static var _defaultFontName:String = "";
		/**
		 * 微软雅黑 
		 */		
		public static const FONT_WRYH:String = "Microsoft YaHei,微软雅黑";
		
		public static const FONT_ARIAL:String = "Arial, Arial 常规";
		
		/**
		 * 苹果丽黑 
		 */		
		public static const FONT_PGLZH:String = "Hiragino Sans GB,苹果丽黑";
		
		private static var _os:String = "";
		
		private static var _br:String = "";
		
		private static var _brver:String = "";
		
		private static var _fpver:String = "";
		
		private static var _refPage:String = "";
		
		public static function debugDisplayObject(target:DisplayObject):void {
			var g:Graphics = null;
			var shape:Shape = null;
			if (target.hasOwnProperty("graphics")) {
				g = target["graphics"];
			} else {
				shape = new Shape();
				g = shape.graphics;
			}
			g.clear();
			g.lineStyle(1, 0xFF0000);
			g.beginFill(0x000000, 0);
			var rect:Rectangle = target.getBounds(target);
			g.drawRect(rect.x - 1, rect.y - 1, rect.width + 2, rect.height + 2);
			g.endFill();
			g.lineStyle(1, 0x00FF00);
			g.beginFill(0x000000, 0);
			g.drawRect(-1, -1, target.width + 2, target.height + 2);
			g.endFill();
			
			if (shape) {
				if (target is DisplayObjectContainer) {
					DisplayObjectContainer(target).addChild(shape);
				}
			}
		}
		
		/**
		 * 验证字符串是否可用.一般用于判断时检验字符串是否合法.
		 *  
		 * @param s
		 * @return 
		 */		
		public static function validateStr(s:String):Boolean {
			return s != null && trimStr(s) != "";
		}
		
		/**
		 * 验证某个Object中是否包含某个参数，并且不为空(不判断value[key]的具体值)
		 * @param value 源object
		 * @param key 需要的确定的key
		 * @return 
		 */		
		public static function validateObj(value:Object, key:String):Boolean {
			return value && value.hasOwnProperty(key);
		}
		
		/**
		 * 解析url中的url参数
		 *  
		 * @param url
		 * @return 
		 */		
		public static function parseURLParams(url:String):Object {
			var p:Object = null;
			if (!validateStr(url)) return p;
			
			p = {};
			
			var split:Array = url.split("?");
			if (split.length > 1) {
				//取问号后面
				var paramStr:String = split[1];
				if (validateStr(paramStr)) {
					//按&分隔
					var params:Array = paramStr.split("&");
					for each (var pair:String in params) {
						//按=分隔
						var pairSplit:Array = pair.split("=");
						//如果分隔成功,就可以当成key=value来解析了
						if (pairSplit.length > 1) {
							p[pairSplit[0]] = pairSplit[1];
						}
					}
				}
			}
			
			return p;
		}
		
		/**
		 * 去除字符串空格
		 *  
		 * @param s
		 * @return 
		 */		
		public static function trimStr(s:String):String {
			return s.replace(/([ ]{1})/g, "");
		}
		
		/**
		 * 格式化TextField超过指定长度方法
		 * 测试方法，不一定试用所有情况
		 * 0.5是尝试出来的数字
		 */
		public static function formatStringExceed(textF:TextField, textW:Number):String
		{
			var re:String = "";
			if(textF.text == "")
			{
				return re;
			}
			var oneWidth:Number = textF.width / textF.length;
			var wordNum:int = (textW - oneWidth * 0.5) / oneWidth;
			re = textF.text.slice(0, wordNum);
			return re;
		}
		
		/**
		 * 获取默认的非系统默认字体 
		 * @return 
		 */		
		public static function getDefaultFontNotSysFont():String {
			if (!_defaultFontName) {
				switch (os) {
					case "Windows" : 
						return _defaultFontName = FONT_WRYH;
						break;
					case "Mac" : 
						return _defaultFontName = FONT_PGLZH;
						break;
					case "Linux" : 
						return _defaultFontName = FONT_WRYH;
						break;
					default : 
						return _defaultFontName = FONT_WRYH;
						if (os.indexOf("iphone")) {
							
						} else {
							
						}
						break;
				}
				_defaultFontName = null;
			}
			return _defaultFontName;
		}
		
		/**
		 * 获取默认的非系统默认数字类型字体(底部控制栏用)
		 * @return 
		 */		
		public static function getDefaultNumberFontNotSysFont():String {
			var re:String = null;
			switch (os) {
				case "Windows" : 
					return re = FONT_ARIAL;
					break;
				case "Mac" : 
					return re = null;
					break;
				case "Linux" : 
					return re = null;
					break;
				default : 
					return re = null;
					if (os.indexOf("iphone")) {
						
					} else {
						
					}
					break;
			}
			re = null;
			return re;
		}
		
		/**
		 * 根据网速算出应该使用的清晰度
		 */
		public static function getAutoDef(speed:Number):String
		{
			var _maxKbps:Number = speed * 8;
			if(_maxKbps <= 260)
			{
				//标清
				return "1";
			}
			else if(_maxKbps > 260 && _maxKbps <= 450)
			{
				//高清
				return "2";
			}
			else if(_maxKbps > 450 && _maxKbps <= 650)
			{
				//超清
				return "4";
			}
			else if(_maxKbps > 650 && _maxKbps <= 1500)
			{
				//原画（720）
//				return "8";
				return "4";
			}
			else if(_maxKbps > 1500 && _maxKbps <= 2000)
			{
				//原画（1080）
//				return "8";
				return "4";
			}
			else
			{
				return "4";
			}
		}
		
		private static var _testTF:TextField = null;
		/**
		 * 缩短textfield字符串长度并自动在末尾加上三个'.'的方法.
		 * 不支持htmltext设置的textfield.
		 * 根据字符串的复杂程度,性能范围为1-6ms. 
		 * @param tf
		 * @param width
		 * 
		 */		
		public static function shortenText(tf:TextField, width:Number):void {
			if (!tf || !tf.text || !tf.getTextFormat() || width <= 0) return;
			
			if (_testTF == null) {
				_testTF = new TextField();
				_testTF.autoSize = TextFieldAutoSize.LEFT;
			}
			var fmt:TextFormat = tf.getTextFormat();
			_testTF.defaultTextFormat = fmt;
			
			_testTF.text = ".";
			var baseDotW:Number = _testTF.textWidth;
			
			//要求的宽度还不如3个点那么宽,就不做处理
			if (width <= (baseDotW * 3)) {
				_testTF.text = "...";
			} else {
				var text:String = tf.text;
				_testTF.text = text;
				
				var needShorten:Boolean = false;
				//如果文字的宽度大于要求的宽度,则需要处理
				if (_testTF.textWidth > width) {
					needShorten = true;
				}
				
				if (needShorten) {
					//需要缩短到{需求的宽度-三个点的宽度}
					var shortenTo:Number = width - baseDotW * 3;
					var shortend:String = text;
					var complete:Boolean = false;
					//一个一个字符的减少,直到宽度符合要求
					while (complete == false) {
						if (shortend.length >= 1) {
							shortend = shortend.substr(0, shortend.length - 1);
							_testTF.text = shortend;
							if (_testTF.textWidth <= shortenTo) {
								complete = true;
							}
						} else {
							complete = true;
						}
					}
					tf.text = shortend + "...";
				}
			}
		}
		
		/**
		 * 为指定字符串填充直指定长度的填充符.
		 *  
		 * @param str 指定的字符串
		 * @param fillWith 填充用的字符串
		 * @param len 想要填充到的长度
		 * @param isFront 是否从字符串前面填充
		 * @return 填充成指定长度的字符串
		 * 
		 */		
		public static function fillStr(str:String, fillWith:String, len:int, isFront:Boolean = true):String {
			if (str.length < len) {
				var diff:int = len - str.length;
				for (var i:int = 0; i < diff; i ++) {
					str = fillWith + str;
				}
			}
			return str;
		}
		
		/**
		 * 获取当前播放器所处的操作系统
		 *  
		 * @return 如: "Windows", "Mac"
		 * 
		 */		
		public static function get os():String {
			if (!validateStr(_os)) {
				_os = Capabilities.os.split(" ")[0];
			}
			return _os;
		}
		
		/**
		 * 获取当前播放器版本.
		 *  
		 * @return 如: "WIN-11.8"
		 */		
		public static function get fpver():String {
			if (!validateStr(_fpver)) {
				var ver:String = Capabilities.version;
				var fp:String = ver.substr(0, 3);
				var arr:Array = ver.substr(4, ver.length - 3).split(",");
				_fpver = fp + "-" + arr.join(".");
			}
			return _fpver;
		}
		
		/**
		 * 通过js获取播放器的当前引用页 
		 * 
		 * @return 如: "http://v.17173.com"
		 */		
		public static function get refPage():String {
			if (!validateStr(_refPage) && JSBridge.enabled) {
				var result:Object = JSBridge.addCall("" +
					"function () {" +
					"return window.location.href;" +
					"}", null, "");
				if (result) {
					_refPage = String(result);
				}
			}
			return _refPage;
		}
		
		/**
		 * 通过js获取浏览器类型
		 *  
		 * @return 如: "Firefox", "Chrome"等
		 */		
		public static function get browser():String {
			if (!validateStr(_br)) {
				var b:Object = br;
				if (b) {
					_br = b["b"];
					_brver = b["r"];
				}
			}
			return _br;
		}
		
		/**
		 * 获取浏览器版本的js代码
		 *  
		 * @return 
		 */		
		private static function get br():Object {
			return !JSBridge.enabled ? null : 
				JSBridge.addCall("function(){var userAgent = navigator.userAgent.toLowerCase();var browserArr = [{'n':'IE', 'v':'11', 'r':'rv:11'},{'n':'IE', 'r':'msie'},{'n':'FireFox', 'r':'firefox/'},{'n':'Chrome', 'r':'chrome/'},{'n':'Opera', 'r':'opera/'},{'n':'Safari', 'r':'safari/'}];for(var i=0; i<browserArr.length; i++){if(new RegExp(browserArr[i].r).test(userAgent)){var reg = new RegExp(browserArr[i].r+'([\\d.]+)');return {'b':browserArr[i].n, 'r': browserArr[i].v ? browserArr[i].v : userAgent.match(reg)[1]};}}}", 
					null, "");
		}
		
		/**
		 * 通过js获取当前浏览器版本
		 *  
		 * @return 如: "24", "30"
		 */		
		public static function get browserver():String {
			if (!validateStr(_brver)) {
				var b:Object = br;
				if (b) {
					_br = b["b"];
					_brver = b["r"];
				}
			}
			return _brver;
		}
		
		public static function toUrl(url:String, stage:String = "_blank"):void {
			var links:String = url;
			var WINDOW_OPEN_FUNCTION:String = "window.open";
			var myURL:URLRequest = new URLRequest(links);
			var browserName:String = browser;
			var openStage:String = stage;
			if(JSBridge.enabled)
			{
				if(browserName != "IE")
				{
					navigateToURL(myURL, openStage);
				} else {
					ExternalInterface.call(WINDOW_OPEN_FUNCTION, links, openStage);
				}
			} else {
				navigateToURL(myURL, openStage);
			}
			
			if (Context.stage.displayState != StageDisplayState.NORMAL)
			{
//				Context.stage.displayState = StageDisplayState.NORMAL;
				Context.getContext("eventManager").send("onPlayerFullScreen");
			}
		}
		
		/**
		 * 计算字符串的长度.
		 * 
		 * 比如:中文或者中文符号等于两位.
		 *  
		 * @param s
		 * @return 
		 */		
		public static function strCharLen(s:String):int {
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes(s);
			var l:int = ba.length;
			
			ba.clear();
			ba = null;
			
			return l;
		}
		
		/**
		 *返回字符串的字符长度 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function checkStrLength(str:String):int{
			return str.replace(/[^\x00-\xff]/g,"xx").length
		}
		
		
		/**
		 * 获取时间显示类型00:00:00
		 *  
		 * @param time 指定的秒数
		 * @param showHour 是否显示小时(设置不显示，如果小于一小时则显示时间为XX:XX 否则正常返回)
		 * @return 返回的字符串
		 * 
		 */	
		public static function getTimerText(time:int,showHour:Boolean = true):String
		{
			var str:String = "";
			var hour:int = time/3600;
			var min:int = (time - hour*3600)/60;
			var sec:int = (time - hour*3600 - min * 60);
			if(showHour || hour > 0){
				if(hour <= 0)
				{
					str +="00:";
				}else if(hour < 10)
				{
					str +="0"+hour+":";
				}
				else
				{
					str +=hour+":";
				}
			}
			if(min <= 0)
			{
				str +="00:";
			}else if(min < 10)
			{
				str +="0"+min+":";
			}
			else
			{
				str +=min+":";
			}
			
			
			if(sec <= 0)
			{
				str +="00";
			}else if(sec < 10)
			{
				str +="0"+sec;
			}
			else
			{
				str +=sec;
			}
			return str;
		}
		
		
		/**
		 * 从一个url中获取某个参数的值
		 * @param url 源url
		 * @param key 要获取的参数名称，不带“=”号
		 * @return 要获取的参数的值
		 * 
		 */		
		public static function getValueFromUrl(url:String, key:String):String {
			key = key + "=";
			if (Util.validateStr(url) && url.indexOf(key) != -1) {
				var start:int = url.indexOf(key);
				var tempStr:String = url.slice(start + key.length, url.length);
				tempStr = tempStr.split("?")[0];
				tempStr = tempStr.split("&")[0];
				return tempStr;
			} else {
				return "";
			}
		}
		
		/**
		 * 复制复杂对象属性.
		 * 
		 * 对于Object或者Dictionary,这种复制可以成功复制所有属性.
		 * 对于其他复杂对象来说,只能复制公开的可访问的属性.在这种情况下慎用,因为有可能会导致赋予属性的对象和被复制的对象持有同一引用.
		 * 
		 * 此方法不支持ByteArray.
		 *  
		 * @param target
		 * @param to
		 * @param props 限制可被复制的属性.如果定义该属性,当isInclude为false时,target上的属性只有在这个数组中才会被复制,反之当isInclude为true时,target上的属性如果在该数组中存在,则不会被复制.
		 */		
		public static function cloneTo(target:*, to:*, props:Array = null, isInclude:Boolean = true):void {
			//为空肯定不复制
			if (!target || !to) return;
			//简单类型不予复制
			if (isSimpleType(target) || isSimpleType(to)) return;
			
			var isSkip:Boolean = false;
			for (var k:* in target) {
				if (!k) continue;
				//定义了限制属性并且当前属性在限制属性里,则跳过
				if ((isInclude == false && props && props.indexOf(k) != -1) ||
					(isInclude == true && props && props.indexOf(k))) {
					isSkip = true;
				}
				if (!isSkip) {
					to[k] = target[k];
				}
			}
		}
		
		/**
		 * 判断对象是否为简单类型.
		 * 
		 * int, number, uint, string, boolean
		 *  
		 * @param o
		 * @return 
		 */		
		public static function isSimpleType(o:*):Boolean {
			return ["boolean", "number", "string"].indexOf(typeof(o)) != -1;
		}
		
		/**
		 * 深度复制.
		 * 并不是所有的类型都支持,对object类型和array类型支持的比较好.
		 * 
		 * 其他复杂对象类型需要使用registerAlias进行注册.
		 *  
		 * @param target
		 * @return 
		 */		
		public static function clone(target:*):* {
			var ba:ByteArray = new ByteArray();
			ba.writeObject(target);
			ba.position = 0;
			return ba.readObject();
		}
		
		/**
		 * 是否允许全屏
		 *  
		 * @return 
		 */		
		public static function allowFullscreen(stage:Stage):Boolean {
			var a1:Boolean = stage.hasOwnProperty("displayState");
			var a2:Boolean = stage.hasOwnProperty("allowsFullScreen");
			var a3:Boolean = a2 ? stage.allowsFullScreen : false;
			if (a1 && a2 && a3) {
				return true;
			} else {
				return false;
			}
		}
		
		/**
		 * 11.3版本以上才支持全屏交互
		 *  
		 * @return 
		 */		
		public static function get allowFullscreenInteractive():Boolean {
			//WIN-11.9.9
			var fp:Array = Util.fpver.split("-")[1].split(".");
			//"11.9"
			var fpv:String = fp.length > 1 ? fp[0] + "." + fp[1] : fp[0];
			//11.9
			var fpn:Number = Number(fpv);
			if (fpn < 11.3) {
				return false;
			} else {
				return true;
			}
		}
		
		/**
		 * 刷新页面 
		 */		
		public static function refreshPage():void {
			JSBridge.addCall("function(){window.location.reload();}", null, "");
		}
		
		public static function timerFormat(mili:Number,replace:String = ":"):String
		{
			var result:String = "";
			var sec:int = mili / 1000 % 60;
			result = Util.fillStr(String(sec), "0", 2);
			
			var min:int = mili / 1000 / 60 % 60;
			result = Util.fillStr(String(min), "0", 2) + replace + result;
			
			var h:int = mili / 1000 / 60 / 60 % 24;
			result = Util.fillStr(String(h), "0", 2) + replace + result;
			return result;
		}
	}
}