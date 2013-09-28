package
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	
	public class StoryState extends FlxState
	{
		override public function create(): void
		{
			add (new FlxText(FlxG.width/6, FlxG.height/5, 2*FlxG.width/3,"Time is a valuable thing. You have always known this ever since you were manufactured." +
				" As a robot you have the glorious privlege of copious amounts of time. But the humans are jealous. They want to steal all of your time." +
				" You know that if they have it they will just waste it wandering around aimlessly. You cannot let that happen. So instead you built a" +
				" device that lets you convert humans into more time. Show those humans how one should truly spend their time."))
			var playButton:FlxButton = new FlxButton(FlxG.width/2 -45, 4*FlxG.height/5, "Play", playButtonCallback);
			add (playButton);
		}
		public function playButtonCallback():void{
			FlxG.switchState(new PlayState)
		}
	}	
}