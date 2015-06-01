package com._17173.flash.player.ad_refactor.delegate
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.ad_refactor.AdData_refactor;
	import com._17173.flash.player.ad_refactor.display.AdDisplay_error;
	import com._17173.flash.player.ad_refactor.display.IAdDisplay_refactor;

	/**
	 * 广告出错逻辑,在前贴展现完成前的所有广告异常,都应该会被导向这里.</br>
	 * 出错后的逻辑为优先展示百度广告,如果百度广告展现出错,则正式展现屏蔽界面.
	 *  
	 * @author 庆峰
	 */	
	public class AdDelegate_error extends BaseAdDelegate
	{
		
		public function AdDelegate_error()
		{
		}
		
		override protected function init():void {
			// 启动百度广告
			// 百度广告正常播放完成,调用complete结束
			// 百度广告也错误,展示error界面并等待结束
			startAdBaidu(
				complete, 
				function (e:Object = null):void {
					showErrorPage(complete, error);
				});
		}
		
		protected function startAdBaidu(r:Function, e:Function):void {
			Debugger.log(Debugger.INFO, "[ad]", "广告出错,开始展现第三方广告!");
			
			var delegate:IAdDelegate = new AdDelegate_qiantie();
			delegate.onComplete = 
				function ():void {
					Debugger.log(Debugger.INFO, "[ad]", "广告出错,播放第三方广告完毕!");
					if (r != null) {
						r.apply(null, null);
					}
				};
			delegate.onError = e;
			// 假数据
			var d:AdData_refactor = new AdData_refactor();
			d.url = "baidu";
			d.time = 20;
			d.totalTime = 20;
			delegate.data = d;
		}
		
		protected function showErrorPage(r:Function, e:Function):void {
			Debugger.log(Debugger.INFO, "[ad]", "广告出错,开始展现屏蔽页面!");
			
			var errorPanel:IAdDisplay_refactor = new AdDisplay_error();
			// 不管完成还是错误,都先移除面板,然后启动回调
			errorPanel.onComplete = function (oc:Object):void {
				_("uiManager").closePopup(errorPanel);
				r(oc);
			};
			errorPanel.onError = function (oe:Object):void {
				_("uiManager").closePopup(errorPanel);
				e(oe);
			};
			errorPanel.data = null;
			// 让popup层来管理它的缩放
			_("uiManager").popup(errorPanel);
		}
		
	}
}