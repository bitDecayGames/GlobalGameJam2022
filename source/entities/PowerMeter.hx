package entities;

import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import extensions.FlxPointExt;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class PowerMeter extends FlxTypedSpriteGroup<FlxSprite> {
	public static final THICKNESS:Float = 20;
	public static final LENGTH:Float = 60;
	private static final RUMBLE_RADIUS:Float = 1.5;

	private var _shell:PowerMeterFrame;
	private var _power:PowerMeterPower;

	private var _anchor:FlxPoint;
	private var _rnd:FlxRandom;

	// a number between 0 and 1 to represent how full the meter is (0 is empty)
	@:isVar public var power(get, set):Float;

	// either -1 or +1
	private var _flucDir:Float;

	function get_power():Float {
		return power;
	}

	function set_power(power:Float) {
		var p:Float = 0;
		if (power < 0) {
			p = 0;
		} else if (power > 1) {
			p = 1;
		} else {
			p = power;
		}
		_power.scale.set(LENGTH * p, THICKNESS);
		return this.power = p;
	}

	public function new(x:Float, y:Float) {
		super(x, y);
		_flucDir = 1;
		_shell = new PowerMeterFrame(x, y);
		_power = new PowerMeterPower(x, y);
		_shell.scale.set(LENGTH, THICKNESS);
		add(_shell);
		add(_power);
		power = 0;

		saveAnchor();
		_rnd = new FlxRandom();
	}

	public function saveAnchor() {
		_anchor = FlxPoint.get(x, y);
	}

	public function fluctuatePower(speed:Float):PowerMeter {
		var p = power + _flucDir * speed;
		if (p < 0) {
			p = 0;
			_flucDir = 1;
		} else if (p > 1) {
			p = 1;
			_flucDir = -1;
		}
		power = p;
		return this;
	}

	public function buildUpMorePower(speed:Float):PowerMeter {
		var p = power + _flucDir * speed;
		if (p < 0) {
			p = 0;
		} else if (p > 1) {
			p = 1;
		}
		power = p;
		return this;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		rumble();
	}

	private function rumble() {
		if (power > 0) {
			var rumblePoint = FlxPointExt.pointOnCircumference(_anchor, _rnd.float() * 360, power * RUMBLE_RADIUS);
			x = rumblePoint.x;
			y = rumblePoint.y;
		} else {
			x = _anchor.x;
			y = _anchor.y;
		}
	}
}
