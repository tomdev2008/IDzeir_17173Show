package com._17173.flash.show.base.module.chat.vo
{
	import com._17173.flash.core.context.Context;
	import com._17173.flash.core.util.debug.Debugger;
	import com._17173.flash.show.base.components.common.BitmapMovieClip;
	import com._17173.flash.show.base.context.resource.IResourceData;
	import com._17173.flash.show.base.context.resource.IResourceManager;
	import com._17173.flash.show.base.context.text.IGraphicTextManager;
	import com._17173.flash.show.base.context.user.IUser;
	import com._17173.flash.show.base.context.user.IUserData;
	import com._17173.flash.show.base.context.user.UserData;
	import com._17173.flash.show.base.utils.FontUtil;
	import com._17173.flash.show.model.CEnum;
	
	import flash.display.AVM1Movie;
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.TextElement;

	public class LuckGiftVo extends BaseChatVo
	{
		private var _opName:String;
		private var _userId:String;
		private var _giftUrl:String;
		private var _giftName:String;
		private var _ttCount:String;
		private var _ttPl:String;
		private var _times:uint;
		private var _price:int;
		private var _hitResult:Array;
		private var _totalReturnGiftCount:uint
		
		public function LuckGiftVo()
		{
			super();
			
		}

		/**
		 * 礼物共返还数量
		 */
		public function get totalReturnGiftCount():uint
		{
			return _totalReturnGiftCount;
		}

		/**
		 * @private
		 */
		public function set totalReturnGiftCount(value:uint):void
		{
			_totalReturnGiftCount = value;
		}

		/**
		 * 中奖详细个数
		 */
		public function get hitResult():Array
		{
			return _hitResult;
		}

		/**
		 * @private
		 */
		public function set hitResult(value:Array):void
		{
			_hitResult = value;
		}

		override protected function initVo():void
		{
			super.initVo();
			_elems.push(this.timeStamp);
			
			var iuser:IUser = Context.getContext(CEnum.USER) as IUser;
			var opUser:IUserData = iuser.getUser(_userId);
			//是否是私聊
			var me:Boolean = this._hitResult&&(iuser.me.id == _userId);
			
			var textElement:TextElement;
			textElement = new TextElement("恭喜"+(me?"您":" "),FontUtil.getFormat(0xFF9900));
			_elems.push(textElement);			
			
			if(!me)
			{
				var _name:String = opUser?opUser.name:_opName;
				textElement = new TextElement(_name,FontUtil.getFormat(0x63acff));
				textElement.eventMirror = (Context.getContext(CEnum.GRAPHIC_TEXT) as IGraphicTextManager).controler;
				textElement.userData = opUser?opUser:new UserData();
				_elems.push(textElement);	
			}
			textElement = new TextElement((me?"":" ")+"送出的 ",FontUtil.getFormat(0xFF9900));
			_elems.push(textElement);	
			
			textElement = new TextElement(this._giftName,FontUtil.getFormat(0xCCCCCC));
			_elems.push(textElement);	
			
			var SIZE:uint = 26;
			var giftBox:Sprite = new Sprite();
			giftBox.graphics.beginFill(0x000000, 0);
			giftBox.graphics.drawRect(0, 0, SIZE, SIZE);
			giftBox.graphics.endFill();			
			giftBox.y = 3;	
			var ires:IResourceManager = (Context.getContext(CEnum.SOURCE) as IResourceManager);
			var getBitmapCall:Function = function(value:Object):void
			{				
				var data:Array;
				if(value.key.indexOf(".swf")!=-1)
				{
					if(value.newSource is AVM1Movie)
					{
						Debugger.log(Debugger.ERROR,"[AVM1Movie]","加载礼物动画资源是AVM1Movie的无法序列图播放");
					}else{
						ires.addAnimDatas4Mc(value.key,value.newSource as MovieClip,false);
						data = ires.getAnimDatas(value.key);
					}					
				}else{
					data = [(value.newSource as Bitmap).bitmapData];
				}
				
				var bitmapMc:BitmapMovieClip = new BitmapMovieClip(true,24,24);
				bitmapMc.data = data;
				bitmapMc.x = (giftBox.width-bitmapMc.width)>>1;
				bitmapMc.y = (giftBox.height-bitmapMc.height)>>1;
				giftBox.addChild(bitmapMc);
				giftBox.graphics.clear();
			};	
			(Context.getContext(CEnum.SOURCE) as IResourceManager).loadResource(this._giftUrl, getBitmapCall);
			giftBox.y = 3;				
			var graphic:GraphicElement = new GraphicElement(giftBox, SIZE, SIZE, FontUtil.getFormat());
			_elems.push(graphic);	
			
			textElement = new TextElement(" 有 ",FontUtil.getFormat(0xFF9900));
			_elems.push(textElement);	
			
			textElement = new TextElement(_ttCount,FontUtil.getFormat(0xFFFF00));
			_elems.push(textElement);	
			
			textElement = new TextElement(" 个中奖啦！",FontUtil.getFormat(0xFF9900));
			_elems.push(textElement);

			hitResult && createLuckInfo(hitResult);
			
			textElement = new TextElement("共获得 ",FontUtil.getFormat(0xFF9900));
			_elems.push(textElement);	
			
			textElement = new TextElement((this._price*this._totalReturnGiftCount)+"", FontUtil.getFormat(0xFFFF00));
			_elems.push(textElement);
			
			textElement = new TextElement(" 个乐币奖励！",FontUtil.getFormat(0xFF9900));
			_elems.push(textElement);	
			
//			textElement = new TextElement(String(_price), FontUtil.getFormat(0xefe46c));
//			_elems.push(textElement);
//			
//			textElement = new TextElement(" 乐币。",FontUtil.getFormat(0xec7218));
//			_elems.push(textElement);	
		}
		
		private function createLuckInfo(value:Array):void
		{
			for (var i:uint = 0;i<value.length;i++)
			{
				_elems.push(new TextElement(" "+value[i].giftNum, FontUtil.getFormat(0xFFFF00)));	
				_elems.push(new TextElement(" 倍奖励 ",FontUtil.getFormat(0xFF9900)));	
				_elems.push(new TextElement(value[i].count, FontUtil.getFormat(0xFFFF00)));	
				_elems.push(new TextElement(" 个"+((i==value.length-1)?"。":"，"),FontUtil.getFormat(0xFF9900)));	
			}
		}
		
		/**
		 *总共倍率 
		 * @return 
		 * 
		 */		
		public function get ttPl():String
		{
			return _ttPl;
		}
		
		public function set ttPl(value:String):void
		{
			_ttPl = value;
		}
		
		public function get ttCount():String
		{
			return _ttCount;
		}
		
		/**
		 *总共个数 
		 * @param value
		 * 
		 */		
		public function set ttCount(value:String):void
		{
			_ttCount = value;
		}
		/**
		 * 反馈价值
		 */
		public function set price(value:int):void
		{
			_price = value;
		}

		/**
		 * 倍数
		 */
		public function set times(value:uint):void
		{
			_times = value;
		}

		/**
		 * 礼物名称
		 */
		public function set giftName(value:String):void
		{
			_giftName = value;
		}
		
		/**
		 * 礼物地址
		 */
		public function set giftUrl(value:String):void
		{
			_giftUrl = value;
		}

		/**
		 * 回馈的id
		 */
		public function set userId(value:String):void
		{
			_userId = value;
		}

		/**
		 * 回馈的用户名
		 */
		public function set opName(value:String):void
		{
			_opName = value;
		}
		
		override protected function dispose():void
		{
			super.dispose();
			this.hitResult = null;
		}
	}
}