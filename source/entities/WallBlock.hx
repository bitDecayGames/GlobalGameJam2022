package entities;

import echo.FlxEcho;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class WallBlock extends FlxSprite {
	public static final WALL_HEIGHT:Int = 40;

	public function new(x:Float, y:Float) {
		trace('making block at (${x}, ${y})');
		super();
		makeGraphic(WALL_HEIGHT, WALL_HEIGHT, FlxColor.BROWN);

		FlxEcho.add_body(this, {
			x: x + WALL_HEIGHT / 2,
			y: y + WALL_HEIGHT / 2,
			shape: {
				type: RECT,
				width: WALL_HEIGHT,
			},
			mass: 0,
		});
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
