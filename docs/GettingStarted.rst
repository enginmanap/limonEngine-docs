.. _GettingStarted:

===============
Getting Started
===============

Acquiring Limon Engine
======================

You can download the prebuilt binaries from `github releases <https://github.com/enginmanap/limonEngine/releases>`_, or you can build the engine for yourself.

The engine comes with a test map, and launches it by default, so you can launch the engine and start working. If you are not interested in building on your own, you can continue to :ref:`UsingBuiltinEditor`.

Building
========

Limon uses c++14, so a supporting c++ compiler is required. GCC 7.2 to 8.2 are tested. Building Limon also requires the libraries listed below:

* assimp
* bullet
* sdl2
* sdl2-image
* freetype (likely freetype6 as library name)
* tinyxml2
* glew
* glm

If you are using Ubuntu, you can use the line below to install the required libraries:
::
   sudo apt-get install libassimp-dev libbullet-dev libsdl2-dev libsdl2-image-dev libfreetype6-dev libtinyxml2-dev libglew-dev build-essential libglm-dev libtinyxml2-dev

Limon Engine uses cmake as build system, if all the libraries are installed and cmake can find them, invoking cmake should build the engine.

Release source contains a directory, in that directory, call these commands:
::
    mkdir build
    cd build
    cmake ../

after that, depending on the system, either the executable binaries, or appropriate build system files like automake should be generated. If that is the case, use the build system for your installation to compile final binaries.

Running
=======

Limon engine takes single parameter, and that is the path to first map file to load. If no parameter is passed, it defaults to "./Data/Maps/World001.xml", which is a test map that has samples for capabilities of the engine.

The Custom trigger are automatically loaded from the same directory of the engine binary, with name  *libcustomTriggers*, the extension of that file depends on the platform(dll, so, dynlib).

After engine launch, the key bindings are as follows:

* Pressing `0` switches to debug mode, renders physics collision meshes and disconnects player from physics (flying and passing trough objects)
* Pressing `F2` key switches to editor mode, which allows creating maps.
* Pressing `+` and `-` changes mouse sensitivity.
* `wasd` for walking around and mouse for looking around as usual.

The options of the game engine can be edited using ./Engine/Options.xml file. 
