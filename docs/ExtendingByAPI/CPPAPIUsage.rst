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

* MODEL: Lists the models in the map. Uses variable type LONG, sets handle id.
* ANIMATION: Lists the custon animations loaded in the map. Uses variable type LONG, sets handle id.
* SWITCH: Renders tick box. Uses variable type BOOLEAN, sets is ticked.
* FREE_TEXT: Renders input box. Uses variable type STRING. Sets the input text.
* TRIGGER: Lists the trigger volumes in the map, and selector for "first enter", "enter", "exit". Uses variable type LONG_ARRAY, sets handle id, and selected trigger. for details refer to :ref:`Trigger Object Editor`
* GUI_TEXT: Lists the GUI Text elements in the map. Uses variable type LONG, sets handle id
* FREE_NUMBER: Renders input box for number. Uses variable type LONG. Sets the number entered.
* COORDINATE: Used to pass 3D vectors. Editor doesn't handle this type.
* TRANSFORM: Used to pass 4x4 Transformation matrix. Editor doesn't handle this type.
* MULTI_SELECT: Renders combobox. In a request, same description and multi select parameters are grouped to build the combobox. First of this group is the selected object. Selected object should be repeated at its desired position. Ex: "apple, banana, apple, grape" values will render "banana, apple, grape" combobox with apple selected.

ValueTypes Enum
===============

Used to determine how to handle Value union. *valueType* variable keeps the value.

Possible values:

* STRING
* DOUBLE
* LONG
* LONG_ARRAY
* FLOAT_ARRAY
* BOOLEAN
* VEC4
* MAT4

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