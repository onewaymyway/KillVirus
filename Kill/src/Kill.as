package
{

	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import pubs.DebugToolScreen;
	import pubs.GameInfors;

	[SWF(backgroundColor=0x111144,frameRate=24)]
	public class Kill extends Sprite
	{
		public function Kill()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			GameInfors.getInstance().gameStage=stage;
			DebugToolScreen.tParent=this;
			DebugToolScreen.init();
			initGame();
		}
		private var gameMain:CutEffects;
		public function initGame():void
		{
			gameMain=new CutEffects();
			this.addChild(gameMain);
		
			gameMain.createGame();
			DebugToolScreen.isDebug=false;
			gameMain.beginGame();
		}
	}
}