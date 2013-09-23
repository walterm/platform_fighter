package
{
	import LaserProjectile;
	
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	import org.flixel.FlxSprite;
	
	public class Player extends FlxSprite
	{
		[Embed(source='res/player.png')]
		public static var ImgPlayer:Class;
		
		[Embed(source='res/jump.mp3')]
		public static var Mp3Jump:Class;
		
		[Embed(source='res/laser.mp3')]
		public static var Mp3Laser:Class;
		
		public static var Lasers:Array;
		// PLayer configuration constants
		private static var DRAG_FACTOR:int = 4;
		private static var GRAVITY_ACCEL:int = 200;
		private static var MAX_X_VEL:int = 80;
		private static var MAX_Y_VEL:int = 200;
		private static var X_ACCEL_SCALAR:int = 4;
		private static var Y_ACCEL_SCALAR:Number = 0.5;
		private static var MAX_HEALTH:Number = 100;
		
		public var laser:LaserProjectile;
		
		public function Player()
		{
			super(FlxG.width / 2, FlxG.height/2-10);
			health = MAX_HEALTH;
			
			// Loading image
			loadGraphic(ImgPlayer, true, true, 14, 15);
			
			// Setting animations
			addAnimation("idle" /*name of animation*/, [0] /*used frames*/);
			addAnimation("walk", [0, 1, 2, 1], 5 /*frames per second*/);
			addAnimation("jump", [3]);
			addAnimation("shoot", [4, 5, 6, 5], 5);
			addAnimation("shoot_short", [6]);
			
			maxVelocity.x = MAX_X_VEL;
			maxVelocity.y = MAX_Y_VEL;
			acceleration.y = GRAVITY_ACCEL;
			drag.x = maxVelocity.x * DRAG_FACTOR;
			facing = RIGHT;
		}
		
		//		public function hit(Projectile projectile){
		//			health -= projectile.power;
		//		}
		
		override public function update():void
		{	
			super.update();
			
			acceleration.x = 0;
			if (FlxG.keys.LEFT){
				acceleration.x = -maxVelocity.x * X_ACCEL_SCALAR;
				facing = LEFT;
			}
			if (FlxG.keys.RIGHT){
				acceleration.x = maxVelocity.x * X_ACCEL_SCALAR;
				facing = RIGHT;
			}
			if (FlxG.keys.SPACE && isTouching(FlxObject.FLOOR))
			{
				velocity.y = -maxVelocity.y * Y_ACCEL_SCALAR;
				FlxG.play(Mp3Jump);
			}
			if(FlxG.keys.justPressed("S")){
				FlxG.play(Mp3Laser, 0.2);
			}
			
			if (isTouching(FlxObject.FLOOR))
			{
				if (FlxG.keys.justPressed("S")){
					var sprite:FlxSprite = (FlxG.state as PlayState).playerBullets.recycle() as FlxSprite;
					sprite.reset(x + width/2 - sprite.width/2, y + height/2);
					sprite.color = 0x990000;
					if(facing == RIGHT){
						sprite.velocity.x = 200;
					}
					else{
						sprite.velocity.x = -200;
					}
				}
				
				if(FlxG.keys.S){
					play("shoot_short");
				}
				else if (!FlxG.keys.LEFT && !FlxG.keys.RIGHT &&!FlxG.keys.S)
				{
					play("idle");
				}
				else
				{
					play("walk");
				}
			}
			else
			{
				if (FlxG.keys.justPressed("S")){
					var bullet:FlxSprite = (FlxG.state as PlayState).playerBullets.recycle() as FlxSprite;
					bullet.reset(x + width/2 - bullet.width/2, y + height/2);
					bullet.color = 0x990000;
					if(facing == RIGHT){
						bullet.velocity.x = 200;
					}
					else{
						bullet.velocity.x = -200;
					}
				}
				
				if (FlxG.keys.S){
					play("shoot_short");
				}
				else{
					play("jump");
				}
			}
		}
	}
}