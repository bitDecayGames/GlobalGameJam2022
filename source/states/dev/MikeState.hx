package states.dev;

import flixel.math.FlxRandom;
import haxefmod.flixel.FmodFlxUtilities;
import input.SimpleController;
import haxe.io.Input;
import entities.Wall;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;

using extensions.FlxStateExt;

class MikeState extends FlxTransitionableState {
	override public function create() {
		super.create();
		FlxG.camera.pixelPerfectRender = true;
		var rnd = new FlxRandom();
		var wall = new Wall(100, 0).buildWallBlocks(10, rnd.int(1, 3));
		add(wall);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (SimpleController.just_pressed(Button.UP)) {
			FmodFlxUtilities.TransitionToState(new MikeState());
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
