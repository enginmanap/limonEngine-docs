.. _CPPAPIUsage:

===================
C++ Limon API Usage
===================

Limon Engine provides an C++ API for extending and customising it to fit your game. The API has a parameter system for requesting and providing variables, and the parameters are connected to both editor and serialize/deserialize subsystem so saving and loading is handled by the engine.

LimonAPI class
##############

The LimonAPI class has all the methods available for usage. It also provides means to pass data around, namely ``LimonTypes::GenericParameter`` struct. This struct is used for both asking for and providing data. This struct is de/serialized by the engine, and editor can build graphical interfaces for it, there is no need to worry about that aspects of development.

.. _GenericParameter:

GenericParameter struct
_______________________

The struct is main means of data transfer. The serialize and deserialize methods are meant to be used by engine internals, they should be ignored for API usage purposes.

.. note::
    The value of any instance is initialized to 0.

.. _GenericParameter-unified-contract:

The Unified Parameter Contract
==============================

``LimonTypes::GenericParameter`` is the single mechanism the engine uses to handle three concerns for every extension point:

#. **Load** - reading saved configuration back from disk when a map or pipeline is loaded.
#. **Serialize** - writing the current configuration (and, where relevant, state) to disk.
#. **Edit** - building the editor interface so a level designer can change values.

Because all three concerns flow through the same struct, an extension only has to describe its parameters once. The same vector drives the editor widgets, the on-disk format, and the values handed back at runtime - there is no separate editor-binding, serializer, or loader to write.

All extension points share this contract:

.. list-table::
   :header-rows: 1
   :widths: 28 36 36

   * - Extension point
     - Where defaults come from
     - Value home (read/write)
   * - :ref:`TriggerInterface <implementAction>`
     - seeded into the ``parameters`` member in the **constructor**
     - instance ``parameters`` member, via ``getParameters()`` / ``setParameters()``
   * - :ref:`ActorInterface <implementAIActor>`
     - base ``parameters`` member (seeded in the **constructor**), or built from typed members in an overridden ``getParameters()``
     - instance ``parameters`` member by default; the actor's own typed members when overridden (the bundled actors do this)
   * - :ref:`PlayerExtensionInterface <implementPlayerExtension>`
     - seeded into the ``parameters`` member in the **constructor**
     - instance ``parameters`` member, via ``getParameters() const`` / ``setParameters()``
   * - :ref:`RenderMethodInterface <RenderingPipeline>`
     - the method's ``getParameters()``
     - persisted in both ``nodeGraph.xml`` (editor) and ``renderPipeline.xml`` (runtime)
   * - :ref:`CameraAttachment <implementCameraAttachment>`
     - not yet unified
     - not yet unified

In every case ``getParameters()`` returns one vector whose entries carry **both** a descriptor (request type, description, value type) **and** a value. There is no separate schema call. ``TriggerInterface``, ``PlayerExtensionInterface`` and ``ActorInterface`` all provide the same convenience: a protected ``parameters`` member with base ``getParameters()`` / ``setParameters()`` implementations that hold and return it directly. You seed your defaults into that member in the constructor, and the engine overwrites them through ``setParameters()`` on edit or load; that single member is then the source of truth for load, serialize, editor edits, and ``run()``. Because both methods are ``virtual``, an extension may instead keep its configuration in any form it likes - override ``getParameters()`` to convert typed members into the vector, and override ``setParameters()`` to apply values back onto them (the Actor style). Override ``setParameters()`` alone if you only need to react to a value change rather than just store it.

.. note::
    This is a change from earlier releases, where triggers returned their parameter descriptors from ``getParameters()`` each call and the engine threaded the values separately. Triggers now seed defaults in the constructor and let the base ``getParameters()`` return the stored member. A short-lived ``getParametersReference()`` accessor that existed during the transition has been removed - use ``getParameters()`` and ``setParameters()``.

.. note::
    Registered :ref:`camera attachments <implementCameraAttachment>` (``CameraExtensionInterface``) participate in this contract too - they hold the same protected ``parameters`` member and provide ``getParameters()`` / ``setParameters()``.

RequestParameterTypes Enum
==========================

Used to indicate the semantic meaning of the parameter. Editor will render interface accordingly. The *requestType* variable keeps the value.

Possible values:

* MODEL: Lists the models in the map. Uses value type LONG, sets world object ID.
* ANIMATION: Lists the custom animations loaded in the map. Uses value type LONG, sets animation index. Stale indices (animation removed after save) are detected and reset on load.
* SWITCH: Renders a checkbox. Uses value type BOOLEAN, sets whether it is ticked.
* FREE_TEXT: Renders a text input box. Uses value type STRING. Sets the entered text.
* TRIGGER: Lists the trigger volumes in the map with a selector for "First Enter", "Enter", or "Exit". Uses value type LONG_ARRAY; ``longValues[1]`` holds the trigger world object ID and ``longValues[2]`` holds the event (1=First Enter, 2=Enter, 3=Exit). Stale IDs (trigger removed after save) are detected and reset. For details see :ref:`Trigger Object Editor`.
* GUI_TEXT: Lists the GUI Text elements in the map. Uses value type LONG, sets world object ID.
* FREE_NUMBER: Renders a number input. Uses value type LONG (integer drag) or DOUBLE (decimal input box, full double precision). Set *valueType* explicitly to choose.
* COORDINATE: Renders three drag-float fields for X, Y, Z. Uses value type VEC4; the ``w`` component is not edited.
* TRANSFORM: Renders nine drag-float fields for position (X/Y/Z), rotation in degrees (X/Y/Z), and scale (X/Y/Z). Uses value type MAT4; composes and decomposes the matrix automatically.
* MULTI_SELECT: Renders a combobox. Parameters sharing the same description and MULTI_SELECT type are grouped into one combo. The first entry holds the currently selected string value; subsequent entries are the available options. Use ``LimonAPI::buildMultiSelect()`` to construct this group correctly.
* LIGHT: Lists the lights in the map. Uses value type LONG, sets world object ID. Stale IDs are detected and reset.
* SOUND: Lists the sounds in the map. Uses value type LONG, sets world object ID. Stale IDs are detected and reset.
* CAMERA_RIG: Lists the camera rigs in the map. Uses value type LONG, sets world object ID. Stale IDs are detected and reset.

ValueTypes Enum
===============

Used to determine how to handle the Value union. The *valueType* variable keeps the value. In most cases the correct value type is implied by the request type — see the list above.

Possible values:

* STRING: Used by FREE_TEXT and MULTI_SELECT.
* DOUBLE: Used by FREE_NUMBER for full-precision decimal values.
* LONG: Used by MODEL, ANIMATION, GUI_TEXT, LIGHT, SOUND, CAMERA_RIG, and FREE_NUMBER for integer values.
* LONG_ARRAY: Used by TRIGGER. ``longValues[0]`` is the count (always 3), ``longValues[1]`` is the trigger ID, ``longValues[2]`` is the event selector.
* BOOLEAN: Used by SWITCH.
* VEC4: Used by COORDINATE. Fields ``x``, ``y``, ``z`` are edited; ``w`` is left unchanged.
* MAT4: Used by TRANSFORM. Edited as decomposed position/rotation/scale and recomposed automatically.

Description String
==================

Used in editor and shown to user directly. It is also used to group MULTI_SELECT elements to build the combobox.

Value Union
===========

Union to store value set by editor or other triggers or engine itself. *value* variable keeps it.

Union variables

* char stringValue[64]
* long longValue
* long longValues[16]
* float floatValues[16]
* double doubleValue
* bool boolValue
* Vec4 vectorValue
* Mat4 matrixValue

.. note::
    For ``longValues`` and ``floatValues`` array types, the first element (index 0) stores the element count. The actual data starts at index 1, giving a maximum of 15 usable elements.

isSet
=====

Used to indicate if the variable is set or or not. If default value is considered valid then should be initialized true.

.. warning::
    If a variable is not required aka optional, this should be initialized with true, because editor doesn't allow saving a trigger with any parameter not set.