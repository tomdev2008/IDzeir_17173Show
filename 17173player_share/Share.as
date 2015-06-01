package 
{
	import com.greensock.TweenLite;
	import com.greensock.loading.core.DisplayObjectLoader;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.system.Security;
	import flash.system.System;
	import flash.text.TextField;
	
	import model.ButtonModel;
	
	public class Share extends MovieClip {
		
		public static const SHARE_A:String = 'sina';
		public static const SHARE_B:String = 'sohu';
		public static const SHARE_C:String = 'five';
		public static const SHARE_D:String = 'qzone';
		public static const SHARE_E:String = 'renren';
		public static const SHARE_F:String = 'feixin';
		public static const SHARE_G:String = 'kaixin';
		public static const SHARE_H:String = 'qq';
		public static const SHARE_I:String = 'bai';
		public static const SHARE_J:String = 'douban';
		public static const SHARE_K:String = 'i';
		public static const SHARE_L:String = "wangyiweibo";
		public static const SHARE_M:String = "tengxunpengyou";
		public static const SHARE_COPYVIDEO:String = 'copyvideo';
		public static const SHARE_COPYPAGE:String = 'copypage';
		public static const SHARE_COPEHTML:String = 'copyhtml';
		public static const SHARE_INFO:String = 'copyinfo';
		public static const SHARE_TIP:String = 'copytip';
		public static const SHARE_CLOSE:String = 'close';
		
		public function Share() {
			Security.allowDomain('*');
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			initView();
			positionView();
			
			var t:Array = [_sina,_qq,_qzone,_sohu,_kaixin,_i,_wangyiweibo,_tengxunpengyou,_douban];
			for (var i:Number = 0; i < t.length; i++ ) {
				t[i].addEventListener(MouseEvent.CLICK, buttonHandler);
//				t[i].addEventListener(MouseEvent.ROLL_OVER, buttonHandler);
//				t[i].addEventListener(MouseEvent.ROLL_OUT, buttonHandler);				
			}
			
			_close.addEventListener(MouseEvent.CLICK, buttonHandler);
			
			updateShareBtns();
			
			stage.addEventListener(Event.RESIZE, onresize);
		}
		
		private function onresize(e:Event):void {
			positionView();
		}
		
		public function call(ivd:Object):void {
			if (ivd==null) return;
			_ivd = ivd;
			var w:Number = 480;
			var h:Number = 400;
			if (_ivd.hasOwnProperty("width")) {
				w = _ivd["width"] as Number;
			}
			if (_ivd.hasOwnProperty("height")) {
				h = _ivd["height"] as Number;
			}
			_pageurl = _ivd.sharepagelink;
			_videourl = _ivd.shareflashlink;
			_fullType = _ivd.fullType;
			_html = _videourl ? '<embed id="MainPlayer" name="MainPlayer" src="'+_ivd.shareflashlink+'" ' + _fullType + '="true" quality="high" width="'+ w +'" height="'+ h +'" align="middle" allowScriptAccess="always" type="application/x-shockwave-flash" wmode="transparent"></embed>' : null;
			_domain = _ivd.domain;
			_title = _ivd.title;
			_pic = _ivd.screenshot;
			
			updateShareBtns();
		}
		
		private function updateShareBtns():void {
			if (_copypage) {
				_copypage.visible = _pageurl ? true : false;
				if (_copypage.visible) {
					_copypage.addEventListener(MouseEvent.CLICK, buttonHandler);
				}
			}
			if (_copyvideo) {
				_copyvideo.visible = _videourl ? true : false;
				if (_copyvideo.visible) {
					_copyvideo.addEventListener(MouseEvent.CLICK, buttonHandler);
				}
			}
			if (_copyhtml) {
				_copyhtml.visible = _html ? true : false;
				if (_copyhtml.visible) {
					_copyhtml.addEventListener(MouseEvent.CLICK, buttonHandler);
				}
			}
		}
		
		public function set arrange(hp:String ):void {
			_type = hp;
		}
		/**
		 *   原先： 腾讯微博，新浪微博，QQ空间，搜狐微博，人人网，开心网，豆瓣，贴吧   
			  修改后：QQ空间，新浪微博，腾讯微博，贴吧，网易微博，腾讯朋友，豆瓣，开心网，搜狐微博
		 */
		private function buttonHandler(e:MouseEvent):void {
			switch(e.target.name) {
				case SHARE_A:
					dispatchEvent(new Event("WeiboEvent"));
					//toshare(e.target as ButtonModel, e.type, '新浪微博', 'http://v.t.sina.com.cn/share/share.php?appkey=2038131490&url='+_pageurl+'&title='+_title+'&ralateUid=&source='+_domain+'&sourceUrl='+_domain+'&content=utf8&pic='+_pic);
					break;
				case SHARE_B:
					dispatchEvent(new Event("clickEvent"));
					toshare(e.target as ButtonModel, e.type, '搜狐微博', 'http://t.sohu.com/third/post.jsp?&url='+_pageurl+'&title='+encodeURI(_title)+'&pic='+_pic);
					break;
				case SHARE_D:
					dispatchEvent(new Event("qzoneEvent"));
					//toshare(e.target as ButtonModel, e.type, 'QQ空间', 'javascript:window.open("http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?url='+encodeURIComponent(_pageurl)+'")');
					break;
				case SHARE_E:
					dispatchEvent(new Event("clickEvent"));
					toshare(e.target as ButtonModel, e.type, '人人网', 'http://share.renren.com/share/buttonshare?link='+_pageurl+'&title='+_title);
					//toshare(e.target as ButtonModel, e.type, '人人网', 'http://widget.renren.com/dialog/share?resourceUrl='+_pageurl+'&title='+encodeURI(_title));
					//toshare(e.target as ButtonModel, e.type, '人人网', 'http://widget.renren.com/dialog/share?resourceUrl="http://v.17173.com/live/17326202/2173017205"&title="则是测试"';
					//toshare(e.target as ButtonModel, e.type, '人人网', 'http://widget.renren.com/dialog/share?resourceUrl='+encodeURI("http://v.17173.com/live/17326202/2173017205")+'&title='+encodeURI("则是测试"));
					break;
				case SHARE_G:
					dispatchEvent(new Event("clickEvent"));
					toshare(e.target as ButtonModel, e.type, '开心网', 'http://www.kaixin001.com/repaste/share.php?rtitle='+_title+'&rurl='+_pageurl+'&rcontent=');
					break;
				case SHARE_H:
					dispatchEvent(new Event("QQEvent"));
					//toshare(e.target as ButtonModel, e.type, '腾讯微博', 'http://v.t.qq.com/share/share.php?title='+_title+'&url='+_pageurl+'&appkey=aabc356f13fc4fbea85e8d59f7cd9dd1&site='+_domain+'&pic='+_pic);
					break;
				case SHARE_J:
					dispatchEvent(new Event("clickEvent"));
					//toshare(e.target as ButtonModel, e.type, '豆瓣网', 'http://shuo.douban.com/%21service/share?image='+_pic+'&href='+_pageurl+'&name='+_title);
					toshare(e.target as ButtonModel, e.type, '豆瓣网', 'http://www.douban.com/share/service?bm=&image='+_pic+'&href='+encodeURI(_pageurl)+'&name='+encodeURI(_title));
					break;
				case SHARE_K:
					dispatchEvent(new Event("clickEvent"));
					//toshare(e.target as ButtonModel, e.type, '百度帖吧', 'http://tieba.baidu.com/i/sys/share?link='+_pageurl+'&type=video&title='+_title+'&content='+_videourl);
					toshare(e.target as ButtonModel, e.type, '百度帖吧', 'http://tieba.baidu.com/f/commit/share/openShareApi?url='+encodeURI(_pageurl)+'&title='+_title);
					break;
				/**
				 * 网易微博
				 */
				case SHARE_L:
					//
					dispatchEvent(new Event("clickEvent"));
					//http://t.163.com/article/user/checkLogin.do?link=http%3A%2F%2Fv.youku.com%2Fv_show%2Fid_XNzUxOTEwOTQ0.html&source=%E4%BC%98%E9%85%B7%E7%BD%91&info=%E5%B0%8F%E6%97%B6%E4%BB%A3%2032%201080P%20http%3A%2F%2Fv.youku.com%2Fv_show%2Fid_XNzUxOTEwOTQ0.html
					//toshare(e.target as ButtonModel, e.type, '百度帖吧', 'http://tieba.baidu.com/i/sys/share?link='+_pageurl+'&type=video&title='+_title+'&content='+_videourl);
					//http://t.163.com/article/user/checkLogin.do?link=http%3A%2F%2Fv.youku.com%2Fv_show%2Fid_XNzQyOTExMzY0.html&source=%E4%BC%98%E9%85%B7%E7%BD%91&info=%E3%80%90TI4%E8%83%9C%E8%80%85%E7%BB%84%E3%80%91NB%20VS%20EG%20%E7%AC%AC%E4%B8%80%E5%9C%BA%E7%89%9B%E9%80%BC%E7%9C%9F%E7%9A%84%E7%89%9B%E9%80%BC%E4%BA%86%EF%BC%81NICE%EF%BC%81%EF%BC%81%EF%BC%81%20http%3A%2F%2Fv.youku.com%2Fv_show%2Fid_XNzQyOTExMzY0.html
					toshare(e.target as ButtonModel, e.type, '网易微博', 'http://t.163.com/article/user/checkLogin.do?link='+encodeURI(_pageurl)+'&info=' + encodeURI(_title + " " + _pageurl));
					break;
				/**
				 * 腾讯朋友
				 */
				case SHARE_M:
					dispatchEvent(new Event("clickEvent"));
					//http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?to=pengyou&url=http://v.youku.com/v_show/id_XNzUxNjUwMzc2.html&title=%E4%B8%8D%E6%98%AF%E7%88%B1%E6%83%85%E5%85%AC%E5%AF%93%E7%9A%84%E7%90%83%E7%88%B1%E9%85%92%E5%90%A7%2006
					//toshare(e.target as ButtonModel, e.type, '百度帖吧', 'http://tieba.baidu.com/i/sys/share?link='+_pageurl+'&type=video&title='+_title+'&content='+_videourl);
					toshare(e.target as ButtonModel, e.type, '腾讯朋友', 'http://sns.qzone.qq.com/cgi-bin/qzshare/cgi_qzshare_onekey?to=pengyou&url='+encodeURI(_pageurl)+'&title='+encodeURI(_title));
					break;
				case SHARE_COPYVIDEO:
					toclipboard(_videourl,e.target as ButtonModel);
					break;
				case SHARE_COPYPAGE:
					toclipboard(_pageurl, e.target as ButtonModel);
					break;
				case SHARE_COPEHTML:
					toclipboard(_html, e.target as ButtonModel);
					break;
				case SHARE_CLOSE:
					_copyinfo.visible = false;
					dispatchEvent(new Event("close"));
					break;
			}
		}
		
		private function toclipboard(v:String, b:ButtonModel):void {
			//_timer.reset();
			//_timer.start();
			if (v) {
				System.setClipboard(v);
				switch(_type) {
					case 'horizontal':
						_copyinfo.x = b.x;
						_copyinfo.y = b.y + b.height;
						break;
					case 'vertical':
						_copyinfo.y = b.y;
						_copyinfo.x = b.x + b.width;
				}
				_copyinfo.visible = true;
				dispatchEvent(new Event("bottomClick"));
			}
		}
		
		private function toshare(b:ButtonModel, type:String, v:String,to:String):void {
			//if (_flag) return;
			//_flag = true;
			switch(type) {
				case MouseEvent.CLICK:
					navigateToURL(new URLRequest(to), '_blank');
					break;
				case MouseEvent.ROLL_OVER:							
				case MouseEvent.ROLL_OUT:
					if (_copytip.visible) {
						_copytip.visible = false;
					}else {
						_copytip.visible = true;
						var x:Number = b.x - (_copytip.width - b.width) / 2,
							y:Number = b.y - _copytip.height - 10;
						
						_copytip.x = x - 8;
						_copytip.y = y - 20;
						_copytip.txt.text = v;
						TweenLite.to(_copytip, 1, { y:y } );
					}
					break;
			}
		}
		
		private function positionView():void {
			//this.x = (stage.stageWidth - this.width) / 2;
			//this.y = (stage.stageHeight - this.height) / 2;
		}
		
		private function initView():void {
			_qq = getChildByName(SHARE_H) as ButtonModel;
			_sina = getChildByName(SHARE_A) as ButtonModel;
			_qzone = getChildByName(SHARE_D) as ButtonModel;
			_sohu = getChildByName(SHARE_B) as ButtonModel;
			_kaixin = getChildByName(SHARE_G) as ButtonModel;
			_i = getChildByName(SHARE_K) as ButtonModel;
			
			_wangyiweibo = getChildByName(SHARE_L) as ButtonModel;
			_tengxunpengyou = getChildByName(SHARE_M) as ButtonModel;
			
			_douban = getChildByName(SHARE_J) as ButtonModel;
			
			_copyvideo = getChildByName(SHARE_COPYVIDEO) as ButtonModel;
			_copypage = getChildByName(SHARE_COPYPAGE) as ButtonModel;
			_copyhtml = getChildByName(SHARE_COPEHTML) as ButtonModel;
			_close = getChildByName(SHARE_CLOSE) as ButtonModel;
			_copytip = getChildByName(SHARE_TIP) as MovieClip;
			_copyinfo = getChildByName(SHARE_INFO) as TextField;
			if (_copyinfo) _copyinfo.visible = false;
			if (_close == null) {
				_close = new ButtonModel();
			}
		}
		private var _close:ButtonModel;
		private var _copytip:MovieClip;
		private var _copyinfo:TextField;
		
		private var _copyvideo:ButtonModel;
		private var _copypage:ButtonModel;
		private var _copyhtml:ButtonModel;
		
		private var _sina:ButtonModel;
		private var _sohu:ButtonModel;
		private var _five:ButtonModel;
		private var _bai:ButtonModel;
		private var _qzone:ButtonModel;
		private var _qq:ButtonModel;
		private var _kaixin:ButtonModel;
		private var _feixin:ButtonModel;
		private var _i:ButtonModel;
		private var _wangyiweibo:ButtonModel;
		private var _tengxunpengyou:ButtonModel;
		private var _douban:ButtonModel;
		
		private var _flag:Boolean = false;
		private var _ivd:Object;
		private var _delay:Number = 2000;
		private var _videourl:String = '';
		private var _pageurl:String = '';
		private var _html:String = '';
		private var _domain:String = '';
		private var _title:String = '';
		private var _pic:String = '';
		private var _type:String = 'horizontal';		
		private var _fullType = "allowFullScreen";
	}
	
}