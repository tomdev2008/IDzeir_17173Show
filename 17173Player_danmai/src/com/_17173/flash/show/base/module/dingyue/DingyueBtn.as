package com._17173.flash.show.base.module.dingyue
{
	import com._17173.flash.core.components.common.Button;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.module.dingyue.ui.DingyueGotoNACPanel;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	[Event(name = "ButtonResieze", type = "flash.events.Event")];

	public class DingyueBtn extends Button
	{
		private var _mid:String = null;
		//0未关注  1关注
		private var _status:int = 0;
		private var _count:int = 0;
		private var _showCount:Boolean = false;
		private var _dyBtn:MovieClip;
		private var _udyBtn:MovieClip;
		private var _label1:TextField = null;
		private var _countTf:TextField = null;
		private var _cBg:MovieClip = null;
		private var _showFinshAlert:Boolean = true;
		private var _isSendGuide:Boolean = false;
		/**
		 *引导事件 
		 */		
		public static const DINGYUE_GUIDE:String = "dingyue_guide";
		/**
		 *引导事件重定位 
		 */		
		public static const DINGYUE_GUIDE_RP:String = "dingyue_guide_rp";
		/**
		 *关注按钮
		 * @param showCount 是否显示关注数量
		 * @param showAlert 请求成功时是否显示提示
		 */
		public function DingyueBtn(showCount:Boolean = true, showAlert:Boolean = true)
		{
			super("", false);
			_showFinshAlert = showAlert;
			_showCount = showCount;
			this.addEventListener(MouseEvent.CLICK, onClick);
			_dyBtn = new Btn_Dingyue();
			_udyBtn = new Btn_UnDingyue();

			var textf:TextFormat = new TextFormat(null, 14);
			textf.align = TextFormatAlign.CENTER;
			textf.font = FontUtil.f;
			_label1 = new TextField();
			_label1.x = 1;
			_label1.y = -1;
			_label1.textColor = 0xCCCCCC;
			_label1.setTextFormat(textf);
			_label1.defaultTextFormat = textf;
			_label1.width = 40;
			_label1.height = 22;
			_label1.text = "关注"
			_label1.mouseEnabled = false;
			this.addChild(_label1);

			_cBg = new Bg_dingyue();
			_cBg.gotoAndStop(1);
			_cBg.mouseEnabled = false;
			_cBg.x = 46;
			_cBg.y = 0;
			this.addChild(_cBg);

			var tfm:TextFormat = new TextFormat("Microsoft YaHei,微软雅黑,宋体",12,0xCCCCCC,true);
			tfm.align = TextFormatAlign.CENTER;
			_countTf = new TextField();
			_countTf.setTextFormat(tfm);
			_countTf.defaultTextFormat = tfm;
			_countTf.x = 51;
			_countTf.y = 2;
			_countTf.width = 25;
			_countTf.height = 20;
			_countTf.text = "0";
			_countTf.mouseEnabled = false;
			this.addChild(_countTf);
			addLsn();
			
			this.visible=false;
		}

		
		private function addLsn():void{
			((Context.getContext(CEnum.SERVICE))).socket.listen(SEnum.UPDATE_DINGYUE.action,SEnum.UPDATE_DINGYUE.type,updateCount);
		}
		
		
		private function updateCount(data:Object):void{
			try{
				data = data.ct;
				if(data.masterId == _mid && _showCount){
					_count = data.count;
					reInfo();
				}
			}catch(e:Error){
				Debugger.log(Debugger.ERROR,"[Dingyue]","更新数量返回数据错误");
			}
		}
		
		override protected function onShow():void{
			super.onShow();
//			sendShowGuide();
		}
		
		
		private function sendShowGuide():void{
			_isSendGuide = true;
//			var point:Point = this.parent.localToGlobal(new Point(this.x,this.y));
//			point.x += width/2;
//			if(_showCount){
//				(Context.getContext(CEnum.EVENT)).send(DINGYUE_GUIDE,point);
//			}
			}
		
		
		override protected function onResize(e:Event=null):void{
//			var point:Point = this.parent.localToGlobal(new Point(this.x,this.y));
//			point.x += width/2;
//			if(_showCount){
//				(Context.getContext(CEnum.EVENT)).send(DINGYUE_GUIDE_RP,point);
//			}
		}
		
		override protected function onOver(e:Event):void
		{
			super.onOver(e);
			if (_status == 1)
			{
				_label1.text =  "取消";
				_cBg.gotoAndStop(1);
//				setSkin(_dyBtn);
			}
		}

		override protected function onOut(e:Event):void
		{
			super.onOut(e);
			if (_status == 1)
			{
				_label1.text =  "已关注";
				_cBg.gotoAndStop(2);
//				setSkin(_dyBtn);
			}
		}

		/**
		 *初始化数据
		 * @param masterId 主播ID
		 * @param status 关注状态
		 * @param count 关注数量
		 *
		 */
		public function setData(masterId:String):void
		{
			_mid = masterId;
			getInfo();
			setSkin(_dyBtn);
//			if(sendShowGuide == false){
//				sendShowGuide();
//			}
		}

		private function getInfo():void
		{
			var server:Object = Context.getContext(CEnum.SERVICE);
			var data:Object = {};
			data.result = "json";
			data.subid = _mid;
			server.http.getData(SEnum.SUB_COUNT, data, onInfoSucc);
		}


		public function updateInfo():void
		{
			getInfo();
		}

		/**
		 *更新信息
		 *
		 */
		public function reInfo():void
		{
			var tlabel:String = "";
			if (_status == 0)
			{
				tlabel = "关注";
				setSkin(_dyBtn);
			}
			else
			{
				tlabel = "已关注";
				setSkin(_udyBtn);
				_cBg.gotoAndStop(2);
			}
			if (_showCount)
			{
				tlabel = tlabel;
			}
			_label1.text = tlabel;
			if(_count > 999999){
				_countTf.text = "999999+";
			}else{
				_countTf.text = _count.toString();
			}
			var len:int = _count.toString().length;
			if(_showCount){
				if(len <= 3){
					len = 3;
					_countTf.width = 25;
				}else if(len <=6){
					len = 6;
					_countTf.width = 48;
				}else{
					len = 7;
					_countTf.width = 56;
				}
				this.width = 58 + len * 8;
				_cBg.width = 10 + len * 8;
				_cBg.visible = true;
				_label1.width = 48;
			}else{
				this.width = 48;
				_cBg.width = 1;
				_countTf.width = 1;
				_cBg.visible = false;
				_label1.width = 47;
			}
		
			this.height = 22;
			this.resize(null);
			
			this.visible=true;
		}


		private function onClick(e:Event):void
		{
			var showData:Object = Context.variables["showData"];
			if(showData.masterID !=null && int(showData.masterID) > 0){
				
			}else{
				//打开登录
				(Context.getContext(CEnum.EVENT)as IEventManager).send(SEvents.LOGINPANEL_SHOW);
				return;
			}
			var server:Object = Context.getContext(CEnum.SERVICE);
			var data:Object = {};
			data.result = "json";
			data.subid = _mid;
			if (_status == 0)
			{
				server.http.getData(SEnum.SUB_DO, data, onDingYueSucc, onActionError);
			}
			else
			{
				server.http.getData(SEnum.SUB_UNDO, data, onTuiDingSucc, onActionError);
			}

		}

		private function onInfoSucc(obj:Object):void
		{
			if (obj && obj.hasOwnProperty("masterFanNum"))
			{
				_count = obj.masterFanNum;
			}
			if (obj && obj.hasOwnProperty("subStatus"))
			{
				_status = obj.subStatus;
			}
			reInfo();
		}
		/**
		 *关注成功返回 
		 * @param obj
		 * 
		 */
		private function onDingYueSucc(obj:Object):void
		{
			var msg:String = obj as String;
			
			if(msg == ""){//关注成功弹出查看版 
				var dysuc:DingyueGotoNACPanel = new DingyueGotoNACPanel(gotoDyInfo);
				dysuc.title  = "关注成功";
				//新手引导
//				(Context.getContext(CEnum.EVENT)as IEventManager).send(SEvents.TASK_SUBS_SUCCESS);

			}else{//失败弹出正常
				var _dyFail:DingyueNACPanel = new DingyueNACPanel();
				_dyFail.title  = msg;
				popupPanel(_dyFail);
			}
			_status = 1;
			reInfo();
//			changeCountToAction(true);
		}
		/**
		 *退订成功 
		 * @param obj
		 * 
		 */
		private function onTuiDingSucc(obj:Object):void
		{
			var msg:String = obj as String;
			var _dyFail:DingyueNACPanel = new DingyueNACPanel();
			_dyFail.title  = "取消关注成功";
//			popupPanel(_dyFail);
			_status = 0;
			reInfo();
//			changeCountToAction(false);
		}

		private function onActionError(obj:Object):void
		{

		}
		
		
		private function gotoDyInfo():void{
			//关注管理
			Util.toUrl(SEnum.SUB_VIEW);
		}

		/**
		 *改变用户关注数量
		 * @param isAdd 是否是添加一个
		 *
		 */
		private function changeCountToAction(isAdd:Boolean):void
		{
			if (isAdd)
			{
				_count++;
			}
			else
			{
				_count--;
			}
			reInfo();
		}
		
		private function popupPanel(ds:DisplayObject):void{
			Context.getContext(CEnum.UI).popupPanel(ds);
		}

	}
}
