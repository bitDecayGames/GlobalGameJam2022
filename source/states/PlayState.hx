package states;

import input.SimpleController;
import entities.GameData;
import entities.Floor;
import entities.Wall;
import entities.physicsgroups.PhysicsCollisions;
import flixel.math.FlxPoint;
import ui.PlayOverlay;
import entities.Bullet;
import flixel.util.FlxColor;
import flixel.FlxObject;
import echo.Body;
import echo.Echo;
import flixel.addons.transition.FlxTransitionableState;
import signals.Lifecycle;
import entities.Player;
import flixel.FlxSprite;
import flixel.FlxG;
import echo.World;

using extensions.FlxStateExt;
using echo.FlxEcho;

class PlayState extends FlxTransitionableState {
	var player:FlxSprite;
	var gameData:GameData;
	var world:World;

	public static inline var gravity = 98;

	override public function create() {
		super.create();
		bgColor = FlxColor.GRAY;
		Lifecycle.startup.dispatch();

		gameData = new GameData();

		// Initialize  FlxEcho
		FlxEcho.init({width: FlxG.width, height: FlxG.height, gravity_y: PlayState.gravity});

		// this is required for collisions to work
		var physics = new PhysicsCollisions();

		FlxG.camera.pixelPerfectRender = true;
		var wall = new Wall(FlxG.width * .5, 0).buildWallBlocks(10, 3, 3);
		add(wall);

		var floor = new Floor();
		add(floor);

		var player1 = new Player(100, floor.y - 100, 0, physics.bullets);
		add(player1);

		var player2 = new Player(FlxG.width - 100, floor.y - 100, 1, physics.bullets);
		add(player2);

		physics.init([player1, player2], wall, floor);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (subState == null) {
			openSubState(new PlayOverlay(gameData, ()->{}));
		}

		if (FlxG.keys.justPressed.SPACE || SimpleController.just_pressed(Button.B, 0)){
			FlxG.resetGame();
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
