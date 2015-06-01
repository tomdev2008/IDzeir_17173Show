package com._17173.flash.player.ui.comps.def
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Cookies;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.interfaces.IVideoManager;
	import com._17173.flash.player.business.file.FileVideoData;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;
	import com._17173.flash.player.model.PlayerType;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class ControlBarDefButton extends Sprite
	{
		private var _defBtn_back:DisplayObject = null;
		private var _label:TextField = null;
		private var _list:ControlBarDefBar = null;
		private var _mask:Sprite = null;
		private var _mouseOut:Boolean = false;
		private var _timeOut:Boolean = false;
		private var _videoInit:Boolean = false;
		private var _e:IEventManager;
		
		public function ControlBarDefButton()
		{
			super();
			
			_defBtn_back = new mc_def_btn_back();
			_defBtn_back.x = 0;
			_defBtn_back.y = 0;
			addChild(_defBtn_back);
			
			var labelFormat:TextFormat = new TextFormat();
			labelFormat.color = 0xfdcd00;
			labelFormat.size = 12;
			
			_label = new TextField();
			_label.autoSize = TextFieldAutoSize.CENTER;
			_label.text = "标清";
			_label.selectable = false;
			_label.defaultTextFormat = labelFormat;
			_label.setTextFormat(labelFormat);
			_label.mouseEnabled = false;
			addChild(_label);
			
			_mask = new Sprite();
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawRect(0, 0, _defBtn_back.width, _defBtn_back.height);
			_mask.graphics.endFill();
			_mask.buttonMode = false;
			addChild(_mask);
			
			resize();
			init();
			addEventListeners();
			setMouse(false);
		}
		
		private function init():void
		{
			_e = (Context.getContext(ContextEnum.EVENT_MANAGER) as IEventManager);
		}
		
		private function addEventListeners():void {
			_e.listen(PlayerEvents.BI_GET_VIDEO_INFO, resetDef);
			_e.listen(PlayerEvents.BI_PLAYER_INITED, resetMouseState);
			_e.listen(PlayerEvents.BI_INIT_COMPLETE, onBIInitVideoInfo);
			_e.listen(PlayerEvents.UI_SHOW_BACK_RECOMMAND, showBackRec);
			_e.listen(PlayerEvents.UI_HIDE_BACK_RECOMMAND, hideBackRec);
			_e.listen(PlayerEvents.REINIT_VIDEO, reGetSoDef);
			_e.listen(PlayerEvents.BI_VIDEO_DEF_CHANGED, changeDefLabel);
			addEventListener(MouseEvent.CLICK, mouseClick);
		}
		
//		private function addEventListeners():void {
//			Global.eventManager.listen(PlayerEvents.BI_GET_VIDEO_INFO, resetDef);
//			Global.eventManager.listen(PlayerEvents.BI_PLAYER_INITED, resetMouseState);
//			Global.eventManager.listen(PlayerEvents.BI_INIT_COMPLETE, onBIInitVideoInfo);
//			Global.eventManager.listen(PlayerEvents.UI_SHOW_BACK_RECOMMAND, showBackRec);
//			Global.eventManager.listen(PlayerEvents.UI_HIDE_BACK_RECOMMAND, hideBackRec);
//			Global.eventManager.listen(PlayerEvents.REINIT_VIDEO, reGetSoDef);
//			addEventListener(MouseEvent.CLICK, mouseClick);
//		}
		
		private function mouseClick(evt:MouseEvent):void {
//			if (!_mask.mouseEnabled || Global.settings.params["showBackRec"]) {
			if (!_mask.mouseEnabled || Context.variables["showBackRec"]) {
				return;
			}
			_mouseOut = false;
			addEventListener(MouseEvent.ROLL_OUT, mouseRollOut);
			if (!_list) {
				_list = new ControlBarDefBar();
				_list.addEventListener("changeDefName", changeDefName);
			}
			if (_list) {
				if (contains(_list)) {
					Ticker.stop(closeList);
					if (hasEventListener(MouseEvent.ROLL_OUT)) {
						removeEventListener(MouseEvent.ROLL_OUT, mouseRollOut);
					}
					removeChild(_list);
				} else {
					_list.x = (width - _list.width) / 2;
					_list.y = - _list.height - 2;
//					_list.setDefInfo(FileVideoData(Global.videoData).getAllDef());
					_list.setDefInfo(FileVideoData((Context.getContext(ContextEnum.VIDEO_MANAGER) as IVideoManager).data).getAllDef());
					addChild(_list);
					_timeOut = false;
					Ticker.tick(5000, timeOut);
				}
			}
		}
		
		private function mouseRollOut(evt:MouseEvent):void {
			_mouseOut = true;
			closeList();
		}
		
		private function timeOut():void {
			_timeOut = true;
			Ticker.stop(closeList);
			closeList();
		}
		
		private function closeList():void {
			if (_mouseOut) {
				if (_timeOut) {
					if (contains(_list)) {
						if (hasEventListener(MouseEvent.ROLL_OUT)) {
							removeEventListener(MouseEvent.ROLL_OUT, mouseRollOut);
						}
						removeChild(_list);
					}
				} else {
					Ticker.tick(1000, closeList);
				}
			}
		}
		
		private function changeDefName(evt:DataEvent):void {
			if(evt.data && evt.data.toString() != "")
			{
				setLabel(evt.data.toString());
			}
		}
		
		private function changeDefLabel(data:Object):void {
			if (data && data.hasOwnProperty("def") && _label && data["def"] != _label.text) {
				_label.text = Context.getContext(ContextEnum.SETTING).defName[data["def"]];
			}
		}
		
		private function resetMouseState(data:Object):void {
			_videoInit = true;
			setMouse(true);
		}
		
		private function onBIInitVideoInfo(data:Object):void {
			setMouse(false);
		}
		
		private function setMouse(value:Boolean):void {
			if (_videoInit){
				_mask.buttonMode = value;
				_mask.mouseChildren = value;
				_mask.mouseEnabled = value;
			} else {
				_mask.buttonMode = false;
				_mask.mouseChildren = false;
				_mask.mouseEnabled = false;
			}
//			this.buttonMode = value;
//			if (!value) {
//				var mat:Array = [0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0];
//				var colorMat:ColorMatrixFilter = new ColorMatrixFilter(mat);
//				this.filters = [colorMat];
//			} else {
//				this.filters = null;
//			}
		}
		
		/**
		 * 根据so中的def、自动网速测速、videoData里面的信息重新设置videoData的_defaultDef信息和so中的def
		 */
		private function resetDef(data:Object):void
		{
			_videoInit = false;
			var videoData:FileVideoData = data as FileVideoData;
//			var soDef:String = Global.settings.def;
			var soDef:String = getSoDef();
			var allDef:String = videoData.getAllDef();
//			var autoDef:String = Util.getAutoDef(Number(Global.settings.params["speed"]));
			var autoDef:String = getAutoDef();
			var def:String = "";
			var defName:String = "";
			Debugger.log(Debugger.INFO, "[defButton]清晰度状态 so:" + soDef + "  all:" + allDef + "   autoDef:" + autoDef + "   speed:");
			if (Context.variables.hasOwnProperty("def") && Context.variables["def"] && allDef.search(Context.variables["def"]) != -1) {
				//如果flashvars里面有设置，那么使用flashvars的
				def = Context.variables["def"];
				Debugger.log(Debugger.INFO, "[defButton] use flashvars");
			} else {
				if(soDef == "-1" || soDef.split(":").length < 2)
				{
					//兼容以前用户已经储存过def的情况，现在格式为“def：清晰度”
					useAutoDef();
				} else
				{
					var tempDef:String = soDef.split(":")[1];
					if(allDef.search(tempDef) != -1)
					{
						def = tempDef;
						Debugger.log(Debugger.INFO, "[defButton] use so:" + def);
					}
					else
					{
						useAutoDef();
					}
				}
			}
			
			function useAutoDef():void {
				def = videoData.defaultDef;
				if(allDef.search(autoDef) != -1)
				{
					def = autoDef;
					Debugger.log(Debugger.INFO, "[defButton] use auto:" + def);
				}
				else
				{
					def = videoData.defaultDef;
					Debugger.log(Debugger.INFO, "[defButton] use default:" + def);
				}
			}
			setDef(videoData, def, defName);
		}
		
		private function setDef(videoData:FileVideoData, def:String, name:String = ""):void
		{
			videoData.defaultDef = def;
//			Global.settings.def = def;
			Context.getContext(ContextEnum.SETTING)["def"] = def;
			if(name == "")
			{
				name = Context.getContext(ContextEnum.SETTING).defName[def];
			}
			else
			{
				name = name;
			}
			setLabel(name);
		}
		
		public function setLabel(value:String):void
		{
			_label.text = value;
		}
		
		public function resize():void
		{
			if(_label && contains(_label) && _defBtn_back)
			{
				_label.x = (_defBtn_back.width - _label.width) / 2;
				_label.y = (_defBtn_back.height - _label.height) / 2 - 1;
			}
		}
		
		private function showBackRec(data:Object):void {
			setMouse(false);
		}
		
		private function hideBackRec(data:Object):void {
			setMouse(true);
		}
		
		/**
		 * 直接内部跳转别的视频，重新获取清晰度
		 */		
		private function reGetSoDef(data:Object):void {
			var cookie:Cookies = new Cookies("shared", "/");
//			Global.settings.def = String(cookie.get("def"));
			Context.getContext(ContextEnum.SETTING)["def"] = String(cookie.get("def"));
			Context.variables["def"] = cookie.get("def");
			setMouse(false);
		}
		
		override public function get height():Number {
			return _defBtn_back.height;
		}
		
		/**
		 * 获取默认清晰度
		 */		
		private function getAutoDef():String {
			if (Context.variables["type"] == PlayerType.F_ZHANWAI) {
				return Util.getAutoDef(32);//站外暂时使用
			} else  {
				return Util.getAutoDef(35);//由于测速不准确,所以默认使用高清
			}
		}
		
		/**
		 * 获取so中清晰度
		 */		
		private function getSoDef():String {
			if (Context.variables["type"] == PlayerType.F_ZHANWAI) {
				return "-1";//站外暂时使用
			} else  {
				return Context.getContext(ContextEnum.SETTING)["def"];
			}
		}
		
		
	}
}