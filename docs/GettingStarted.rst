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

Limon uses C++17, so a supporting C++ compiler is required. Building Limon also requires the libraries listed below:

* assimp
* bullet
* sdl3
* sdl3-image
* freetype (likely freetype6 as library name)
* tinyxml2
* glew
* glm

If you are using Ubuntu, you can use the line below to install the required libraries:
::
$ sudo apt install cmake git libassimp-dev libbullet-dev libsdl3-dev libsdl3-image-dev libfreetype6-dev libtinyxml2-dev libglew-dev build-essential libglm-dev

Sample data and bundled third-party sources are included through git submodules, so no separate asset download step is required. Clone the engine and pull its submodules with:
::
git clone https://github.com/enginmanap/limonEngine.git
cd limonEngine
git submodule update --init

Limon Engine uses cmake as build system, if all the libraries are installed and cmake can find them, invoking cmake should build the engine.

In the cloned directory, call these commands:
::
mkdir build
cd build
cmake ../
cd ..

After cmake is done creating the build files, you can build and copy the sample data using these commands:
::
cd build
make
cp -a ../Data .

Running
=======

Limon engine takes single parameter, and that is the path to first map file to load. If no parameter is passed, Limon first tries to get the file name from release settings file, at ./Data/Release.xml, if file not found, or no world name specified, it defaults to "./Data/Maps/World001.xml", which is a test map that has samples for capabilities of the engine.

The Custom trigger are automatically loaded from the same directory of the engine binary, with name  *libcustomTriggers*, the extension of that file depends on the platform(dll, so, dynlib).

Keyboard, mouse, and gamepad/controller input are all supported out of the box. Bindings are defined in ``./Engine/inputBindings.xml`` and can be changed without recompiling the engine. See :ref:`InputSystem` for the full binding format, the built-in action list, and how to add your own game actions.

After engine launch, the default key bindings are as follows:

* Pressing `0` switches to debug mode, renders physics collision meshes and disconnects player from physics (flying and passing trough objects)
* Pressing `F2` key switches to editor mode, which allows creating maps.
* Pressing `+` and `-` changes mouse sensitivity.
* `wasd` for walking around and mouse for looking around as usual.

The options of the game engine can be edited using the ``./Engine/Options.xml`` file.
See :ref:`OptionsReference` for the full list of available options, their types and defaults.
