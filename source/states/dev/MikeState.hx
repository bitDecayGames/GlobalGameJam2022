package states.dev;

import entities.PowerMeter;
import flixel.math.FlxRandom;
import haxefmod.flixel.FmodFlxUtilities;
import input.SimpleController;
import haxe.io.Input;
import entities.Wall;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;

using extensions.FlxStateExt;

class MikeState extends FlxTransitionableState {
	private var power:PowerMeter;

	override public function create() {
		super.create();
		FlxG.camera.pixelPerfectRender = true;
		var rnd = new FlxRandom();
		var wall = new Wall(100, 0).buildWallBlocks(10, rnd.int(1, 3));
		add(wall);

		power = new PowerMeter(200, 200);
		add(power);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (SimpleController.just_pressed(Button.UP)) {
			FmodFlxUtilities.TransitionToState(new MikeState());
		}
		if (SimpleController.pressed(Button.LEFT)) {
			power.power -= 0.01;
		} else if (SimpleController.pressed(Button.RIGHT)) {
			power.power += 0.01;
		} else if (SimpleController.pressed(Button.DOWN)) {
			power.fluctuate(elapsed);
		}
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
