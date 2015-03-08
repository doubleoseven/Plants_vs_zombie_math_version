package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import nme.ui.Mouse;
import nme.display.Graphics;
import nme.display.BlendMode;
import nme.display.BitmapData;
import nme.display.Bitmap;
import nme.events.Event;
import nme.events.KeyboardEvent;
import nme.events.TouchEvent;
import nme.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_9_9_FollowDragandDrop extends ActorScript
{          	
	
public var _XOffset:Float;

public var _YOffset:Float;

public var _Grabbed:Bool;

public var _OldX:Float;

public var _OldY:Float;

public var _DistanceX:Float;

public var _DistanceY:Float;

public var _Distance:Float;

public var _Direction:Float;

public var _MinimumSpeed:Float;

public var _Speed:Float;

public var _ScreenDiagonal:Float;

public var _KeepMovingonRelease:Bool;

public var _ReleaseSpeedFactor:Float;

 
 	public function new(dummy:Int, actor:Actor, engine:Engine)
	{
		super(actor, engine);	
		nameMap.set("Actor", "actor");
nameMap.set("X Offset", "_XOffset");
_XOffset = 0.0;
nameMap.set("Y Offset", "_YOffset");
_YOffset = 0.0;
nameMap.set("Grabbed", "_Grabbed");
_Grabbed = false;
nameMap.set("Old X", "_OldX");
_OldX = 0.0;
nameMap.set("Old Y", "_OldY");
_OldY = 0.0;
nameMap.set("Distance X", "_DistanceX");
_DistanceX = 0.0;
nameMap.set("Distance Y", "_DistanceY");
_DistanceY = 0.0;
nameMap.set("Distance", "_Distance");
_Distance = 0.0;
nameMap.set("Direction", "_Direction");
_Direction = 0.0;
nameMap.set("Minimum Speed", "_MinimumSpeed");
_MinimumSpeed = 5.0;
nameMap.set("Speed", "_Speed");
_Speed = 1000.0;
nameMap.set("Screen Diagonal", "_ScreenDiagonal");
_ScreenDiagonal = 0.0;
nameMap.set("Keep Moving on Release", "_KeepMovingonRelease");
_KeepMovingonRelease = false;
nameMap.set("Release Speed Factor", "_ReleaseSpeedFactor");
_ReleaseSpeedFactor = 0.5;

	}
	
	override public function init()
	{
		    
/* ======================== When Creating ========================= */
        _ScreenDiagonal = asNumber(Math.sqrt((Math.pow(getScreenWidth(), 2) + Math.pow(getScreenHeight(), 2))));
propertyChanged("_ScreenDiagonal", _ScreenDiagonal);
    
/* ======================== When Updating ========================= */
addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
{
if(wrapper.enabled)
{
        if(_Grabbed)
{
            if(isMouseDown())
{
                _DistanceX = asNumber(((getScreenX() + getMouseX()) - (actor.getXCenter() - _XOffset)));
propertyChanged("_DistanceX", _DistanceX);
                _DistanceY = asNumber(((getScreenY() + getMouseY()) - (actor.getYCenter() - _YOffset)));
propertyChanged("_DistanceY", _DistanceY);
                _Distance = asNumber(Math.sqrt((Math.pow(_DistanceX, 2) + Math.pow(_DistanceY, 2))));
propertyChanged("_Distance", _Distance);
                _Direction = asNumber(Utils.DEG * (Math.atan2(_DistanceY, _DistanceX)));
propertyChanged("_Direction", _Direction);
                if((_Distance > 0))
{
                    actor.setVelocity(_Direction, (_MinimumSpeed + (_Speed * (_Distance / _ScreenDiagonal))));
}

                else
{
                    actor.setVelocity(0, 0);
}

                actor.setAngularVelocity(Utils.RAD * (0));
}

            if(isMouseReleased())
{
                if(_KeepMovingonRelease)
{
                    actor.setXVelocity((actor.getXVelocity() * _ReleaseSpeedFactor));
                    actor.setYVelocity((actor.getYVelocity() * _ReleaseSpeedFactor));
}

                else
{
                    actor.setVelocity(0, 0);
}

                _Grabbed = false;
propertyChanged("_Grabbed", _Grabbed);
}

}

        else
{
            if(actor.isMousePressed())
{
                _XOffset = asNumber((actor.getXCenter() - (getScreenX() + getMouseX())));
propertyChanged("_XOffset", _XOffset);
                _YOffset = asNumber((actor.getYCenter() - (getScreenY() + getMouseY())));
propertyChanged("_YOffset", _YOffset);
                _Grabbed = true;
propertyChanged("_Grabbed", _Grabbed);
}

}

}
});

	}	      	
	
	override public function forwardMessage(msg:String)
	{
		
	}
}