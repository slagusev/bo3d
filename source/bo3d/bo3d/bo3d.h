#define BBDECL extern "C" __declspec(dllexport)
#define BBCALL __stdcall

#include <stdio.h>
#include <string.h>
#include <Ogre.h>
#include <OgreFontManager.h> 
#include <OgreTextAreaOverlayElement.h>
#include <OgreException.h>
#include <OIS.h>

using namespace Ogre;

#if OGRE_PLATFORM == OGRE_PLATFORM_WIN32
	#define WIN32_LEAN_AND_MEAN
	#include "windows.h"
#endif

const int DIRECTX9		= 1;
const int OPENGL		= 2;

Ogre::String appTitle	= "bo3D";
Ogre::String pluginCfg	= "plugins.cfg";
Ogre::String configFile	= "config.cfg";
Ogre::String logFile	= "bo3d.log";
Ogre::String rendersys	= "Direct3D9 Rendering Subsystem";
Ogre::String fsaa		= "2";

struct bo3d{
	Ogre::Root* ogreRoot;
	Ogre::SceneManager* sceneMgr;
	Ogre::RenderWindow* renderWindow;
	OIS::InputManager* input;
	OIS::Mouse* mouse;
	OIS::Keyboard* keyboard;
	int keys[256];
	int mbs[32];
};

enum entityType{
	TYPE_PIVOT	= 1,
	TYPE_LIGHT,
	TYPE_CAMERA,
	TYPE_MIRROR,
	TYPE_LISTENER,
	TYPE_SPRITE,
	TYPE_TERRAIN,
	TYPE_PLANE,
	TYPE_MESH,
	TYPE_MD2,
	TYPE_BSP
};

struct entity{
	unsigned int __hnd;
	Ogre::SceneNode* __node;
	enum entityType __type;
	bool __subentity;
};