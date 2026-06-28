.. _OptionsReference:

========================
Engine Options Reference
========================

Engine options are loaded from two files at startup:

* ``./Engine/Options.xml`` — engine defaults, shipped with the engine. Never overwritten by the engine at runtime.
* ``./Data/Options.xml`` — user overrides. Optional; if absent, engine defaults are used as-is. Values here take precedence over any matching entry in the engine defaults file.

Each option is a ``<Parameter>`` entry with a ``Description`` (the option name), a ``Value``, and a ``valueType``. Options are global and persist across levels and sessions; they can also be read and modified at runtime through the API (:ref:`get_options<pythonApi-get_options>` / :ref:`save_options<pythonApi-save_options>`).

Calling ``save_options()`` / ``saveOptions()`` writes the current in-memory options to ``./Data/Options.xml`` only — engine defaults are never touched. This means custom values survive engine restarts without risk of corrupting the shipped defaults.

The values below are the defaults shipped with the engine. Unless noted, changing an option takes effect the next time the engine starts; audio channel volumes are applied live.

.. note::
   ``valueType`` values map to: ``Long`` (integer), ``Double`` (floating point),
   ``Boolean`` (``True``/``False``), ``String`` (text), ``Vec4`` (X/Y/Z[/W]
   coordinate), ``LongArray`` / ``FloatArray`` (comma-separated lists).

General
=======

.. list-table::
   :header-rows: 1
   :widths: 25 12 20 43

   * - Option
     - Type
     - Default
     - Description
   * - ``dataDirectory``
     - String
     - ``../dataLocal/``
     - Root directory the engine loads game data and assets from.
   * - ``render_backend``
     - String
     - ``libOpenGLGraphicsBackend``
     - Graphics backend library to load (e.g. OpenGL or OpenGL ES).
   * - ``render_pipeline``
     - String
     - ``./Engine/forward_renderPipeline.xml``
     - Render pipeline definition loaded at startup.

Display
=======

.. list-table::
   :header-rows: 1
   :widths: 25 12 20 43

   * - Option
     - Type
     - Default
     - Description
   * - ``display_width``
     - Long
     - ``2560``
     - Game window width in pixels.
   * - ``display_height``
     - Long
     - ``1440``
     - Game window height in pixels.
   * - ``display_fullScreen``
     - Boolean
     - ``False``
     - Launch in fullscreen.
   * - ``render_textureFiltering``
     - String
     - ``Trilinear``
     - Texture filtering mode: ``Nearest``, ``Bilinear`` or ``Trilinear``.

Audio
=====

Audio is mixed on five channels (buses). The effective gain of a sound is
``per-sound gain × channel volume × master volume``. These options are the channel
volumes; see :ref:`Audio Channels<pythonApi-audio_channels>` in the Python API
reference. Changes are applied to the mixer immediately.

.. list-table::
   :header-rows: 1
   :widths: 25 12 20 43

   * - Option
     - Type
     - Default
     - Description
   * - ``audio_volumeMaster``
     - Double
     - ``1.0``
     - Master channel volume, normalized 0.0..1.0. Multiplies every sound.
   * - ``audio_volumeMusic``
     - Double
     - ``1.0``
     - Music channel volume, normalized 0.0..1.0.
   * - ``audio_volumeSFX``
     - Double
     - ``1.0``
     - Sound-effects channel volume, normalized 0.0..1.0.
   * - ``audio_volumeSpeech``
     - Double
     - ``1.0``
     - Speech/dialogue channel volume, normalized 0.0..1.0.
   * - ``audio_volumeAmbient``
     - Double
     - ``1.0``
     - Ambient/environmental sound channel volume, normalized 0.0..1.0.

Player Movement
===============

.. list-table::
   :header-rows: 1
   :widths: 25 12 20 43

   * - Option
     - Type
     - Default
     - Description
   * - ``player_walkSpeed``
     - Vec4
     - ``(8, 0, 8)``
     - Player walk speed.
   * - ``player_runSpeed``
     - Vec4
     - ``(12, 0, 12)``
     - Player run speed.
   * - ``player_moveSpeed``
     - Vec4
     - ``(8, 0, 8)``
     - General movement speed.
   * - ``player_freeMovementSpeed``
     - Vec4
     - ``(0.5, 0.5, 0.5)``
     - Free-camera (editor / debug) movement speed.
   * - ``player_lookAroundSpeed``
     - Double
     - ``-6.5``
     - Look sensitivity. Applies equally to mouse and gamepad stick (both normalised to the same unit). See :ref:`InputSystem-look-speed`.
   * - ``gamepad_deadZone``
     - Double
     - ``0.1``
     - Gamepad analog axis dead zone. Stick values with absolute magnitude below this threshold produce no output.
   * - ``player_jumpFactor``
     - Double
     - ``7.0``
     - Jump impulse factor.

Lighting and Shadows
====================

.. list-table::
   :header-rows: 1
   :widths: 30 12 18 40

   * - Option
     - Type
     - Default
     - Description
   * - ``performance_maximumLights``
     - Long
     - ``4``
     - Maximum number of simultaneous dynamic lights.
   * - ``shadow_mapDirectionalSize``
     - Long
     - ``2048``
     - Directional light shadow map resolution.
   * - ``shadow_mapPointWidth``
     - Long
     - ``512``
     - Point light shadow map width.
   * - ``shadow_mapPointHeight``
     - Long
     - ``512``
     - Point light shadow map height.
   * - ``shadow_pointSampleCount``
     - Long
     - ``20``
     - PCF sample count for point light shadows.
   * - ``shadow_directionalSampleCount``
     - Long
     - ``8``
     - PCF sample count for directional light shadows.
   * - ``shadow_cascadeCount``
     - Long
     - ``4``
     - Number of cascaded shadow map cascades.
   * - ``shadow_cascadeLimitList``
     - FloatArray
     - ``5.0, 20.0, 50.0, 150.0, 250.0``
     - View-space distance splits between shadow cascades.
   * - ``shadow_cascadeStaggerOffsets``
     - LongArray
     - ``4, 1, 2, 4``
     - Per-cascade frame offset for staggered shadow updates (cascade 0 updates every frame).
   * - ``shadow_cascadeStaggerIntervals``
     - LongArray
     - ``4, 2, 4, 8``
     - Per-cascade update interval in frames. Larger values improve framerate but delay shadow updates.
   * - ``shadow_directionalProjectionBackOff``
     - Double
     - ``-5000``
     - Back-off distance for the directional light orthographic projection.
   * - ``shadow_pointNearPlane``
     - Double
     - ``0.1``
     - Near plane for point light shadow projection.
   * - ``shadow_pointFarPlane``
     - Double
     - ``100``
     - Far plane for point light shadow projection.

Ambient Occlusion (SSAO)
========================

.. list-table::
   :header-rows: 1
   :widths: 25 12 20 43

   * - Option
     - Type
     - Default
     - Description
   * - ``ssao_width``
     - Long
     - ``2560``
     - SSAO buffer width.
   * - ``ssao_height``
     - Long
     - ``1440``
     - SSAO buffer height.
   * - ``ssao_sampleCount``
     - Long
     - ``9``
     - SSAO kernel sample count.
   * - ``ssao_blurRadius``
     - Long
     - ``1``
     - SSAO blur radius.

Culling, LOD and Occlusion
==========================

.. list-table::
   :header-rows: 1
   :widths: 32 12 16 40

   * - Option
     - Type
     - Default
     - Description
   * - ``performance_multiThreadedCulling``
     - Boolean
     - ``True``
     - Run visibility culling on worker threads.
   * - ``LOD_distanceList``
     - LongArray
     - ``5, 10, 25, 150, 250``
     - Distance thresholds selecting LOD level (3 LODs are generated per model, so 4 levels).
   * - ``LOD_skipRenderDistance``
     - Double
     - ``50.0``
     - Distance at which the engine may start skipping rendering of an object (with ``LOD_skipRenderSize``).
   * - ``LOD_skipRenderSize``
     - Double
     - ``0.075``
     - On-screen size (fraction) below which distant objects past ``LOD_skipRenderDistance`` are skipped.
   * - ``LOD_maxSkipRenderSize``
     - Double
     - ``3``
     - On-screen size above which an object is never skipped (avoids jarring wall/ground pop).
   * - ``occlusion_enabled``
     - Boolean
     - ``True``
     - Enable software occlusion culling for the player camera. Can be toggled at runtime from the editor.
   * - ``SplitModelToMeshCount``
     - Long
     - ``10``
     - Models with more meshes than this get occlusion tested per mesh instead of per model.
   * - ``occlusion_renderWidth``
     - Long
     - ``512``
     - Software-rasterized depth buffer width (must be a multiple of 8).
   * - ``occlusion_renderHeight``
     - Long
     - ``256``
     - Software-rasterized depth buffer height (must be a multiple of 8).
   * - ``occlusion_occluderSizePerspective``
     - Double
     - ``0.1``
     - On-screen size threshold for an object to be treated as an occluder for perspective cameras (1 = full coverage).
   * - ``occlusion_occluderSizeOrthographic``
     - Double
     - ``0.01``
     - Same threshold for orthographic (shadow) cameras; optimal value is much lower than for perspective.

Debugging and Profiling
=======================

.. list-table::
   :header-rows: 1
   :widths: 32 12 16 40

   * - Option
     - Type
     - Default
     - Description
   * - ``debug_renderInformations``
     - Boolean
     - ``True``
     - Show the on-screen logger overlay and tris/lines/FPS counters.
   * - ``debug_drawLines``
     - Boolean
     - ``False``
     - Draw debug lines.
   * - ``debug_drawBufferSize``
     - Long
     - ``1000``
     - Vertex buffer size for debug line drawing.
   * - ``profiler_enableServer``
     - Boolean
     - ``True``
     - Enable the built-in profiler server.
   * - ``occlusion_renderDump``
     - Boolean
     - ``False``
     - Dump the software-rasterized depth buffer to a PPM file (debug only).
   * - ``occlusion_renderDumpFrequency``
     - Long
     - ``300``
     - How often (in frames) to dump the software depth buffer when dumping is enabled.
