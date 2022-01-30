package states;

import entities.CameraManager;
import flixel.addons.display.FlxZoomCamera;
import entities.Floor;
import entities.Wall;
import entities.physicsgroups.PhysicsCollisions;
import flixel.math.FlxPoint;
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

	var world:World;
	var cameraManager:CameraManager;

	public static inline var gravity = 98;

	override public function create() {
		super.create();

		Lifecycle.startup.dispatch();

		// Initialize  FlxEcho
		FlxEcho.init({width: FlxG.width, height: FlxG.height, gravity_y: PlayState.gravity});

		// this is required for collisions to work
		var physics = new PhysicsCollisions();

		var zoomCamera = new FlxZoomCamera(0, 0, FlxG.width, FlxG.height, 0);
		zoomCamera.zoomSpeed = 0; // 0.75;
		zoomCamera.targetZoom = 0; //1.1;
		zoomCamera.pixelPerfectRender = true;
		FlxG.cameras.reset(zoomCamera);

		var wall = new Wall(FlxG.width * .5, 0).buildWallBlocks(10, 3);
		add(wall);

		var center = new FlxObject(0, 0, 1, 1);
		cameraManager = new CameraManager(zoomCamera, center);

		var floor = new Floor();
		add(floor);

		var player1 = new Player(100, floor.y - 100, 0, physics.bullets, cameraManager);
		add(player1);

		var player2 = new Player(FlxG.width - 100, floor.y - 100, 1, physics.bullets, cameraManager);
		add(player2);

		// this is also required for collisions to work
		physics.init([player1, player2], wall, floor);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		cameraManager.update();
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
