package entities;

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

	var speed:Float = 30;
	var playerNum:Int;

	var wid = 50;
	var hig = 100;

	private var angleInd:AngleIndicator;
	private var powerMeter:PowerMeter;

	public var body:FlxSprite;

	private var bulletPhysicsGroup:Null<BulletsPhysicsGroup>;

	public function new(x:Float, y:Float, playerNum:Int, ?bulletPhysicsGroup:BulletsPhysicsGroup) {
		super(x, y);
		this.bulletPhysicsGroup = bulletPhysicsGroup;
		body = new FlxSprite();
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
	}

	public function shoot() {
		var bullet = new Bullet(x, y, FlxVector.get(0, -1).rotateByDegrees(angleInd.angle).scale(powerMeter.power * POWER_SCALE));
		FlxG.state.add(bullet);
		if (bulletPhysicsGroup != null) {
			bulletPhysicsGroup.addBullet(bullet);
		}
	}

	public function shot(hitBy:FlxSprite, state:FlxState) {
		// for now just delete the player and whatever it was hit by
		// later we can add fancy animations, screams of terror,
		// explosions, etc.
		state.remove(hitBy);
		state.remove(this);
	}
}
