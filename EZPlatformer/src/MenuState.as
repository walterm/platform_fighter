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
			FlxG.bgColor = 0xffaaaaaa;
			var menuText:FlxText = new FlxText(FlxG.width/2- 48 ,FlxG.height/3,100,"Platform Fighter!");
			add(menuText);
			var playButton:FlxButton = new FlxButton(FlxG.width/2 -45, 3*FlxG.height/5, "Play", playButtonCallback);
			add (playButton);
			var creditButton:FlxButton = new FlxButton(FlxG.width/2 -45, 4*FlxG.height/5, "Credits", creditButtonCallback);
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