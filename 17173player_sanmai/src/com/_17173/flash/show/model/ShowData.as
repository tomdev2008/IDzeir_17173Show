package com._17173.flash.show.model 
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.show.base.utils.Utils;

	/**
	 * 整个房间的大数据
	 *  
	 * @author shunia-17173
	 */	
	public class ShowData
	{
		
		/**
		 * 三麦房类型定义 
		 */		
		private static const TYPE:String = "1";
		
		private var _ownerID:String = null
		private var _roomID:String = null;
		private var _cid:String = null;
		private var _ckey:String = null;
		private var _token:String = null;
		private var _liveID:String = null;
		private var _masterID:String = null;
		private var _roomName:String = null;
		/**
		 *公聊是否开启 
		 */		
		private var _publicChat:int = 0;
		/**
		 *礼物效果是否开启  
		 */		
		private var _giftShow:int = 0;
		/**
		 *本地设置礼物效果是否开启  0关闭,1开启(本地设置，不由服务器设置，所以默认值为1开启状态);
		 */		
		private var _selfGiftShow:int = 1;
			
		private var _memberCount:int = 0;
		/**
		 *公告信息 
		 */		
		private var _announcement:Object;
		/**
		 * 房间类型  0直接过，1收费 2密码
		 */		
		private var _limit:int = 0;
		private var _socketDomain:String = null;
		private var _socketPort:int = 0;
		//房间状态 isShow 房间开启状态  0是关闭  1是开启
		private var _roomStatus:int = 0;
		
		private var _order:Object = {"1":null ,"2":null,"3":null};
		
		private var _camInit:Boolean = false;
		
		private var _userPrivateChatStatus:Boolean = true;
		
		private var _roomLiveId:String = "";
		
		private var _majorVersion:Number;
		private var _majorRevision:Number;
		private var _roomInfo:Object = null;
		public function ShowData()
		{
		}
		
		public function get ownerID():String
		{
			return _ownerID;
		}

		public function update(data:Object):void {
			//http://show.17173.com/pls_close.action?liveId=411007&closeCode=2
			//房间id
			_roomID = Context.variables["roomId"];
			var liveInfo:Object = data.liveInfo;
			var userInfo:Object = data.userInfo;
			var chatInfo:Object = data.chatInfo;
			var troomInfo:Object = data.roomInfo;
			_roomInfo = troomInfo;
			//			breaking 0是正常  1是断开
//			_order = liveInfo.order;
			//房间状态 isShow 房间开启状态  0是关闭  1是开启
			_roomStatus = roomInfo.isShow;
			
			_roomLiveId = liveInfo.roomLiveId;
			//视频id
			_cid = liveInfo.cId;
			//视频ckey
			_ckey = liveInfo.ckey;
			//是否被禁止
			_limit = liveInfo.limit;
			//连接聊天用的token
			_token = liveInfo.token;
			//当前用户
			_masterID = userInfo.userId;
			//房间信息
			if(roomInfo){
				//房间名
				_roomName = roomInfo.name;
				//公告信息
				_announcement ={text:roomInfo.text,link:roomInfo.link};
				if(roomInfo.masterId)_ownerID = String(roomInfo.masterId);
			}
			if(liveInfo.roomLiveId == 0){
				_roomStatus = 0;
			}
			_publicChat = liveInfo.publicChat;
			_giftShow = liveInfo.giftShow;
			
			//socket
			_socketDomain = chatInfo.chatNodeIp;
			_socketPort = chatInfo.chatNodePort;
			
			var array:Array = Utils.getFlashVersion();
			_majorVersion = parseInt(array[0]);
			_majorRevision = parseInt(array[1]);
		}
		/**
		 *检测是否需要派发事件 
		 * @param roomInfo
		 * 
		 */		
		protected function checkAndSendEvent(roomInfo:Object):void{
			//判断是否需要发送聊天区事件
			if(roomInfo && roomInfo.hasOwnProperty("enterEffect") && roomInfo.enterEffect==1){
				//发送聊天区特殊显示动画
				Context.getContext(CEnum.EVENT).send(SEvents.ADD_INFO_TO_CHAT,{info:"您来到的是中秋节活动冠军-嫦娥仙子"+_roomName+"的房间！",color:"#66FF00"});
				
				//驻场动画
				var obj:Object = {};
				obj.enterEffect = roomInfo.enterEffect;
				obj.enterEffectType = roomInfo.enterEffectType;
				obj.enterEffectSwfKey = roomInfo.enterEffectSwfKey;
				obj.enterEffectPath = roomInfo.enterEffectPath;
				Context.getContext(CEnum.EVENT).send(SEvents.SCENE_EFFECT,obj);
				
			}
			
			
		}
		
		public function supportH264():Boolean 
		{
			return (_majorVersion >= 11);
		}
		
		public function supportEnhanceMic():Boolean 
		{
			return (_majorVersion > 10 || (_majorVersion == 10 && _majorRevision >= 3));
		}
		
		public function getMicData():Array{
			var array:Array = new Array();
			for(var i:int = 1; i <= 3;i++){
				var obj:Object = this.order[i];
				if(obj){
					array.push(obj);
				}else{
					array.push(null);
				}
			}
			return array;
		}
		
		public function get roomLiveId():String
		{
			return _roomLiveId;
		}

		public function set roomLiveId(value:String):void
		{
			_roomLiveId = value;
		}

		/**
		 * 用户自己公聊状态 
		 */
		public function get userPrivateChatStatus():Boolean
		{
			return _userPrivateChatStatus;
		}

		/**
		 * @private
		 */
		public function set userPrivateChatStatus(value:Boolean):void
		{
			_userPrivateChatStatus = value;
		}

		public function get camInit():Boolean
		{
			return _camInit;
		}

		public function set camInit(value:Boolean):void
		{
			_camInit = value;
		}

		public function get micIndex():int{
			var micIndex:int = -1;
			for(var i:int = 1; i<=3; i++){
				var obj:Object = order[i];
				if(obj && obj.masterId == masterID){
					micIndex = i;
					break;
				}
			}
			return micIndex;
		}
		
		/**
		 *自己是否开启礼物效果 （0 关闭，1开启）;
		 */
		public function get selfGiftShow():int
		{
			return _selfGiftShow;
		}

		/**
		 * @private
		 */
		public function set selfGiftShow(value:int):void
		{
			_selfGiftShow = value;
		}

		/**
		 *礼物效果（0 关闭，1开启）; 
		 */
		public function get giftShow():int
		{
			return _giftShow;
		}

		/**
		 * @private
		 */
		public function set giftShow(value:int):void
		{
			_giftShow = value;
		}

		/**
		 * 如果服务器是不允许开,则不开
		 * 如果服务器允许开,但是本地不允许开,则不开
		 *  
		 * @return 
		 */		
		public function get showGift():Boolean {
			return _giftShow != 0 && _selfGiftShow != 0;
		}
		
		/**
		 *公聊状态（0 关闭，1开启）; 
		 */
		public function get publicChat():int
		{
			return _publicChat;
		}

		/**
		 * @private
		 */
		public function set publicChat(value:int):void
		{
			_publicChat = value;
		}

		public function get order():Object
		{
			return _order;
		}

		public function set order(value:Object):void
		{
			_order = value;
		}

		public function get roomStatus():int
		{
			return _roomStatus;
		}

		public function set roomStatus(value:int):void
		{
			_roomStatus = value;
		}

		/**
		 *公告 
		 */
		public function get announcement():Object
		{
			return _announcement;
		}

		/**
		 * @private
		 */
		public function set announcement(value:Object):void
		{
			_announcement = value;
		}

		public function get memberCount():int
		{
			return _memberCount;
		}

		public function set memberCount(value:int):void
		{
			_memberCount = value;
		}

		public function get roomName():String
		{
			return _roomName;
		}

		public function set roomName(value:String):void
		{
			_roomName = value;
		}

		public function get roomID():String
		{
			return _roomID;
		}

		public function set roomID(value:String):void
		{
			_roomID = value;
		}

		public function get cid():String
		{
			return _cid;
		}

		public function set cid(value:String):void
		{
			_cid = value;
		}

		public function get ckey():String
		{
			return _ckey;
		}

		public function set ckey(value:String):void
		{
			_ckey = value;
		}

		public function get token():String
		{
			return _token;
		}

		public function set token(value:String):void
		{
			_token = value;
		}

		public function get liveID():String
		{
			return _liveID;
		}

		public function set liveID(value:String):void
		{
			_liveID = value;
		}

		public function get masterID():String
		{
			return _masterID;
		}

		public function set masterID(value:String):void
		{
			_masterID = value;
		}

		public function get limit():int
		{
			return _limit;
		}

		public function set limit(value:int):void
		{
			_limit = value;
		}

		public function get socketDomain():String
		{
			return _socketDomain;
		}

		public function get socketPort():int
		{
			return _socketPort;
		}
		public function get roomInfo():Object
		{
			return _roomInfo;
		}
		
		public function set roomInfo(value:Object):void
		{
			_roomInfo = value;
		}
		/**
		 * 房间类型:三麦
		 *  
		 * @return 
		 */		
		public function get type():String {
			return TYPE;
		}

	}
}