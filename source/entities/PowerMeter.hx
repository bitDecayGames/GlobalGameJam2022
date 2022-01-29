package entities;

import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class PowerMeter extends FlxTypedSpriteGroup<FlxSprite> {
	public static final THICKNESS:Float = 20;
	public static final LENGTH:Float = 60;

	private var _shell:PowerMeterFrame;
	private var _power:PowerMeterPower;

	// a number between 0 and 1 to represent how full the meter is (0 is empty)
	@:isVar public var power(get, set):Float;

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
		_shell = new PowerMeterFrame(x, y);
		_power = new PowerMeterPower(x, y);
		_shell.scale.set(LENGTH, THICKNESS);
		add(_shell);
		add(_power);
		power = 0;
	}
}
