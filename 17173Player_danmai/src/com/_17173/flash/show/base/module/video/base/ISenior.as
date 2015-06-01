package com._17173.flash.show.base.module.video.base 
{
	import flash.media.Microphone; //类监视音频或从麦克风捕获音频。
	import flash.net.NetStream;
	
	public interface ISenior 
	{
		function setH264(ns:NetStream):NetStream;
		function setEnhanceMic(mic:Microphone):void;
		function getVideoCodecId():int;
		function getStreamWidth():int;
		function getStreamHeight():int;
		function getBandWidth():int;
	}
	
}