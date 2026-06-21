========
Road Map
========

Latest release of the Limon Engine is 0.7. This page tracks the development plan up to 1.0. Information here is subject to change.

Version 0.6
===========

Main goal was fighting mechanics. All items implemented.

#. Asset discovery automatic, instead of manual asset list.
#. Model attachment to player -for carrying weapons.
#. Input listening from triggers -for attack actions.
#. Raycast to cursor with distance -for hit detection.
#. Distance-to-player provided to AI Actors -for melee range checks.
#. Trigger ↔ Actor communication -for hit events.
#. Quad decals -for bullet holes etc.
#. Player hit mechanics exposed via API.

Version 0.7
===========

All items implemented.

#. Material editor -global material registry with per-model copy-on-write editing.
#. Particle emitters -CPU and GPU particle emitters with full runtime API.
#. Shadow mapping improvements -staggered cascade rendering, point light cube map shadows.
#. Node-based render pipeline editor -visual pipeline configuration with forward and deferred configurations shipped.
#. SIMD software occlusion culling -SSE4.1 on x86, NEON on AArch64 (Apple Silicon, Raspberry Pi 4/5).
#. Automatic LOD generation -meshoptimizer, 4 LOD levels per model.
#. Python scripting -full LimonAPI surface via pybind11, multi-interpreter, all five extension types implementable in Python.
#. Camera Attachment -fourth user extension point: registered, configurable cameras (perspective and orthographic) wrapped in first-class ``CameraRig`` scene objects, enabling third-person, isometric, top-down, and custom cameras.
#. RenderMethod Extension -fifth user extension point for custom GPU rendering primitives.
#. Asset browser -typed tree with model preview using world lighting.
#. limonmodel native format -near memory-direct layout for fast release builds.
#. Debug line draw API -3D world-space coloured lines via ID-based buffer system.
#. In-game logger overlay -transparent, toggleable, with C++ and Python API.
#. Tracy profiling -embedded flame graph in editor, GPU zones from pipeline config, profileScope API.

Planned for 0.8
===============

#. Navigation reimplementation -switch to dynamic navmesh generation and steering.
#. GUI system extension -proper layout engine, input widgets, etc.
#. Editor updates -undo/redo, usability improvements.
#. Reference search in editor -e.g. search by animation, returning all objects referencing that animation, to help game development troubleshooting.
#. Improve animation system with masking and blend trees.
#. Projected decals (Optional).

Before 1.0
==========

#. Generate AI navigation mesh from AI navigation grid. Serialize it with map. **Done**
#. Make world a tree, and allow modifications to groups. **Done**
#. Mixamo animation support. **Done**
#. Object culling. **Done** (SIMD software occlusion culling)
#. File logger. **Done** (in-game logger overlay)
#. Custom shaders. **Done** (via pipeline editor and RenderMethod extension point)
#. Python scripting support. **Done**
#. Options can't be set using GUI, they should have.
#. Directory listings should auto generate for assets, with refresh support. Partial -no refresh.
#. Stair support.
#. Editor undo/redo.
#. Auto-align objects.
#. Spot lights.
#. Opacity handling improvements.

Known Limitations in 0.7
========================

The following limitations are confirmed in version 0.7:

**Rendering and Assets**

* Model scaling is imported directly from the source file - no automatic correction is applied. Incorrect scale must be fixed in the editor.
* Aggressive engine-wide LOD settings can produce visible mesh pop-in. Tune the ``LodDistanceList`` option for your scene.
* Raspberry Pi 4/5 is affected by an upstream Mesa driver bug causing a visual artefact. A ticket is open on the public Mesa tracker.
* limonmodel load-time benchmarks are not yet published.

**Navigation and AI**

* Pathfinding assumes actor collision size and mobility matches the player. Flying and swimming actors are not natively supported.
* Navigation grid is not generated if the world contains no AI actors.
* Navigation grid does not update for dynamic geometry changes at runtime. Planned post-0.7.
* Map geometry disconnected from the flood-fill origin of the first AI actor is silently excluded from the navigation grid.

**Animation**

* Skeletal animation blending is two-animation crossfade only. Blend trees and state machines are not supported.

**Input**

* Keyboard and mouse input are natively supported. Controllers and other devices require SDL2 passthrough via a Player Extension.

**Player**

* Player movement customisation beyond the options (jump factor, speeds) requires a custom Player Extension.

**Missing Features**

* No height map terrain support.
* No time dilation.
* No networking.
* No mobile platform builds (Android/iOS).

Possible Additions
==================

#. Vulkan backend
#. Android support
#. Emscripten/WebAssembly support
