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
		_curBullets = maxBullets;
	}

	public function shoot():Bool {
		if (_curBullets == 0) {
			return false;
		} else if (_curBullets < 0) {
			return true;
		}
		if (!GameData.currentRound.unlimitedAmmo){
			_curBullets--;
		}
		return true;
	}

	public function reload() {
		_curBullets = _maxBullets;
	}

	public function count():Int {
		return _curBullets;
	}
}
