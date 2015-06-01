package com._17173.flash.show.base.module.roomset.common
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.show.base.context.authority.AuthorityStaitc;
	import com._17173.flash.show.base.context.user.User;
	import com._17173.flash.show.base.module.bottombar.BottomEvents;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	import com._17173.flash.show.model.ShowData;
	
	import flash.utils.Dictionary;

	/**
	 *按钮管理类 
	 * @author zhaoqinghao
	 * 
	 */	
	public class BottomButtonManager
	{
		/**
		 *所有按钮 
		 */		
		private var _allButtons:Dictionary = null;
		/**
		 *本地化文件引用 
		 */		
		private var _ilocal:ILocale = null;
		/**
		 *默认按钮检测方法组 
		 */		
		private var _checkDefaultFunctions:Array;
		/**
		 *按钮检测方法组 
		 */		
		private var _checkFunctions:Array;
		/**
		 *初始化检测方法 
		 */		
		private var _initChecksFunction:Array;
		public function BottomButtonManager()
		{
			
			_ilocal = Context.getContext(CEnum.LOCALE) as ILocale;
			initButtons();
			initCheckUserFunctions();
		}
		
		
		private function initButtons():void{
			_allButtons = new Dictionary();
			var data1:ButtonBindData = new ButtonBindData(SEvents.CHANGE_ROOM_STATUS_CLICK, _ilocal.get("btn_label_openroom", "bottom"));
			var data2:ButtonBindData = new ButtonBindData(SEvents.CAMER_SHOW_CLICK, _ilocal.get("btn_label_opencar", "bottom"));
			var data3:ButtonBindData = new ButtonBindData(SEvents.REQUEST_MAI_CLICK, _ilocal.get("btn_label_actionmai", "bottom"));
			var data4:ButtonBindData = new ButtonBindData(BottomEvents.EDIT_GONGGAO, _ilocal.get("btn_label_changegg", "bottom"));
			var data5:ButtonBindData = new ButtonBindData(BottomEvents.MOVE_USER, _ilocal.get("btn_label_moveuser", "bottom"));
			var data6:ButtonBindData = new ButtonBindData(SEvents.CHANGE_PUBLICCHAT_CLICK, _ilocal.get("btn_label_closepublic", "bottom"));
			var data7:ButtonBindData = new ButtonBindData(SEvents.CHANGE_ROOMGIFT_EFFECT_CLICK, _ilocal.get("btn_label_closegifteff", "bottom"));
			var data8:ButtonBindData = new ButtonBindData(SEvents.UPLOAD_OL_VIDEO_CLICK, _ilocal.get("btn_label_offline", "bottom"));
			_allButtons[data1.type] = data1;
			_allButtons[data2.type] = data2;
			_allButtons[data3.type] = data3;
			_allButtons[data4.type] = data4;
			_allButtons[data5.type] = data5;
			_allButtons[data6.type] = data6;
			_allButtons[data7.type] = data7;
			_allButtons[data8.type] = data8;
		}
		/**
		 *检测用户权限对应按钮组(如按钮数据order不设定，则按照检测顺序返回排列)（后期如果复杂可以修改为类检查）
		 * <br> 方法定义格式 参数：Object; 返回值：按钮数据（如果允许显示则返回 否 返回null）
		 */		
		private function initCheckUserFunctions():void{
			_checkFunctions = [checkOpenRoom, checkOpenCar, checkMai, checkGonggao,checkOffLineVideo, checkMoveUser, checkOpenPublic, checkOpenGiftEff];
			_initChecksFunction = [checkOpenRoom, checkOpenCar, checkGonggao,checkOffLineVideo, checkMoveUser, checkOpenPublic, checkOpenGiftEff];
		}

		
		/**
		 *添加按钮检测 (扩展用，暂时未用到)
		 * @param check
		 * @param type
		 * 
		 */		
		public function addCheckFunction(check:Function):void{
			if(check!=null && _checkFunctions.indexOf(check)<0){
				_checkFunctions.push(check);
			}
		}

		/**
		 *根据用户获取按钮 
		 * @param user
		 * @return 
		 * 
		 */		
		public function getButtonDatas(isInit:Boolean = false):Array{
			var result:Array = [];
			if(isInit){
				result = getButtonByCheckFunctions(_initChecksFunction);
			}else{
				result = getButtonByCheckFunctions(_checkFunctions);
			}			
			return result;
		}

		/**
		 *通过检测方法获得按钮组 
		 * @param checks
		 * @return 
		 * 
		 */		
		private function getButtonByCheckFunctions(checks:Array):Array{
			var buttonDatas:Array = [];
			var data:ButtonBindData;
			var check:Function;
			var len:int = checks.length;
			for (var i:int = 0; i < len; i++) 
			{
				check = checks[i] as Function;
				data = check();
				if(data != null){
					buttonDatas[buttonDatas.length] = data;
				}
			}
			return buttonDatas;
		}
		/**
		 *离线录像 
		 * @return 
		 * 
		 */		
		private function checkOffLineVideo():ButtonBindData{
			var user:User = Context.getContext(CEnum.USER) as User;
			var can:Boolean  = user.validateAuthority(user.me,AuthorityStaitc.THING_13).can;
//			Debugger.log(Debugger.INFO, "[BOTTOM_BUTTON]", "离线录像  : " + can,user.me.auth);
			var bdata:ButtonBindData
			var btnLabel:String;
			//判断用于是否转移观众
			if(can){
				bdata = _allButtons[SEvents.UPLOAD_OL_VIDEO_CLICK];
			}
			return bdata;
		}
		/**
		 *获取转移观众 
		 * 
		 */		
		private function checkMoveUser():ButtonBindData{
			var user:User = Context.getContext(CEnum.USER) as User;
			var can:Boolean  = user.validateAuthority(user.me,AuthorityStaitc.THING_14).can;
//			Debugger.log(Debugger.INFO, "[BOTTOM_BUTTON]", "转移观众 : " + can,user.me.auth);
			var bdata:ButtonBindData
			var btnLabel:String;
			//判断用于是否转移观众
			if(can){
				bdata = _allButtons[BottomEvents.MOVE_USER];
			}
			return bdata;
		}
		/**
		 *检查是否可以修改公告 
		 * @param data
		 * @return 
		 * 
		 */		
		private function checkGonggao():ButtonBindData{
			var user:User = Context.getContext(CEnum.USER) as User;
			var can:Boolean  = user.validateAuthority(user.me,AuthorityStaitc.THING_11).can;
//			Debugger.log(Debugger.INFO, "[BOTTOM_BUTTON]", "修改公告 : " + can,user.me.auth);
			var bdata:ButtonBindData
			var btnLabel:String;
			//判断用于是否修改公告
			if(can){
				bdata = _allButtons[BottomEvents.EDIT_GONGGAO];
			}
			return bdata;
		}
		
		/**
		 *检查是否可以上麦
		 * @param data
		 * @return 
		 * 
		 */		
		private function checkMai():ButtonBindData{
			var user:User = Context.getContext(CEnum.USER) as User;
			
			var can:Boolean  = user.validateAuthority(user.me,AuthorityStaitc.THING_38).can;
//			Debugger.log(Debugger.INFO, "[BOTTOM_BUTTON]", "是否可以上麦: " + can,user.me.auth);
			var bdata:ButtonBindData
			var btnLabel:String;
			//判断用于是否可以排麦
			var roomStatus:int;
			//判断用于是否可以开启摄像头 
			roomStatus = Context.variables["showData"].roomStatus;
			if(can &&  roomStatus == 1){
				bdata = _allButtons[SEvents.REQUEST_MAI_CLICK];
				var micStatus:int = user.getUserMicStatus(user.me.id);
				if(micStatus ==1){//是否排麦中
					btnLabel = _ilocal.get("btn_label_cancalmai", "bottom");
				}else if(micStatus == 2){//是否已经上麦
					btnLabel = _ilocal.get("btn_label_exitmai", "bottom");
				}else{ //上麦
					btnLabel = bdata.label;
				}
				bdata.label = btnLabel;
			}
			return bdata;
		}
		
		/**
		 *检查是否可以开启摄像头 
		 * @param data
		 * @return 
		 * 
		 */		
		private function checkOpenCar():ButtonBindData{
			var user:User = Context.getContext(CEnum.USER) as User;
			var can:Boolean  = user.validateAuthority(user.me,AuthorityStaitc.THING_38).can;
//			Debugger.log(Debugger.INFO, "[BOTTOM_BUTTON]", "是否可以开启摄像头: " + can,user.me.auth);
			var bdata:ButtonBindData
			var btnLabel:String;
			var roomStatus:int;
			//判断用于是否可以开启摄像头 
			roomStatus = Context.variables["showData"].roomStatus;
			if(can &&  roomStatus == 1){
				bdata = _allButtons[SEvents.CAMER_SHOW_CLICK];
				//开启摄像头 
			}
			return bdata;
		}
		/**
		 *检查房间是否开启 
		 * @return 
		 * 
		 */		
		private function checkOpenRoom():ButtonBindData{
			var user:User = Context.getContext(CEnum.USER) as User;
			var can:Boolean  = user.validateAuthority(user.me,AuthorityStaitc.THING_9).can;
//			Debugger.log(Debugger.INFO, "[BOTTOM_BUTTON]", "检查房间是否开启 : " + can,user.me.auth);
			var bdata:ButtonBindData
			var btnLabel:String;
			var roomStatus:int;
			//判断用于是否可以开启房间
			if(can){
				bdata = _allButtons[SEvents.CHANGE_ROOM_STATUS_CLICK];
				//判断当前房间状态是否已经开启(是否显示关闭房间) 0房间未开启 1房间已开启
				roomStatus = Context.variables["showData"].roomStatus;
				if(roomStatus == 0){
					btnLabel = bdata.label;
				}else{
					btnLabel = _ilocal.get("btn_label_closeroom", "bottom");
				}
				bdata.label = btnLabel;
			}
			return bdata;
		}
		
		/**
		 *检查是否可以显示开启关闭公聊按钮 
		 * @return 
		 * 
		 */		
		private function checkOpenPublic():ButtonBindData{
			var user:User = Context.getContext(CEnum.USER) as User;
			var can:Boolean  = user.validateAuthority(user.me,AuthorityStaitc.THING_12).can;
//			Debugger.log(Debugger.INFO, "[BOTTOM_BUTTON]", "开启关闭公聊 : " + can,user.me.auth);
			var bdata:ButtonBindData
			var btnLabel:String;
			//判断用于是否可以开启关闭公聊
			if(can){
				bdata = _allButtons[SEvents.CHANGE_PUBLICCHAT_CLICK];
				//当前是否已经关闭了公聊
				var publicChat:int = Context.variables["showData"].publicChat;
				if(publicChat == 1){
					btnLabel = bdata.label;
				}else{
					btnLabel = _ilocal.get("btn_label_openpublic", "bottom");
				}
				bdata.label = btnLabel;
			}
			return bdata;
		}
		/**
		 *检查是否可以关闭房间礼物效果 
		 * @param data
		 * @return 
		 * 
		 */		
		private function checkOpenGiftEff():ButtonBindData{
			var user:User = Context.getContext(CEnum.USER) as User;
			var can:Boolean  = user.validateAuthority(user.me,AuthorityStaitc.THING_37).can;
//			Debugger.log(Debugger.INFO, "[BOTTOM_BUTTON]", "关闭房间礼物效果 : " + can,user.me.auth);
			var bdata:ButtonBindData
			var btnLabel:String;
			//判断用于是否可以关闭房间礼物效果 
			if(can){
				bdata = _allButtons[SEvents.CHANGE_ROOMGIFT_EFFECT_CLICK];
				//标题设置
				var showData:ShowData = Context.variables["showData"] as ShowData;
				if(showData.selfGiftShow == 1){
					btnLabel = bdata.label;
				}else{
					btnLabel = _ilocal.get("btn_label_opengifteff", "bottom");
				}
				bdata.label = btnLabel;
			}
			return bdata;
		}
	}
}