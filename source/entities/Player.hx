package entities;

import states.PlayState;
import flixel.FlxState;
import input.SimpleController;
import input.InputCalcuator;
import flixel.util.FlxColor;
import entities.physicsgroups.BulletsPhysicsGroup;
import flixel.math.FlxVector;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import haxe.Int64Helper;
import input.InputCalcuator;
import input.SimpleController;

using echo.FlxEcho;

class Player extends FlxTypedSpriteGroup<FlxSprite> {
	private static final CHANGE_ANGLE_SPEED:Float = 1.0;
	private static final POWER_SCALE:Float = 300;
	private static final MIN_SHOOT_POWER:Float = 75;

	var speed:Float = 30;

	public var playerNum:Int;

	var wid = 50;
	var hig = 100;

	private var angleInd:AngleIndicator;
	private var powerMeter:PowerMeter;

	public var body:FlxSprite;

	private var bulletPhysicsGroup:Null<BulletsPhysicsGroup>;
	private var cameraManager:CameraManager;

	public function new(x:Float, y:Float, playerNum:Int, bulletPhysicsGroup:Null<BulletsPhysicsGroup>, cameraManager:CameraManager) {
		super(x, y);
		this.bulletPhysicsGroup = bulletPhysicsGroup;
		this.cameraManager = cameraManager;
		body = new PlayerBodySprite(this);
		body.makeGraphic(wid, hig, FlxColor.GREEN);
		add(body);
		this.playerNum = playerNum;

		angleInd = new AngleIndicator(0, -70, 70);
		add(angleInd);

		// MW notice the .25 instead of .5 here... no fucking idea...
		powerMeter = new PowerMeter(-PowerMeter.LENGTH * .25, -hig * .5);
		powerMeter.visible = false;
		add(powerMeter);

		body.add_body({
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

		if (SimpleController.just_pressed(Button.A, playerNum)) {
			powerMeter.power = 0;
			powerMeter.visible = true;
		} else if (SimpleController.pressed(Button.A, playerNum)) {
			powerMeter.fluctuate(delta * 2);
		} else if (SimpleController.just_released(Button.A, playerNum)) {
			powerMeter.visible = false;
			shoot();
		}

		if (SimpleController.pressed(Button.UP, playerNum)) {
			angleInd.angle += CHANGE_ANGLE_SPEED;
		} else if (SimpleController.pressed(Button.DOWN, playerNum)) {
			angleInd.angle -= CHANGE_ANGLE_SPEED;
		}

		var stick = SimpleController.getLeftStick(playerNum);
		if (stick != null && stick.length > 0.2) {
			stick.normalize();
			// TODO: MW might want to add some lerp to this so that the angle isn't so jittery from your finger?

			// the + 90 is here because stick.degrees is relative to the horizontal axis, but we need it relative to the vertical
			// axis to match up with the fact that 0 degress equals up
			angleInd.angle = stick.degrees + 90;
		}
	}

	public function shoot() {
		var bullet = new Bullet(x, y, FlxVector.get(0, -1).rotateByDegrees(angleInd.angle).scale(MIN_SHOOT_POWER + powerMeter.power * POWER_SCALE));
		FlxG.state.add(bullet);
		if (bulletPhysicsGroup != null) {
			bulletPhysicsGroup.addBullet(bullet);
		}
		FlxG.camera.shake(powerMeter.power / 85, powerMeter.power / 3);
	}

	public function shot(hitBy:Bullet) {
		// for now just delete the player and whatever it was hit by
		// later we can add fancy animations, screams of terror,
		// explosions, etc.
		this.cameraManager.zoomTo(this);
		hitBy.kill();
		this.kill();
	

	}

	override function kill() {
		super.kill();
		// remove echo physics body from the world here
		body.get_body().active = false;
	}
}
