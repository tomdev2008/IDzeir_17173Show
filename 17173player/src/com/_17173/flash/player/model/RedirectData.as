package com._17173.flash.player.model
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.module.stat.IStat;
	import com._17173.flash.player.module.stat.base.StatTypeEnum;

	/**
	 * 回链类
	 *  
	 * @author shunia-17173
	 */	
	public class RedirectData
	{
		
		private var _link:String = "";
		
		private var _url:String = "";
		private var _from:String = "";
		private var _vid:String = "";
		private var _action:String = "";
		private var _click_type:String = "1";
		
		public function RedirectData()
		{
			_link = Context.variables["redirectLink"];
			_url = parse(Context.variables["redirectUrl"]);
			_from = parse(Context.variables["redirectFrom"]);
			_vid = parse(Context.variables["redirectVid"]);
			_action = parse(Context.variables["redirectAction"]);
		}
		
		public function get link():String
		{
			return _link;
		}

		public function set link(value:String):void
		{
			_link = value;
		}

		public function get action():String
		{
			return _action;
		}

		public function set action(value:String):void
		{
			_action = value;
		}

		public function get vid():String
		{
			return _vid;
		}

		public function set vid(value:String):void
		{
			_vid = value;
		}

		public function get from():String
		{
			return _from;
		}

		public function set from(value:String):void
		{
			_from = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}
		/**
		 * 1:点击回链按钮
		 * 2:点击正常按钮
		 * 3:播放器弹框展示
		 */		
		public function get click_type():String
		{
			return _click_type;
		}
		
		public function set click_type(value:String):void
		{
			_click_type = value;
		}

		public function send():void {
			//暂时只统计直播站外（企业版）
			if (Context.variables["type"] != "f6") {
				Util.toUrl(_url);
			} else {
				if (!Util.validateStr(_link)) return;
				Util.toUrl(_link + "?" + 
					"url=" + _url + 
					"&from=" + _from + 
					"&vid=" + _vid + 
					"&action=" + _action);
				
				IStat(Context.getContext(ContextEnum.STAT)).stat(
					StatTypeEnum.QM, StatTypeEnum.EVENT_REDIRECT, this);
				IStat(Context.getContext(ContextEnum.STAT)).stat(
					StatTypeEnum.BI, StatTypeEnum.EVENT_REDIRECT, this);
			}
		}
		
		private function parse(s:String):String {
			return Util.validateStr(s) ? s : "";
		}

		
	}
}