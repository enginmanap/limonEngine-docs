.. _RenderingPipeline:

==================
Rendering Pipeline
==================

The rendering pipeline in Limon is fully configurable through a node-based visual editor. The engine ships with forward and deferred pipeline configurations, but any custom pipeline can be built and loaded at runtime without modifying engine source.

Three types of developer benefit from this system:

* **Optimisation-focused** -improve performance by adjusting pass ordering, culling parameters, and LOD settings without touching engine code.
* **Custom rendering** -add post-processing effects, custom shaders, or a completely different shading model, with real-time preview in the editor.
* **Learning** -isolate individual rendering stages to experiment with GPU programming in a live scene.

The author switched the engine to deferred rendering in under a day using this system.

Pipeline Editor
===============

The pipeline editor is accessible from within the editor UI. Every available GLSL shader program is discovered automatically via runtime reflection and appears as a node type. Nodes are wired together to define how GPU resources flow between passes. The compiled pipeline is a runtime object executed every frame -the visual graph and the runtime object are always consistent.

.. figure:: _static/media/images/editor-pipeline-Node-Editor.png
    :align: center

    The pipeline node editor with shader nodes wired together.

.. figure:: _static/media/images/editor-pipeline_editor_open.png
    :align: center

    Opening the pipeline editor from within the editor UI.

.. figure:: _static/media/images/editor-pipeline_editor_open.png
    :align: center

    When the renderMethod has parameters to configure, they are exposed on the node.
.. figure:: _static/media/images/editor-pipeline-rendermethod-parameters.png
    :align: center

Nodes and Wiring
----------------

Each node represents a rendering pass. Inputs and outputs on each node are discovered automatically from the shader source via reflection -no manual registration required. Outputs from one node connect to inputs of another to define GPU resource flow.

The **Screen node** is the terminal -the final colour output must be wired to it.

Each node has two configuration fields beyond wiring:

* **RenderMethod** -selects which RenderMethod renders geometry through this shader pass. See `RenderMethod Extension Point`_ below.
* **Camera name** -names which camera's culling results this pass uses. Multiple cameras with independent culling results are supported.

When the selected RenderMethod exposes configurable parameters, those parameter widgets appear on the node directly beneath the RenderMethod field. The values are saved with the node graph and the runtime pipeline -see `RenderMethod Extension Point`_ below.

The pipeline editor performs **automatic stage reordering** at compile time -passes are ordered for correctness based on their dependency graph.

Built-in Pipeline Configurations
---------------------------------

Two configurations ship with the engine:

* **Forward** -single-pass geometry rendering with direct lighting. Lower memory usage.
* **Deferred** -geometry and lighting decoupled across passes. Scales better with many lights.

A custom pipeline can be loaded at runtime from a file (:ref:`C++ <LimonAPI-changeRenderPipeline>` | :ref:`Python <pythonApi-change_render_pipeline>`)::

    changeRenderPipeline(pipelineFileName)

.. figure:: _static/media/images/editor-pipeline-editor-deferred.png
    :align: center

    The deferred pipeline with all nodes and wiring visible.

Filtering Pipeline
==================

Each rendering pass applies four sequential visibility filters. With multiple cameras in the pipeline (player camera, shadow map cameras), each camera runs its culling workload on a separate thread concurrently.

1. **Tag filtering** -each camera and each scene object carries a tag. The pass specifies which camera tags render which object tags. Tags are converted to 64-bit hashes at pipeline load for zero-cost matching at runtime.

2. **Frustum culling** -objects outside the camera's view volume are discarded. Point lights use sphere-based culling rather than frustum culling -a point light illuminates in all directions, and a frustum test would incorrectly cull lights behind the camera that still illuminate visible geometry.

3. **Occlusion culling** -a SIMD software depth buffer on the CPU. Objects above a configurable size threshold act as occluders; smaller objects are tested against the depth buffer. See `SIMD Software Occlusion Culling`_ below.

4. **LOD selection** -each object uses the coarsest level whose switch distance it is past. See `Level of Detail`_ below.

.. _Tagging:

Tagging
-------

Every model carries a list of tags, and every render stage lists the object tags it renders. A model is rendered by a stage if **any** of its tags appears in that stage's list. A model tagged ``basic_model_object,static_model_object`` is drawn both by a stage that asks for ``basic_model_object`` and by one that asks for ``static_model_object``.

The engine sets these tags itself:

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Tag
     - Set on
   * - ``basic_model_object``
     - Models that are not animated, not transparent and have no ambient map.
   * - ``animated_model_object``
     - Animated models without an ambient map.
   * - ``transparent_model_object``
     - Transparent models.
   * - ``ambient_model_object``
     - Models with an ambient map in any mesh.
   * - ``static_model_object``, ``physical_model_object``
     - Models with mass 0, and models with mass above 0.
   * - ``basic_player_attachment``, ``animated_player_attachment``, ``transparent_player_attachment``
     - Models attached to the player, directly or through other objects. Each one follows the matching ``*_model_object`` tag, so a model without ``basic_model_object`` doesn't get ``basic_player_attachment`` either. Added on attach, removed on detach.
   * - ``picked_object``
     - The object selected in the editor. Not saved with the map.

Cameras carry tags too, and a stage's camera tags select which cameras it renders for: ``player_camera``, ``directional_camera`` and ``point_camera``.

Any tag can be added, and the engine-set ones can be removed, both from the editor and at runtime through the API (:ref:`addObjectTag<LimonAPI-addObjectTag>`, :ref:`removeObjectTag<LimonAPI-removeObjectTag>`, :ref:`getObjectTags<LimonAPI-getObjectTags>`). A custom tag and a stage that asks for it is how a game gives a category of objects its own shader or its own pass.

* A model with no tags would be rendered by no stage, so removing the last tag puts the engine-set ones back.
* Changing the mass between 0 and a positive value swaps ``static_model_object`` and ``physical_model_object``, but only if the model still has one of them.
* A tag change made from game code (triggers, actors, Python) is used by the same frame's rendering.
* Tags are saved with the map, so engine-set tags you removed stay removed. Once saved, the engine no longer re-derives them, so if a model's asset later becomes animated or transparent, update its tags by hand.

Built-in Shaders
================

The following shader programs ship with the engine and appear as node types in the pipeline editor. Custom shaders placed in the shader directory are discovered automatically via the same reflection.

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Shader
     - Description
   * - **Directional shadow map generation**
     - Cascaded shadow map generation for directional lights.
   * - **Point shadow map generation**
     - Cube map shadow generation for point lights.
   * - **Static model**
     - Standard mesh render pass.
   * - **GPU skinning model**
     - Skeletal mesh render pass with GPU-side skinning.
   * - **Transparent model pass**
     - Alpha-blended geometry pass.
   * - **SSAO generation**
     - Screen-space ambient occlusion -implemented as a sample custom RenderMethod.
   * - **SSAO blur**
     - Depth-aware blur for SSAO output.
   * - **Combine shading**
     - Composites lighting contributions across passes.
   * - **GUI**
     - Renders GUI elements.
   * - **Editor**
     - Renders editor overlays.
   * - **Sky**
     - Skybox render pass.

RenderMethod Extension Point
============================

RenderMethod is the fifth user-layer extension point. It is a custom GPU rendering primitive instantiated and wired in the pipeline editor. Like all five extension types, it is scanned from the user dynamic library at engine launch.

.. list-table::
   :header-rows: 1
   :widths: 22 78

   * - Method
     - Description
   * - ``getName``
     - Returns the method name for the editor dropdown.
   * - ``getParameters``
     - Pure virtual. Returns the method's ``GenericParameter`` list - each entry carrying both its descriptor (request type, description, value type) and its value. Drives both the editor widgets and persistence.
   * - ``initRender``
     - Called at pipeline load. Receives the GPU program and the configured GenericParameter list. Set up GPU resources here.
   * - ``renderFrame``
     - Called each frame. Receives the GPU program pointer.
   * - ``cleanupRender``
     - Tears down GPU resources on pipeline unload or reconfiguration. Receives the GPU program and the GenericParameter list.

The ``GenericParameter`` list returned from ``getParameters()`` automatically appears as editable fields on the shader node in the pipeline editor -no separate editor code required. RenderMethod is part of the :ref:`unified parameter contract <GenericParameter-unified-contract>`, with one difference from the other extension points: its configured values are persisted in **two** places.

* **nodeGraph.xml** - the editor's node graph. The values you set on the node are saved here so they survive editing sessions and reopen with the node.
* **renderPipeline.xml** - the runtime pipeline. The values are also written here so the compiled pipeline can apply them when it runs, independently of the editor graph.

Both persistence points use the same ``<Parameter>`` element format as the rest of the engine, so a RenderMethod's configuration round-trips through the editor and the runtime identically.

Two built-in RenderMethods ship with the engine:

* **Render By Tag** -the primary RenderMethod for all 3D geometry. Uses a named camera's culling results and a tag filter. Used by static model, GPU skinning model, and transparent pass nodes.
* **Quad Renderer** -convenience RenderMethod for post-processing passes. Full-screen quad, no geometry iteration.

**SSAO ships as a sample RenderMethod**, demonstrating GenericParameter configuration (sample count) and full-screen post-processing. It is a good starting point for custom effects. The source is under ``samples/`` as `SSAOKernelRenderMethod <https://github.com/enginmanap/limonEngine/blob/master/samples/SSAOKernelRenderMethod.cpp>`_.

Materials and the Pipeline
==========================

All materials are uploaded to the GPU as a Uniform Buffer Object (UBO). A material index is passed per instance as part of instanced rendering data. Any shader that declares the material UBO is automatically detected via reflection - no registration required. Custom pipeline shaders receive the full material array by declaring the UBO.

For how materials are created, edited, and managed see :ref:`UsingBuiltinEditor` and :ref:`AssetManagement`.

Performance Systems
===================

Targeting integrated GPU hardware motivates a significant CPU-side visibility investment. Draw call overhead is more expensive on iGPU than on discrete GPU -reducing the objects submitted for rendering produces a larger framerate gain than the same reduction would on dedicated hardware. All culling systems run multithreaded, with each camera's workload on a separate thread.

SIMD Software Occlusion Culling
--------------------------------

A software depth buffer produces per-camera visibility results consumed by Render By Tag passes.

* Depth buffer based, AABB occludee testing
* Default resolution 512x256 -must be a multiple of 8 for SIMD alignment, configurable
* SSE4.1 on x86, NEON on AArch64 -covers Apple Silicon and Raspberry Pi 4/5
* A debug AABB wireframe picture-in-picture overlay is available in the editor

Occluders are **baked**: the mesh is compressed into quads once, at load, and that blob is rasterized every frame instead of the triangle list. Which LOD is baked is set by :ref:`occlusion_bakeLodLevel <option-occlusion_bakeLodLevel>`. A ``limonmodel`` stores a bake for every level, so the option can be changed without re-exporting; a model loaded from a source file only carries the level it was loaded with, and any other level falls back to submitting the raw mesh.

Animated models never act as occluders. Their occluder would need the node transform and the current pose, neither of which is available where occluders are submitted, so they are only ever tested as occludees.

.. _LevelOfDetail:

Level of Detail
---------------

LOD levels are generated automatically with meshoptimizer. A project defines a list of levels, each with a **distance** and **five pixel limits**; by default three levels at 50, 100 and 200 meters, plus the original mesh. The distance is where the level is used, and the limits say how different it may look from the original when seen from there.

**How a level is generated**

Each level is the coarsest simplification that passes all five of its limits. To find it, the engine renders the candidate and the original on the CPU from 14 directions, at twice the size the model would have on screen at that distance, and compares them:

* **Surface** -how far the visible surface moved. A texture sliding a few texels counts here too.
* **Outline** -how far the silhouette moved.
* **Holes** -the widest place where something behind now shows through.
* **Texture** -the widest place where the UV jumped to another part of the texture.
* **Normal** -the widest place whose shading changed by more than :ref:`LOD_normalDeviation <option-LOD_normalDeviation>`.

All five are in pixels of a reference screen, :ref:`LOD_referenceHeight <option-LOD_referenceHeight>` tall with a :ref:`LOD_referenceFov <option-LOD_referenceFov>` field of view, not the screen of the machine doing the work. The default is a low-end 1080p screen, so the same levels are produced on every machine. Albedo is never compared, because materials can be edited after the levels are made, and the check never uses the GPU, because render pipelines are user defined.

The triangle count is therefore a result, not a setting. The defaults are tuned so a typical map keeps about 80%, 60% and 40% of its triangles at the three levels; :ref:`LOD_levelTriangleTargets <option-LOD_levelTriangleTargets>` holds those numbers, but they are only shown in the editor for comparison. A level is not built when even the smallest simplification breaks a limit at its distance, or when it saves less than 5% of the triangles over the level before it.

Simplification is attribute aware: normals and UVs take part in the error metric, and vertices where UVs differ at a shared position are protected, so texture and palette seams survive.

**Shadow levels**

From :ref:`LOD_shadowWeldedFromLevel <option-LOD_shadowWeldedFromLevel>` on, each level also gets a **welded** copy for shadow cameras. Welding merges vertices by position and drops normals and UVs, which a depth-only pass never reads, and simplifies about three times further at the coarse end. These copies are checked on surface, outline and holes only, and only cameras that aren't the player camera can use them. Turn them off with :ref:`LOD_shadowWeldedLevels <option-LOD_shadowWeldedLevels>`.

**Animated models**

A skinned mesh deforms, so a render of its bind pose says nothing about how a level will look. Animated models are never measured; their levels are built straight to the :ref:`LOD_levelTriangleTargets <option-LOD_levelTriangleTargets>` shares.

**Load time and caching**

Generating the levels is expensive: each search step renders the model from 14 directions, and a large map can take several minutes on its first load. The results are cached, so later loads take seconds:

* For a source asset (OBJ, FBX, ...), in a ``.limon`` sidecar file next to it -see :ref:`LodSidecar`.
* For a ``limonmodel``, inside the file itself.

A level is regenerated only when what was asked of it changes. Changing one level's distance or limits rebuilds that level only. Changing :ref:`LOD_referenceHeight <option-LOD_referenceHeight>`, :ref:`LOD_referenceFov <option-LOD_referenceFov>`, :ref:`LOD_normalDeviation <option-LOD_normalDeviation>`, :ref:`LOD_calibrationMaxResolution <option-LOD_calibrationMaxResolution>`, :ref:`LOD_calibrateSearchSteps <option-LOD_calibrateSearchSteps>` or the shadow level options rebuilds every level of every source model.

With :ref:`LOD_calibrate <option-LOD_calibrate>` off, nothing is generated: models use the levels their sidecar or ``limonmodel`` already holds, otherwise only the original. Generate the levels on a desktop machine and ship the sidecars or ``limonmodel`` files; slower targets such as the Raspberry Pi should run with calibration off.

**How a level is selected**

* Selection is by distance from the player. Every distance is multiplied by the instance's scale (its largest axis), so a model scaled up twice switches twice as far away.
* :ref:`LOD_switchHysteresis <option-LOD_switchHysteresis>` adds a dead band around every switch distance, so an object standing on a threshold doesn't flip every frame.
* Shadow cameras select the same way. A point light also considers its own distance: an object next to the light gets its fine level in that shadow map even when the player is far away. Directional cascades follow the player.
* :ref:`LOD_forceLevel <option-LOD_forceLevel>` forces one level everywhere, for inspection.

**Per model settings**

The levels are configured for the whole project by the ``LOD_level*`` options. A single model can take over its own levels from the model editor, see :ref:`LOD levels in the model editor <LodLevelsEditor>`. Aggressive limits can produce visible pop-in while moving; the editor preview is the place to judge a level before it is used in the map.

Size-Based Render Skipping
--------------------------

Objects below a projected screen-space size threshold are skipped entirely -not submitted for rendering. This is a binary skip, independent from LOD. The threshold is an engine-wide option.

Lighting
--------

* Directional light with cascaded shadow maps. Each cascade uses a tight-fitting, texel-snapped orthographic view derived from the player view frustum and the :ref:`shadow_cascadeLimitList <option-shadow_cascadeLimitList>` boundaries -no manual projection extents required. :ref:`shadow_directionalProjectionBackOff <option-shadow_directionalProjectionBackOff>` controls how far behind the camera the light origin is pulled to capture shadow casters behind the player. Staggered cascade rendering is optional (~10% performance gain).
* Point lights with cube map shadow casting. A point light is shaped by Intensity, Radius, Falloff, Edge Brightness and a constrained Constant/Linear/Exponential curve, and reaches exactly zero at its radius - that radius is also its culling distance and shadow depth range. See :ref:`Light Object Settings`.
* Ambient lighting, per light. It is never shadowed. A point light's ambient falls off with distance and reaches zero at its radius; a directional light's reaches the whole world evenly.
* Lights are creatable and removable at runtime via :ref:`addLightPoint <LimonAPI-addLightPoint>` / :ref:`addLightDirectional <LimonAPI-addLightDirectional>` / :ref:`removeLight <LimonAPI-removeLight>` (:ref:`Python: add_light_point <pythonApi-add_light_point>` / :ref:`add_light_directional <pythonApi-add_light_directional>` / :ref:`remove_light <pythonApi-remove_light>`). Only one directional light can exist; a second one is rejected.
* No global illumination -direct lighting with shadow maps only.

Configuration Reference
=======================

Rendering is configured through engine options; :ref:`OptionsReference` is the canonical list with types, defaults and descriptions. The options that affect rendering are:

* **Backend and pipeline** - :ref:`render_backend <option-render_backend>`, :ref:`render_pipeline <option-render_pipeline>`, :ref:`render_textureFiltering <option-render_textureFiltering>`
* **Display** - :ref:`display_width <option-display_width>`, :ref:`display_height <option-display_height>`, :ref:`display_fullScreen <option-display_fullScreen>`
* **Lights and shadows** - :ref:`performance_maximumLights <option-performance_maximumLights>`, :ref:`shadow_mapDirectionalSize <option-shadow_mapDirectionalSize>`, :ref:`shadow_mapPointWidth <option-shadow_mapPointWidth>`, :ref:`shadow_mapPointHeight <option-shadow_mapPointHeight>`, :ref:`shadow_directionalSampleCount <option-shadow_directionalSampleCount>`, :ref:`shadow_pointSampleCount <option-shadow_pointSampleCount>`, :ref:`shadow_cascadeCount <option-shadow_cascadeCount>`, :ref:`shadow_cascadeLimitList <option-shadow_cascadeLimitList>`, :ref:`shadow_cascadeStaggerIntervals <option-shadow_cascadeStaggerIntervals>`, :ref:`shadow_cascadeStaggerOffsets <option-shadow_cascadeStaggerOffsets>`, :ref:`shadow_directionalProjectionBackOff <option-shadow_directionalProjectionBackOff>`, :ref:`shadow_pointNearPlane <option-shadow_pointNearPlane>`, :ref:`shadow_pointFarPlane <option-shadow_pointFarPlane>`
* **SSAO** - :ref:`ssao_width <option-ssao_width>`, :ref:`ssao_height <option-ssao_height>`, :ref:`ssao_sampleCount <option-ssao_sampleCount>`, :ref:`ssao_blurRadius <option-ssao_blurRadius>`
* **Culling and LOD** - :ref:`performance_multiThreadedCulling <option-performance_multiThreadedCulling>`, :ref:`LOD_levelDistances <option-LOD_levelDistances>`, :ref:`LOD_calibrate <option-LOD_calibrate>`, :ref:`LOD_switchHysteresis <option-LOD_switchHysteresis>`, :ref:`LOD_forceLevel <option-LOD_forceLevel>`, :ref:`LOD_skipRenderDistance <option-LOD_skipRenderDistance>`, :ref:`LOD_skipRenderSize <option-LOD_skipRenderSize>`, :ref:`LOD_maxSkipRenderSize <option-LOD_maxSkipRenderSize>`, :ref:`SplitModelToMeshCount <option-SplitModelToMeshCount>`
* **Software occlusion** - :ref:`occlusion_enabled <option-occlusion_enabled>`, :ref:`occlusion_renderWidth <option-occlusion_renderWidth>`, :ref:`occlusion_renderHeight <option-occlusion_renderHeight>`, :ref:`occlusion_occluderSizePerspective <option-occlusion_occluderSizePerspective>`, :ref:`occlusion_occluderSizeOrthographic <option-occlusion_occluderSizeOrthographic>`, :ref:`occlusion_bakeLodLevel <option-occlusion_bakeLodLevel>`, :ref:`occlusion_renderDump <option-occlusion_renderDump>`, :ref:`occlusion_renderDumpFrequency <option-occlusion_renderDumpFrequency>`
* **Debugging** - :ref:`debug_renderInformations <option-debug_renderInformations>`, :ref:`debug_drawLines <option-debug_drawLines>`, :ref:`debug_drawBufferSize <option-debug_drawBufferSize>`, :ref:`profiler_enableServer <option-profiler_enableServer>`


Further Reading
===============

* `New Render System -overview and motivation <https://limonengine.com/technical/2026/03/23/New-Render-System.html>`_
* `Render Pipeline How-To -filtering and culling internals <https://limonengine.com/technical/2026/03/24/Render-system-how-to.html>`_
