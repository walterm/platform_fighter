package
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class MenuState extends FlxState
	{
		
		override public function create():void
		{
			add(new FlxText(0,0,100,"Main Menu!")); //adds a 100px wide text field at position 0,0 (upper left)
			var playButton:FlxButton = new FlxButton(FlxG.width/2, FlxG.height/5, "Play", playButtonCallback);
			add (playButton);
			var creditButton:FlxButton = new FlxButton(FlxG.width/2, 2*FlxG.height/5, "Credits", creditButtonCallback);
			add (creditButton);
			FlxG.mouse.show();
		}
		public function playButtonCallback():void{
			FlxG.switchState(new PlayState)
		}
		public function creditButtonCallback():void{
			FlxG.switchState(new CreditState)
		}
	}
}