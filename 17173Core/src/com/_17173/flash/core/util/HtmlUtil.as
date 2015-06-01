package com._17173.flash.core.util
{
	/**
	 * html代码转义替换
	 *  
	 * @author shunia-17173
	 */	
	public class HtmlUtil
	{
		public function HtmlUtil()
		{
		}
		
		/**
		 * 将html转义符转义为html记号.
		 *  
		 * @param s
		 * @return 
		 */		
		public static function decodeHtml(s:String):String {
			s = s.
				replace(/&lt;/g,'<').
				replace(/&gt;/g,'>').
				replace(/\\n/g,'<br/>').
				replace(/&nbsp;/g,' ').
				replace(/&amp;/g,'&');
			return s;
		}
		
		/**
		 * 将html转义符转义为字符串.
		 *  
		 * @param s
		 * @return 
		 */		
		public static function encodeHtml(s:String):String {
			s = s.
				replace(/&nbsp;/g, ' ').
				replace(/(&rsquo;|&lsquo;)/g, '\'').
				replace(/&middot;/g, '·').
				replace(/(&ldquo;|&rdquo;|&quot;)/g, '"').
				replace(/&mdash;/g, '—').
				replace(/&hellip;/g, '…').
				replace(/&lt;/g, '<').
				replace(/&gt;/g, '>').
				replace(/\\n/g, '\r').
				replace(/&rarr;/g, '→').
				replace(/&amp;/g, '&');
			return s;
		}
		
	}
}