package
{
	import Enemy;
	
	import Player;
	
	import org.flixel.*;
	
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
		public var paused:Boolean;
		public var pauseGroup:FlxGroup;
		public var HealthBar:FlxSprite;
		
		public static var PLAYER_DAMAGE:int = 10;
		public static var TIME_LIMIT:int = 300;
		
		public var gameTimer:Number;
		
		public static var timerText:FlxText;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffaaaaaa;
			
			gameTimer = TIME_LIMIT;
			timerText = new FlxText(0,0,300,"Time: " + FlxU.ceil(gameTimer).toString());
			//Get the HealthBar Frame
			[Embed(source='res/HealthBarFrame.png')]
			var ImgHealthBarFrame:Class;
			
			//Get the HealthBar
			[Embed(source='res/HealthBar.png')]
			var ImgHealthBar:Class;
			
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
			
			//Adding in a basic enemy
			enemies.add(new Enemy());
			add(enemies);
			
			add(timerText);
			
			//Making the Pause menu
			paused = false;
			pauseGroup = new FlxGroup();
			pauseGroup.add(new FlxText(FlxG.width/2 , 0,300,"Paused")); 
			pauseGroup.add(new FlxText(FlxG.width/2 , FlxG.height/5, 300,"Press P to unpause"))
			var newGameButton:FlxButton = new FlxButton(FlxG.width/2 - 45, 2*FlxG.height/5, "New Game", newGameCallback);
			pauseGroup.add (newGameButton);
			var MenuButton:FlxButton = new FlxButton(FlxG.width/2 - 45, 3*FlxG.height/5, "Main Menu", mainMenuCallback);
			pauseGroup.add (MenuButton);
			

			//adding instructions 
			add(new FlxText(0,30,FlxG.width,"Use arrow keys to move, up to jump, and space to shoot. Kill the enemies before they kill you!"))
			//Adding in the Health Bar Frame
			var HealthBarFrame:FlxSprite = new FlxSprite(FlxG.width/2 - 30,FlxG.height - 14, ImgHealthBarFrame);
			HealthBarFrame.scrollFactor.x = HealthBarFrame.scrollFactor.y = 0;
			add(HealthBarFrame);
			
			//Adding in the Health Bar
			var HealthBar:FlxSprite = new FlxSprite(FlxG.width/2 - 25,FlxG.height - 11, ImgHealthBar);
			HealthBar.scrollFactor.x = HealthBar.scrollFactor.y = 0;
			HealthBar.origin.x = 0;
			HealthBar.scale.x = 50;
			add(HealthBar);
			
			//Adding in the player
			player = new Player(HealthBar);
			add(player);
		}
		
		override public function update():void
		{
			if(FlxG.keys.justPressed("P"))
				paused = !paused;
			if(paused)
				return pauseGroup.update();
			FlxG.play(chiptune);
			FlxG.collide(level, player);
			FlxG.collide(level, enemies);
			FlxG.overlap(enemies, playerBullets, hitEnemy);
			FlxG.overlap(player, enemies, hitPlayer);
			
			gameTimer -= FlxG.elapsed;
			if(gameTimer<=0)
				endGame();
			remove(timerText);
			timerText = new FlxText(0,0,300,"Time: " + FlxU.ceil(gameTimer).toString());
			add(timerText);
			
			spawn();
			super.update();
		}
		
		public function spawn():void
		{
			this.counter++;
			if(this.counter % 100 == 0){
				enemies.add(new Enemy());
				this.counter = 0;
			}
		}
		
		override public function draw():void
		{
			if(paused)
				return pauseGroup.draw();
			super.draw();
		}
		
		public function hitEnemy(enemy:Enemy, bullet:FlxSprite):void
		{
			enemy.hit(PLAYER_DAMAGE);
			bullet.kill();
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
		
		public function newGameCallback():void{
			FlxG.switchState(new PlayState);
		}
		
		public function mainMenuCallback():void{
			FlxG.switchState(new MenuState);
		}
		
	}
	
}






