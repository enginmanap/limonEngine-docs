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
   * - .. _option-dataDirectory:

       ``dataDirectory``
     - String
     - ``../dataLocal/``
     - Root directory the engine loads game data and assets from.
   * - .. _option-render_backend:

       ``render_backend``
     - String
     - ``libOpenGLGraphicsBackend``
     - Graphics backend library to load (e.g. OpenGL or OpenGL ES).
   * - .. _option-render_pipeline:

       ``render_pipeline``
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
   * - .. _option-display_width:

       ``display_width``
     - Long
     - ``2560``
     - Game window width in pixels.
   * - .. _option-display_height:

       ``display_height``
     - Long
     - ``1440``
     - Game window height in pixels.
   * - .. _option-display_fullScreen:

       ``display_fullScreen``
     - Boolean
     - ``False``
     - Launch in fullscreen.
   * - .. _option-render_textureFiltering:

       ``render_textureFiltering``
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
   * - .. _option-audio_volumeMaster:

       ``audio_volumeMaster``
     - Double
     - ``1.0``
     - Master channel volume, normalized 0.0..1.0. Multiplies every sound.
   * - .. _option-audio_volumeMusic:

       ``audio_volumeMusic``
     - Double
     - ``1.0``
     - Music channel volume, normalized 0.0..1.0.
   * - .. _option-audio_volumeSFX:

       ``audio_volumeSFX``
     - Double
     - ``1.0``
     - Sound-effects channel volume, normalized 0.0..1.0.
   * - .. _option-audio_volumeSpeech:

       ``audio_volumeSpeech``
     - Double
     - ``1.0``
     - Speech/dialogue channel volume, normalized 0.0..1.0.
   * - .. _option-audio_volumeAmbient:

       ``audio_volumeAmbient``
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
   * - .. _option-player_walkSpeed:

       ``player_walkSpeed``
     - Vec4
     - ``(8, 0, 8)``
     - Player walk speed.
   * - .. _option-player_runSpeed:

       ``player_runSpeed``
     - Vec4
     - ``(12, 0, 12)``
     - Player run speed.
   * - .. _option-player_moveSpeed:

       ``player_moveSpeed``
     - Vec4
     - ``(8, 0, 8)``
     - General movement speed.
   * - .. _option-player_freeMovementSpeed:

       ``player_freeMovementSpeed``
     - Vec4
     - ``(0.5, 0.5, 0.5)``
     - Free-camera (editor / debug) movement speed.
   * - .. _option-player_lookAroundSpeed:

       ``player_lookAroundSpeed``
     - Double
     - ``-6.5``
     - Look sensitivity. Applies equally to mouse and gamepad stick (both normalised to the same unit). See :ref:`InputSystem-look-speed`.
   * - .. _option-gamepad_deadZone:

       ``gamepad_deadZone``
     - Double
     - ``0.1``
     - Gamepad analog axis dead zone. Stick values with absolute magnitude below this threshold produce no output.
   * - .. _option-player_jumpFactor:

       ``player_jumpFactor``
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
   * - .. _option-performance_maximumLights:

       ``performance_maximumLights``
     - Long
     - ``4``
     - Maximum number of simultaneously active lights. A directional light, if there is one, always takes a slot; the point lights that survive culling fill the rest, closest to the player first.
   * - .. _option-shadow_mapDirectionalSize:

       ``shadow_mapDirectionalSize``
     - Long
     - ``2048``
     - Directional light shadow map resolution.
   * - .. _option-shadow_mapPointWidth:

       ``shadow_mapPointWidth``
     - Long
     - ``512``
     - Point light shadow map width.
   * - .. _option-shadow_mapPointHeight:

       ``shadow_mapPointHeight``
     - Long
     - ``512``
     - Point light shadow map height.
   * - .. _option-shadow_pointSampleCount:

       ``shadow_pointSampleCount``
     - Long
     - ``20``
     - PCF sample count for point light shadows.
   * - .. _option-shadow_directionalSampleCount:

       ``shadow_directionalSampleCount``
     - Long
     - ``8``
     - PCF sample count for directional light shadows.
   * - .. _option-shadow_cascadeCount:

       ``shadow_cascadeCount``
     - Long
     - ``4``
     - Number of cascaded shadow map cascades.
   * - .. _option-shadow_cascadeLimitList:

       ``shadow_cascadeLimitList``
     - FloatArray
     - ``5.0, 20.0, 50.0, 150.0, 250.0``
     - View-space distance splits between shadow cascades.
   * - .. _option-shadow_cascadeStaggerOffsets:

       ``shadow_cascadeStaggerOffsets``
     - LongArray
     - ``4, 1, 2, 4``
     - Per-cascade frame offset for staggered shadow updates (cascade 0 updates every frame).
   * - .. _option-shadow_cascadeStaggerIntervals:

       ``shadow_cascadeStaggerIntervals``
     - LongArray
     - ``4, 2, 4, 8``
     - Per-cascade update interval in frames. Larger values improve framerate but delay shadow updates.
   * - .. _option-shadow_directionalProjectionBackOff:

       ``shadow_directionalProjectionBackOff``
     - Double
     - ``-5000``
     - How far behind the player frustum the directional light's view origin is pulled. Increase it to capture shadow casters behind the camera.
   * - .. _option-shadow_pointNearPlane:

       ``shadow_pointNearPlane``
     - Double
     - ``0.1``
     - Near plane for point light shadow projection.
   * - .. _option-shadow_pointFarPlane:

       ``shadow_pointFarPlane``
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
   * - .. _option-ssao_width:

       ``ssao_width``
     - Long
     - ``2560``
     - SSAO buffer width.
   * - .. _option-ssao_height:

       ``ssao_height``
     - Long
     - ``1440``
     - SSAO buffer height.
   * - .. _option-ssao_sampleCount:

       ``ssao_sampleCount``
     - Long
     - ``9``
     - SSAO kernel sample count.
   * - .. _option-ssao_blurRadius:

       ``ssao_blurRadius``
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
   * - .. _option-performance_multiThreadedCulling:

       ``performance_multiThreadedCulling``
     - Boolean
     - ``True``
     - Run visibility culling on worker threads.
   * - .. _option-LOD_distanceList:

       ``LOD_distanceList``
     - LongArray
     - ``5, 10, 25, 150, 250``
     - Distance thresholds selecting LOD level (3 LODs are generated per model, so 4 levels).
   * - .. _option-LOD_skipRenderDistance:

       ``LOD_skipRenderDistance``
     - Double
     - ``50.0``
     - Distance at which the engine may start skipping rendering of an object (with ``LOD_skipRenderSize``). Objects closer than this are never skipped by size.
   * - .. _option-LOD_skipRenderSize:

       ``LOD_skipRenderSize``
     - Double
     - ``0.075``
     - On-screen size (fraction) below which distant objects past ``LOD_skipRenderDistance`` are skipped.
   * - .. _option-LOD_maxSkipRenderSize:

       ``LOD_maxSkipRenderSize``
     - Double
     - ``3``
     - World-space size (bounding box width or height) at or above which an object is never skipped regardless of distance, so large geometry such as ground and walls doesn't disappear at range.
   * - .. _option-occlusion_enabled:

       ``occlusion_enabled``
     - Boolean
     - ``True``
     - Enable software occlusion culling for the player camera. Can be toggled at runtime from the editor.
   * - .. _option-SplitModelToMeshCount:

       ``SplitModelToMeshCount``
     - Long
     - ``10``
     - Models with more meshes than this get occlusion tested per mesh instead of per model.
   * - .. _option-occlusion_renderWidth:

       ``occlusion_renderWidth``
     - Long
     - ``512``
     - Software-rasterized depth buffer width (must be a multiple of 8).
   * - .. _option-occlusion_renderHeight:

       ``occlusion_renderHeight``
     - Long
     - ``256``
     - Software-rasterized depth buffer height (must be a multiple of 8).
   * - .. _option-occlusion_occluderSizePerspective:

       ``occlusion_occluderSizePerspective``
     - Double
     - ``0.1``
     - On-screen size threshold for an object to be treated as an occluder for perspective cameras (1 = full coverage).
   * - .. _option-occlusion_occluderSizeOrthographic:

       ``occlusion_occluderSizeOrthographic``
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
   * - .. _option-debug_renderInformations:

       ``debug_renderInformations``
     - Boolean
     - ``True``
     - Show the on-screen logger overlay and tris/lines/FPS counters.
   * - .. _option-debug_drawLines:

       ``debug_drawLines``
     - Boolean
     - ``False``
     - Draw the engine's own debug lines - shadow cascade frustums and ray cast results. Toggled at runtime with F4. Lines drawn through the API and the editor's object visualisations are not affected by it and render regardless.
   * - .. _option-debug_drawBufferSize:

       ``debug_drawBufferSize``
     - Long
     - ``1000``
     - Vertex buffer capacity for debug line drawing. Accumulated lines are flushed to the GPU when it fills.
   * - .. _option-profiler_enableServer:

       ``profiler_enableServer``
     - Boolean
     - ``True``
     - Enable the embedded Tracy profiling server (flame graph visible in the editor).
   * - .. _option-profiler_enableTracing:

       ``profiler_enableTracing``
     - Boolean
     - ``True``
     - Master switch for profiler zones. When off, none of the ``profiler_trace*`` groups below are recorded. Toggled live from the editor profiler window.
   * - .. _option-profiler_traceSimulation:

       ``profiler_traceSimulation``
     - Boolean
     - ``True``
     - Record simulation (tick) zones. Only applies while ``profiler_enableTracing`` is on; toggled live from the editor profiler window.
   * - .. _option-profiler_traceVisibility:

       ``profiler_traceVisibility``
     - Boolean
     - ``True``
     - Record visibility and culling zones. Only applies while ``profiler_enableTracing`` is on; toggled live from the editor profiler window.
   * - .. _option-profiler_traceRendering:

       ``profiler_traceRendering``
     - Boolean
     - ``True``
     - Record CPU-side rendering zones. Only applies while ``profiler_enableTracing`` is on; toggled live from the editor profiler window.
   * - .. _option-profiler_traceGpuRendering:

       ``profiler_traceGpuRendering``
     - Boolean
     - ``True``
     - Record GPU rendering zones. Only applies while ``profiler_enableTracing`` is on; toggled live from the editor profiler window.
   * - .. _option-debug_fpsWindowMs:

       ``debug_fpsWindowMs``
     - Long
     - ``500``
     - Time window in milliseconds over which the FPS and frame-time statistics in the profiler window are averaged. Valid range 50 to 10000; a value outside it logs a warning and falls back to 500.
   * - .. _option-occlusion_renderDump:

       ``occlusion_renderDump``
     - Boolean
     - ``False``
     - Dump the software-rasterized depth buffer to a PPM file (debug only).
   * - .. _option-occlusion_renderDumpFrequency:

       ``occlusion_renderDumpFrequency``
     - Long
     - ``300``
     - How often (in frames) to dump the software depth buffer when dumping is enabled.
