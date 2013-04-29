Const NO_PROJECTION:Int	= 0
Const PERSPECTIVE:Int	= 1
Const ORTHOGRAPHIC:Int	= 2

Extern "win32"
	Function __createCamera:Byte ptr(engine:Byte ptr, objName$z, parent:Byte ptr) = "__createCamera@12"
	Function __cameraClsColor(cam:Byte ptr, r:Float, g:Float, b:Float) = "__cameraClsColor@16"
	Function __cameraRange(cam:Byte ptr, near:Float, far:Float) = "__cameraRange@12"
	Function __cameraProjMode(cam:Byte ptr, projMode:Int) = "__cameraProjMode@8"
	Function __cameraZoom(cam:Byte ptr, zoom:Float) = "__cameraZoom@8"
End Extern

Type TCamera Extends TEntity
	Function CreateCamera:TCamera(ogre:TOgre, parent:TEntity = Null)
		Local p:Byte ptr
		If parent <> Null Then p = parent._hnd
		
		Local cam:TCamera	= New TCamera
		cam._objType		= TYPE_CAMERA
		cam._objName		= ogre.genName("cam_")
		cam._hnd			= __createCamera(ogre._hnd, ogre.genName(), p)
		
		Return cam
	End Function
	
	Method CameraClsColor(r:Float = 0.0, g:Float = 0.0, b:Float = 0.0)
		__cameraClsColor(Self._hnd, (1.0 / 255.0) * r, (1.0 / 255.0) * g, (1.0 / 255.0) * b)
	End Method
	
	Method CameraRange(near:Float = 1.0, far:Float = 1000.0)
		__cameraRange(Self._hnd, near, far)
	End Method
	
	Method CameraProjMode(projMode:Int = PERSPECTIVE)
		__cameraProjMode(Self._hnd, projMode)
	End Method
	
	Method CameraZoom(zoom:Float = 1.0)
		__cameraZoom(Self._hnd, -(zoom * 45.0))
	End Method
End Type


Function CreateCamera:Int(parent:Int = 0)
	Local p:TEntity = Null
	If parent <> 0 Then p = TEntity(HandleToObject(parent))
	
	Return HandleFromObject(TCamera(TCamera.CreateCamera(__ogre, p)))
End Function

Function CameraClsColor(cam:Int, r:Float = 0.0, g:Float = 0.0, b:Float = 0.0)
	TCamera(HandleToObject(cam)).CameraClsColor(r, g, b)
End Function

Function CameraRange(cam:Int, near:Float = 1.0, far:Float = 1000.0)
	TCamera(HandleToObject(cam)).CameraRange(near, far)
End Function

Function CameraProjMode(cam%, projMode:Int = PERSPECTIVE)
	TCamera(HandleToObject(cam)).CameraProjMode(projMode)
End Function

Function CameraZoom(cam%, zoom:Float = 1.0)
	TCamera(HandleToObject(cam)).CameraZoom(zoom)
End Function