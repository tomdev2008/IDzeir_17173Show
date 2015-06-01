package com._17173.flash.player.module.quiz
{
	import flash.events.Event;
	
	public class QuizCustomEvent extends Event
	{
		public static const QUIZ_EVENT:String = "quizEvent";
		/**
		 * 竞猜ID
		 */		
		public var quizID:String;
		/**
		 * 庄ID
		 */		
		public var dealerID:String;
		
		public function QuizCustomEvent()
		{
			super(QUIZ_EVENT);
		}
	}
}