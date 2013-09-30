package
{
	import Enemy;
	
	import Player;
	
	import org.flixel.FlxButton;
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxU;
	
	import flash.external.*;
	
	public class PlayState extends FlxState
	{
		public var LifeText:FlxText;
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
		public var LifeBar:FlxSprite;
		
		public static var PLAYER_DAMAGE:int = 10;
		public static var INITIAL_TIME:int = 60;
		public static var ENEMY_TIME_REWARD:int = 2;
		
		public var gameTimer:Number;
		public var life:Number;
		public var elapsedTime:Number;
		
		public static var timerText:FlxText;
		public static var scoreText:FlxText;
		public  var instructionText:FlxText;
		public static var pauseText:FlxText;
		
		public static var endText:FlxText;
		
		override public function create():void
		{
			FlxG.bgColor = 0xffaaaaaa;
			
			scoreText = new FlxText(0,FlxG.width - 60, 300, "Score: 0");
			
			LifeText = new FlxText(FlxG.width/2 - 10, 0, 300, "LIFE");
			
			endText = new FlxText(FlxG.width/2,2*FlxG.height/5, 300, "You killed 0 humans and lasted 0 seconds");
			pauseText = new FlxText(0,15, 300, "P - Pause");
			
			gameTimer = INITIAL_TIME;
			elapsedTime = 0;
			timerText = new FlxText(0,0,300,"Time: " + FlxU.ceil(gameTimer).toString());
			
			
			//Get the HealthBar Frame
			[Embed(source='res/HealthBarFrame.png')]
			var ImgHealthBarFrame:Class;
			
			//Get the HealthBar
			[Embed(source='res/HealthBar.png')]
			var ImgHealthBar:Class;
			
			//Get the LifeBar
			[Embed(source='res/LifeBar.png')]
			var ImgLifeBar:Class;
			
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
			var enemy:Enemy = new Enemy();			
			enemies.add(enemy);
			add(enemies);
			
			add(LifeText);
			add(timerText);
			add(scoreText);
			add(pauseText);
			
			//Making the Pause menu
			paused = false;
			pauseGroup = new FlxGroup();
			pauseGroup.add(new FlxText(FlxG.width/2 - 25 , FlxG.height/5,300,"Paused")); 
			pauseGroup.add(new FlxText(FlxG.width/2 -52, 2*FlxG.height/5, 300,"Press P to unpause"))
			var newGameButton:FlxButton = new FlxButton(FlxG.width/2 - 45, 3*FlxG.height/5, "New Game", newGameCallback);
			pauseGroup.add (newGameButton);
			var MenuButton:FlxButton = new FlxButton(FlxG.width/2 - 45, 4*FlxG.height/5, "Main Menu", mainMenuCallback);
			pauseGroup.add (MenuButton);
			
			//adding the life bar
			var LifeBar:FlxSprite = new FlxSprite(FlxG.width/2, 10, ImgLifeBar);
			LifeBar.scale.x = 100;
			add(LifeBar);

			//adding instructions 
			instructionText = new FlxText(0,30,FlxG.width,"Use arrow keys or WASD to move and up to jump. Use space to shoot your enemies.");
			add(instructionText);
			
			//Adding in the player
			player = new Player(LifeBar);
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
			elapsedTime += FlxG.elapsed;
			if(gameTimer<=0)
				endGame();		
			remove(timerText);
			remove(scoreText);
			remove (instructionText);
			timerText = new FlxText(0,0,300,"Time: " + FlxU.ceil(gameTimer).toString());
			scoreText = new FlxText(FlxG.width - 60,0,300, "Score: " + enemies.countDead().toString());
			if (elapsedTime < 5) {
				instructionText = (new FlxText(0,FlxG.width /2 + 55,FlxG.width,"Use arrow keys or WASD to move and up to jump. Use space to shoot your enemies."))
			}
			else if (elapsedTime <10){
				instructionText = (new FlxText(0,FlxG.width /2 + 45,FlxG.width,"If you fall off the platform or run out of time you die. When the humans touch you they shove you and take away some of your time... Those mean humans :( "))
			}
			else if (elapsedTime <15){
				instructionText = (new FlxText(40,FlxG.width /2 + 55,FlxG.width,"You can prolong your life by killing the humans"))
			}
			else if (elapsedTime <20){
				instructionText = (new FlxText(0,FlxG.width /2 + 55,FlxG.width,"If you need a break from all this intensity you can press P to pause"))
			}
			else if (elapsedTime <30) {
				instructionText = (new FlxText(FlxG.width/2 -25,FlxG.width /2 + 55 ,FlxG.width,"Good Luck!"))
			}
			else if (elapsedTime <40){
				instructionText = (new FlxText(FlxG.width/4 -5,FlxG.width /2 + 55,FlxG.width,"Are you still reading these messages?"))
			}
			else if (elapsedTime <60){
				instructionText = (new FlxText(50,FlxG.width /2 + 55,FlxG.width,"You really should be focusing more on surviving..."))
			}
			else if (elapsedTime <100){
				instructionText = (new FlxText(10,FlxG.width /2 + 55,FlxG.width,"Man you are pretty good at this, maybe you will live forever"))
			}
			else if (true){
				instructionText = (new FlxText(25,FlxG.width /2 + 55,FlxG.width,"I don't think I've seen any other robot survive this long"))
			}
			
				
			add(timerText);
			add(scoreText);
			add (instructionText);
			endText = new FlxText(FlxG.width/2 - 100 ,2*FlxG.height/5, 300, ("You killed "+ enemies.countDead().toString()+ " human(s) and lasted " +  FlxU.ceil(elapsedTime).toString() + " seconds"));
			spawn();
			super.update();
		}
		
		public function spawn():void
		{
			this.counter++;
			if(this.counter % 50 == 0){
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
			if(enemy.hit(PLAYER_DAMAGE)){
				gameTimer += ENEMY_TIME_REWARD;
			}
			bullet.kill();
		}
		
		public function hitPlayer(player:Player, enemy:Enemy):void
		{
			if(player.hit(enemy))
				gameTimer -= enemy.damage;
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






