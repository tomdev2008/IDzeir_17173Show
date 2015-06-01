package com._17173.flash.player.business.stream
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.util.time.Ticker;
	import com._17173.flash.core.video.source.VideoSourceInfo;
	import com._17173.flash.player.context.ContextEnum;
	import com._17173.flash.player.model.PlayerEvents;

	import flash.events.NetStatusEvent;

	import stream.XNetStreamLiveFactory;


	/**
	 *云成p2p
	 * @author zhaoqinghao
	 *
	 */
	public class YCP2PVideoSource extends StreamVideoSource
	{
		private var _streamFactory:XNetStreamLiveFactory;
		private const TIME_OUT:int = 10000;
		private const P2PINFO:String = "http://info.ppweb.com.cn/webp2p/linfo/17173.php";

		public function YCP2PVideoSource(loadToStart:int)
		{
			super(loadToStart);
		}

		/**
		 *p2p创建链接 需要先请求p2p接口地址，成功后才能进行链接
		 *
		 */
		override public function connect(conntionURL:String = null, streamURL:String = null, streamInvoke:Function = null, faultRetryTime:int = 3):void
		{
			_connectionURL = conntionURL;
			_streamURL = streamURL;
			_invokeFunc = streamInvoke;
			initStreamFactory();
		}

		/**
		 *初始化p2p接口
		 *
		 */
		private function initStreamFactory():void
		{
			_streamFactory = new XNetStreamLiveFactory(onDataComplete, P2PINFO); // 云成配置 合作方无需变更
			_streamFactory.load();
		}

		/**
		 *数据返回完毕可以进行获取stream
		 *
		 */
		private function onDataComplete():void
		{
			if (_streamFactory.isSuccess)
			{
				initStream();
			}
			else
			{
				//派发p2p接口失败，需要更换为正常播放地址
				Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_P2P_FAIL);
			}
		}

		override protected function initStream():void
		{
			//通过云成构造出stream
			_stream = _streamFactory.newNetStreamLive("17173live", "testchannel", 0);
			//监听事件
			handlerStreamEvents();
			Debugger.log(Debugger.INFO, "[stream]", "p2p视频流开始加载",_streamURL);

			//在播放地址后直接派发已链接事件
			invoke({"type": VideoSourceInfo.CONNECTED, "code": "NetConnection.Connect.Success"}, _streamURL);
			_stream.play(_streamURL);
			configStream();
			Ticker.tick(TIME_OUT,onMetaDataTimeOut);
		}

		override protected function onMetaData(info:Object = null):void
		{
			super.onMetaData(info);
		}

		override public function close():void
		{
			super.close();
		}


		override protected function onStreamHandler(event:NetStatusEvent):void
		{
			if (event.info.code == "NetStream.Play.Start") {
				//判断无效视频
				Ticker.stop(onMetaDataTimeOut);
			}
			super.onStreamHandler(event);
		}

		/**
		 *超时
		 *
		 */
		private function onMetaDataTimeOut(data:Object = null):void
		{
			Debugger.log(Debugger.INFO, "[stream]", "p2p视频流相应超时，转换非p2p");
			Context.getContext(ContextEnum.EVENT_MANAGER).send(PlayerEvents.BI_P2P_FAIL);
		}

		override protected function configStream():void
		{
			//临时解决花屏/绿屏现象,后续可以再优化
			_stream.bufferTime = 3;
			_stream.client = {"onMetaData": onMetaData, "onPlayStatus": onPlayStatus};
		}
	}
}
