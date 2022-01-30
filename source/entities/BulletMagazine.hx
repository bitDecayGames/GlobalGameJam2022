package entities;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import echo.FlxEcho;

class BulletMagazine {
	private var _maxBullets:Int;
	private var _curBullets:Int;

	public function new(maxBullets:Int) {
		_maxBullets = maxBullets;
	}

	public function shoot():Bool {
		if (_curBullets <= 0) {
			return false;
		}
		_curBullets--;
		return true;
	}

	public function reload() {
		_curBullets = _maxBullets;
	}

	public function count():Int {
		return _curBullets;
	}
}
