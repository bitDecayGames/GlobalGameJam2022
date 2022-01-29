package entities;

import flixel.FlxObject;
import echo.data.Data.CollisionData;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;

using echo.FlxEcho;

class Bullet extends FlxSprite {
	public var isLethal:Bool = false;
    var maxBounces = 1;
    var remainingBounces = 1;

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
