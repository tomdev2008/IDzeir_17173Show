package com._17173.flash.show.base.module.chat
{
	import com._17173.flash.core.components.common.GraphicText;
	import com._17173.flash.core.components.common.TabBar;
	import com._17173.flash.core.components.common.TabContainer;
	import com._17173.flash.core.components.common.ViewStack;
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.event.IEventManager;
	import com._17173.flash.core.locale.ILocale;
	import com._17173.flash.core.util.Util;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	import com._17173.flash.show.model.SEvents;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.engine.ContentElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.utils.setTimeout;

	/**
	 * @author idzeir
	 * 创建时间：2014-2-18  下午3:13:46
	 */
	public class ChatTabContainer extends TabContainer
	{
		private var _block:TextBlock;

		private var txt:GraphicText;
		
		private var txtBg:Sprite;
		
		private var _breakVline:Shape;
		
		//游戏tip ui
		private var _gameTips:MovieClip;
		//要显示的游戏图标
		private var _gameIcon:BitmapMovieClip;
		//弹出的pop ui
		private var _pop:PopGame;
		//pop显示的时间
		private var SHOW_TIME:uint = 5000;
		
		public function ChatTabContainer()
		{
			super();
		}

		override protected function addChildren():void
		{
			tabBar = new TabBar(ChatListTabButton,Breakline1_8);
			tabBar.gap = 2;
			viewStack = new ViewStack();
			txtBg = new NoticeBg1_8();

			this.addChild(tabBar);
			this.addChild(txtBg);
			this.addChild(viewStack);
			
			_gameTips = new GameMoveClip1_8_1();
			_gameTips.gotoAndStop(1);
			_gameTips.y = 15;
			_gameTips.x = 280;
			_gameTips.scaleX = _gameTips.scaleY = .6;			
			_gameTips.addEventListener(Event.ADDED_TO_STAGE,onGameTipsAdded);			
			_gameIcon = new BitmapMovieClip(true,40,40);			
			_pop = new PopGame();
			//创建房间公告内容
			createNotice();
			
			_breakVline = new Shape();		
			
			(Context.getContext(CEnum.EVENT) as IEventManager).listen(SEvents.GAME_SHOW_TIPS,playGameTips);
		}
		
		protected function onGameTipsAdded(event:Event):void
		{
			if(_gameTips["mc"])
			{
				var aniTip:MovieClip = _gameTips["mc"];
				_gameIcon.width = aniTip.width/aniTip.scaleX;
				_gameIcon.height = aniTip.height/aniTip.scaleY;
				aniTip.addChild(_gameIcon);
			}
		}
		/**
		 * 显示游戏tips 
		 * @param value
		 * 
		 */		
		private function playGameTips(value:Object):void
		{
			_pop.data = value;
			_gameIcon.url = value.icon;
			
			this.addChild(_gameTips);
			_gameTips.gotoAndPlay(1);
			
			if(_gameTips.hasEventListener(Event.ENTER_FRAME))
			{
				_gameTips.removeEventListener(Event.ENTER_FRAME,onFrame);	
			}
			_gameTips.addEventListener(Event.ENTER_FRAME,onFrame);				
		}
		
		private function onFrame(e:Event):void
		{
			//最后一帧停止动画
			if(_gameTips.currentFrame == _gameTips.totalFrames)
			{
				_gameTips.removeEventListener(Event.ENTER_FRAME,onFrame);
				_gameTips.stop();
				
				var finalGameDef:MovieClip = _gameTips["mc"];
				//游戏图标相对当前容器的的坐标
				var p:Point = this.globalToLocal(finalGameDef.localToGlobal(new Point()));
				_pop.x = p.x - 5;
				_pop.y = p.y + finalGameDef.height*.5 + 5;				
				this.addChild(_pop);
				
				//消除动画
				setTimeout(function():void{
					contains(_gameTips)&&removeChild(_gameTips);
					contains(_pop)&&removeChild(_pop);
					_pop.data = null;
				},SHOW_TIME);					
			}			
		}
		
		private function createNotice():void
		{
			_block = new TextBlock();
			_block.baselineZero = flash.text.engine.TextBaseline.DESCENT;
			txt = new GraphicText(null,true,65);
			txt.leading = 7;
			txt.textWidth = 330;	
			txt.x = 8;
		}
		
		public function get noticeTxtRawHeight():Number
		{
			return txt.height;
		}
		
		public function set hidenNotice(bool:Boolean):void
		{
			txt.visible = bool;
			//txtBg.visible = bool;
		}
		
		public function get noticeHeight():Number
		{
			return txt.visible?txt.height + 5:-15;
		}
		
		public function notice(value:String,link:String = ""):void
		{
			var local:ILocale = Context.getContext(CEnum.LOCALE) as ILocale;
			var msg:String = value == ""?local.get("defaultNotice","chatPanel"):value;
			var txtMgr:IGraphicTextManager = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager);
			txt.clear();
			
			var te:TextElement = new TextElement(local.get("msg_notice","chatPanel")+" : "+msg,FontUtil.getFormat(0xFFFFFF));
			
			var vector:Vector.<ContentElement> = new Vector.<ContentElement>();
			vector.push(te);
			
			var gp:GroupElement = new GroupElement(vector,FontUtil.getFormat(0xFFFFFF));
			if(Util.validateStr(link))
			{
				gp.userData = {"link":link,indent:60,unline:true,leading:0,showlink:true};	
			}			
			txt.addElement(gp);			
			if(!this.contains(txt))
			{
				this.addChild(txt);
			}
			txtBg.height = txt.height + 20;
			
			txtBg.y = tabBar.contentMaxHeight;
			viewStack.y = tabBar.contentMaxHeight + 15 + noticeHeight + 10;
		}

		public function redraw():void
		{
			viewStack.y = tabBar.contentMaxHeight + 15 + noticeHeight + 10;
		}
		
		override public function addItem(key:String, label:String, graphic:DisplayObject):void
		{
			var tbData:Object = {label:label, index:tabBar.size}
			tabBar.addItem(tbData);
			viewStack.addItem(key, label, graphic);

			if(!tabBar.hasEventListener(flash.events.Event.CHANGE))
			{
				tabBar.addEventListener(Event.CHANGE, onChange);
			}
			txt.y = tabBar.height + 10;	
			
			//txtBg.width = 330;
			txtBg.y = tabBar.contentMaxHeight;
			viewStack.y = tabBar.contentMaxHeight + 15 + txt.height + 10;
			drawRules();
		}

		override protected function drawRules():void
		{
			if(!this.contains(_breakVline))
			{
				this.addChild(_breakVline);
			}
			_breakVline.graphics.clear();
			_breakVline.graphics.lineStyle(0, 0, 0);

			_breakVline.graphics.beginFill(0xBE006B,.9);
			_breakVline.graphics.drawRect(0, tabBar.contentMaxHeight - 1, viewStack.contentMaxWidth-1, 1);

			_breakVline.graphics.beginFill(0x80004D);
			_breakVline.graphics.drawRect(0, tabBar.contentMaxHeight, viewStack.contentMaxWidth-1, 1);
			
			this.tabBar.graphics.clear();
			this.tabBar.graphics.beginFill(0x380646,.85);
			this.tabBar.graphics.drawRect(0,0,this.width - 1,this.tabBar.height);
			this.tabBar.graphics.endFill();
		}
		
		public function goto(id:int):void
		{
			tabBar.index = id;
		}

		/**
		 * 指定index的tab闪烁
		 * @param _index
		 *
		 */
		public function flash(_index:uint):void
		{
			(Context.getContext(CEnum.EVENT) as IEventManager).send(SEvents.TAB_BUTTON_FLASH, _index);
			tabBar.flash(_index);
		}
	}
}
import com._17173.flash.core.context.Context;
import com._17173.flash.core.event.IEventManager;
import com._17173.flash.core.locale.ILocale;
import com._17173.flash.core.util.Util;
import com._17173.flash.show.base.context.user.IUser;
import com._17173.flash.show.base.utils.FontUtil;
import com._17173.flash.show.model.CEnum;
import com._17173.flash.show.model.SEvents;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;

class PopGame extends Sprite
{
	//显示pop文字
	private var _txt:TextField;
	//背景
	private var bg:MovieClip;	
	private var _data:Object;
	
	private var _ilocal:ILocale;

	public function PopGame()
	{
		_ilocal = Context.getContext(CEnum.LOCALE) as ILocale;
		_txt = new TextField();
		_txt.defaultTextFormat = new TextFormat(FontUtil.f, 12);
		_txt.autoSize = "left";
		bg = new Pop();
		this.addChild(bg);
		this.mouseChildren = false;
		this.buttonMode = true;		
		
		this.addEventListener(MouseEvent.CLICK,function():void
		{
			if(_data){
				var e:IEventManager = (Context.getContext(CEnum.EVENT) as IEventManager);
				var iuser:IUser = (Context.getContext(CEnum.USER) as IUser);
				//未登录不链接到游戏页面
				if(iuser.me.isLogin){
					if(_data["link"].indexOf("http://")!=-1)
					{
						Util.toUrl(_data["link"]);
					}else{
						const CHAT_TO_EGG_GAME:String = "chatToZadan";
						e.send(_data["link"],{type:CHAT_TO_EGG_GAME});
					}
				}else{
					e.send(SEvents.LOGINPANEL_SHOW);
				}
			}
		});
	}

	public function set data(value:Object):void
	{
		_data = value;
		if(value)
		{
			_txt.text = _ilocal.get("gameTips","chatPanel").replace("game",value.label);
			bg.width = _txt.width + 10;
			var rect:Rectangle = bg.getBounds(this);
			_txt.x = rect.left + 5;
			_txt.y = rect.top + ((rect.height - _txt.height) >> 1) - 4;
			this.addChild(_txt);
		}
	}
}