Const PT_CUBE:Int		= 1
Const PT_PLANE:Int		= 2
Const PT_SPHERE:Int		= 3


Extern "win32"
	Function __loadMesh:Byte ptr(engine:Byte ptr, parent:Byte ptr, filename$z, meshname$z) = "__loadMesh@16"
	Function __createPrefab:Byte ptr(engine:Byte ptr, parent:Byte ptr, meshname$z, typ:Int) = "__createPrefab@16"
	Function __countChildren:Int(entity:Byte ptr) = "__countChildren@4"
	Function __getChild:Byte ptr(engine:Byte ptr, entity:Byte ptr, index:Int) = "__getChild@12"
End Extern

Type TMesh Extends TEntity
	Function LoadMesh:TMesh(engine:TOgre, filename:String, parent:TEntity = Null)
		Local p:Byte ptr
		If parent <> Null Then p = parent._hnd
		
		engine.addResourceLocation(filename)
		
		Local mesh:TMesh	= New TMesh
		mesh._objType		= TYPE_MESH
		mesh._objName		= engine.genName("mesh_")
		mesh._hnd			= __loadMesh(engine._hnd, p, StripDir(filename), mesh._objName)
		
		Return mesh
	End Function
	
	Function LoadAnimMesh:TMesh(engine:TOgre, filename:String, parent:TEntity = Null)
		Return TMesh.LoadMesh(engine, filename, parent)
	End Function
	
	Function CreatePrefab:TMesh(engine:TOgre, parent:TEntity = Null, typ:Int = PT_CUBE)
		Local p:Byte ptr
		If parent <> Null Then p = parent._hnd
				
		Local mesh:TMesh	= New TMesh
		mesh._objType		= TYPE_MESH
		mesh._objName		= engine.genName("mesh_")
		mesh._hnd			= __createPrefab(engine._hnd, p, mesh._objName, typ)
		
		Return mesh
	End Function
	
	Function CreateCube:TMesh(engine:TOgre, parent:TEntity = Null)
		Return TMesh.CreatePrefab(engine, parent)
	End Function
	
	Function CreateSphere:TMesh(engine:TOgre, parent:TEntity = Null)
		Return TMesh.CreatePrefab(engine, parent, PT_SPHERE)
	End Function
	
	Function CreatePlane:TMesh(engine:TOgre, parent:TEntity = Null)
		Return TMesh.CreatePrefab(engine, parent, PT_PLANE)
	End Function
	
	Method CountChildren:Int()
		Return __countChildren(Self._hnd)
	End Method

	Method GetChild:TMesh(engine:TOgre, index:Int)
		Local mesh:TMesh	= New TMesh
		mesh._hnd			= __getChild(engine._hnd, Self._hnd, index)
		mesh._objType		= TYPE_MESH
		
		Return mesh
	End Method
End Type

Function LoadMesh:Int(filename:String, parent:Int = 0)
	Local p:TEntity = Null
	If parent > 0 Then p = TEntity(HandleToObject(parent))
	
	Return HandleFromObject(TMesh.LoadMesh(__ogre, filename, p))
End Function

Function LoadAnimMesh:Int(filename:String, parent:Int = 0)
	Return LoadMesh(filename, parent)
End Function

Function CreateCube:Int(parent:Int = 0)
	Local p:TEntity = Null
	If parent > 0 Then p = TEntity(HandleToObject(parent))
	
	Return HandleFromObject(TMesh.CreateCube(__ogre, p))
End Function

Function CreateSphere:Int(parent:Int = 0)
	Local p:TEntity = Null
	If parent > 0 Then p = TEntity(HandleToObject(parent))
	
	Return HandleFromObject(TMesh.CreateSphere(__ogre, p))
End Function

Function CreatePlane:Int(parent:Int = 0)
	Local p:TEntity = Null
	If parent > 0 Then p = TEntity(HandleToObject(parent))
	
	Return HandleFromObject(TMesh.CreatePlane(__ogre, p))
End Function

Function CountChildren:Int(entity:Int)
	Return TMesh(HandleToObject(entity)).CountChildren()
End Function

Function GetChild:Int(entity:Int, index:Int)
	Return HandleFromObject(TMesh(HandleToObject(entity)).GetChild(__ogre, index))
End Function