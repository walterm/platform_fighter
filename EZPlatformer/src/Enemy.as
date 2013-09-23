package
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class Enemy extends FlxSprite
	{
		[Embed(source='res/enemy.png')]
		public static var ImgEnemy:Class;
		
		//Get Hurt from http://www.sinisterdesign.net/Downloads/Assemblee%201%20-%20Hurt%202.wav
		[Embed(source='res/hurt.mp3')]
		public static var Hurt:Class;
		
		//Enemy configuration
		private static var MAX_HEALTH:Number = 100;
		private static var X_ACCEL_SCALAR:int = 200;
		private static var MAX_X_VEL:int = 20;
		private static var MAX_Y_VEL:int = 200;
		private static var GRAVITY_ACCEL:int = 200;
		
		public var damage:int;
		private var counter:int;
		
		public function randomRange():Number{
			return Math.random() * 100 + 50;
		}
		
		public function Enemy()
		{
			//aspect ratio?
			super(randomRange(), randomRange());
			health = MAX_HEALTH;
			
			//Loading the sprite
			loadGraphic(ImgEnemy, true, true, 14, 15);
			
			//Setting animations
			addAnimation("walk",[0,1,2,1], 5);
			addAnimation("idle",[0]);
			
			maxVelocity.x = MAX_X_VEL;
			maxVelocity.y = MAX_Y_VEL;
			acceleration.x = X_ACCEL_SCALAR;
			acceleration.y = GRAVITY_ACCEL;
			this.counter = 0;
			
			//Setting damage
			damage = 10
		}
		
		public function hit(damage:int):void
		{
			health -= damage;
			FlxG.play(Hurt, 1);
			if(health <= 0){
				this.exists = false;
			}
		}
		
		override public function update():void
		{
			super.update();
			if(isTouching(FlxObject.FLOOR)){
				velocity.y = 0;
				play("walk");
				
				this.counter+= 1;
				if(this.counter == 100){
					if(facing == LEFT){
						facing = RIGHT;
						acceleration.x = maxVelocity.x * X_ACCEL_SCALAR;
					} else {
						facing = LEFT;
						acceleration.x = -maxVelocity.x * X_ACCEL_SCALAR;
					}
					this.counter = 0;
				}
			}
			
		}
	}
}