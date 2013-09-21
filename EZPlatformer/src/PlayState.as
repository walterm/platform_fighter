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
		public var player:FlxSprite;
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
			
			
			//Create player (a red box)
			player = new FlxSprite(FlxG.width / 2 - 5);
			player.makeGraphic(10, 12, 0xffaa1111);
			player.maxVelocity.x = 80;
			player.maxVelocity.y = 200;
			player.acceleration.y = 200;
			player.drag.x = player.maxVelocity.x * 4;
			add(player);
		}
		
		override public function update():void
		{
			player.acceleration.x = 0;
			if (FlxG.keys.LEFT)
				player.acceleration.x = -player.maxVelocity.x * 4;
			if (FlxG.keys.RIGHT)
				player.acceleration.x = player.maxVelocity.x * 4;
			if (FlxG.keys.SPACE && player.isTouching(FlxObject.FLOOR))
				player.velocity.y = -player.maxVelocity.y / 2;
			
			super.update();
			
			FlxG.collide(level, player);
		}
	}
}