package com._17173.flash.show.base.context.errorrecord
{

	public class ErrorRecordType
	{
		public function ErrorRecordType()
		{
		}
		/***************************************推流********************************************/
		/**
		 *调度失败 (推流)
		 */
		public static const PUSH_GSLB_ERROR:String = "1001";
		/**
		 *链接失败 (推流)
		 */
		public static const PUSH_CONN_ERROR:String = "1002";
		/**
		 *流链接失败 (推流)
		 */
		public static const PUSH_STREAM_ERROR:String = "1003";
		/**
		 * 分发失败 (推流)
		 */
		public static const PUSH_FENFA_ERROR:String = "1004";
		/**
		 *链接关闭 (推流)
		 */
		public static const PUSH_CONN_CLOSE_ERROR:String = "1005";
		/**
		 *链接权限失败 (推流)
		 */
		public static const PUSH_CONN_REJECTED_ERROR:String = "1006";
		/**
		 * 流关闭 (推流)
		 */
		public static const PUSH_STREAM_CLOSE_ERROR:String = "1007";
		/**
		 *流权限不足 (推流)
		 */
		public static const PUSH_STREAM_REJECTED_ERROR:String = "1008";
		
		/***************************************推流 END********************************************/
		
		
		/***************************************拉流 ********************************************/
		/**
		 * 调度失败(拉流)
		 */
		public static const LIVE_GSLB_ERROR:String = "2001";
		/**
		 * 链接失败(拉流)
		 */
		public static const LIVE_CONN_ERROR:String = "2002";
		/**
		 * 流链接失败(拉流)
		 */
		public static const LIVE_STREAM_ERROR:String = "2003";
		/**
		 * 链接关闭(拉流)
		 */
		public static const LIVE_CONN_CLOSE_ERROR:String = "2005";
		/**
		 * 链接权限不足(拉流)
		 */
		public static const LIVE_CONN_REJECTED_ERROR:String = "2006";
		/**
		 * 流关闭(拉流)
		 */
		public static const LIVE_STREAM_CLOSE_ERROR:String = "2007";
		/**
		 * 流权限不足(拉流)
		 */
		public static const LIVE_STREAM_REJECTED_ERROR:String = "2008";
		/**
		 * 定时监测是否流不接收新数据 (拉流)
		 */
		public static const LIVE_TIMEOUT_ERROR:String = "2009";

	}
}
