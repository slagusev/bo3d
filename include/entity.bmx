Const TYPE_PIVOT:Int	= 1
Const TYPE_LIGHT:Int	= 2
Const TYPE_CAMERA:Int	= 3
Const TYPE_MIRROR:Int	= 4
Const TYPE_LISTENER:Int	= 5
Const TYPE_SPRITE:Int	= 6
Const TYPE_TERRAIN:Int	= 7
Const TYPE_PLANE:Int	= 8
Const TYPE_MESH:Int		= 9
Const TYPE_MD2:Int		= 10
Const TYPE_BSP:Int		= 11

Global __classes:String[12]
__classes[0]			= "Unknown"
__classes[TYPE_PIVOT]	= "Pivot"
__classes[TYPE_LIGHT]	= "Light"
__classes[TYPE_CAMERA]	= "Camera"
__classes[TYPE_MIRROR]	= "Mirror"
__classes[TYPE_LISTENER]= "Listener"
__classes[TYPE_SPRITE]	= "Sprite"
__classes[TYPE_TERRAIN]	= "Terrain"
__classes[TYPE_PLANE]	= "Plane"
__classes[TYPE_MESH]	= "Mesh"
__classes[TYPE_MD2]		= "MD2"
__classes[TYPE_BSP]		= "BSP"

Extern "win32"
	Function __entityParent(entity:Byte ptr, parent:Byte ptr) = "__entityParent@8"
	Function __positionEntity(entity:Byte ptr, x:Float, y:Float, z:Float, glob:Byte) = "__positionEntity@20"
	Function __rotateEntity(entity:Byte ptr, x:Float, y:Float, z:Float, glob:Byte) = "__rotateEntity@20"
	Function __moveEntity(entity:Byte ptr, x:Float, y:Float, z:Float) = "__moveEntity@16"
	Function __turnEntity(entity:Byte ptr, x:Float, y:Float, z:Float) = "__turnEntity@16"
	Function __translateEntity(entity:Byte ptr, x:Float, y:Float, z:Float) = "__translateEntity@16"
	Function __pointEntity(entity:Byte ptr, target:Byte ptr) = "__pointEntity@8"
	Function __entityX:Float(entity:Byte ptr) = "__entityX@4"
	Function __entityY:Float(entity:Byte ptr) = "__entityY@4"
	Function __entityZ:Float(entity:Byte ptr) = "__entityZ@4"
	Function __entityPitch:Float(entity:Byte ptr) = "__entityPitch@4"
	Function __entityYaw:Float(entity:Byte ptr) = "__entityYaw@4"
	Function __entityRoll:Float(entity:Byte ptr) = "__entityRoll@4"
	Function __entityClass:Int(entity:Byte ptr) = "__entityClass@4"
	Function __freeEntity(entity:Byte ptr) = "__freeEntity@4"
	Function __showEntity(entity:Byte ptr) = "__showEntity@4"
	Function __hideEntity(entity:Byte ptr) = "__hideEntity@4"
End Extern

Type TEntity
	Field _hnd:Byte ptr
	Field _objName:String
	Field _objType:Int
		
	Method EntityParent(parent:TEntity)
		__entityParent(Self._hnd, parent._hnd)
	End Method
	
	Method PositionEntity(x:Float = 0.0, y:Float = 0.0, z:Float = 0.0, globalPosition:Byte = False)
		__positionEntity(Self._hnd, x, y, z, globalPosition)
	End Method
	
	Method RotateEntity(x:Float = 0.0, y:Float = 0.0, z:Float = 0.0, globalRotation:Byte = False)
		__rotateEntity(Self._hnd, x, y, z, globalRotation)
	End Method
	
	Method MoveEntity(x:Float = 0.0, y:Float = 0.0, z:Float = 0.0)
		__moveEntity(Self._hnd, x, y, z)
	End Method
	
	Method TurnEntity(pitch:Float = 0.0, yaw:Float = 0.0, roll:Float = 0.0)
		__turnEntity(Self._hnd, pitch, yaw, roll)
	End Method
	
	Method TranslateEntity(x:Float = 0.0, y:Float = 0.0, z:Float = 0.0)
		__translateEntity(Self._hnd, x, y, z)
	End Method
	
	Method PointEntity(target:TEntity)
		__pointEntity(Self._hnd, target._hnd)
	End Method
	
	Method EntityX:Float()
		Return __entityX(Self._hnd)
	End Method
	
	Method EntityY:Float()
		Return __entityY(Self._hnd)
	End Method
	
	Method EntityZ:Float()
		Return __entityZ(Self._hnd)
	End Method
	
	Method EntityPitch:Float()
		Return __entityPitch(Self._hnd)
	End Method
	
	Method EntityYaw:Float()
		Return __entityYaw(Self._hnd)
	End Method
	
	Method EntityRoll:Float()
		Return __entityRoll(Self._hnd)
	End Method
	
	Method EntityClass:String()
		Return __classes[__entityClass(Self._hnd)]
	End Method
	
	Method FreeEntity()
		__freeEntity(Self._hnd)
	End Method
	
	Method ShowEntity()
		__showEntity(Self._hnd)
	End Method
	
	Method HideEntity()
		__hideEntity(Self._hnd)
	End Method
	
	Method NameEntity(nme:String)
		Self._objName = nme
	End Method
End Type


Function EntityParent(entity:Int, parent:Int)
	TEntity(HandleToObject(entity)).EntityParent(TEntity(HandleToObject(parent)))
End Function

Function PositionEntity(entity:Int, x:Float = 0.0, y:Float = 0.0, z:Float = 0.0, globalPosition:Byte = False)
	TEntity(HandleToObject(entity)).PositionEntity(x, y, z, globalPosition)
End Function

Function RotateEntity(entity:Int, x:Float = 0.0, y:Float = 0.0, z:Float = 0.0, globalRotation:Byte = False)
	TEntity(HandleToObject(entity)).RotateEntity(x, y, z, globalRotation)
End Function

Function MoveEntity(entity:Int, x:Float = 0.0, y:Float = 0.0, z:Float = 0.0)
	TEntity(HandleToObject(entity)).MoveEntity(x, y, z)
End Function

Function TurnEntity(entity:Int, pitch:Float = 0.0, yaw:Float = 0.0, roll:Float = 0.0)
	TEntity(HandleToObject(entity)).TurnEntity(pitch, yaw, roll)
End Function

Function TranslateEntity(entity:Int, x:Float = 0.0, y:Float = 0.0, z:Float = 0.0)
	TEntity(HandleToObject(entity)).TranslateEntity(x, y, z)
End Function

Function PointEntity(entity:Int, target:Int)
	TEntity(HandleToObject(entity)).PointEntity(TEntity(HandleToObject(target)))
End Function

Function EntityX:Float(entity:Int)
	Return TEntity(HandleToObject(entity)).EntityX()
End Function

Function EntityY:Float(entity:Int)
	Return TEntity(HandleToObject(entity)).EntityY()
End Function

Function EntityZ:Float(entity:Int)
	Return TEntity(HandleToObject(entity)).EntityZ()
End Function

Function EntityPitch:Float(entity:Int)
	Return TEntity(HandleToObject(entity)).EntityPitch()
End Function

Function EntityYaw:Float(entity:Int)
	Return TEntity(HandleToObject(entity)).EntityYaw()
End Function

Function EntityRoll:Float(entity:Int)
	Return TEntity(HandleToObject(entity)).EntityRoll()
End Function

Function EntityClass:String(entity:Int)
	Return TEntity(HandleToObject(entity)).EntityClass()
End Function

Function FreeEntity(entity:Int)
	TEntity(HandleToObject(entity)).FreeEntity()
End Function

Function ShowEntity(entity:Int)
	TEntity(HandleToObject(entity)).ShowEntity()
End Function

Function HideEntity(entity:Int)
	TEntity(HandleToObject(entity)).HideEntity()
End Function

Function NameEntity(entity:Int, nme:String)
	TEntity(HandleToObject(entity)).NameEntity(nme)
End Function