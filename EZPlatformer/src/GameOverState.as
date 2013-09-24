package
{
	import org.flixel.*;
	
	public class GameOverState extends FlxState
	{
		override public function create():void
		{
			FlxG.bgColor = 0xffaaaaaa;
			
			add(new FlxText(FlxG.width/2, FlxG.height/5,300,"GAME OVER")); //adds a 100px wide text field at position 0,0 (upper left)
			var playButton:FlxButton = new FlxButton(FlxG.width/2 -45, 2*FlxG.height/5, "Replay", replayCallback);
			add (playButton);
			var creditButton:FlxButton = new FlxButton(FlxG.width/2 -45, 3*FlxG.height/5, "Main Menu", mainMenuCallback);
			add (creditButton);
			
			//Get When-the-game-is-over from http://www.newgrounds.com/audio/listen/504312
			[Embed(source = 'res/when-the-game-is-over.mp3')]
			var gameOverTune:Class;
			FlxG.playMusic(gameOverTune, .5);
		}
		
		public function replayCallback():void{
			FlxG.switchState(new PlayState);
		}
		public function mainMenuCallback():void{
			FlxG.resetGame();
		}
	}
}