package entities;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using echo.FlxEcho;

class Bullet extends FlxSprite {
	public var age:Float = 0.0;

	public function new(x:Float, y:Float, vel:FlxPoint) {
		super(x, y);
		makeGraphic(10, 10, FlxColor.RED);

		this.add_body({
			x: x + 5,
			y: y + 5,
			elasticity: 0.95,
			shape: {
				type: CIRCLE,
				radius: 5
			},
			velocity_x: vel.x,
			velocity_y: vel.y
		});
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		age += elapsed;
	}

	override function kill() {
		super.kill();
		// remove echo physics body from the world here
		this.get_body().active = false;
	}
}
