.. _PythonAPIUsage:

======================
Python Limon API Usage
======================

Limon Engine exposes the same extension API to Python that it does to C++. Python extensions are built on `pybind11 <https://github.com/pybind/pybind11>`_ and have full parity with the C++ API - the same :ref:`GenericParameter contract <GenericParameter-unified-contract>`, the same enums, and automatic type conversion. This page covers how Python scripting is wired up: where scripts live, how the engine discovers them, and the conventions an extension must follow. For the method-by-method API listing see the :ref:`Python API reference <pythonApi>`; for the per-extension-point how-tos see :ref:`implementAction`, :ref:`implementPlayerExtension`, :ref:`implementAIActor`, and :ref:`implementCameraAttachment`.

.. note::
    Python and C++ extensions are not mutually exclusive. A C++ Action and a Python Player Extension can run in the same world; they share the same engine API instance but execute in separate contexts. See :ref:`Multi-Interpreter Python <APIFundamentals>`.

Where scripts live
==================

Scripts are loaded from two directories, following the engine-wide convention that ``Engine/`` holds built-ins and ``Data/`` holds user content:

* ``./Engine/Scripts`` - **built-in**: the base interface classes, helper types, and the bundled samples. Treat this as engine-owned; don't put your game's scripts here.
* ``./Data/Scripts`` - **your scripts**: drop your own extension ``.py`` files here. This directory is optional - if it doesn't exist it's simply skipped.

.. code-block:: text

    Engine/Scripts/                      # built-in (engine-owned)
        __init__.py                      # package marker (not loaded as a script)
        trigger_interface.py             # base class
        actor_interface.py               # base class
        camera_extension_interface.py    # base class
        player_extension_interface.py    # base class
        generic_parameter.py             # helper type
        vec3.py                          # helper type
        limonimp.py                      # sample trigger (MyTrigger)
        simple_guard_actor.py            # sample actor (SimpleGuardActor)
        python_orthographic_camera_rig.py  # sample camera attachment (PythonOrthographicCameraRig)
        python_player_extension.py       # sample player extension (PythonPlayerExtension)

    Data/Scripts/                        # your game's scripts go here
        my_trigger.py
        my_actor.py

Both directories are on the Python import path (``Engine/Scripts`` first), so a script in ``Data/Scripts`` can freely import the built-in base classes and helpers - ``from trigger_interface import TriggerInterface`` works from either location.

.. warning::
    Don't give a user script the same filename as a built-in module (``trigger_interface.py``, ``actor_interface.py``, ``camera_extension_interface.py``, ``player_extension_interface.py``, ``generic_parameter.py``, ``vec3.py``). Python resolves a module name to the built-in copy (it is first on the path), so a same-named file in ``Data/Scripts`` is skipped with a warning and never loads. Pick a distinct filename.

How discovery works
===================

When a world is loaded, the engine creates an isolated Python sub-interpreter for it and scans both script directories (``./Engine/Scripts`` then ``./Data/Scripts``). Every ``.py`` file **except** ``__init__.py`` is imported as a module, and each top-level class in that module is inspected:

* A class that subclasses **TriggerInterface** is registered as an :ref:`Action <implementAction>`.
* A class that subclasses **PlayerExtensionInterface** is registered as a :ref:`Player Extension <implementPlayerExtension>`.
* A class that subclasses **ActorInterface** is registered as an :ref:`AI Actor <implementAIActor>`.
* A class that subclasses **CameraExtensionInterface** is registered as a :ref:`Camera Attachment <implementCameraAttachment>`.

Registration is automatic - there is no Python equivalent of the C++ ``registerAsTrigger`` entry point. The name the extension is registered under, and the name a map designer picks from in the editor, is the **Python class name** itself.

.. note::
    Registered camera *attachments* (``CameraExtensionInterface``) are auto-discovered the same way - a class subclassing it is registered as a :ref:`Camera Attachment <implementCameraAttachment>`.

.. warning::
    Because every class in every module is inspected, keep one extension class per file (the samples follow this convention). Helper classes that do **not** subclass one of the extension interfaces are ignored, so they are safe to keep alongside.

The ``limon`` module and the base classes
=========================================

Inside each sub-interpreter the engine injects a built-in ``limon`` module. It exposes value types and enums you use at runtime (``Vec4``, ``Inputs``, ``LogSubsystem``, and so on); the ``LimonAPI`` instance is handed to your extension's constructor as ``limon_api``.

Your extension class must subclass the matching **pure-Python base class** shipped in ``Engine/Scripts``:

.. code-block:: python

    from trigger_interface import TriggerInterface
    class MyTrigger(TriggerInterface):
        ...

    from player_extension_interface import PlayerExtensionInterface
    class MyExtension(PlayerExtensionInterface):
        ...

Discovery matches by **class identity** against these base classes (``TriggerInterface`` in ``trigger_interface.py``, ``PlayerExtensionInterface`` in ``player_extension_interface.py``, ``ActorInterface`` in ``actor_interface.py``).

.. warning::
    Do not use ``dir(limon)`` to discover extension base classes. The ``limon`` module exposes internal C++ binding types such as ``limon.TriggerInterface`` that are not intended for user extension — subclassing them will silently fail to register, and can trigger an interpreter-shutdown crash. Only use the documented pure-Python base classes from ``Engine/Scripts``. You still ``import limon`` when you need its value types and enums.

Required methods per extension type
===================================

The engine calls a fixed set of methods on each extension instance. The base classes in ``Engine/Scripts`` document the full contract of each method in their docstrings; the minimum set the engine expects is:

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Extension type
     - Methods the engine calls
   * - ``TriggerInterface``
     - ``get_name``, ``get_parameters``, ``set_parameters``, ``run``, ``get_results``
   * - ``PlayerExtensionInterface``
     - ``get_name``, ``process_input``, ``interact``
   * - ``ActorInterface``
     - ``get_name``, ``play``, ``interaction``, ``get_parameters``, ``set_parameters``
   * - ``CameraExtensionInterface``
     - ``get_name``, ``get_parameters``, ``set_parameters``, ``get_camera_variables``, ``get_projection``, ``is_dirty``, ``clear_dirty``, ``set_attachment_transform``

All method names are ``snake_case`` to match the Python API binding. See :ref:`implementCameraAttachment` for camera attachments.

Parameters
==========

Python extensions use the same :ref:`unified parameter contract <GenericParameter-unified-contract>` as C++. ``get_parameters`` returns a list of :ref:`GenericParameter <pythonApi>` objects - each carrying both its descriptor (request type, description, value type) and its value - and ``set_parameters`` receives the edited or loaded values back. The defaults you return from ``get_parameters`` at construction are what the editor shows; the configured values are persisted with the map and editable in the editor exactly as for C++ extensions.

The ``RequestParameterType`` and ``ValueType`` enums and the ``GenericParameter`` and ``Vec3`` helper types are documented in the :ref:`Python API reference <pythonApi>`.

World-scoped interpreters
=========================

Each world gets its own Python sub-interpreter, so scripts in one world cannot access or interfere with scripts in another. When a world is unloaded its interpreter is torn down and any module-level state is released; when a world is loaded a fresh interpreter starts. Scripts do not carry state across world loads unless they persist it externally (for example through the engine's ``set_variable`` / ``get_variable`` API). For the full behaviour and the caveats around module-level singletons, see :ref:`Multi-Interpreter Python <APIFundamentals>`.

Next steps
==========

* Browse the :ref:`Sample Scripts <pythonApi-sample-scripts>` and copy the one closest to what you need.
* Read the per-extension-point how-tos: :ref:`implementAction`, :ref:`implementPlayerExtension`, :ref:`implementAIActor`, :ref:`implementCameraAttachment`.
* Look up individual methods in the :ref:`Python API reference <pythonApi>`.
* Review engine behaviours that cut across extension types in :ref:`APIFundamentals`.
