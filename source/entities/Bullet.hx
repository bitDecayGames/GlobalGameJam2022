package entities;

import flixel.math.FlxRandom;
import flixel.FlxObject;
import echo.data.Data.CollisionData;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using echo.FlxEcho;

class Bullet extends FlxSprite {
	public static final BULLET_RADIUS:Int = 15;
	public static final MAX_SPIN_SPEED:Float = 200;

	public var isLethal:Bool = true;

	var maxBounces = 1;
	var remainingBounces = 1;

	public function new(x:Float, y:Float, vel:FlxPoint) {
		super(x, y);
		// makeGraphic(BULLET_RADIUS * 2, BULLET_RADIUS * 2, FlxColor.RED);
		loadGraphic(AssetPaths.slimeball__png, true, 80, 80);
		animation.add("squish", [0, 1, 2, 3, 4, 5, 6, 7], 10);
		animation.play("squish");
		scale.scale((BULLET_RADIUS * 2.0) / width);

		this.add_body({
			x: x + BULLET_RADIUS*3,
			y: y + BULLET_RADIUS*3,
			elasticity: 0.95,
			shape: {
				type: CIRCLE,
				radius: BULLET_RADIUS
			},
			velocity_x: vel.x,
			velocity_y: vel.y,
			rotational_velocity: (new FlxRandom()).float(-1, 1) * MAX_SPIN_SPEED,
		});
	}

	override function kill() {
		super.kill();
		// remove echo physics body from the world here
		this.get_body().active = false;
	}

	public function hit(terrain:FlxSprite, collisionData:Array<CollisionData>) {
		// override this to do cool stuff on a per-bullet type basis
		remainingBounces--;
		if (remainingBounces < 0) {
			kill();
		}
	}
}
