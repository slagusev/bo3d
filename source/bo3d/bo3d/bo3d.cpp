#include "bo3d.h"

BBDECL void BBCALL __appTitle(const char* apptitle){ appTitle = Ogre::String(apptitle); }
BBDECL void BBCALL __pluginDir(const char* plugins){ pluginCfg = Ogre::String(plugins); }
BBDECL void BBCALL __configFile(const char* configfile){ configFile = Ogre::String(configfile); }
BBDECL void BBCALL __logFile(const char* logfile){ logFile = Ogre::String(logfile); }

BBDECL void BBCALL __setRenderer(int renderer){
	switch(renderer){
	case DIRECTX9 : rendersys = "Direct3D9 Rendering Subsystem"; break;
	case OPENGL : rendersys = "OpenGL Rendering Subsystem"; break;
	default : rendersys = "Direct3D9 Rendering Subsystem";
	};
}

BBDECL void BBCALL __antialias(const char* aa){
	fsaa = Ogre::String(aa);
}


/*
	Graphics3D
*/
BBDECL bo3d* BBCALL __graphics3D(unsigned int width = 800, unsigned int height = 600, int depth = 32, bool fullscreen = true){
	bo3d* engine;
	
	Ogre::String fs = "Yes"; if(!fullscreen) fs = "No";
	Ogre::String ww = Ogre::StringConverter::toString(width);
	Ogre::String hh = Ogre::StringConverter::toString(height);
	Ogre::String dd = Ogre::StringConverter::toString(depth);

	try{
		engine = new bo3d;
		engine->ogreRoot = new Ogre::Root(pluginCfg, configFile, logFile);

		Ogre::RenderSystem* rs = engine->ogreRoot->getRenderSystemByName(rendersys);
		engine->ogreRoot->setRenderSystem(rs);

		rs->setConfigOption("Full Screen", fs);
		rs->setConfigOption("Video Mode", ww + " x " + hh + " @ " + dd + "-bit colour");
		rs->setConfigOption("FSAA", fsaa);
		
		engine->renderWindow	= engine->ogreRoot->initialise(true, appTitle);
		engine->sceneMgr		= engine->ogreRoot->createSceneManager(ST_GENERIC);
		engine->sceneMgr->setAmbientLight(Ogre::ColourValue(0.0, 0.0, 0.0));

		//
		// InputSystem
		//
		size_t hWnd				= 0;
		engine->renderWindow->getCustomAttribute("WINDOW", &hWnd);
		engine->input			= OIS::InputManager::createInputSystem(hWnd);

		engine->mouse			= static_cast<OIS::Mouse*>(engine->input->createInputObject(OIS::OISMouse, false));
		engine->keyboard		= static_cast<OIS::Keyboard*>(engine->input->createInputObject(OIS::OISKeyboard, false));

		unsigned int width, height, depth;
		int top, left;

		engine->renderWindow->getMetrics(width, height, depth, top, left);
		const OIS::MouseState &ms = engine->mouse->getMouseState();
		ms.width	= width;
		ms.height	= height;

		for(int i = 0; i < 32; i++){
			engine->mbs[i] = 0;
		}
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return engine;
}


/*
	EndGraphics3D
*/
BBDECL void BBCALL __endGraphics3D(bo3d* engine){
	try{
		engine->ogreRoot->shutdown();
		delete engine;
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	RenderWorld
*/
BBDECL void BBCALL __renderWorld(bo3d* engine){
	try{
		//engine->keyboard->capture();
		engine->mouse->capture();

		// check mouse buttons
		const OIS::MouseState &ms = engine->mouse->getMouseState();

		for(int i = 0; i < 32; i++){
			engine->mbs[i] = 0;
		}

		if(ms.buttonDown(OIS::MB_Left)) engine->mbs[1] = 1;
		if(ms.buttonDown(OIS::MB_Right)) engine->mbs[2] = 1;
		if(ms.buttonDown(OIS::MB_Middle)) engine->mbs[3] = 1;

		// render world
		engine->ogreRoot->renderOneFrame();
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


BBDECL void BBCALL __addResourceLocation(bo3d* engine, const char* location){
	Ogre::ResourceGroupManager::getSingleton().addResourceLocation(Ogre::String(location), "FileSystem");
	Ogre::ResourceGroupManager::getSingleton().initialiseAllResourceGroups();
}


/*
	TrisRendered
*/
BBDECL int BBCALL __trisRendered(bo3d* engine){
	int result;

	try{
		result = engine->renderWindow->getTriangleCount();
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return result;
}


/*
	====================================================================
	Input
	====================================================================
*/

/*
	MouseDown()
*/
BBDECL int BBCALL __mouseDown(bo3d* engine, int button){
	return engine->mbs[button];
};


/*
	MouseHit
*/
BBDECL int BBCALL __mouseHit(bo3d* engine, int button){
	int result = 0;

	try{
		engine->mouse->capture();

		OIS::MouseButtonID mb;
		switch(button){
		case 1 : mb = OIS::MB_Left; break;
		case 2 : mb = OIS::MB_Right; break;
		case 3 : mb = OIS::MB_Middle; break;
		};

		const OIS::MouseState &ms = engine->mouse->getMouseState();
		bool res = ms.buttonDown(mb);
		
		if((engine->mbs[button] == 1) && (!res)){
			result = 1;
		}

		engine->mbs[button] = 0;
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return result;
}


BBDECL int BBCALL __mouseZSpeed(bo3d* engine){
	int result;
	
	try{
		result = engine->mouse->getMouseState().Z.abs;
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return result;
}

/*
	====================================================================
	EntityControl
	====================================================================
*/

/*
	EntityParent
*/
BBDECL void BBCALL __entityParent(entity* object, entity* parent){
	try{
		parent->__node->addChild(object->__node);
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	FreeEntity
*/
BBDECL void BBCALL __freeEntity(entity* obj){
	try{
		switch(obj->__type){
		case TYPE_LIGHT : delete(reinterpret_cast<Ogre::Light*>(obj->__hnd)); break;
		case TYPE_CAMERA : delete(reinterpret_cast<Ogre::Camera*>(obj->__hnd)); break;
		case TYPE_MESH : delete(reinterpret_cast<Ogre::Entity*>(obj->__hnd)); break;
		};

		delete(obj->__node);
		delete(obj);

	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}

/*
	ShowEntity
*/
BBDECL void BBCALL __showEntity(entity* obj){
	try{
		switch(obj->__type){
		case TYPE_LIGHT : reinterpret_cast<Ogre::Light*>(obj->__hnd)->setVisible(true); break;
		case TYPE_CAMERA : reinterpret_cast<Ogre::Camera*>(obj->__hnd)->setVisible(true); break;
		case TYPE_MESH : reinterpret_cast<Ogre::Entity*>(obj->__hnd)->setVisible(true); break;
		};
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}

/*
	HideEntity
*/
BBDECL void BBCALL __hideEntity(entity* obj){
	try{
		switch(obj->__type){
		case TYPE_LIGHT : reinterpret_cast<Ogre::Light*>(obj->__hnd)->setVisible(false); break;
		case TYPE_CAMERA : reinterpret_cast<Ogre::Camera*>(obj->__hnd)->setVisible(false); break;
		case TYPE_MESH : reinterpret_cast<Ogre::Entity*>(obj->__hnd)->setVisible(false); break;
		};
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}



/*
	====================================================================
	EntityMovement
	====================================================================
*/

/*
	PositionEntity
*/
BBDECL void BBCALL __positionEntity(entity* obj, float x, float y, float z, bool global){
	try{
		Ogre::Node* parent = obj->__node->getParent();
		if(!global){
			if(parent){
				obj->__node->setPosition(parent->getPosition() + Ogre::Vector3(Ogre::Real(x), Ogre::Real(y), Ogre::Real(-z)));
			}else{
				obj->__node->setPosition(Ogre::Real(x), Ogre::Real(y), Ogre::Real(-z));
			}
		}else{
			obj->__node->setPosition(Ogre::Real(x), Ogre::Real(y), Ogre::Real(-z));
		}
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	RotateEntity
*/
BBDECL void BBCALL __rotateEntity(entity* obj, float x, float y, float z, bool global){
	try{
		Ogre::Node* parent = obj->__node->getParent();
		if(!global){
			if(parent){
				obj->__node->setOrientation(parent->getOrientation() + Ogre::Quaternion(1.0, Ogre::Real(x), Ogre::Real(y), Ogre::Real(-z)));
			}
		}else{
			obj->__node->setOrientation(1.0, Ogre::Real(x), Ogre::Real(y), Ogre::Real(-z));
		}
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	MoveEntity
*/
BBDECL void BBCALL __moveEntity(entity* obj, float x, float y, float z){
	try{
		obj->__node->translate(Ogre::Real(x), Ogre::Real(y), Ogre::Real(-z));
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	TurnEntity
*/
BBDECL void BBCALL __turnEntity(entity* obj, float x, float y, float z){
	try{
		obj->__node->rotate(Ogre::Quaternion(1.0, Ogre::Real(x), Ogre::Real(y), Ogre::Real(-z)));
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	TranslateEntity
*/
BBDECL void BBCALL __translateEntity(entity* obj, float x, float y, float z){
	try{
		Ogre::Vector3 pos = obj->__node->getPosition();
		obj->__node->setPosition(pos + Ogre::Vector3(Ogre::Real(x), Ogre::Real(y), Ogre::Real(-z)));
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	PointEntity
*/
BBDECL void BBCALL __pointEntity(entity* obj, entity* target){
	try{
		
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	====================================================================
	Entity State
	====================================================================
*/

/*
	EntityX
*/
BBDECL float BBCALL __entityX(entity* obj){
	float res;

	try{
		res = float(obj->__node->getPosition().x);
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return res;
}


/*
	EntityY
*/
BBDECL float BBCALL __entityY(entity* obj){
	float res;

	try{
		res = float(obj->__node->getPosition().y);
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return res;
}

/*
	EntityZ
*/
BBDECL float BBCALL __entityZ(entity* obj){
	float res;

	try{
		res = float(obj->__node->getPosition().z);
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return res;
}


/*
	EntityPitch
*/
BBDECL float BBCALL __entityPitch(entity* obj){
	Ogre::Radian res;

	try{
		res = obj->__node->getOrientation().getPitch();
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return float(res.valueDegrees());
}


/*
	EntityYaw
*/
BBDECL float BBCALL __entityYaw(entity* obj){
	Ogre::Radian res;

	try{
		res = obj->__node->getOrientation().getYaw();
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return float(res.valueDegrees());
}


/*
	EntityRoll
*/
BBDECL float BBCALL __entityRoll(entity* obj){
	Ogre::Radian res;

	try{
		res = obj->__node->getOrientation().getRoll();
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return float(res.valueDegrees());
}


/*
	EntityClass
*/
BBDECL int BBCALL __entityClass(entity* obj){
	int res;

	try{
		res = int(obj->__type);
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return res;
}


/*
	CountChildren
*/
BBDECL int BBCALL __countChildren(entity* obj){
	int result = 0;

	try{
		if(obj->__type == TYPE_MESH){
			Ogre::Entity* ent	= (Ogre::Entity*)obj->__hnd;
			result	= int(ent->getNumSubEntities());
		}
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return result;
}


BBDECL entity* BBCALL __getChild(bo3d* engine, entity* obj, unsigned int index){
	entity* child = new entity;

	try{
		Ogre::Entity* ent	= (Ogre::Entity*)obj->__hnd;
		Ogre::SubEntity* sub= ent->getSubEntity(index);
		
		child->__hnd		= (unsigned int)sub;
		child->__subentity	= true;
		child->__type		= TYPE_MESH;
		child->__node		= engine->sceneMgr->createSceneNode();
		child->__node->attachObject((Ogre::MovableObject*)sub);
		
		Ogre::Entity* nent = new Entity();

		obj->__node->addChild(child->__node);
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return child;
};


/*
	====================================================================
	Camera
	====================================================================
*/

/*
	CreateCamera
*/
BBDECL entity* BBCALL __createCamera(bo3d* engine, const char* name, entity* parent = NULL){
	entity* e	= new entity;

	try{
		Ogre::Camera* cam = engine->sceneMgr->createCamera(Ogre::String(name));
		e->__hnd	= unsigned int(cam);
		e->__node	= engine->sceneMgr->createSceneNode("node_" + Ogre::String(name));
		e->__type	= TYPE_CAMERA;
		Ogre::Viewport* vp = engine->renderWindow->addViewport(cam);
		cam->setNearClipDistance(Ogre::Real(0.1));
		cam->setAspectRatio(Ogre::Real(vp->getActualWidth()) / Ogre::Real(vp->getActualHeight()));
		if(parent != NULL){
			e->__node->addChild(parent->__node);
		}else{
			e->__node->attachObject(cam);
		}
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return e;
}


/*
	CameraClsColor
*/
BBDECL void BBCALL __cameraClsColor(entity* obj, float r, float g, float b){
	try{
		Ogre::Camera* cam = reinterpret_cast<Ogre::Camera*>(obj->__hnd);
		cam->getViewport()->setBackgroundColour(ColourValue(r, g, b));
		
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	CameraRange
*/
BBDECL void BBCALL __cameraRange(entity* obj, float near, float far){
	try{
		Ogre::Camera* cam = reinterpret_cast<Ogre::Camera*>(obj->__hnd);
		cam->setNearClipDistance(Ogre::Real(near));
		cam->setFarClipDistance(Ogre::Real(far));
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	CameraProjMode
*/
BBDECL void BBCALL __cameraProjMode(entity* obj, int projMode){
	try{
		Ogre::Camera* cam = reinterpret_cast<Ogre::Camera*>(obj->__hnd);
		switch(projMode){
		case 0 : cam->setVisible(false); break;
		case 1 : cam->setProjectionType(Ogre::PT_PERSPECTIVE); break;
		case 2 : cam->setProjectionType(Ogre::PT_ORTHOGRAPHIC); break;
		default : cam->setProjectionType(Ogre::PT_PERSPECTIVE);
		};
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	CameraZoom
*/
BBDECL void BBCALL __cameraZoom(entity* obj, float zoom){
	try{
		Ogre::Camera* cam = reinterpret_cast<Ogre::Camera*>(obj->__hnd);
		cam->setFOVy(Ogre::Radian(zoom));
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	====================================================================
	Mesh
	====================================================================
*/

/*
	LoadMesh
*/
BBDECL entity* BBCALL __loadMesh(bo3d* engine, entity* parent, const char* filename, const char* name){
	entity* obj = new entity;

	try{
		Ogre::Entity* ent		= engine->sceneMgr->createEntity(Ogre::String(name), Ogre::String(filename));
		Ogre::SceneNode* node	= engine->sceneMgr->createSceneNode("node" + Ogre::String(name));

		engine->sceneMgr->getRootSceneNode()->addChild(node);
		node->attachObject(ent);

		obj->__hnd				= unsigned int(ent);
		obj->__node				= node;
		obj->__type				= TYPE_MESH;

	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return obj;
}


/*
	CreateCube, CreateSphere, CreatePlane
*/
BBDECL entity* BBCALL __createPrefab(bo3d* engine, entity* parent, const char* name, int type){
	entity* obj = new entity;

	try{
		Ogre::SceneManager::PrefabType t = Ogre::SceneManager::PT_CUBE;

		switch(type){
		case 2 : t = Ogre::SceneManager::PT_PLANE; break;
		case 3 : t = Ogre::SceneManager::PT_SPHERE; break;
		}

		Ogre::Entity* ent	= engine->sceneMgr->createEntity(t);
		Ogre::SceneNode* node	= engine->sceneMgr->createSceneNode("node" + Ogre::String(name));
		node->scale(Ogre::Real(0.02), Ogre::Real(0.02), Ogre::Real(0.02));

		engine->sceneMgr->getRootSceneNode()->addChild(node);
		node->attachObject(ent);

		obj->__hnd				= unsigned int(ent);
		obj->__node				= node;
		obj->__type				= TYPE_MESH;
		
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return obj;
}


/*
	====================================================================
	Light
	====================================================================
*/

/*
	CreateLight
*/
BBDECL entity* BBCALL __createLight(bo3d* engine, int lightType, entity* parent){
	entity* obj = new entity;

	try{
		Ogre::Light::LightTypes ltype;

		switch(lightType){
		case 2 : ltype = Ogre::Light::LT_POINT; break;
		case 3 : ltype = Ogre::Light::LT_SPOTLIGHT; break;
		default : ltype = Ogre::Light::LT_DIRECTIONAL;
		};
		
		Ogre::Light* light = engine->sceneMgr->createLight();
		light->setType(ltype);

		Ogre::SceneNode* node = engine->sceneMgr->createSceneNode();
		node->attachObject(light);

		if(!parent){
			engine->sceneMgr->getRootSceneNode()->addChild(node);
		}else{
			parent->__node->addChild(node);
		}
		
		obj->__hnd	= unsigned int(light);
		obj->__node	= node;
		obj->__type = TYPE_LIGHT;

	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}

	return obj;
}


/*
	AmbientLight
*/
BBDECL void BBCALL __ambientLight(bo3d* engine, float r, float g, float b){
	try{
		engine->sceneMgr->setAmbientLight(Ogre::ColourValue(r, g, b));
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	LightColor
*/
BBDECL void BBCALL __lightDiffuseColour(entity* light, float r, float g, float b){
	try{
		Ogre::Light* l = reinterpret_cast<Ogre::Light*>(light->__hnd);
		l->setDiffuseColour(Ogre::Real(r), Ogre::Real(g), Ogre::Real(b));
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}

/*
	LightRange
*/
BBDECL void BBCALL __lightRange(entity* light, float range){
	try{
		Ogre::Light* l = reinterpret_cast<Ogre::Light*>(light->__hnd);
		l->setAttenuation(Ogre::Real(range), 1.0f, 4.5f/Ogre::Real(range), 75.0f/(Ogre::Real(range) / Ogre::Real(range)));
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}

/*
	LightConeAngles
*/
BBDECL void BBCALL __lightConeAngles(entity* light, float inner_angle, float outer_angle){
	try{
		Ogre::Light* l = reinterpret_cast<Ogre::Light*>(light->__hnd);
		l->setSpotlightInnerAngle(Ogre::Radian(inner_angle));
		l->setSpotlightOuterAngle(Ogre::Radian(outer_angle));
	}catch(Ogre::Exception &e){
		std::cout << e.getDescription() << std::endl;
	}
}


/*
	==========================================================
	Materials
	==========================================================
*/
BBDECL void BBCALL __getMaterial(entity* obj){
	
}