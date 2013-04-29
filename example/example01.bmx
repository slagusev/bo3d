Framework sedm.bo3d
Import brl.random

WinTitle("bo3D 0.18")
AntiAlias(16)

Graphics3D(1024)
cam = CreateCamera()
CameraClsColor(cam, 90, 60, 30)

ogre = LoadMesh("media\ogrehead.mesh")
PositionEntity(ogre, 0.0, 100, 100)
PositionEntity(cam, 0.0, 0.0, -10.0)

l = CreateLight(2)
PositionEntity(l, -100, 100, -100)

p = CreatePlane()

Repeat		
	TurnEntity(ogre, 0, 0.01, 0)
	TurnEntity(p, 0.01, 0.01, 0.01)
	RenderWorld
	
	If MouseZSpeed() Then Exit
Until MouseHit()

EndGraphics3D
