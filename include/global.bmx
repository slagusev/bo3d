Extern "win32"
	Function __appTitle(title$z) = "__appTitle@4"
	Function __setRenderer(renderer:Int) = "__setRenderer@4"
	Function __graphics3D:Byte ptr(width:Int, Height:Int, depth:Int, fullscreen:Byte) = "__graphics3D@16"
	Function __endGraphics3D(engine:Byte ptr) = "__endGraphics3D@4"
	Function __renderWorld(engine:Byte ptr) = "__renderWorld@4"
	Function __addResourceLocation(engine:Byte ptr, location$z) = "__addResourceLocation@8"
	Function __ambientLight(engine:Byte ptr, r:Float, g:Float, b:Float) = "__ambientLight@16"
	Function __antialias(aa$z) = "__antialias@4"
	Function __trisRendered:Int(engine:Byte ptr) = "__trisRendered@4"
	
	Function __mouseDown:Int(engine:Byte ptr, button:Int) = "__mouseDown@8"
	Function __mouseHit:Int(engine:Byte ptr, button:Int) = "__mouseHit@8"
	Function __mouseZSpeed:Int(engine:Byte ptr) = "__mouseZSpeed@4"
End Extern

Const DIRECTX9:Int		= 1
Const OPENGL:Int		= 2


Const MB_LEFT:Int		= 1
Const MB_RIGHT:Int		= 2
Const MB_MIDDLE:Int		= 3



Type TOgre
	Field _hnd:Byte ptr
	Field locations:TList
	Field _mousewheel:Int
	
	Function Graphics3D:TOgre(width:Int = 800, Height:Int = 600, depth:Int = 32, fullscreen:Byte = False)
		Local ogre:TOgre	= New TOgre
		ogre._hnd			= __graphics3D(width, Height, depth, fullscreen)
		
		Return ogre
	End Function
	
	Method EndGraphics3D()
		__endGraphics3D(Self._hnd)
	End Method
	
	Method RenderWorld()
		__renderWorld(Self._hnd)
	End Method
	
	Method AmbientLight(r:Float = 0.0, g:Float = 0.0, b:Float = 0.0)
		__ambientLight(Self._hnd, (1.0 / 255.0) * r, (1.0 / 255.0) * g, (1.0 / 255.0) * b)
	End Method
	
	Method genName:String(prefix:String = "entity_")
		Return prefix + String(Int(MilliSecs()))
	End Method
	
	Method addResourceLocation(location:String)
		If Self.locations = Null Then Self.locations = New TList
		Local found:Byte = False
		For Local loc:String = EachIn Self.locations
			If location = loc
				found = True
				Exit
			End If
		Next
		
		If Not found 
			Local path:String = ExtractDir(location)
			Self.locations.AddLast(path)
			__addResourceLocation(Self._hnd, path)
		End If
	End Method
	
	
	Method TrisRendered:Int()
		Return __trisRendered(Self._hnd)
	End Method
	
	
	'
	' Input
	'
	Method MouseDown:Byte(button:Int = MB_LEFT)
		Local result:Byte = False
		If __mouseDown(Self._hnd, button) result = True
			
		Return result
	End Method
	
	Method MouseHit:Byte(button:Int = MB_LEFT)
		Local result:Byte = False
		If __mouseHit(Self._hnd, button) result = True
			
		Return result
	End Method
	
	Method MouseZSpeed:Byte()
		Local result:Byte = 0
		Local mz:Int = __mouseZSpeed(Self._hnd)
		If mz > Self._mousewheel result = 1
		If mz < Self._mousewheel result = -1
		
		Self._mousewheel = mz
		
		Return result
	End Method
End Type

Global __ogre:TOgre

Function SetRenderer(renderer:Int = DIRECTX9)
	__setRenderer(renderer)
End Function

Function WinTitle(title:String)
	__appTitle(title)
End Function

Function AntiAlias(aa:Int = 2)
	__antialias(String(aa))
End Function

Function Graphics3D(width:Int = 800, Height:Int = 600, depth:Int = 32, fullscreen:Byte = False)
	If Not __ogre __ogre = TOgre.Graphics3D(width, Height, depth, fullscreen)
End Function

Function EndGraphics3D()
	If __ogre __ogre.EndGraphics3D()
End Function

Function RenderWorld()
	If __ogre __ogre.RenderWorld()
End Function

Function AmbientLight(r:Float = 0.0, g:Float = 0.0, b:Float = 0.0)
	__ogre.AmbientLight(r, g, b)
End Function

Function TrisRendered:Int()
	Return __ogre.TrisRendered()
End Function


rem
	Input
endrem

Function MouseDown:Byte(button:Int = MB_LEFT)
	Return __ogre.MouseDown(button)
End Function

Function MouseHit:Byte(button:Int = MB_LEFT)
	Return __ogre.MouseHit(button)
End Function

Function MouseZSpeed:Byte()
	Return __ogre.MouseZSpeed()
End Function
