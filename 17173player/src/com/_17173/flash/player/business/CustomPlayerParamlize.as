package com._17173.flash.player.business
{
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.player.model.PlayerType;

	/**
	 * 把点直播的企业版播放器参数处理逻辑进行整合.
	 * 正常情况下,使用config.action请求返回的数据处理参数化过程.
	 * 特殊情况下,会需要用flashvars来代替请求,提供参数化过程.
	 * 
	 * 目前的特殊情况包括:
	 *   17173域下
	 *  
	 * @author ShuniaHuang
	 */	
	public class CustomPlayerParamlize
	{
		
		/**
		 * 是否能接受flashvars参数 
		 * @return 
		 */		
		public static function acceptFlashvars():Boolean {
			return isDomain(_("refPage"), "17173.com");
		}
		
		/**
		 * 是否17173域名下
		 *  
		 * @return 
		 */		
		private static function isDomain(domain:String, search:String):Boolean {
			var r:String = domain;
			if (r) {
				var arr:Array = r.split("://");
				if (arr.length > 1) {
					arr = arr[1] ? arr[1].split("/") : null;
					if (arr && arr.length > 1) {
						return String(arr[0]).search(search) != -1;
					}
				}
			}
			return false;
		}
		
		public static function resolve(data:Object):Object {
			if (_("type") != PlayerType.S_CUSTOM && _("type") != PlayerType.F_CUSTOM) return null;
			
			// 解析结果
			var r:Object = null,
				// 代理方法, 因为 _ 实际上是一个方法,为了解析方式的一致性,需要将正常情况下的解析逻辑包装成方法
				d:Function = null;
			if (_("allowModuleParam") == true) {
				// 接受flashvars参数
				d = function (prop:String):Boolean {
					// trick
					// 因为下面指定的this参数是默认值,所以这里根据_里有没有指定的属性来确定应该是取默认值,还是指定的值
					var a:String = _(prop);
					var b:Boolean = a == null ? this : a == "1";
//					Debugger.log(Debugger.INFO, "[cp]", "p: " + prop + ", this: " + this + ", a: " + a + ", b: " + b);
					return b;
				};
			} else {
				// 不接受flashvars参数
				if (data) {
					d = function (prop:String):Boolean {
						return data.hasOwnProperty(prop) ? (data[prop] ? data[prop].visible : false) : false;
					};
				}
			}
			// 根据播放器类型选择解析方法
			var rsl:Function = 
				_("type") == PlayerType.S_CUSTOM ? resolveStream : 
								_("type") == PlayerType.F_CUSTOM ? resolveFile : null;
			if (rsl != null) {
				r = rsl.apply(null, [d]);
				
				// 特殊处理合作方logo的url参数
				if ((_("type") == PlayerType.S_CUSTOM && r["m2"]) ||
					(_("type") == PlayerType.F_CUSTOM && r["m3"])) {
					// 说明有合作方logo
					try {
						var lurl:String = _("allowModuleParam") ? _("hzu") : data["m2"].url;
						var ljump:String = _("allowModuleParam") ? _("hzj") : data["m2"].j;
						
						r["otherLogo"] = lurl;
						r["j"] = ljump;
					} catch (e:Error) {
						Debugger.log(Debugger.ERROR, "[customparam]", "合作方logo解析出错!");
					}
				}
			}
			
			var flv:Object = _("stage").loaderInfo.parameters;
			Debugger.log(Debugger.INFO, "[customparam]", "flashvars: " + JSON.stringify(flv));
			Debugger.log(Debugger.INFO, "[customparam]", "result: " + JSON.stringify(r));
			var a:Object = {};
			for (var k:String in flv) {
				a[k] = {"r": flv[k], "_": _(k)};
			}
			Debugger.log(Debugger.INFO, "[customparam]", "compare: " + JSON.stringify(a));
			
			return r;
		}
		
		/**
		 * 直播ui模块解析
		 * m1:17173Logo
		 * m2:合作Logo
		 * m3:水印
		 * m4:顶部搜索
		 * m5:播主房间
		 * m6:更多直播
		 * m7:弹幕
		 * m8:送礼 
		 * m9:分享
		 * m10:前贴
		 * m11:暂停
		 * m12:真全屏
		 * m13:假全屏
		 * m14:视频标题
		 * m15:后推
		 * m16:竞猜
		 * m17:秀场推广位
		 * 
		 * hzu:合作方logo图片地址 (需要编码)
		 * hzj:合作方logo跳转地址(需要编码)
		 */
		private static const StreamDefault:Array = 
			[true, false, true, true, true, true, true, true, true, true, true, false, true, true, true, false, false];
		private static function resolveStream(data:Function):Object {
			return resolveDelegate(data, "m", StreamDefault);
		}
		
		/**
		 * 辅助方法用来简化默认值和实际值的处理逻辑 
		 */		
		private static function resolveDelegate(data:Function, base:String, defaults:Array):Object {
			var f:Function = function ():Object {
				var r:Object = {}, 
					l:int = defaults.length, 
					b:String = base, 
					s:String = null, 
					d:Boolean = false, 
					h:Boolean = data == null ? false : true;
				for (var i:int = 1; i <= l; i ++) {
					s = b + i;
					// 取默认值
					d = defaults[i - 1];
					// trick
					// apply方法把d当做thisarg是为了让  _ 的代理闭包方法在遇到  _ 里没有相应属性的时候取默认值
					var c:Boolean = h ? data.apply(d, [s]) : d;
//					Debugger.log(Debugger.INFO, "[cp]", "c: " + c);
					r[s] = c;
				}
				return r;
			};
			return f();
		}
		
		/**
		 * 点播ui模块解析
		 * m1:顶部搜索
		 * m2:17173Logo
		 * m3:合作Logo 
		 * m4:侧边栏-评论 
		 * m5:侧边栏-移动版 
		 * m6:侧边栏-分享 
		 * m7:侧边栏-录制
		 * m8:视频标题
		 * m9:后推 分享
		 * m10:前贴广告
		 * m11:暂停
		 * m12:真全屏
		 * m13:假全屏
		 * m14:秀场推广位
		 * m15:点击播放
		 * m16:自动播放
		 * 
		 * hzu:合作方logo图片地址 (需要编码)
		 * hzj:合作方logo跳转地址(需要编码)
		 */
		private static const FileDefault:Array = 
			[true, true, false, true, true, true, true, true, true, true, true, true, false, false, true, false];
		private static function resolveFile(data:Function):Object {
			return resolveDelegate(data, "m", FileDefault);
		}
		
	}
}