.. _implementCameraAttachment:

==============================
How to implement a camera rig
==============================

A **camera rig** is the extension point for camera behaviour. It takes full per-frame control of the
player camera - overriding the default first-person viewpoint with any camera behaviour you implement:
third-person, isometric, top-down, orbital, fixed security camera, and so on. It supports **both
perspective and orthographic projection**, is configurable through the same ``GenericParameter`` contract
as every other extension point, and is edited and activated as a first-class scene object in the editor.

.. note::
   Camera rigs are registered extensions (like Triggers and Actors) and live as ``CameraRig`` objects in the
   scene. They replace the older mechanism of a Player Extension handing the engine a plain camera
   attachment, which has been removed.

The model: behaviour + object
=============================

A camera rig is two pieces that work together:

* **The behaviour** - a ``CameraExtensionInterface`` you implement in C++ **or Python** (see
  `Python cameras`_). This is the registered, configurable part: it produces the camera pose and declares
  the projection.
* **The object** - an engine-side ``CameraRig`` that *owns* your behaviour. It is a normal scene object
  (it has a transform, a world id, a tree node, and is saved in the world file). The engine provides this;
  you do not implement it.

This split is deliberate. Your behaviour cannot subclass an engine scene object across the plugin boundary,
so the engine wraps it in a ``CameraRig`` for you. Following a world object then uses the engine's standard
attachment system (see `Following an object`_) rather than anything camera-specific.

Many camera rigs may exist in a world, but **only one is active at a time**. When no rig is active, the
player drives its own built-in camera - so deactivating a rig always falls back to the first-person view.

Interface
=========

.. list-table::
   :header-rows: 1
   :widths: 32 68

   * - Method
     - Description
   * - ``getName``
     - Returns the registered type name of this rig (the name it is registered under, shown in the editor).
   * - ``getParameters`` / ``setParameters``
     - The :ref:`unified parameter contract <GenericParameter-unified-contract>`. ``getParameters`` advertises
       the editable fields (and is what gets saved); ``setParameters`` applies edited/loaded values. This is
       how the editor renders the rig's configuration and how it round-trips through the world file.
   * - ``getCameraVariables``
     - Called every frame. Returns four vectors that define the camera pose: position, center (look-at
       direction), up, and right.
   * - ``getProjection``
     - **Required.** Returns the :ref:`projection <camerarig-projection>` the engine should build for this
       camera - perspective or orthographic, plus the near/far planes and field-of-view or orthographic
       half-height.
   * - ``isDirty`` / ``clearDirty``
     - ``isDirty`` returns ``true`` when the pose has changed since the last frame; ``clearDirty`` marks it
       consumed. A follow camera typically returns ``true`` every frame.
   * - ``setAttachmentTransform``
     - Optional. When the rig's ``CameraRig`` is attached to a world object, the engine calls this each frame
       *before* ``getCameraVariables`` with the target's world transform, already decomposed into position,
       orientation, and scale (so no rig ever decomposes a matrix per frame). When the rig is unattached,
       this is never called and the rig produces its own pose.

.. _camerarig-projection:

Projection: perspective or orthographic
=======================================

The engine selects the player camera type purely from ``getProjection().type``. Returning ``ORTHOGRAPHIC``
is the *only* thing that makes a camera orthographic; everything else (pose, following, configuration) is
identical to a perspective rig.

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Field
     - Meaning
   * - ``type``
     - ``PERSPECTIVE`` or ``ORTHOGRAPHIC``.
   * - ``verticalFieldOfView``
     - Perspective only. Vertical FoV in radians.
   * - ``orthographicHalfHeight``
     - Orthographic only. Half the vertical span of the view volume in world units (this is the zoom -
       smaller is more zoomed in). The horizontal span follows the screen aspect ratio.
   * - ``nearPlane`` / ``farPlane``
     - Depth range. Orthographic has uniform depth precision, so a wide range is cheap.

.. important::
   Camera type is fully decoupled from the render pipeline. Switching a camera between perspective and
   orthographic at runtime keeps the same cascaded shadow maps and the same render stages - you never have
   to change the pipeline when you change the camera. Aspect ratio is supplied by the engine, so it is not
   part of the projection parameters.

Following an object
===================

To make a rig follow a world object, attach its ``CameraRig`` to that object using the standard object
attachment workflow (the same one used for models, sounds, and lights): select the camera rig, choose
"Attach this object to another", then pick the target. There is no camera-specific "target id" - following
is just attachment.

Each frame, the engine resolves the attached object's (or bone's) world transform and feeds it to your
behaviour through ``setAttachmentTransform`` before reading the pose. Your ``getCameraVariables`` then
composes your local offset and any custom behaviour (smoothing, collision pushback, look-ahead) on top of
that engine-provided parent transform. An *unattached* rig produces its own pose instead - for example, a
rig that follows the player by querying ``getPlayerPosition`` through the API.

Registering a rig (C++)
=======================

Camera rigs are discovered from the same user dynamic library as every other extension type, through the
``registerCameraExtensions`` entry point:

.. code-block:: cpp

   extern "C" void registerCameraExtensions(
           std::map<std::string, CameraExtensionInterface*(*)(LimonAPI*)>* cameraExtensionMap) {
       (*cameraExtensionMap)["ObjectAttachedCameraRig"] = &createCameraExtension<ObjectAttachedCameraRig>;
       (*cameraExtensionMap)["OrthographicCameraRig"]   = &createCameraExtension<OrthographicCameraRig>;
   }

Using a rig in the editor
=========================

Camera rigs are ordinary scene objects, so they are created, edited, and activated like any other object.

**1. Add a rig.** In the main editor panel, open **Add Camera Rig**, pick a registered rig type, and add it.

.. figure:: ##ENGIN_SS
   :alt: The Add Camera Rig panel

   The **Add Camera Rig** panel: choose a registered rig type and add it to the scene.

**2. Edit it.** The new rig appears in the object tree under **Cameras**. Select it to open its properties:
its parameters (rendered from ``get_parameters``) are edited live - changes take effect immediately while
playing - and an **Activate / Deactivate** button binds it to (or releases it from) the player camera.

.. figure:: ##ENGIN_SS
   :alt: A camera rig selected in the Cameras tree with its properties

   A camera rig under the **Cameras** tree node, showing its editable parameters and the Activate button.

**3. (Optional) Attach it.** To make it follow an object, attach the rig to that object using the standard
attach controls.

**4. See it.** With an orthographic rig active, the scene renders through the orthographic projection.

.. figure:: ##ENGIN_SS
   :alt: The scene rendered through an active orthographic camera rig

   The same scene viewed through an active orthographic camera rig.

Saving the world persists the rig (and which one is active) as a ``<CameraRig>`` block; loading recreates it.

Activating a rig from gameplay
==============================

Camera rigs can also be created and switched at runtime from any extension (a Trigger, Player Extension,
script, ...) through three ``LimonAPI`` methods. **Create and activate are separate operations** - activation
works on any rig, whether it was created through the API or placed in the editor:

.. list-table::
   :header-rows: 1
   :widths: 42 58

   * - Method
     - Description
   * - ``createCameraRig(typeName)`` → id
     - Instantiate a registered rig type and add it to the world as a (non-active) scene object. Returns its
       new world object id, or ``0`` if the type is unknown.
   * - ``activateCameraRig(id)`` → bool
     - Make the rig with this world object id drive the player camera. Returns ``false`` if no rig has that id.
   * - ``deactivateCameraRig()``
     - Revert to the player's own (built-in) camera.

.. code-block:: cpp

    // e.g. switch to a third-person camera when the player picks up a vehicle
    uint32_t rigId = limonAPI->createCameraRig("ThirdPersonCameraRig");
    if (rigId != 0) {
        limonAPI->activateCameraRig(rigId);
    }

(Python: ``create_camera_rig`` / ``activate_camera_rig`` / ``deactivate_camera_rig``.)

Samples
=======

The engine ships these camera rigs under ``samples/``:

* `ObjectAttachedCameraRig <https://github.com/enginmanap/limonEngine/blob/master/samples/ObjectAttachedCameraRig.h>`_
  - a perspective follow camera. It composes a local offset on top of the transform of whatever object its
  ``CameraRig`` is attached to, and looks at that object. Parameters: the local offset X/Y/Z.
* `OrthographicCameraRig <https://github.com/enginmanap/limonEngine/blob/master/samples/OrthographicCameraRig.h>`_
  - an isometric / top-down orthographic camera that follows the player (via ``getPlayerPosition``, so it is
  unattached). Parameters: offset X/Y/Z, zoom (orthographic half height), and near / far planes. A good
  starting point for any orthographic view.
* `ThirdPersonCameraRig <https://github.com/enginmanap/limonEngine/blob/master/samples/ThirdPersonCameraRig.h>`_
  - a perspective third-person follow camera with collision-aware pullback (raycasts toward the desired
  position and pulls in if a wall is in the way). The ``CowboyShooterExtension`` sample activates it at
  runtime through ``createCameraRig`` / ``activateCameraRig``.

Python cameras
==============

Camera rigs have full Python parity. Subclass ``camera_extension_interface.CameraExtensionInterface`` in a
script under ``Engine/Scripts`` or ``Data/Scripts``, and the engine auto-discovers it **by class name** -
exactly like Python Triggers, Actors, and Player Extensions. The rig then appears in the editor's **Cameras**
tree, is configurable through ``get_parameters`` / ``set_parameters``, supports orthographic projection, and
follows objects through the attachment system, identical to a C++ rig.

The Python method names are the snake_case equivalents (``get_name``, ``get_parameters`` /
``set_parameters``, ``get_camera_variables`` - which fills the four vectors it is handed - ``get_projection``,
``is_dirty`` / ``clear_dirty``, ``set_attachment_transform``). A sample ships as
``python_orthographic_camera_rig.py`` under ``Engine/Scripts/``.

Relationship to the player
==========================

The player is no longer a camera itself. Each player owns a default camera attachment that it feeds its own
eye pose to; that default is what you see when no rig is active. Activating a camera rig overrides it, and
deactivating restores it - this is why the player's own camera is always the backup.
