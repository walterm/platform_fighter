package
{
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;

	public class MenuState extends FlxState
	{
		
		[Embed(source='res/Title.png')]
		public static var ImgTitle:Class;
		
		[Embed(source='res/laser.mp3')]
		public static var MP3Click:Class;
		
		override public function create():void
		{	
			FlxG.bgColor = 0xffaaaaaa;
			
			//var menuText:FlxText = new FlxText(FlxG.width/2- 48 ,FlxG.height/3,100,"Platform Fighter!");
			//add(menuText);
			
			var title:FlxSprite = new FlxSprite(FlxG.width/2 - 35, FlxG.height/2 - 50, ImgTitle);
			title.scale.x = 2;
			title.scale.y = 2;
			add (title);
			
			var playButton:FlxButton = new FlxButton(FlxG.width/2 -45, 3*FlxG.height/5, "Start", startButtonCallback);
			add (playButton);
			var creditButton:FlxButton = new FlxButton(FlxG.width/2 -45, 4*FlxG.height/5, "Credits", creditButtonCallback);
			add (creditButton);
			FlxG.mouse.show();
		}
		public function startButtonCallback():void{
			FlxG.play(MP3Click);
			FlxG.switchState(new StoryState)
		}
		public function creditButtonCallback():void{
			FlxG.play(MP3Click);
			FlxG.switchState(new CreditState)
		}
	}
}