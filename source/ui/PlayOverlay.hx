package ui;

import entities.Player;
import flixel.util.FlxAxes;
import flixel.FlxG;
import entities.GameData;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxSubState;

class PlayOverlay extends FlxSubState {
    var data:GameData;

    var startup:FlxSprite;
    var p1Score:FlxSprite;
    var p1Ammo:Array<FlxSprite> = new Array<FlxSprite>();
    var p2Score:FlxSprite;
    var p2Ammo:Array<FlxSprite> = new Array<FlxSprite>();

    var gameStarted:Bool = false;

    var callback:Void->Void;

    public function new(data:GameData, callback:Void->Void) {
        super();

        this.data = data;
        this.callback = callback;
    }

    function CreateBulletSprite(x:Int, y:Int):FlxSprite {
        var bulletSprite = new FlxSprite();
        bulletSprite.makeGraphic(20, 20, FlxColor.BROWN);
        bulletSprite.x = x;
        bulletSprite.y = y;
        add(bulletSprite);
        return bulletSprite;
    }

    override function create() {
        super.create();

        p1Score = new FlxSprite();
        p1Score.makeGraphic(50, 50, FlxColor.LIME);
        p1Score.x = 20;
        p1Score.y = 20;
        add(p1Score);


        p2Score = new FlxSprite();
        p2Score.makeGraphic(50, 50, FlxColor.LIME);
        p2Score.x = FlxG.width - 70;
        p2Score.y = 20;
        add(p2Score);

        for (i in 0...data.maxAmmo) {
            var spriteSpacingX = 25;
            var spriteDistanceFromTop = 20;
            p1Ammo.push(CreateBulletSprite(50 + spriteSpacingX * (i+1), spriteDistanceFromTop));
            p2Ammo.push(CreateBulletSprite((FlxG.width - 100) - (spriteSpacingX * i+1), spriteDistanceFromTop));
        }

        startup = new FlxSprite();
		startup.loadGraphic(AssetPaths.readysetgo__png, true, 200, 200);
		startup.animation.add("countdown", [0, 1, 2, 0], 1);
        startup.animation.play("countdown");
        startup.screenCenter(FlxAxes.XY);


        // Do this effect up front as the first frame doesn't seem to trigger it correctly
        FmodManager.PlaySoundOneShot(FmodSFX.AnnouncerReady);
        startup.animation.callback = (name:String, frameNum:Int, frameIndex:Int) -> {
            trace('name: ${name}, frame number: ${frameNum}, frame index: ${frameIndex}');
            // if (name == "countdown" && frameNum == 0) {
            //     FmodManager.PlaySoundOneShot(FmodSFX.AnnouncerReady);
            // }
            if (name == "countdown" && frameNum == 1) {
                FmodManager.PlaySoundOneShot(FmodSFX.AnnouncerSet);
            }
            if (name == "countdown" && frameNum == 2) {
                FmodManager.PlaySoundOneShot(FmodSFX.AnnouncerGo);
            }
            if (name == "countdown" && frameNum == 3) {
                gameStarted = true;
                callback();
                startup.kill();
            }
        };

        add(startup);
    }

    public function subtractAmmoFromPlayer(player:Player){
        if (player.playerNum == 0){
            var ammoSprite = p1Ammo.pop();
            if (ammoSprite != null){
                ammoSprite.destroy();
            }
        } else if (player.playerNum == 1) {
            var ammoSprite = p2Ammo.pop();
            if (ammoSprite != null){
                ammoSprite.destroy();
            }
        }
    }

    public function declareWinner(player:Player) {
        // TODO: Use the real victory overlay
        var winner = new FlxSprite();
        winner.scrollFactor.set(0,0);
		winner.loadGraphic(AssetPaths.readysetgo__png, true, 200, 200);
        winner.animation.add("win", [2], 1, false);
        winner.animation.play("win");
        winner.screenCenter(FlxAxes.XY);
        add(winner);

        p1Score.kill();
        p2Score.kill();
    }

    public function tieGame() {
        var tie = new FlxSprite();
        tie.scrollFactor.set(0,0);
		tie.loadGraphic(AssetPaths.readysetgo__png, true, 200, 200);
        tie.animation.add("tie", [1], 1, false);
        tie.animation.play("tie");
        tie.screenCenter(FlxAxes.XY);
        add(tie);

        p1Score.kill();
        p2Score.kill();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        _parentState.update(elapsed);
    }
}