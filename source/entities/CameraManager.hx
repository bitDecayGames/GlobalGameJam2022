package entities;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxObject;
import flixel.FlxCamera.FlxCameraFollowStyle;
import states.transitions.Trans;
import js.html.TrackElement;
import flixel.addons.display.FlxZoomCamera;

enum Transition{
    None;
    ZoomToPlayer;
    ZoomOut;
}

class CameraManager {
    var camera:FlxZoomCamera;
    var focusHome:FlxObject;


    var oldScrollX:Float = 0;
    var oldScrollY:Float = 0;
    var currentTransition:Transition = Transition.None;
    var currentTarget:FlxObject;
    var baseCameraXOffset:Float;
    var baseCameraYOffset:Float;

    public function new(camera:FlxZoomCamera, focusHome:FlxObject) {
        this.camera = camera;
        this.focusHome = focusHome;
        this.currentTarget = focusHome;
        this.baseCameraXOffset = -(camera.x - focusHome.x);
        this.baseCameraYOffset = -(camera.y - focusHome.y);
    }

    public function zoomTo(player:Player) {
        this.currentTransition = Transition.ZoomToPlayer;
        //this.camera.targetZoom = 3;
        //this.camera.zoomSpeed = 0.5;
        this.currentTarget = player;
        this.camera.follow(player, FlxCameraFollowStyle.LOCKON, 0.02);
    };

    public function zoomOut() {
        trace("zoom out");
        this.currentTransition = Transition.ZoomOut;
        this.currentTarget = focusHome;
        this.camera.targetZoom = 0;
        this.camera.follow(focusHome, FlxCameraFollowStyle.LOCKON, 0.02);
    }

    private function isCameraOnTarget() {
        var closeEnoguh = 10;

        var xOffset = Math.abs(camera.scroll.x + FlxG.width / 2 + this.baseCameraXOffset - currentTarget.getMidpoint().x);
        var yOffset = Math.abs(camera.scroll.y + FlxG.height / 2 + this.baseCameraYOffset - currentTarget.getMidpoint().y);

        // trace("camera scroll:" + camera.scroll.x + ", " + camera.scroll.y);
        // trace("camera scroll - screen w/h:" + (camera.scroll.x - FlxG.width) + ", " + (camera.scroll.y - FlxG.height));
        // trace("target midpoint: " + currentTarget.getMidpoint().x, currentTarget.getMidpoint().y);
        // trace("target x, y: " + currentTarget.x + ", " + currentTarget.y);
        // trace("target w x h: " + currentTarget.width + ", " + currentTarget.height);
        // trace("FlxG wxh:" + FlxG.width + ", " + FlxG.height);
        trace("distance to target?: " + xOffset + ", " + yOffset);
        
        // The y coord seems off by 64 pixels even though it's calculated the same as x, but the way the camera follow works,
        // the x should be close at around the same as y so checking just x should be fine
        return xOffset < closeEnoguh; // && yOffset < closeEnoguh; 

    }

    public function update() {
                
        //Determining if the camera has caught up with what it is following by coordinates is hard. 
        trace("camera:" + camera.x + ", " + camera.y);       // so lets just see if the camera has stopped moving relative to it's last position

        trace("camera update!:" + this.camera.x + ", " + this.currentTransition);
        if (currentTransition == Transition.ZoomToPlayer && this.isCameraOnTarget()) {
           this.zoomOut();
        } else if (currentTransition == Transition.ZoomOut && this.isCameraOnTarget()) {
            this.currentTransition = Transition.None;
        }
    }
}