package entities;

import echo.FlxEcho;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class WallBlock extends FlxSprite {
	public static final WALL_HEIGHT:Int = 40;

	public function new(x:Float, y:Float, height:Int) {
		trace('making block at (${x}, ${y}) of height ${height}');
		super();

		var physicsHeight = height * WALL_HEIGHT;

		// BEGIN: build our wall as a single sprite so that stamping effect looks nice
		makeGraphic(WALL_HEIGHT, physicsHeight, FlxColor.BROWN, true);

		var stamper = new FlxSprite(WALL_HEIGHT, WALL_HEIGHT);
		stamper.makeGraphic(WallBlock.WALL_HEIGHT, physicsHeight, FlxColor.TRANSPARENT, true);
		for (i in 0...height) {
			stamper.stamp(this, 0, Std.int(y + i * WALL_HEIGHT));
		}
		// END

		FlxEcho.add_body(this, {
			x: x + WALL_HEIGHT / 2,
			y: y + physicsHeight / 2,
			shape: {
				type: RECT,
				width: WALL_HEIGHT,
				height: physicsHeight
			},
			mass: 0,
		});
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
