=======
Welcome
=======

Welcome to Limon Engine's documentation!
========================================

Limon is a multi-platform, open-source 3D game engine (LGPL) focused on ease of use and ease of study. It includes a built-in in-process level editor, forward and deferred rendering pipelines, C++ and Python scripting, a particle system, AI pathfinding, physics, and a GUI system.

Prebuilt binaries for Windows, Linux and MacOS can be `found here <https://github.com/enginmanap/limonEngine/releases>`_

The documentation is separated in three major sections:

1. How to use the engine and built-in editor to create games.
2. Extending capabilities using Limon API.
3. Engine architecture and internals.

Features at a Glance
====================

**Scripting**

Gameplay logic runs in C++ plugins or Python scripts (via pybind11) through five extension points: :ref:`Actions <implementAction>`, :ref:`Player Extensions <implementPlayerExtension>`, :ref:`AI Actors <implementAIActor>`, :ref:`Camera Attachments <implementCameraAttachment>`, and :ref:`RenderMethods <RenderingPipeline>`. All five types are loaded from a single user dynamic library at engine launch.

**Rendering**

Forward and deferred pipelines ship with the engine. The :ref:`node-based visual pipeline editor <RenderingPipeline>` lets you build custom pipelines, add post-processing passes, and swap shaders without touching engine source. Rendering features include:

* Cascaded shadow maps for directional lights; cube map shadows for point lights
* Screen-space ambient occlusion (SSAO), included as a sample RenderMethod
* SIMD software occlusion culling: SSE4.1 on x86, NEON on AArch64 (Apple Silicon, Raspberry Pi 4/5)
* Automatic LOD with 4 levels per model via meshoptimizer
* Multithreaded culling — each camera's frustum and occlusion workload runs on a separate thread
* Instanced rendering with GPU-side skeletal skinning
* Lights are creatable and removable at runtime via API

**Camera**

Any camera type is supported: first-person, third-person, top-down, orbital, isometric, and fixed, in both **perspective and orthographic** projection. Cameras are :ref:`Camera Attachments <implementCameraAttachment>` — first-class scene objects. The engine ships a first-person default plus perspective and orthographic attachment samples.

**Physics**

Bullet Physics with automatic collision shape generation from mesh data: full mesh for static objects, convex hull for dynamic objects, per-bone hulls for animated objects, and ``UCX_``-prefixed custom collision meshes.

**AI and Pathfinding**

A 3D navigation grid is built per world via flood fill. Route requests are asynchronous — the simulation tick is never blocked. Any extension can query the pathfinding system via the route request API.

**Particles**

CPU and GPU particle emitters are both full :ref:`scene object types <EngineArchitecture>` and can be attached to model bones, following skeletal animation through the full bone transform.

**Audio**

OpenAL audio backend with OGG and WAV support. Sounds can be attached to scene objects and bones for 3D positional audio that moves with geometry. Audio channel volumes are configurable at runtime via API.

**GUI**

Layered GUI system with text, image, and button elements. GUI elements are creatable, movable, and removable at runtime via API. Interactive GUI activates in menu mode. GUI elements can be animated via the animation sequencer.

**Editor**

The editor runs inside the game process — there is no separate play mode. Changes apply live to the running world. Built with Dear ImGui. The in-editor :ref:`pipeline editor <RenderingPipeline>` lets you wire custom rendering passes with real-time preview.

**Animation**

Skeletal animation with GPU-side skinning. Models, lights, particles, sounds, trigger volumes, and cameras can attach to specific named bones and follow them through the full skeletal animation.

**Platforms**

Linux (primary), Windows, macOS (Apple Silicon), and Raspberry Pi 4/5. The graphics backend is a swappable dynamic library — the engine ships OpenGL 3.3 and OpenGL ES 3.1. Custom backends (Vulkan, Metal, DirectX) are possible without modifying engine source.

Contribute
----------

If you are having issues, or if you think some awesome feature is missing, please let us know using the issue tracker.
Also if you want to chat, there is a Discord channel.

- Issue Tracker: https://github.com/enginmanap/limonEngine/issues
- Source Code: https://github.com/enginmanap/limonEngine
- Discord: https://discord.gg/gqprbFd

License
-------

The project is licensed under the LGPL license.

.. toctree::
   :maxdepth: 1

   self
   GettingStarted
   UsingTheEditor
   AssetManagement
   ExtendingByAPI/index
   EngineArchitecture
   RenderingPipeline
   SupportingSystems
   OptionsReference
   RoadMap
   authors

Indices and tables
==================

* :ref:`genindex`
* :ref:`modindex`
* :ref:`search`
