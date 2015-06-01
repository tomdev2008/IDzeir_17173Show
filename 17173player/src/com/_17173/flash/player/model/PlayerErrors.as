package com._17173.flash.player.model
{
	

	public class PlayerErrors
	{
		
		private static var dict:Object;
		
		/**
		 * 后台请求的默认成功代码,一般结构为 {code : "000000", msg : "message", data : {...}}
		 * 当code等于000000时认为成功,否则为数据出错(请求参数错误,或者后台数据出错) 
		 */		
		public static const HAND_SHAKE_SUCCESS_CODE:String = "000000";
		
		/**
		 * 一般为请求视频数据类型错误时候发出
		 * 例如:请求视频的信息错误
		 */
		public static const VIDEO_DISPATCH_URL_RETRIVE_FAIL:String = "视频调度失败!";
		/**
		 * 点播ns连接视频出错时候调用
		 */
		public static const VIDEO_FILE_CAN_NOT_CONNECT:String = "视频文件无法连接!";
		/**
		 * 直播ns连接视频出错时候调用
		 */
		public static const VIDEO_STREAM_CAN_NOT_CONNECT:String = "指定的视频流不存在!";
		/**
		 * 获取的视频文件不存在的时候调用
		 */
		public static const VIDEO_FILE_NOT_EXISTS:String = "视频文件不存在!";
		/**
		 * 获取视频推荐数据获取失败时候调用
		 */
		public static const VIDEO_RECOMMAND_RETRIVE_FAIL:String = "视频推荐数据获取失败!";
		/**
		 * 获取视频推荐数据结构错误时候调用
		 */
		public static const VIDEO_RECOMMAND_DATA_CORRUPTED:String = "视频推荐数据结构错误!";
		/**
		 * 视频数据被删除或者隐藏
		 */
		public static const VIDEO_DELETE_OR_HIDE:String = "视频被删除或者隐藏!";
		/**
		 * url请求io错误
		 */
		public static const DATA_IO_ERROR:String = "请求失败!";
		/**
		 * url请求返回内容错误调用
		 */
		public static const REQUEST_DATA_ERROR:String = "请求数据错误!";
		/**
		 * 前贴广告播放失败 
		 */		
		public static const AD_A2_ERROR:String = "广告无法播放!";
		/**
		 * 礼物数据调度出错 
		 */		
		public static const GIFT_DATA_ERROR:String = "礼物数据错误!";
		/**
		 * 直播间信息接口出错 
		 */		
		public static const LIVE_INFO_ERROR:String = "无法获取直播间数据!";
		/**
		 * 无效的cid或者ckey 
		 */		
		public static const STREAM_DISPATCH_PARAMETER_INVALID:String = "直播调度参数无效!";
		/**
		 * 直播不存在或者还没有可以使用的服务器 
		 */		
		public static const STREAM_DISPATCH_NO_SERVER:String = "直播调度请求不到服务器!";
		/**
		 * 请求直播数据时,gslb那边给过来的数据出错了 
		 */		
		public static const STREAM_SERVER_NOT_FOUND:String = "直播请求不存在!";
		
		public var error:String = "";
		public var id:String = "";
		public var msg:String = "";
		public var needErrorPanel:Boolean = false;
		
		public static function initDic():void {
			if(!dict) {
				dict = new Object();
				dict[VIDEO_DISPATCH_URL_RETRIVE_FAIL] = {"code":"0001", "needErrorPanle":true};
				dict[VIDEO_FILE_CAN_NOT_CONNECT]      = {"code":"0002", "needErrorPanle":true};
				dict[VIDEO_STREAM_CAN_NOT_CONNECT]    = {"code":"0003", "needErrorPanle":true};
				dict[VIDEO_FILE_NOT_EXISTS] = {"code":"0004", "needErrorPanle":true};
				dict[VIDEO_RECOMMAND_RETRIVE_FAIL] = {"code":"0005", "needErrorPanle":true};
				dict[VIDEO_RECOMMAND_DATA_CORRUPTED] = {"code":"0006", "needErrorPanle":true};
				dict[DATA_IO_ERROR] = {"code":"0007", "needErrorPanle":false};
				dict[REQUEST_DATA_ERROR] = {"code":"0008", "needErrorPanle":false};
				dict[AD_A2_ERROR] = {"code":"0009", "needErrorPanle":false};
				dict[GIFT_DATA_ERROR] = {"code":"0010", "needErrorPanle":false};
				dict[LIVE_INFO_ERROR] = {"code":"0011", "needErrorPanle":false};
				dict[STREAM_DISPATCH_PARAMETER_INVALID] = {"code":"0012", "needErrorPanle":true};
				dict[STREAM_DISPATCH_NO_SERVER] = {"code":"0013", "needErrorPanle":true};
				dict[STREAM_SERVER_NOT_FOUND] = {"code":"0014", "needErrorPanle":false};
				dict[VIDEO_DELETE_OR_HIDE] = {"code":"0015", "needErrorPanle":true};
			}
		}
		
		/**
		 * 打包一个error对象. 
		 * @param error
		 * @param code
		 * @param msg
		 * @return 
		 */		
		public static function packUpError(error:String, msg:String = ""):PlayerErrors {
			initDic();
			var temp:PlayerErrors = new PlayerErrors();
			temp.error = error;
			temp.id = dict[error]["code"];
			temp.msg = msg;
			temp.needErrorPanel = dict[error]["needErrorPanle"];
			return temp;
		}
	}
}