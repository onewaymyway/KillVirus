package pubs
{

	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class GameInfors
	{
		
		public var gameStage:Stage;
		

		public function GameInfors()
		{
			
			
		}
		public static var monsterName:String="Virus";
		public static var soldierName:String="TCell";
		private static var  _instance:GameInfors;
		public static function getInstance():GameInfors
		{
			if(!_instance)_instance=new GameInfors;
			return _instance;
		}

		public static function get width():Number
		{
			return getInstance().gameStage.stageWidth;
		}
		
		public static function get height():Number
		{
			return getInstance().gameStage.stageHeight;
		}
		
		private static var defaultTxtFormat:TextFormat;
		public static function get textFormat():TextFormat
		{
			if(!defaultTxtFormat)
			{
				defaultTxtFormat=new TextFormat;
				defaultTxtFormat.color=0xFFFF00;
				defaultTxtFormat.size=24;
			}
			return defaultTxtFormat;
		}
		
		private static var monsterTxtFormat:TextFormat;
		public static function get monsterFormat():TextFormat
		{
			if(!monsterTxtFormat)
			{
				monsterTxtFormat=new TextFormat;
				monsterTxtFormat.color=0xFF22FF;
				monsterTxtFormat.size=24;
			}
			return monsterTxtFormat;
		}
		public static function getANewTxt():TextField
		{
			var text:TextField;
			text=new TextField;
			text.multiline=true;
			text.wordWrap=false;
			text.autoSize=TextFieldAutoSize.LEFT;
			text.defaultTextFormat=GameInfors.textFormat;
			text.mouseEnabled=false;
			
			textLayer.addChild(text);
			return text;
		}
		
		private static var debugTextFormat:TextFormat;
		/**
		 * debug文本样式 
		 * @return 
		 * 
		 */		
		public static function getDebugTextFormat():TextFormat
		{
			if(debugTextFormat == null)
			{
				debugTextFormat = new TextFormat();
				debugTextFormat.align = TextFormatAlign.RIGHT;
				debugTextFormat.color = 0xffff00;
				debugTextFormat.size = 12;
				debugTextFormat.font = "宋体";
				debugTextFormat.leading = 1;
				debugTextFormat.letterSpacing = 1;
			}
			return debugTextFormat;
		}
		
		public static var textLayer:Sprite;
		
		public static function isPointIn(x:Number,y:Number):Boolean
		{
			if(x<0) return false;
			if(y<0) return false;
			if(x>width) return false;
			if(y>height) return false;
			return true;
		}
		public static function updatePos(dis:DisplayObject,x:Number,y:Number):void
		{
			dis.x=x;
			dis.y=y;
			adaptDisPos(dis);
		}
		public static function adaptDisPos(dis:DisplayObject):void
		{
			if(dis.x<0) dis.x=0;
			if(dis.y<0) dis.y=0;
			if(dis.x>width-dis.width) dis.x=width-dis.width;
			if(dis.y>height-dis.height) dis.y=height-dis.height;
		}
		public static function remove(dis:DisplayObject):void
		{
			if(dis&&dis.parent)
			{
				dis.parent.removeChild(dis);
			}
		}
		
		public static function getLen(sX:Number,sY:Number,eX:Number,eY:Number):Number
		{
			return Math.pow((sX-eX)*(sX-eX)+(sY-eY)*(sY-eY),0.5);
		}
	}
}