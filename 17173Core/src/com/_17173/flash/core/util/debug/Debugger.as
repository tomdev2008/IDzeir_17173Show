package com._17173.flash.core.util.debug
{
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.core.util.Util;
	
	import flash.utils.getTimer;
	
	/**
	 * 消息输出控件.
	 * 支持log信息,可以往console里输出. 
	 * @author shunia-17173
	 */	
	public class Debugger implements IContextItem
	{
		
		public static const CONTEXT_NAME:String = "debugger";
		
		private static var _output:IDebuggerOutput = null;
		private static var _source:String = null;
		
		public function Debugger()
		{
		}
		
		public static function set output(value:IDebuggerOutput):void {
			_output = value;
		}
		
		public static function set source(value:String):void {
			_source = value;
		}
		
		/**
		 * 打印输出到flash控制台 
		 * @param info
		 */		
		public static function tracer(...info):void {
			delegateOutput(trace, serialize(INFO, info));
		}
		
		/**
		 * 打印输出到外部控制台.通过制定output(IDebuggerOutput)属性,可以将log信息指向
		 * 该output实例的output方法中.
		 * 从而通过实现不同的IDebuggerOutput实例,完成输出log到不同环境中的功能. 
		 * @param level
		 * @param logs
		 */		
		public static function log(level:int, ...logs):void {
			delegateOutput(_output.output, serialize(level, logs) + "\n");
		}
		
		protected static function serialize(level:int, ...contents):String {
			return getLevelStr(level) + " " + paramsToString(contents);
		}
		
		private static function delegateOutput(delegate:Function, ...content):void {
			var s:String = "";
			if (Util.validateStr(_source)) {
				s = "[" + _source + "]";
			}
			delegate("[" + getTimeStr() + "]" + s + paramsToString(content));
		}
		
		private static function paramsToString(params:Array):String {
			var str:String = "";
			for (var i:int = 0; i < params.length; i ++) {
				var section:* = params[i];
				if (section == null) section = "null";
				
				var toString:String = null;
				try {
					toString = section["toString"]();
				} catch (e:*) {
					toString = String(section);
				}
				str += toString;
			}
			return str;
		}
		
		public static function perf(level:int, ...perfs):void {
			
		}
		
		public static function track(...value):void {
			
		}
		
		/**
		 * 系统时间
		 *  
		 * @return 冒号分隔的系统时间,从小时到毫秒
		 */		
		private static function getTimeStr():String {
			var result:String = "";
			var d:Date = new Date();
			result = Util.fillStr(String(d.milliseconds), "0", 3);
			result = Util.fillStr(String(d.seconds), "0", 2) + ":" + result;
			result = Util.fillStr(String(d.minutes), "0", 2) + ":" + result;
			result = Util.fillStr(String(d.hours), "0", 2) + ":" + result;
			return result;
		}
		
		private static function fillTimeStr(value:int):String {
			return value < 10 ? "0" + value : String(value);
		}
		
		private static function getLevelStr(level:int):String {
			var str:String = "";
			switch (level) {
				case INFO : 
					str = "[info]";
					break;
				case WARNING : 
					str = "[warning]";
					break;
				case ERROR : 
					str = "[error]";
					break;
			}
			return str;
		}
		
		public static const INFO:int = 0;
		public static const WARNING:int = 1;
		public static const ERROR:int = 2;
		
		public function get contextName():String {
			return CONTEXT_NAME;
		}
		
		public function startUp(param:Object):void {
			if (param.hasOwnProperty("source")) {
				source = param["source"];
			}
			if (param.hasOwnProperty("output")) {
				output = param["output"];
			}
		}
		
	}
}