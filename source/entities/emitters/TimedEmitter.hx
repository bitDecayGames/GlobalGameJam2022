package entities.emitters;

import flixel.FlxBasic;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;

class TimedEmitter extends FlxEmitter
{
    public function new(x:Float, y:Float) {
		super(x, y);
        makeParticles(2, 2, FlxColor.GREEN, 200);
        launchMode = FlxEmitterMode.SQUARE;
        velocity.set(-10,-10,10,10,-10,-10,10,10);
        alpha.set(0.9, 1, 0, 0);
        lifespan.set(0.5, 1.5);
        scale.set(0.3, 0.3, 1, 1);
        start(true, 0.1, 10);
    }
    
	override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        // for (emitter => timeLeft in emitters) {
        //     timeLeft -= elapsed;
        //     if (timeLeft <= 0) {
        //         emitter.destroy();
        //     }
        // }
    }
}

