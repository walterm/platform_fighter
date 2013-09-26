package
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	
	public class Enemy extends FlxSprite
	{
		[Embed(source='res/enemy.png')]
		public static var ImgEnemy:Class;
		
		//Get Hurt from http://www.sinisterdesign.net/Downloads/Assemblee%201%20-%20Hurt%202.wav
		[Embed(source='res/hurt.mp3')]
		public static var Hurt:Class;
		
		//Enemy configuration
		private static var MAX_HEALTH:Number = 20;
		private static var X_ACCEL_SCALAR:int = 200;
		private static var MAX_X_VEL:int = 20;
		private static var MAX_Y_VEL:int = 200;
		private static var GRAVITY_ACCEL:int = 200;
		private var hasHitFloor:Boolean = false;
		
		public var damage:int;
		private var counter:int;
		
		public function randomRange():Number{
			return Math.random() *  (FlxG.width - 50) + 30;
		}
		
		
		public function Enemy()
		{
			//aspect ratio?
			super(randomRange(), 20);
			health = MAX_HEALTH;
			
			//Loading the sprite
			loadGraphic(ImgEnemy, true, true, 14, 15);
			
			//Setting animations
			addAnimation("walk",[0,1,2,1], 5);
			addAnimation("idle",[0]);
			
			maxVelocity.x = -MAX_X_VEL;
			maxVelocity.y = MAX_Y_VEL;
			acceleration.x = X_ACCEL_SCALAR;
			acceleration.y = GRAVITY_ACCEL;
			this.counter = 0;
			
			var num:int = Math.random() * 4 + 1;
			if(num < 3){
				maxVelocity.x = -MAX_X_VEL;
				maxVelocity.y = MAX_Y_VEL;
				acceleration.x = X_ACCEL_SCALAR;
				acceleration.y = GRAVITY_ACCEL;
				facing = LEFT;
			} else{
				maxVelocity.x = MAX_X_VEL;
				maxVelocity.y = MAX_Y_VEL;
				acceleration.x = X_ACCEL_SCALAR;
				acceleration.y = GRAVITY_ACCEL;
				facing = RIGHT;
			}
			
			//Setting damage
			damage = 1;
		}
		
		public function hit(damage:int):Boolean
		{
			health -= damage;
			FlxG.play(Hurt, 1);
			if(health <= 0){
				this.kill();
				return true;
			}
			return false;
		}
		
		override public function update():void
		{
			super.update();
			if(isTouching(FlxObject.FLOOR)){
				velocity.y = 0;
				play("walk");
				this.hasHitFloor = true;
			}else{
				if(this.hasHitFloor){
					var last:FlxPoint = this.last;
					if(facing == LEFT){
						this.reset(last.x + 10, last.y);
						facing = RIGHT;
						acceleration.x = maxVelocity.x * X_ACCEL_SCALAR;
					}
					else{
						facing = LEFT;
						this.reset(last.x - 10, last.y);
						acceleration.x = -maxVelocity.x * X_ACCEL_SCALAR;
					}
				}
			}
			
		}
	}
}