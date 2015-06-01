package com._17173.flash.player.ui.tip
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;

	/**
	 * 友好提示的数据源. 
	 * @author shunia-17173
	 */	
	public class TooltipData
	{
		
		private static const DEFAULT_HTML_STREAM:String = "<p><FONT FACE='{font}' SIZE='14' COLOR='#FDCD00'>{0}</FONT></p>"
		private static const DEFAULT_HYPER_STREAM:String = "<a href=\'event:hyperlink\'><u><FONT COLOR='#0000FF'>{0}</FONT></u></a>";
		
		private static const DEFAULT_HTML_FILE:String = "<p><FONT SIZE='12' COLOR='#B9B9B9'>{0}</FONT></p>";
		private static const DEFAULT_HYPER_FILE:String = "<a href=\'event:hyperlink\'><u><FONT COLOR='#FFAE00'>{0}</FONT></u></a>";
		
		/**
		 * 将字符串参数转换成html字符串,用以显示在友好提示中. 
		 * @param content	要显示的默认文字
		 * @param seprator	用于替换默认文字的分隔符,可以将默认文字分为两段,以填入超链接
		 * @param hyperlink	超链接文字
		 * @param callback	点击超链接的回调
		 * @return 			返回转换出来的友好提示数据源
		 * 
		 */		
		public static function fromContent(content:String, seprator:String = "|", hyperlink:String = null, callback:Function = null):TooltipData {
			if (content == null) return null;
			
			var html:String = "";
			var hyper:String = "";
			
			if (Context.variables["lv"]) {
				html = DEFAULT_HTML_STREAM.replace("{font}", Util.getDefaultFontNotSysFont());
				hyper = DEFAULT_HYPER_STREAM;
			} else {
				hyper = DEFAULT_HYPER_FILE;
				html = DEFAULT_HTML_FILE;
			}
			if (seprator && hyperlink) {
				hyperlink = DEFAULT_HYPER_STREAM.replace("{0}", hyperlink);
				content = content.replace(seprator, hyperlink);
			}
			content = html.replace("{0}", content);
			
			var td:TooltipData = new TooltipData();
			
			td.content = content;
			td.callback = callback;
			
			return td;
		}
		
		private var _content:String = null;
		private var _callback:Function = null;

		public function get content():String
		{
			return _content;
		}

		public function set content(value:String):void
		{
			_content = value;
		}

		public function get callback():Function
		{
			return _callback;
		}

		public function set callback(value:Function):void
		{
			_callback = value;
		}

		
	}
}