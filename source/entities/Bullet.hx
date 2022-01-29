package entities;

import echo.FlxEcho;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

class Bullet extends FlxSprite {
	public var age:Float = 0.0;

	public function new(x:Float, y:Float, vel:FlxPoint) {
		super(x, y);
		makeGraphic(10, 10, FlxColor.RED);

		FlxEcho.add_body(this, {
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
}
