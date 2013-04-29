Const DIRECTIONAL:Int	= 1
Const POINT:Int			= 2
Const SPOT:Int			= 3

Extern "win32"
	Function __createLight:Byte ptr(engine:Byte ptr, lightType:Int, parent:Byte ptr) = "__createLight@12"
	Function __lightDiffuseColour(light:Byte ptr, r:Float, g:Float, b:Float) = "__lightDiffuseColour@16"
	Function __lightRange(light:Byte ptr, Range:Float) = "__lightRange@8"
	Function __lightConeAngles(light:Byte ptr, inner_angle:Float, outer_angle:Float) = "__lightConeAngles@12"
End Extern

Type TLight Extends TEntity
	Function CreateLight:TLight(engine:TOgre, lightType:Int = DIRECTIONAL, parent:TEntity = Null)
		Local p:Byte ptr
		If parent <> Null Then p = parent._hnd
		
		Local light:TLight	= New TLight
		light._hnd			= __createLight(engine._hnd, lightType, p)
		light._objName		= engine.genName("light_")
		light._objType		= TYPE_LIGHT
		
		Return light
	End Function
	
	Method LightDiffuseColor(r:Float = 0.0, g:Float = 0.0, b:Float = 0.0)
		__lightDiffuseColour(Self._hnd, (1.0 / 255.0) * r, (1.0 / 255.0) * g, (1.0 / 255.0) * b)
	End Method
	
	Method LightRange(lrange:Float = 300.0)
		__lightRange(Self._hnd, lrange)
	End Method
	
	Method LightConeAngles(inner_angle:Float = 0.0, outer_angle:Float = 90.0)
		__lightConeAngles(Self._hnd, inner_angle, outer_angle)
	End Method
End Type


Function CreateLight:Int(lightType:Int = DIRECTIONAL, parent:Int = 0)
	Local p:TEntity
	If parent > 0 Then p = TEntity(HandleToObject(parent))
	
	Return HandleFromObject(TLight.CreateLight(__ogre, lightType, p))
End Function

Function LightColor(light:Int, r:Float = 255.0, g:Float = 255.0, b:Float = 255.0)
	TLight(HandleToObject(light)).LightDiffuseColor(r, g, b)
End Function

Function LightRange(light:Int, lrange:Float = 300.0)
	TLight(HandleToObject(light)).LightRange(lrange)
End Function

Function LightConeAngles(light:Int, inner_angle:Float = 0.0, outer_angle:Float = 90.0)
	TLight(HandleToObject(light)).LightConeAngles(inner_angle, outer_angle)
End Function