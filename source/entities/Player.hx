package entities;

import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import flixel.FlxSprite;

using echo.FlxEcho;

class Player extends FlxSprite {
	var speed:Float = 30;
	var playerNum = 0;

	var wid = 50;
	var hig = 100;

	public function new(x:Float, y:Float) {
		super(x, y);
		makeGraphic(wid, hig, FlxColor.WHITE);
		color = FlxColor.BLUE;

		this.add_body({
			mass: 0,
			x: x,
			y: y,
			shape: {
				type: RECT,
				width: wid,
				height: hig,
			}
		});
	}

	override public function update(delta:Float) {
		super.update(delta);

		var inputDir = InputCalcuator.getInputCardinal(playerNum);
		if (inputDir != NONE) {
			inputDir.asVector(velocity).scale(speed);
		} else {
			velocity.set();
		}

		if (SimpleController.just_pressed(Button.A, playerNum)) {
			color = color ^ 0xFFFFFF;
		}
	}
}
