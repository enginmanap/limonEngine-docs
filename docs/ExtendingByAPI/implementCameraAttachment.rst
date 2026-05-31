.. _implementCameraAttachment:

====================================
How to implement a camera attachment
====================================

Camera Attachment Extension is the fourth user-layer extension point. It takes full per-frame control of the camera - overriding the default first-person viewpoint with any camera behaviour you implement. It is implementable in C++ or Python and is scanned from the same user dynamic library as all other extension types.

.. note::
    Camera Attachment is the one extension point **not yet migrated** to the :ref:`unified parameter contract <GenericParameter-unified-contract>`. Unlike Triggers, Actors, Player Extensions, and RenderMethods, it does not expose ``getParameters()`` / ``setParameters()`` and therefore has no editor-exposed ``GenericParameter`` configuration. Configuration is currently passed in code (for example, through the owning Player Extension's constructor) rather than persisted and edited in the editor. Migrating it to the shared contract is planned.

Interface
=========

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Method
     - Description
   * - ``get_camera_variables``
     - Called every frame. Returns four vectors that define the camera pose: position, center (look-at point), up, and right.
   * - ``is_dirty``
     - Returns ``True`` if the camera parameters have changed since the last call to ``clear_dirty``. The engine checks this each frame to avoid redundant updates.
   * - ``clear_dirty``
     - Marks the camera parameters as clean after the engine has consumed them.

Wiring the Extension
====================

A Camera Attachment Extension is activated through the Player Extension, not directly from the editor. Override ``get_custom_camera_attachment`` in your Player Extension and return an instance of your Camera Attachment class. Return ``None`` to use the built-in first-person camera.

.. code-block:: python

    def get_custom_camera_attachment(self):
        return MyThirdPersonCamera()

Only one Camera Attachment can be active at a time. Returning a new instance from ``get_custom_camera_attachment`` replaces the current one.

Python Example
==============

The following example reads the transform of any world object and uses it as the camera position. This is the approach used by the built-in "3D object pick up" sample.

.. code-block:: python

    import limonEngine

    class ObjectFollowCamera:
        def __init__(self, api, target_object_id):
            self.api = api
            self.target_id = target_object_id
            self._dirty = True
            self._position = limonEngine.LimonTypes.Vec4(0, 0, 0, 1)
            self._center = limonEngine.LimonTypes.Vec4(0, 0, 1, 1)
            self._up = limonEngine.LimonTypes.Vec4(0, 1, 0, 0)
            self._right = limonEngine.LimonTypes.Vec4(1, 0, 0, 0)

        def get_camera_variables(self):
            matrix = self.api.getObjectTransformationMatrix(self.target_id)
            # Extract position, forward, up, right from the transform matrix
            # and populate self._position, self._center, self._up, self._right
            self._dirty = True
            return (self._position, self._center, self._up, self._right)

        def is_dirty(self):
            return self._dirty

        def clear_dirty(self):
            self._dirty = False

.. note::
    :ref:`getObjectTransformationMatrix <LimonAPI-getObjectTransformationMatrix>` (:ref:`Python <pythonApi-get_object_transformation_matrix>`) returns the full 4x4 world transform of any object. This is the recommended method for reading object transforms that drive physics or camera position - it returns the physics-authoritative matrix rather than the interpolated editor values returned by ``getObjectTransformation``.

Sample Extension
================

The engine ships with a "3D object pick up" sample implementing Camera Attachment Extension. It demonstrates:

* Reading a target object's transform each frame via :ref:`getObjectTransformationMatrix <LimonAPI-getObjectTransformationMatrix>`
* Forwarding the object's position, forward, up, and right vectors directly to the camera
* Enabling third-person, orbital, or fixed-camera behaviour without any engine modification

The sample is a good starting point for any custom camera mode. It is available as part of the bundled extension samples alongside the western theme AI actor and player controller samples.

Limitations
===========

* Camera attachment overrides the full camera pose - there is no partial-control mode.
* Perspective camera only - orthographic projection is not supported.
* The camera is attached to the player context only. A free-floating camera independent of the player is not directly supported in 0.7 (CameraObject planned).
