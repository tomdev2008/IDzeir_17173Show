package com._17173.flash.player.test
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.core.video.VideoSupport;
	
	public class TestMain
	{
		public function TestMain()
		{
			testStageVideoSupport();
		}
		
		private function testStageVideoSupport():void {
			Debugger.tracer("[test] stage video support: [version]", VideoSupport.fpVersionSupportStageVideo(), " [available]", VideoSupport.hasStageVideo(Context.stage));
		}
		
	}
}