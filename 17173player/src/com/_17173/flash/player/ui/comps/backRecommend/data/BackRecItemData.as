package com._17173.flash.player.ui.comps.backRecommend.data
{
	import com._17173.flash.core.util.HtmlUtil;
	import com._17173.flash.core.util.Util;

	public class BackRecItemData
	{
		private var _id:String = "";
		private var _duration:String = "";
		private var _isHot:int = 0;
		private var _nickname:String = "";
		private var _pic_16in9:String = "";
		private var _pic_4in3:String = "";
		private var _play_num:int = 0;
		private var _play_url:String = "";
		private var _space_url:String = "";
		private var _title:String = "";
		private var _pic_small_little:String = "";
		private var _isShow:Boolean = true;
		
		public function BackRecItemData(id:String, value:Object)
		{
			if(id && id != "")
			{
				this.id = id;
			}
			
			if(value)
			{
				if(value.hasOwnProperty("duration"))
				{
					this.duration = value["duration"];
				}
				if(value.hasOwnProperty("isHot"))
				{
					this.isHot = value["isHot"];
				}
				if(value.hasOwnProperty("nickname"))
				{
					this.nickname = value["nickname"];
				}
				if(value.hasOwnProperty("pic_small"))
				{
					this.pic_16in9 = value["pic_small"];
				}
				if(value.hasOwnProperty("photo4In3"))
				{
					this.pic_4in3 = value["photo4In3"];
				}
				if(value.hasOwnProperty("play_num"))
				{
					this.play_num = value["play_num"];
				}
				if(value.hasOwnProperty("play_url"))
				{
					this.play_url = value["play_url"];
				}
				if(value.hasOwnProperty("space_url"))
				{
					this.space_url = value["space_url"];
				}
				if(value.hasOwnProperty("title"))
				{
					this.title = value["title"];
				}
				if (value.hasOwnProperty("pic_small_little")) {
					this.pic_small_little = value["pic_small_little"];
				}
			}
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function set id(value:String):void
		{
			_id = value;
		}
		
		public function get duration():String
		{
			return _duration;
		}
		
		public function set duration(value:String):void
		{
			_duration = value;
		}
		
		public function get isHot():int
		{
			return _isHot;
		}
		
		public function set isHot(value:int):void
		{
			_isHot = value;
		}
		
		public function get nickname():String
		{
			return _nickname;
		}
		
		public function set nickname(value:String):void
		{
			_nickname = Util.validateStr(value) ? HtmlUtil.decodeHtml(value) : value;
		}
		
		public function get pic_16in9():String
		{
			return _pic_16in9;
		}
		
		public function set pic_16in9(value:String):void
		{
			_pic_16in9 = value;
		}
		
		public function get play_num():int
		{
			return _play_num;
		}
		
		public function set play_num(value:int):void
		{
			_play_num = value;
		}
		
		public function get play_url():String
		{
			return _play_url;
		}
		
		public function set play_url(value:String):void
		{
			_play_url = value;
		}
		
		public function get space_url():String
		{
			return _space_url;
		}
		
		public function set space_url(value:String):void
		{
			_space_url = value;
		}
		
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			_title = Util.validateStr(value) ? HtmlUtil.decodeHtml(value) : value;
		}

		public function get pic_small_little():String
		{
			return _pic_small_little;
		}

		public function set pic_small_little(value:String):void
		{
			_pic_small_little = value;
		}

		public function get pic_4in3():String
		{
			return _pic_4in3;
		}

		public function set pic_4in3(value:String):void
		{
			_pic_4in3 = value;
		}

		/**
		 * 是否是秀场推荐位
		 */		
		public function get isShow():Boolean
		{
			return _isShow;
		}

		public function set isShow(value:Boolean):void
		{
			_isShow = value;
		}


	}
}