package com._17173.flash.show.base.context.authority
{
	import com._17173.flash.core.context.IContextItem;
	import com._17173.flash.show.model.CEnum;
	
	/**
	 * 权限管理.
	 *  
	 * @author 安庆航
	 */	
	public class Authority implements IContextItem, IAuthority
	{
		public function Authority()
		{
		}
		
		public function get contextName():String
		{
			return CEnum.AUTHORITY;
		}
		
		public function startUp(param:Object):void
		{
		}
		
		/**
		 * type
		 * -1 ：游客
		 * 1：登录用户
		 * 2：房主
		 * 3：副房主
		 * 4：房间管理员
		 * 5：房间主播
		 * 6：巡管
		 * 7：黄色vip
		 * 8：紫色vip
		 */
		
		/**
		 * things
		 * 1:聊天字数
		 * 2:发言间隔时间 
		 * 3:私聊
		 * 4:拒绝私聊
		 * 5:发喇叭
		 * 6:送礼
		 * 7:申请房间
		 * 8:进入直播间
		 * 9:开启/关闭房间
		 * 10:查看房间公告
		 * 11:修改房间公告
		 * 12:关闭聊天
		 * 13:个人直播间离线录像
		 * 14:转移观众
		 * 15:自由上/下麦
		 * 16:抱麦
		 * 17:闭麦(原名：开启/关闭麦上声音)
		 * 18:增/删副房主
		 * 19:增/删主播 
		 * 20:增/删管理
		 * 21:盖章/被盖章
		 * 22:擦除印章
		 * 23:踢用户出房间
		 * 24:禁言用户
		 * 25:恢复发言
		 * 26:拉黑用户
		 * 27:删除黑名单
		 * 28:封IP
		 * 29:设置主播
		 * 30:设置房间管理员
		 * 31:撤销管理
		 * 32:公聊佩戴“主播”标识
		 * 33:公聊佩戴“管理”标识
		 * 34:隐身进入房间
		 * 35:购买紫色Vip
		 * 36:购买黄色色Vip
		 * 37:关闭礼物效果
		 * 38：开启摄像头(报麦，下麦)
		 * 39：移除麦序
		 * 40:一对一公聊
		 * 41:屏蔽一对一私聊(开启一对一私聊)
		 * 42：开始直播/结束直播（单麦用）
		 * 43: 下麦（单麦:巡官下别人麦  三麦：有权限的人下别人麦）
		 * 44: 是否是管理用户组
		 * 45: 是否是房主
		 */		
		
		private static const  _list:Object = 
			{
				"-1" : {//游客
					//操作
					"1" : {
						"limit" : {"min":10}
					},
					"2" : {
						"limit" : {"min":10}
					},
					"8" : {},
					"10" : {}
				},
				"1" : {//登录用户
					"1" : {
						"limit" : {"min":150}
					},
					"2" : {
						"limit" : {"min":3}
					},
					"3" : {
						"limit" : {"wealth":3,"list":[1,2,3,4,5,6,7,8]}
					},
					"4" : {},
					"5" : {},
					"6" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"7" : {},
					"8" : {},
					"10" : {},
					"21" : {},
					"22" : {},
					"35" : {
						"limit" : {"wealth":10}
					},
					"36" : {
						"limit" : {"wealth":3}
					},
					"38" : {},
					"40" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					}
				},
				"2" : {//房主
					"1" : {
						"limit" : {"min":150}
					},
					"2" : {
						"limit" : {"min":3}
					},
					"3" : {
						"limit" : {"wealth":0, "list":[1,2,3,4,5,6,7,8]}
					},
					"4" : {},
					"5" : {},
					"6" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"8" : {},
					"9" : {},
					"10" : {},
					"11" : {},
					"12" : {},
					"14" : {},
					"15" : {},
					"16" : {},
					"17" : {},
					"19" : {},
					"20" : {},
					"23" : {
						"limit" : {"list":[-1,1,3,4,5,7,8],"broadcaster":{"8":15}}
					},
					"24" : {
						"limit" : {"list":[-1,1,3,4,5,7,8]}
					},
					"25" : {
						"limit" : {"list":[-1,1,3,4,5,7,8]}
					},
					"29" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"30" : {
						"limit" : {"list":[1,4,5,7,8]}
					},
					"31" : {
						"limit" : {"list":[1,4,5,6,7,8]}
					},
					"32" : {},
					"35" : {
						"limit" : {"wealth":10}
					},
					"36" : {
						"limit" : {"wealth":3}
					},
					"38" : {},
					"39" : {
						"limit" : {"list":[-1,1,2,3,4,5,7,8]}
					},
					"40" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"41" : {
						"limit" : {"list":[1,2,3,4,5,7,8]}
					},
					"43" : {
						"limit" : {"list":[1,2,3,4,5,7,8]}
					},
					"44" : {},
					"45" : {}
				},
				"3" : {//副房主
					"1" : {
						"limit" : {"min":150}
					},
					"2" : {
						"limit" : {"min":3}
					},
					"3" : {
						"limit" : {"wealth":0, "list":[1,2,3,4,5,6,7,8]}
					},
					"4" : {},
					"5" : {},
					"6" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"7" : {},
					"8" : {},
					"9" : {},
					"10" : {},
					"11" : {},
					"12" : {},
					"14" : {},
					"15" : {},
					"16" : {},
					"17" : {},
					"19" : {},
					"20" : {},
					"23" : {
						"limit" : {"list":[-1,1,4,5,7]}
					},
					"24" : {
						"limit" : {"list":[-1,1,4,5,7,8]}
					},
					"25" : {
						"limit" : {"list":[-1,1,4,5,7,8]}
					},
					"29" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"30" : {
						"limit" : {"list":[1,4,5,7,8]}
					},
					"31" : {
						"limit" : {"list":[1,4,5,6,7,8]}
					},
					"32" : {},
					"35" : {
						"limit" : {"wealth":10}
					},
					"36" : {
						"limit" : {"wealth":3}
					},
					"38" : {},
					"39" : {
						"limit" : {"list":[-1,1,2,3,4,5,7,8]}
					},
					"40" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"41" : {
						"limit" : {"list":[1,2,3,4,5,7,8]}
					},
					"43" : {
						"limit" : {"list":[1,2,3,4,5,7,8]}
					},
					"44" : {}
				},
				"4" : {//房间管理员
					"1" : {
						"limit" : {"min":150}
					},
					"2" : {
						"limit" : {"min":3}
					},
					"3" : {
						"limit" : {"wealth":3, "list":[1,2,3,4,5,6,7,8]}
					},
					"4" : {},
					"5" : {},
					"6" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"7" : {},
					"8" : {},
					"10" : {},
					"23" : {
						"limit" : {"list":[-1,1]}
					},
					"24" : {
						"limit" : {"list":[-1,1,7,8]}
					},
					"25" : {
						"limit" : {"list":[-1,1,7,8]}
					},
					"33" : {},
					"35" : {
						"limit" : {"wealth":10}
					},
					"36" : {
						"limit" : {"wealth":3}
					},
					"38" : {},
					"40" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"44" : {}
				},
				"5" : {//房间主播
					"1" : {
						"limit" : {"min":150}
					},
					"2" : {
						"limit" : {"min":3}
					},
					"3" : {
						"limit" : {"wealth":0, "list":[1,2,3,4,5,6,7,8]}
					},
					"4" : {},
					"5" : {},
					"6" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"7" : {},
					"8" : {},
					"9" : {},
					"10" : {},
					"11" : {},
					"14" : {},
					"15" : {},
					"16" : {},
					"17" : {},
					"23" : {
						"limit" : {"list":[-1,1,4]}
					},
					"24" : {
						"limit" : {"list":[-1,1,4,7,8]}
					},
					"25" : {
						"limit" : {"list":[-1,1,4,7,8]}
					},
					"32" : {},
					"35" : {
						"limit" : {"wealth":10}
					},
					"36" : {
						"limit" : {"wealth":3}
					},
					"38" : {},
					"39" : {
						"limit" : {"list":[-1,1,2,3,4,5,7,8]}
					},
					"40" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"41" : {
						"limit" : {"list":[1,2,3,4,5,7,8]}
					},
					"43" : {
						"limit" : {"list":[1,2,3,4,5,7,8]}
					},
					"44" : {}
				},
				"6" : {//巡管
					"1" : {
						"limit" : {"min":150}
					},
					"2" : {
						"limit" : {"min":3}
					},
					"3" : {
						"limit" : {"wealth":0, "list":[1,2,3,4,5,6,7,8]}
					},
					"4" : {},
					"5" : {},
					"6" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"8" : {},
					"9" : {},
					"10" : {},
					"11" : {},
					"12" : {},
					"14" : {},
					"15" : {},
					"16" : {},
					"17" : {},
					"18" : {},
					"19" : {},
					"20" : {},
					"23" : {
						"limit" : {"list":[-1,1,2,3,4,5,7,8]}
					},
					"24" : {
						"limit" : {"list":[-1,1,2,3,4,5,7,8]}
					},
					"25" : {
						"limit" : {"list":[-1,1,2,3,4,5,7,8]}
					},
					"28" : {
						"limit" : {"list":[-1,1,2,3,4,5,7,8]}
					},
					"29" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"30" : {
						"limit" : {"list":[1,4,5,7,8]}
					},
					"31" : {
						"limit" : {"list":[1,4,5,7,8]}
					},
					"34" : {},
					"35" : {
						"limit" : {"wealth":10}
					},
					"36" : {
						"limit" : {"wealth":3}
					},
					"38" : {},
					"39" : {
						"limit" : {"list":[-1,1,2,3,4,5,7,8]}
					},
					"40" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"41" : {
						"limit" : {"list":[1,2,3,4,5,7,8]}
					},
					"43" : {
						"limit" : {"list":[1,2,3,4,5,7,8]}
					},
					"44" : {}
				},
				"7" : {//黄色vip
					"1" : {
						"limit" : {"min":150}
					},
					"2" : {
						"limit" : {"min":3}
					},
					"3" : {
						"limit" : {"wealth":3, "list":[1,2,3,4,5,6,7,8]}
					},
					"4" : {},
					"5" : {},
					"6" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"7" : {},
					"8" : {},
					"10" : {},
					"35" : {
						"limit" : {"wealth":10}
					},
					"36" : {
						"limit" : {"wealth":3}
					},
					"38" : {},
					"40" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					}
				},
				"8" : {//紫色vip
					"1" : {
						"limit" : {"min":150}
					},
					"2" : {
						"limit" : {"min":3}
					},
					"3" : {
						"limit" : {"wealth":3, "list":[1,2,3,4,5,6,7,8]}
					},
					"4" : {},
					"5" : {},
					"6" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"7" : {},
					"8" : {},
					"10" : {},
					"34" : {},
					"35" : {
						"limit" : {"wealth":10}
					},
					"36" : {
						"limit" : {"wealth":3}
					},
					"38" : {},
					"40" : {
						"limit" : {"list":[1,2,3,4,5,6,7,8]}
					},
					"41" : {
						"limit" : {"list":[1,2,3,4,5,7,8]}
					}
				}
			};
		
		/**
		 * 根据用户的权限数组获取对应的权限
		 * @param user 用户权限数组
		 * @param thing 可执行的操作
		 * @return 
		 */		
		public function getAuthorityInfo(user:Array, thing:String):Object {
			var re:Object = {};
			for (var i:int = 0; i < user.length; i++) {
				var userAuth:String = user[i];
				if (_list[userAuth] && _list[userAuth].hasOwnProperty(thing)) {
					//该用户是否有此权限
					if (re.hasOwnProperty("can")) {
						//如果返回值里已经存在
						if (_list[userAuth][thing] != null) {
							re["can"] = true;
							setLimit();
						}
					} else {
						if (_list[userAuth][thing] != null) {
							re["can"] = true;
							setLimit();
						} else {
							re["can"] = false;
							re["limit"] = null;
						}
					}
				} else {
					if (re.hasOwnProperty("can")) {
						if (re["can"]) {
							
						} else {
							re["can"] = false;
						}
					}
				}
			}
			return re;
			
			//设置limit参数
			//如果返回参数中已经存在就更新一下
			function setLimit():void {
				if (_list[userAuth] && _list[userAuth][thing] && _list[userAuth][thing].hasOwnProperty("limit")) {
					if (re.hasOwnProperty("limit")) {
						if (re["limit"]) {
							upDateLimit(re["limit"], _list[userAuth][thing]["limit"]);
						} else {
							re["limit"] = _list[userAuth][thing]["limit"];
						}
					} else {
						re["limit"] = _list[userAuth][thing]["limit"];
					}
				} else {
					if (re.hasOwnProperty("limit")) {
						
					} else {
						re["limit"] = _list[userAuth][thing]["limit"];
					}
				}
			}
		}
		
		/**
		 * 更新返回权限中limit
		 * @param old 第一个obj
		 * @param ne 第二个obj
		 * @return 合并之后的obj
		 * 
		 */		
		private function upDateLimit(old:Object, ne:Object):Object {
			var re:Object = old;
			if (old.hasOwnProperty("min") && ne.hasOwnProperty("min")) {
				if (int(ne["min"]) < int(old["min"])) {
					re["min"] = ne["min"];
				}
			}
			//如果都有财富等级，取小的那个(此处赋值为引用赋值后则会覆盖原有配置)
			if (old.hasOwnProperty("wealth") &&　ne.hasOwnProperty("wealth")) {
				if (int(ne["wealth"]) < int(old["wealth"])) {
					re["wealth"] = ne["wealth"];
				}
			}
			//如果都存在限制列表，将所有项合并，去重
			if (old.hasOwnProperty("list") &&　ne.hasOwnProperty("list")) {
				var alist:Array = old["list"] as Array;
				var blist:Array = ne["list"] as Array;
				
				re["list"] = arrConcat(alist, blist);
				//新数据的限制列表中是否存在特殊条件
				if (ne.hasOwnProperty("broadcaster")) {
					if (re.hasOwnProperty("broadcaster")) {
						for(var item:String in ne["broadcaster"]) {
							//判断返回的限制列表中是否存在相同的数据，如果存在，新的如果小于原来的则替换
							if (re["broadcaster"].hasOwnProperty(item)) {
								if (int(ne["broadcaster"][item]) < int(re["broadcaster"][item])) {
									re["broadcaster"][item] = ne["broadcaster"][item];
								}
							} else {//如果返回的限制列表中不存在该项，添加
								re["broadcaster"][item] = ne["broadcaster"][item];
							}
						}
					} else {
						re["broadcaster"] = ne["broadcaster"];
					}
				}
			}
			return re;
		}
		
		/**
		 * 将两个数组去重并合并
		 * @param old 旧数组
		 * @param ne 新数组
		 * @return 
		 * 
		 */		
		private function arrConcat(old:Array, ne:Array):Array {
			var tempList:Array = [];
			for (var i:int = 0; i < ne.length; i++) {
				var has:int = old.indexOf(ne[i]);
				if (has == -1) {
					tempList.push(ne[i]);
				}
			}
			return old.concat(tempList);
		}
	}
}