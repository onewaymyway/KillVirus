package pubs
{

	
	
	
	
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import pubs.GameInfors;

	public class DebugToolScreen
	{
		/**
		 * 新手引导所在的层 
		 */		
		public static var tParent:DisplayObjectContainer;
		private static var outPutTxt:TextField;
		//private static var secretTxt:TextField;
		private static var isOn:Boolean=true;
		public function DebugToolScreen()
		{
		}
		public static function init():void
		{
			trace("debugTool Inited");
			if(!isOn) return;
			//tParent=BoxFactory.getInstance().getBoxView(NewHelpCommand.NEWHELP_VIEW_NAME);
			outPutTxt=new TextField;
//			outPutTxt.y=GameInfors.height-100;
			outPutTxt.width=250;
			outPutTxt.height=150;
			outPutTxt.multiline=true;
			outPutTxt.wordWrap=true;
			outPutTxt.defaultTextFormat=GameInfors.getDebugTextFormat();
//			outPutTxt.background=true;
//			outPutTxt.backgroundColor=0x0011FF;
			outPutTxt.selectable=false;
			outPutTxt.x=GameInfors.width-250;
			tParent.addChild(outPutTxt);
			var kk:TextField=new TextField;
			kk.text="GameInfo";
			kk.selectable=false;
			kk.width=kk.textWidth+4;
			kk.height=kk.textHeight+4;
			kk.background=true;
			kk.backgroundColor=0x00FF00;
			kk.x=outPutTxt.x+outPutTxt.width+2;
//			kk.y=GameInfors.height-20;
			tParent.addChild(kk);
			kk.visible=false;
			kk.addEventListener(MouseEvent.CLICK,click);
		}
		public static function click(e:MouseEvent):void
		{
			changeState();
		}
		public static function changeState():void
		{
			isDebug=!isOn;
		}
		public static function set isDebug(open:Boolean):void
		{
			isOn=open;
			if(isOn)
			{
				if(!outPutTxt) init();
				outPutTxt.visible=true;
			}
			else
			{
				if(outPutTxt)
				outPutTxt.visible=false;
			}
		}
		public static function addStr(st:String):void
		{
			if(!isOn) return;
			if(!outPutTxt) return;
			if(outPutTxt.text==""||outPutTxt.numLines>150) 
			{
				outPutTxt.text=st ;
			}else
			{
				outPutTxt.text=outPutTxt.text+"\n"+st;
			}
			outPutTxt.scrollV=outPutTxt.maxScrollV;
			
		}
		
		public static function showObj(obj:Object,objName:String="obj"):void
		{
			trace("show obj:"+objName);
			//trace(JSON.encode(obj));
			//JSON.encode(obj);
			trace("show obj finish");
		}
		
	}
}