package states.dev;

import entities.AngleIndicator;
import echo.FlxEcho;
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
	private var angleInd:AngleIndicator;

	override public function create() {
		super.create();

		// Initialize  FlxEcho
		FlxEcho.init({width: FlxG.width, height: FlxG.height, gravity_y: PlayState.gravity});

		FlxG.camera.pixelPerfectRender = true;
		var rnd = new FlxRandom();
		var wall = new Wall(100, 0).buildWallBlocks(10, rnd.int(1, 3));
		add(wall);

		power = new PowerMeter(200, 200);
		add(power);

		angleInd = new AngleIndicator(200, 100, 50);
		add(angleInd);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (SimpleController.just_pressed(Button.UP)) {
			FmodFlxUtilities.TransitionToState(new MikeState());
		}
		if (SimpleController.pressed(Button.LEFT)) {
			power.power -= 0.01;
			angleInd.angle -= 1;
		} else if (SimpleController.pressed(Button.RIGHT)) {
			power.power += 0.01;
			angleInd.angle += 1;
		} else if (SimpleController.pressed(Button.DOWN)) {
			power.fluctuate(elapsed * 2.0);
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
