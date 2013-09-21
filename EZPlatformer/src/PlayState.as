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
		
		[Embed(source='res/jump.mp3')]
		public static var Mp3Jump:Class;
		[Embed(source='res/player.png')]
		public static var ImgPlayer:Class;
		
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
			
			//LOADING GRAPHIC
			player.loadGraphic(ImgPlayer, true, true, 14, 15);
			//SETTING ANIMATIONS
			player.addAnimation("idle" /*name of animation*/, [0] /*used frames*/);
			player.addAnimation("walk", [0, 1, 2, 1], 5 /*frames per second*/);
			player.addAnimation("jump", [3]);
			
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
			{
				player.velocity.y = -player.maxVelocity.y / 2;
				FlxG.play(Mp3Jump, 0.5);
			}
			if (player.isTouching(FlxObject.FLOOR))
			{
				if (!FlxG.keys.LEFT && !FlxG.keys.RIGHT) //NOT MOVING
				{
					player.play("idle");
				}
				else
				{
					player.play("walk");
				}
			}
			else //IN AIR
			{
				player.play("jump");
			}
			
			super.update();
			
			FlxG.collide(level, player);
		}
	}
}