package com._17173.flash.show.base.context.user
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.context.authority.AuthorityStaitc;
	import com._17173.flash.show.base.utils.Utils;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	
	/**
	 * 用户数据.
	 *  
	 * @author shunia-17173
	 */	
	public class UserData implements IUserData
	{
		
		private var _sourceData:Object = null;
		
		private var _id:String = null;
		private var _level:int = 0;
		private var _name:String = null;
		private var _head:String = null;
		private var _type:int = 0;
		private var _jinbi:int = 0;
		private var _jindou:int = 0;
		private var _starLevel:String = null;
		private var _richLevel:String = null;
		private var _isAdmin:Boolean = false;
		private var _role:Array = [];
		private var _vip:int = 0;
		private var _userType:int = -1;
		private var _auth:Array = [];
		private var _hidden:int = 0;
		private var _masterNo:String = "";
		private var _agent:int;
		private var _fanOffset:String = null;
		private var _masterOffset:String = null;
		private var _nextFanLevel:String = null;
		private var _nextMasterLevel:String = null;
		private var _userIp:String = null;
		//扩展信息
		private var _extInfo:Object = null;
		private var _isWeak:Boolean = true;
		
		public function get extInfo():Object
		{
			return _extInfo;
		}

		public function set extInfo(value:Object):void
		{
			_extInfo = value;
		}

		public function get fanOffset():String
		{
			// TODO Auto Generated method stub
			return _fanOffset;
		}
		
		public function get masterOffset():String
		{
			// TODO Auto Generated method stub
			return _masterOffset;
		}
		
		public function get nextFanLevel():String
		{
			// TODO Auto Generated method stub
			return _nextFanLevel;
		}
		
		public function get nextMasterLevel():String
		{
			// TODO Auto Generated method stub
			return _nextMasterLevel;
		}
		
		public function get isWeak():Boolean
		{
			return this._isWeak;
		}
		
		public function set isWeak(bool:Boolean):void
		{
			//是否被用户列表真人同步过
			if(!bool&&_isWeak)
			{
				_isWeak = false;
			}
		}
		
		/**
		 * 用户列表排序依据 越大越靠前
		 */		
		private var _sortNum:Number;
		
		public function UserData(data:Object = null,_isWeak:Boolean = true)
		{
			this.isWeak = _isWeak;
			updateData(data);
		}
		/**
		 * 隐身状态 
		 * @return 
		 * 
		 */		
		public function get hidden():Boolean
		{
			return (_hidden==1);
		}
		
		public function get sortNum():Number
		{
			return this._sortNum;
		}
		
		public function set sortNum(value:Number):void
		{
			this._sortNum = value;
		}
		
		public function get jinbi():int
		{
			return _jinbi;
		}
		
		public function get jindou():int
		{
			return _jindou;
		}
		
		
		public function get richLevel():String
		{
			return _richLevel;
		}
		
		public function get starLevel():String
		{
			return _starLevel;
		}
		
		/**
		 * 用户id.
		 *  
		 * @return 
		 */		
		public function get id():String {
			return _id;
		}
		
		public function get masterNo():String
		{
			return this._masterNo=="0"?"":this._masterNo;
		}
		
		/**
		 * 用户财富等级.
		 *  
		 * @return 
		 */		
		public function get level():int {
			return _level;
		}
		
		/**
		 * 头像地址.
		 *  
		 * @return 
		 */		
		public function get head():String {
			return _head;
		}
		
		/**
		 * 用户类型.
		 *  
		 * @return 
		 */		
		public function get type():int {
			return _type;
		}
		
		public function get agent():Boolean
		{
			return _agent == 1;
		}
		/**
		 * 用户是否是经纪人（房主） 
		 * @return 
		 * 
		 */		
		public function get broker():Boolean
		{
			return this._role.indexOf("1")>=0;
		}
		/**
		 * 用户是否是助理（副房主） 
		 * @return 
		 * 
		 */		
		public function get assistant():Boolean
		{
			return this._role.indexOf("2")>=0;
		}
		/**
		 * 用户是否是艺人 (主播) 
		 * @return 
		 * 
		 */		
		public function get artist():Boolean
		{
			return this._role.indexOf("3")>=0;
		}
		/**
		 * 用户是否是房间管理员 
		 * @return 
		 * 
		 */		
		public function get normalAdmin():Boolean
		{
			return this._role.indexOf("4")>=0;
		}
		/**
		 * 用户名.
		 *  
		 * @return 
		 */		
		public function get name():String {
			return _name;
		}
		
//		public function set id(value:String):void {
//			_id = value;
//		}
//
//		public function set level(value:int):void {
//			_level = value;
//		}
//
//		public function set name(value:String):void {
//			_name = value;
//		}
		
		public function get isLogin():Boolean {
			return Number(_id) > 0;
		}
		
		/**
		 * 是否是巡管
		 */		
		public function get isAdmin():Boolean
		{
			return _isAdmin;
		}
		
//		public function set isAdmin(value:Boolean):void
//		{
//			_isAdmin = value;
//		}
		
		/**
		 * 权限列表
		 * OWNER(1), SUB(2), MASTER(3), ADMIN(4);
		 *	 室主                副室主             主播                 管理员
		 */		
		public function get role():Array
		{
			return _role;
		}
		
		
//		public function set role(value:Array):void
//		{
//			_role = value;
//		}
		
		/**
		 * vip等级
		 * 1紫色// 2黄色
		 */		
		public function get vip():int
		{
			return _vip;
		}
		
//		public function set vip(value:int):void
//		{
//			_vip = value;
//		}
		
		//5假人、10巡官、20游客、30普通用户
		public function get userType():int
		{
			return _userType;
		}
		
//		public function set userType(value:int):void
//		{
//			_userType = value;
//		}
		
		//用户权限（权限判断中使用）
		public function get auth():Array
		{
			return _auth;
		}
		
//		public function set auth(value:Array):void
//		{
//			_auth = value;
//		}
		private function updateData(data:Object):void{
			if (data) {
				//记录更新之前的权限
				_sourceData = data;
				//用户id
				_id = p(_id, _sourceData, "userId");
				//				_id = data.masterId;
				//用户靓号
				_masterNo=p(_masterNo,_sourceData,"masterNo");
				//_masterNo=data.masterNo;
				//用户昵称
				_name = Utils.formatToString(p(_name ? _name : _id, _sourceData, "userName"));
				//				_name = data.masterNick;
				//用户头像
				_head = p(_head, _sourceData, "icon");
				//				_head = data.icon;
				//金币
				_jinbi = p(_jinbi, _sourceData, "jinbi");
				//				if(data.jinbi != null){
				//					_jinbi = data.jinbi;
				//				}
				//隐身状态
				_hidden = p(_hidden, _sourceData, "hidden");
				//排序order
				_sortNum = p(_sortNum, _sourceData, "sortNum");
				
				//用户IP
				_userIp = p(_userIp, _sourceData, "ip")
				
				//金豆
				_jindou = p(_jindou, _sourceData, "jindou");
				//				if(data.jindou){
				//					_jindou = data.jindou;
				//				}
				//艺人等级
				_starLevel = p(_starLevel, _sourceData, "masterLevel");
				//				if(data.masterLevel){
				//					_starLevel = data.masterLevel;
				//				}
				//财富等级
				_richLevel = p(_richLevel, _sourceData, "fanLevel");
				//				if(data.fanLevel){
				//					_richLevel = data.fanLevel;
				//				}
				_userType = p(_userType, _sourceData, "userType");
				//				if (data.userType) {
				//					_userType = int(data.userType);
				//				}
				_agent = p(_agent, _sourceData, "agent");
				//财富等级升级差距
				_fanOffset  = p(_fanOffset, _sourceData, "fanOffset");
				//主播等级升级差距
				_masterOffset  = p(_masterOffset, _sourceData, "masterOffset");
				//财富下级等级
				_nextFanLevel  = p(_nextFanLevel, _sourceData, "nextFanLevel");
				//主播下级等级
				_nextMasterLevel  = p(_nextMasterLevel, _sourceData, "nextMasterLevel");
				//是否是巡管(5假人、10巡官、20游客、30普通用户)
				if(data.userType){
					_isAdmin = _userType == 10 ? true : false;
				}
				
				if(_sourceData.hasOwnProperty("extraInfo")){
					try{
						var str:String = _sourceData["extraInfo"]; 
						if(str && str != ""){
							_extInfo = JSON.parse(_sourceData["extraInfo"]);
						}
					}catch(e:Error){
						Debugger.log(Debugger.INFO,"[用户JSON解析错误]",_sourceData["extraInfo"])
					}
				}
				
				//vip类型 1是紫v，2是黄v
				_vip = p(_vip, _sourceData, "vipType");
				//权限列表
				var r:* = p([], _sourceData, "roomRole");
				if (_sourceData.hasOwnProperty("roomRole") && _sourceData["roomRole"]) {
					_role = r is String ? (r as String).split(",") : [];
				}
			}
		}
		/**
		 * 更新用户数据.
		 *  
		 * @param data
		 */		
		internal function update(data:Object,_isWeak:Boolean = true):void {
			this.isWeak = _isWeak;
			updateData(data);
			if(data){
				dispatchDataUpdate();
			}
		}
		
		/**
		 * 更新权限.
		 *  
		 * @param data
		 */		
		internal function dispatchDataUpdate():void {
			var lastAuth:Array = getAuthority(this);
			_auth = getAuthority(this);
			checkAuthority(lastAuth, _auth);
			//发送用户数据更新事件
			Context.getContext(CEnum.EVENT).send(SEvents.USER_DATA_UPDATE, _id);
		}
		
		private function p(value:*, data:Object, key:String, replace:Boolean = false):* {
			if (data.hasOwnProperty(key)) {
				return data[key];
			} else {
				if (replace) {
					return null;
				} else {
					return value;
				}
			}
		}
		
		/**
		 * 根据用户信息判断用户的用户权限组
		 * @param user 用户信息vo
		 * @return 权限数组
		 */		
		private function getAuthority(user:IUserData):Array {
			var re:Array = [];
			if (!user.isLogin) {
				//游客
				re.push(AuthorityStaitc.USER_1);
				return re;
			} else {
				//登录用户
				re.push(AuthorityStaitc.USER_2);
			}
			if (user.isAdmin) {
				//巡管
				re.push(AuthorityStaitc.USER_7);
			}
			if (user.role.indexOf("1") != -1) {
				//房主
				re.push(AuthorityStaitc.USER_3);
			}
			if (user.role.indexOf("2") != -1) {
				//副房主
				re.push(AuthorityStaitc.USER_4);
			}
			if (user.role.indexOf("3") != -1) {
				//主播
				re.push(AuthorityStaitc.USER_6);
			}
			if (user.role.indexOf("4") != -1) {
				//房间管理员
				re.push(AuthorityStaitc.USER_5);
			}
			if (user.vip == 1) {
				//紫色vip
				re.push(AuthorityStaitc.USER_9);
			} else if (user.vip == 2) {
				//黄色vip
				re.push(AuthorityStaitc.USER_8);
			}
			return re;
		}
		
		/**
		 * 检查用户权限是否改变，如果改变派发权限改变事件
		 * @param old 改变前的权限
		 * @param ne 改变后的权限
		 */		
		private function checkAuthority(old:Array, ne:Array):void {
			var change:Boolean = false;
			if (old.length != ne.length) {
				change = true;
			} else {
				for(var i:int = 0; i < ne.length; i++) {
					if (old.indexOf(ne[i]) == -1) {
						change = true;
						break;
					}
				}
			}
			if (change) {
				Context.getContext(CEnum.EVENT).send(SEvents.USER_AUTH_CHANGED,_id);
			}
		}
		
		public function get userIp():String
		{
			// TODO Auto Generated method stub
			return _userIp;
		}
		
	}
}