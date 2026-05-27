.. _SupportingSystems:

==================
Supporting Systems
==================

Navigation System
=================

Limon builds a 3D navigation grid for each world. The grid is used by AI actors for pathfinding and is queryable by any extension via the route request API.

Grid Generation
---------------

* Flood fill from the location of the first AI actor in the world
* Traversability calculated assuming player-equivalent size and mobility
* Grid is static for the lifetime of the loaded world - runtime geometry changes are not reflected

**Saving the grid**

Generating the navigation grid on large maps can take several minutes. The editor provides two dedicated save buttons so it does not need to be regenerated on every load:

* **Save as binary** - fast-load format, recommended for shipping
* **Save as XML** - human-readable format for engine debugging only. Can require up to 2 GB of memory on large maps.

If the grid is not present in the world file, it is generated at load time as a fallback.

Route Request API
-----------------

Route requests are asynchronous - the result is delivered via callback and the simulation tick is never blocked. A single navigation grid is shared by all AI actors in the world. For implementation details see :ref:`implementAIActor`.

.. warning::
    Navigation grid is not generated if the world contains no AI actors. Areas unreachable from the first AI actor's location are silently excluded. The system assumes actor size and mobility matches the player - flying and swimming actors are not supported natively. Dynamic geometry changes at runtime do not update the grid (planned post-0.7).

Visibility System
=================

Four sequential visibility filters run every frame for each active camera before any geometry is submitted to the GPU. With multiple cameras in the pipeline (player camera, shadow map cameras), each camera's culling workload runs on a separate thread concurrently.

1. **Tag filtering** - each camera and scene object carries a tag; only matching combinations are considered for rendering.
2. **Frustum culling** - objects outside the camera view volume are discarded.
3. **Occlusion culling** - a SIMD software depth buffer on the CPU rejects objects hidden behind other geometry. SSE4.1 on x86, NEON on AArch64 (Apple Silicon, Raspberry Pi 4/5).
4. **LOD selection** - the appropriate level-of-detail mesh is chosen based on projected screen-space size.

Objects below a configurable screen-space size threshold are skipped entirely before any of the above tests run.

Full details - including the three-layer occlusion culling architecture, LOD mesh generation, cascade shadow map setup, all configuration options, and the rationale for targeting integrated GPU hardware - are in :ref:`RenderingPipeline`.

Particle System
===============

Limon has two particle emitter types: **CPU Particle** and **GPU Particle**. Both are full GameObject types and can be attached to model bones at runtime, following the bone transform through skeletal animation.

Emitter Parameters
------------------

.. list-table::
   :header-rows: 1
   :widths: 25 15 60

   * - Parameter
     - Type
     - Description
   * - Emission mode
     - Enum
     - One-time or continuous. Changeable at runtime via ``enableParticleEmitter`` / ``disableParticleEmitter``.
   * - Initial speed
     - Vec3
     - Per-particle initial velocity vector.
   * - Initial direction
     - Vec3
     - Per-particle initial direction vector.
   * - Start position
     - AABB
     - Particles emitted from random positions within the bounding box.
   * - Acceleration
     - Vec3
     - Applied to each particle every simulation tick.
   * - Texture
     - Asset ref
     - Custom texture per emitter.
   * - Per-particle transform/blend
     - Time curve
     - Time-based transform and blend per particle over its lifetime.

Particle API
------------

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - Method
     - Description
   * - ``addParticleEmitter(name, texture, startPos, maxStartDistances, size, count, lifeTime, particlesPerMs, continuouslyEmit)``
     - Create an emitter at runtime. Returns emitter ID. (:ref:`C++ <LimonAPI-addParticleEmitter>` | :ref:`Python <pythonApi-add_particle_emitter>`)
   * - ``removeParticleEmitter(emitterID)``
     - Remove emitter by ID. (:ref:`C++ <LimonAPI-removeParticleEmitter>` | :ref:`Python <pythonApi-remove_particle_emitter>`)
   * - ``enableParticleEmitter(emitterID)``
     - Enable emitter, resuming emission. (:ref:`C++ <LimonAPI-enableParticleEmitter>` | :ref:`Python <pythonApi-enable_particle_emitter>`)
   * - ``disableParticleEmitter(emitterID)``
     - Disable emitter, stopping emission. (:ref:`C++ <LimonAPI-disableParticleEmitter>` | :ref:`Python <pythonApi-disable_particle_emitter>`)
   * - ``setEmitterParticleSpeed(emitterID, speedMultiplier, speedOffset)``
     - Set speed parameters. (:ref:`C++ <LimonAPI-setEmitterParticleSpeed>` | :ref:`Python <pythonApi-set_emitter_particle_speed>`)
   * - ``setEmitterParticleGravity(emitterID, gravity)``
     - Set gravity value. (:ref:`C++ <LimonAPI-setEmitterParticleGravity>` | :ref:`Python <pythonApi-set_emitter_particle_gravity>`)

Debug Systems
=============

In-Game Logger Overlay
----------------------

A transparent logger overlay is built into the engine. New log entries push the scroll up and disappear after 5 seconds. The overlay is toggleable via the ``renderInformations`` option.

The ``log(subsystem, level, text)`` API is available from both C++ (:ref:`C++ <LimonAPI-log>` | :ref:`Python <pythonApi-log>`) and Python.

.. note::
    The overlay is backed by an internal GUI multi-line text type. This type is not exposed as a placeable GUI element.

Debug Line Draw
---------------

3D world-space line rendering with per-vertex RGB colour interpolation. Lines are organised into independent ID-based buffers, so pathfinding visualisation, AI sight lines, and physics overlays can be managed and cleared separately.

.. list-table::
   :header-rows: 1
   :widths: 50 50

   * - Method
     - Description
   * - ``drawDebugLine(from, to, fromColor, toColor, requireCameraTransform)``
     - Create a new line buffer and add the first line. Returns buffer ID. Set ``requireCameraTransform=False`` for camera-space (HUD-style) lines, ``True`` for world-space. (:ref:`C++ <LimonAPI-drawDebugLine>` | :ref:`Python <pythonApi-draw_debug_line>`)
   * - ``addToDebugLine(bufferID, from, to, fromColor, toColor, requireCameraTransform)``
     - Add a line to an existing buffer. (:ref:`C++ <LimonAPI-addToDebugLine>` | :ref:`Python <pythonApi-add_to_debug_line>`)
   * - ``clearDebugLines(bufferID)``
     - Clear all lines in the buffer. (:ref:`C++ <LimonAPI-clearDebugLines>` | :ref:`Python <pythonApi-clear_debug_lines>`)

Colour is linearly interpolated from ``fromColor`` to ``toColor`` along each line. The ``DebugDrawLines`` option must be enabled for lines to render.

Profiling System
================

Limon integrates the Tracy profiler throughout the engine. CPU and GPU instrumentation is available out of the box without any user setup.

* **CPU zones** cover all engine simulation subsystems.
* **GPU zones** are generated automatically from the render pipeline configuration - custom RenderMethod passes produce correct GPU zones without manual instrumentation.
* Zones are organised in named batches that can be individually enabled or disabled via options or from the editor.

profileScope API
----------------

Custom profiling zones can be added from C++ or Python (:ref:`C++ <LimonAPI-profileScope>` | :ref:`Python <pythonApi-profile_scope>`)::

    profileScope("my_zone_name")

User zones participate in the same named batch system as engine zones.

Embedded Flame Graph
--------------------

A custom Tracy server is embedded in the engine process. A per-frame flame graph is visible in the editor as a convenience view for quick inspection.

.. note::
    The embedded view is less capable than the official Tracy UI. The official Tracy client can connect to the embedded server for complete profiling - the two are fully protocol-compatible.
