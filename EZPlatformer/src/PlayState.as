package
{
	import Player;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	
	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		public var bg2:FlxTilemap;
		public var player:Player;
		public var chiptune:Class;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffaaaaaa;
			
			//Get the tilemap from tile.png
			[Embed(source='res/tiles.png')]
			var tiles_bg:Class;
			
			
			//Read from platform.txt and create level map
			[Embed(source = 'utils/platforms.txt', mimeType = 'application/octet-stream')]
			var map_bg:Class;
			
			//Get chiptune from http://www.newgrounds.com/audio/listen/528414 
			[Embed(source = 'utils/chiptune.mp3')]
			var chiptune:Class;
			
			FlxG.playMusic(chiptune, .5);
			
			level = new FlxTilemap();
			level.loadMap(new map_bg,tiles_bg, 0, 0, FlxTilemap.AUTO);
			add(level);
			
			player = new Player();
			
			
			//SETTING ANIMATIONS
			player.addAnimation("idle" /*name of animation*/, [0] /*used frames*/);
			player.addAnimation("walk", [0, 1, 2, 1], 5 /*frames per second*/);
			player.addAnimation("jump", [3]);
			player.maxVelocity.x = 80;
			player.maxVelocity.y = 200;
			player.acceleration.y = 200;
			player.drag.x = player.maxVelocity.x * 4;
			
			player = new Player();
			add(player);
		}
		
		override public function update():void
		{	
			FlxG.play(chiptune);
			FlxG.collide(level, player);
			super.update();
		}
	}
}






