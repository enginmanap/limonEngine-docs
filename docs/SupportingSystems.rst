.. _SupportingSystems:

==================
Supporting Systems
==================

.. toctree::
   :hidden:
   :maxdepth: 1

   Packaging
   MapConverter

Navigation System
=================

Limon builds a 3D navigation grid for each world. The grid is used by :ref:`AI actors <implementAIActor>` for pathfinding and is queryable by any extension via the :ref:`route request API <ActorInterface-route-lifecycle>`.

Grid Generation
---------------

* Flood fill from the location of the first AI actor in the world
* Traversability calculated assuming player-equivalent size and mobility
* Grid is static for the lifetime of the loaded world - runtime geometry changes are not reflected

**Saving the grid**

Generating the navigation grid on large maps can take several minutes. The :ref:`editor <UsingBuiltinEditor>` provides two dedicated save buttons so it does not need to be regenerated on every load:

* **Save as binary** - fast-load format, recommended for shipping
* **Save as XML** - human-readable format for engine debugging only. Can require up to 2 GB of memory on large maps.

If the grid is not present in the world file, it is generated at load time as a fallback.

Route Request API
-----------------

Route requests are asynchronous - the result is delivered via callback and the simulation tick is never blocked. A single navigation grid is shared by all AI actors in the world. For implementation details see :ref:`implementAIActor`.

.. warning::
    Navigation grid is not generated if the world contains no AI actors. Areas unreachable from the first AI actor's location are silently excluded. The system assumes actor size and mobility matches the player - flying and swimming actors are not supported natively. Dynamic geometry changes at runtime do not update the grid (planned post-0.7).

.. _VisibilitySystem:

Visibility System
=================

Four sequential visibility filters run every frame for each active camera before any geometry is submitted to the GPU. With multiple cameras in the pipeline (player camera, shadow map cameras), each camera's culling workload runs on a separate thread concurrently.

1. **Tag filtering** - each camera and scene object carries :ref:`tags <Tagging>`; an object is considered by a render stage if any of its tags is one the stage asks for.
2. **Frustum culling** - objects outside the camera view volume are discarded.
3. **Occlusion culling** - a SIMD software depth buffer on the CPU rejects objects hidden behind other geometry. SSE4.1 on x86, NEON on AArch64 (Apple Silicon, Raspberry Pi 4/5).
4. **LOD selection** (see :ref:`LevelOfDetail`) - each object uses the coarsest level whose switch distance it is past. Levels are generated so that each one stays within pixel limits at its own distance.

Objects below a configurable screen-space size threshold are skipped entirely before any of the above tests run.

To see what occlusion culling removes, and to change how it decides while the game runs, see :ref:`RenderDebugging`.

Full details - including the three-layer occlusion culling architecture, LOD mesh generation, cascade shadow map setup, all configuration options, and the rationale for targeting integrated GPU hardware - are in :ref:`RenderingPipeline`.

Particle System
===============

Limon has two particle emitter types: **CPU Particle** and **GPU Particle**. Both are full GameObject types and can be attached to model bones at runtime, following the bone transform through skeletal animation. **GPU Particle is experimental**

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
   * - Speed Multiplier
     - Vec3
     - Scales a random per-axis launch velocity between -1 and +1 meters/second (1 world unit = 1 meter).
   * - Speed Offset
     - Vec3
     - Constant per-axis launch velocity in meters/second, added on top of Speed Multiplier.
   * - Start position
     - AABB
     - Particles emitted from random positions within the bounding box.
   * - Gravity
     - Vec3
     - Per-axis acceleration in meters/second², e.g. approximately -9.8 on Y for Earth-like gravity.
   * - Texture
     - Asset ref
     - Custom texture per emitter.
   * - Color over lifetime
     - Time curve
     - RGBA color multiplier keyframes, keyed by milliseconds since each particle's own spawn.

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

A transparent logger overlay is built into the engine. New log entries push the scroll up and disappear after 5 seconds. The overlay is toggleable via the :ref:`debug_renderInformations <option-debug_renderInformations>` option.

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

Colour is linearly interpolated from ``fromColor`` to ``toColor`` along each line.

The engine draws its own editor visualisations through these same buffers - a selected particle emitter's spawn box and trajectory hull, and a selected point light's radius sphere. Those are drawn whenever the object is selected and do not depend on the ``debug_drawLines`` option; that option gates the engine's *own* producers such as the shadow cascade frustums and ray cast results, not the buffers a plugin fills.

.. _RenderDebugging:

Render Debugging
----------------

The editor window has a **Render Debugging** section for investigating what the renderer is doing. It has two tools, one for looking at the render pipeline's targets and one for occlusion culling.

.. _RenderTargetViewer:

Render target viewer
^^^^^^^^^^^^^^^^^^^^

Every texture of the active render pipeline can be viewed in the editor, so you can see the output of each render stage instead of guessing from the final image. Pick a texture from the **Current Textures** list. Hovering a name shows what the texture is: its type and format. The list also has the textures the editor's own previews render into.

.. figure:: _static/media/images/editor-render-debugging-textures.png
    :align: center

    The render target viewer, showing a pipeline texture with a custom range.

Once a texture is selected, the viewer shows its id and the controls below it:

* **Fit to window** scales the image to the width of the editor window. Turn it off to see the texture at its real size.
* **Layer** appears for texture arrays and cube map arrays, for example the shadow maps. For a cube map array it also tells you the cube and the face.
* **Range min** and **Range max** are a manual tonemapping. Colours are mapped so that ``min`` shows as black and ``max`` as white. Floating point targets, like HDR colour, can hold values far above 1 and look pure white or pure black at the default range, so drag the range until the part you care about shows up. Targets stored as normalised values (8 bit colour, depth) stay inside 0 to 1. **Reset range** returns to 0 to 1, which shows the texture as it is.
* **Channel** shows all channels, or only red, green, blue or alpha. With all channels, alpha is ignored so a transparent target is still visible.

Selecting another texture resets the range, the channel and the layer.

Occlusion culling debugging
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Occlusion culling is the filter that is hardest to judge by looking at the final image, since it removes things that were hidden anyway. The occlusion controls in **Render Debugging** show what it removes and let you change how it decides, while the game runs. See :ref:`the visibility system <VisibilitySystem>` for how the culling works.

.. figure:: _static/media/images/editor-render-debugging-occlusion.png
    :align: center

    The occlusion controls in the Render Debugging section.

* **Occlusion Culling** turns the whole filter on and off, so you can compare a frame with and without it, or find out whether culling is what removed an object. This is the :ref:`occlusion_enabled <option-occlusion_enabled>` option.
* **Reverse Occlusion** draws only what occlusion culling removed. The scene is drawn without the objects that are visible, so a mesh that disappears when it should not shows up here. It needs occlusion culling to be on, and it only affects the player camera, shadow rendering is left alone. This is the :ref:`occlusion_debugReverse <option-occlusion_debugReverse>` option.
* **Visible meshes opacity** is used while Reverse Occlusion is on. The meshes that passed culling are drawn over the occluded ones with this opacity: at 0 they are not drawn, so you see only the occluded meshes, and at 100 they are drawn as normal. A value in between lets you see the occluded meshes through the visible ones. This is the :ref:`occlusion_debugOverlayOpacity <option-occlusion_debugOverlayOpacity>` option.
* **Occluder size (perspective)** is the share of the screen a mesh must cover to become an occluder for the player camera, with 1 being the full screen. Raise it to get fewer occluders, lower it to get more, and watch the effect on the culling directly. This is :ref:`occlusion_occluderSizePerspective <option-occlusion_occluderSizePerspective>`.
* **Occluder size (orthographic)** is the same threshold for orthographic cameras, which the directional light's shadow cascades use. It changes what shadow rendering culls, not what the player camera culls. This is :ref:`occlusion_occluderSizeOrthographic <option-occlusion_occluderSizeOrthographic>`.
* **Occluder bake LOD** chooses which LOD level is rasterized as the occluder. This is :ref:`occlusion_bakeLodLevel <option-occlusion_bakeLodLevel>`, with the same limit: a model loaded from a source file bakes only that level, so it needs a reload to change, while a ``limonmodel`` switches immediately.
* **Occluder size by group** decides how a model that is in a model group becomes an occluder. When it is on, the model counts as an occluder when the box of its nearest group passes the occluder size, instead of its own box. Turn it off to select occluders from each model individually. This is :ref:`occlusion_occluderSizeByGroup <option-occlusion_occluderSizeByGroup>`.
* **Group member min fraction** applies when occluders are selected by group. A member still has to cover at least this fraction of the occluder size itself, so small props in a big group are not rasterized. At 1 a grouped model follows the same rule as an ungrouped one. This is :ref:`occlusion_occluderGroupMemberMinFraction <option-occlusion_occluderGroupMemberMinFraction>`.

Changes apply on the next tick. The editor does not write them to the options files, so to keep a value, set the option itself, see :ref:`OptionsReference`.

Depth buffer dump
^^^^^^^^^^^^^^^^^

Occlusion culling decides with a small depth buffer that the CPU rasterizes from the occluders. To see that buffer itself, for example to find out why an object is culled or why an occluder is missing, the engine can write it to an image file. There is no editor control for it, it is set with two options:

* :ref:`occlusion_renderDump <option-occlusion_renderDump>` turns the dump on.
* :ref:`occlusion_renderDumpFrequency <option-occlusion_renderDumpFrequency>` sets how often a dump is written, as a number of culling passes of that camera. A dump every frame would flood the disk and slow the game down, so keep it high.

Each dump is a ``.ppm`` image written to the engine's working directory, and the next dump of the same camera replaces it. The player camera writes ``SDOCdepthMap_player.ppm``. Each shadow cascade of the directional light writes its own file, ``SDOCdepthMap_<camera name>_<size>.ppm``, where the size identifies the cascade. The console prints the buffer's dimensions and whether saving worked. Most image viewers can not open ``.ppm`` files, but GIMP and many others can.

The buffer's size is set by :ref:`occlusion_renderWidth <option-occlusion_renderWidth>` and :ref:`occlusion_renderHeight <option-occlusion_renderHeight>`. Combined with the occluder size sliders above, the dump shows what your changes did to the buffer.

Profiling System
================

Limon integrates the Tracy profiler throughout the engine. CPU and GPU instrumentation is available out of the box without any user setup.

* **CPU zones** cover all engine simulation subsystems.
* **GPU zones** are generated automatically from the render pipeline configuration - custom :ref:`RenderMethod <RenderingPipeline>` passes produce correct GPU zones without manual instrumentation.
* Zones are organised in named batches that can be individually enabled or disabled via :ref:`options <OptionsReference>` or from the editor.

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

Asset Tools
===========

Two functions of the engine work on a game's assets rather than inside a running game. Both can be started from the command line, and the packer from the editor too.

* :ref:`Packaging <Packaging>` builds the ``Data.pak`` a released game ships with.
* The :ref:`Map Converter <MapConverter>` splits a map exported from another engine as one model into a world of separate objects.


.. seealso::

   * :ref:`EngineArchitecture-ticks` -simulation steps that drive actors and route requests
   * :ref:`ActorInterface-route-lifecycle` -how an AI actor requests and follows a route
   * :ref:`implementAIActor` -the AI actor extension point that uses the navigation grid
   * :ref:`UsingBuiltinEditor` -saving the navigation grid and the profiler view
   * :ref:`OptionsReference` -options that enable debug drawing and profiling
   * :ref:`RenderingPipeline` -tags, culling and LOD
