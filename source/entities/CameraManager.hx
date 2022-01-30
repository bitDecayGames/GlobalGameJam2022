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

    public function new(camera:FlxZoomCamera, focusHome:FlxObject) {
        this.camera = camera;
        this.focusHome = focusHome;
        this.currentTarget = focusHome;
    }

    public function zoomTo(player:Player) {
        this.currentTransition = Transition.ZoomToPlayer;
        //this.camera.targetZoom = 3;
        //this.camera.zoomSpeed = 0.5;
        this.currentTarget = player;
        this.camera.follow(player, FlxCameraFollowStyle.LOCKON, 0.02);
    }

    public function zoomOut() {
        this.currentTransition = Transition.ZoomOut;
        this.currentTarget = focusHome;
        this.camera.targetZoom = 0;
        this.camera.follow(focusHome, FlxCameraFollowStyle.LOCKON, 0.02);
    }

    private function isCameraOnTarget() {
        var closeEnoguh = 10;

        // These offset calculations don't work. Maybe something from the traces below will help, but I can't make sense of it
        var xOffset = Math.abs(camera.scroll.x + FlxG.width / 2 + currentTarget.x );
        var yOffset = Math.abs(camera.scroll.y + FlxG.height / 2 + currentTarget.y );

        trace("camera scroll:" + camera.scroll.x + ", " + camera.scroll.y);
        trace("camera scroll - screen w/h:" + (camera.scroll.x - FlxG.width) + ", " + (camera.scroll.y - FlxG.height));
        trace("target midpoint: " + currentTarget.getMidpoint().x, currentTarget.getMidpoint().y);
        trace("target x, y: " + currentTarget.x + ", " + currentTarget.y);
        trace("target w x h: " + currentTarget.width + ", " + currentTarget.height);
        trace("targetOffset:" + camera.targetOffset.x + ", " + camera.targetOffset.y);
        trace("distance to target?: " + xOffset + ", " + yOffset);
        return xOffset < closeEnoguh && yOffset < closeEnoguh; 

    }

    public function update() {
                
        //Determining if the camera has caught up with what it is following by coordinates is hard. 
        // so lets just see if the camera has stopped moving relative to it's last position

        trace("camera update!:" + this.camera.x + ", " + this.currentTransition);
        if (currentTransition == Transition.ZoomToPlayer && this.isCameraOnTarget()) {
           this.zoomOut();
        } else if (currentTransition == Transition.ZoomOut && this.isCameraOnTarget()) {
            this.currentTransition = Transition.None;
        }
    }
}