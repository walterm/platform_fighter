package
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	
	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		public var player:Player;
		public var bg2:FlxTilemap;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffaaaaaa;
			
			/*                                 Use this to load your own platform type!
			[Embed(source='data/tilemap_platform.png')]
			private var img_bg:Class;
			*/
			
			//Read from platform.txt and create level map
			[Embed(source = 'utils/platforms.txt', mimeType = 'application/octet-stream')]
			var map_bg:Class;
			
			level = new FlxTilemap();
			level.loadMap(new map_bg, FlxTilemap.ImgAuto, 0, 0, FlxTilemap.AUTO);
			add(level);
			
			player = new Player();
			add(player);
		}
		
		override public function update():void
		{
			FlxG.collide(level, player);
			super.update();
		}
	}
}