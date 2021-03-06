package
{
	import org.flixel.*;
	
	public class CreditState extends FlxState
	{
		override public function create():void
		{
			
			add(new FlxText(FlxG.width/2 -100,0,200,"This is where we would put our credits")); //adds a 100px wide text field at position 0,0 (upper left)
			add(new FlxText(FlxG.width/2 - 50,2 * FlxG.height/10,100,"Walter Menendez"))
			add(new FlxText(FlxG.width/2 -50 ,3 * FlxG.height/10,100,"Travis Wagner"))
			add(new FlxText(FlxG.width/2 - 50,4 * FlxG.height/10,100,"Justin White"))
			add(new FlxText(FlxG.width/2 - 50 ,5 * FlxG.height/10,100,"Paruku Paerhati"))
			var menuButton:FlxButton = new FlxButton(FlxG.width -90, 2*FlxG.height/5, "Menu", menuButtonCallback);
			add (menuButton);
		}
		
		public function menuButtonCallback():void
		{
			FlxG.switchState(new MenuState)
		}
	}
}

