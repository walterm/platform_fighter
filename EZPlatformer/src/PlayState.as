package
{
	import Enemy;
	
	import Player;
	
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxTilemap;
	
	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		public var bg2:FlxTilemap;
		public var player:Player;
		public var enemy:Enemy;
		public var chiptune:Class;
		public var playerBullets:FlxGroup;
		public var enemies:FlxGroup = new FlxGroup();
		public var counter:int = 0;
		
		public static var PLAYER_DAMAGE:int = 5;
		
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
			
			//Make the bullets array which can render max 8 bullets on screen at once
			var i:int;
			var numPlayerBullets:uint = 8;
			playerBullets = new FlxGroup(numPlayerBullets);//Initializing the array is very important and easy to forget!
			var bullet:FlxSprite;
			for(i = 0; i < numPlayerBullets; i++)			//Create 8 bullets for the player to recycle
			{
				bullet = new FlxSprite(-100,-100);	//Instantiate a new sprite offscreen
				bullet.makeGraphic(8,2);			//Create a 2x8 white box
				bullet.exists = false;
				playerBullets.add(bullet);			//Add it to the group of player bullets
			}
			add(playerBullets);
			
			FlxG.playMusic(chiptune, .5);
			
			//Rendering the level
			level = new FlxTilemap();
			level.loadMap(new map_bg,tiles_bg, 0, 0, FlxTilemap.AUTO);
			add(level);
	
			//Adding in the player
			player = new Player();
			add(player);
			
			//Adding in a basic enemy
			enemies.add(new Enemy());
			add(enemies);
		}
		
		override public function update():void
		{	
			FlxG.play(chiptune);
			FlxG.collide(level, player);
			FlxG.collide(level, enemies);
			FlxG.overlap(enemies, playerBullets, hitEnemy);
			FlxG.overlap(player, enemies, hitPlayer);
			super.update();
		}
		
		public function hitEnemy(enemy:Enemy, bullet:FlxSprite):void
		{
			enemy.hit(PLAYER_DAMAGE);
			bullet.kill();
			counter = counter + 1;
			if(counter % 5 == 0){
				var temp:Enemy = recycleEnemy();
				enemies.add(temp);	
				
			}
		}
		
		public function hitPlayer(player:Player, enemy:Enemy):void
		{
			player.hit(enemy);
		}
		
		public function endGame():void
		{
			FlxG.switchState(new GameOverState);
		}
		
		public function recycleEnemy():Enemy
		{
			var enemy:Enemy = enemies.getFirstAvailable() as Enemy;
			
			if(enemy == null){
				var newEnemy:Enemy = new Enemy();
				enemies.add(newEnemy);
				return newEnemy;
			}
			
			return enemy;
		}
	}
}






