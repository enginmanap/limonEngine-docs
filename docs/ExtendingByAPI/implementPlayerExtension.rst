.. _implementPlayerExtension:

===================================
How to Implement a Player Extension
===================================

Player extensions are main ways of handling input in Limon Engine. Input from player is first handled by PhysicalPlayer class, which governs look around and movement, then all input information is passed to selected extension, so it can handle custom interactions, like pickups, shooting etc. On the other side, any interaction send by other entities to player is directly passed to player extension for handling.

Player extensions follow the :ref:`unified parameter contract <GenericParameter-unified-contract>`. Like Triggers, the base class holds the values on a protected ``parameters`` member: you seed any default parameters into that member in the **constructor**, the base ``getParameters() const`` returns it, and ``setParameters()`` overwrites it when the designer edits values or a map is loaded. The configured values are persisted with the map and editable in the editor. An extension with no configurable settings simply seeds nothing and the member stays empty.

PlayerExtensionInterface Class
______________________________

.. list-table::
   :widths: 20 80

   * -
     - :ref:`PlayerExtensionInterface(LimonAPI *limonAPI)<PlayerExtensionInterface-PlayerExtensionInterface>`
   * - ``void``
     - :ref:`processInput(const InputStates &inputState, const PlayerInformation &playerInformation, long time)<PlayerExtensionInterface-processInput>`
   * - ``void``
     - :ref:`interact(std::vector\<LimonTypes::GenericParameter\> &parameters)<PlayerExtensionInterface-interact>`
   * - ``std::vector<LimonTypes::GenericParameter>``
     - :ref:`getParameters() const<PlayerExtensionInterface-getParameters>`
   * - ``void``
     - :ref:`setParameters(std::vector\<LimonTypes::GenericParameter\>parameters)<PlayerExtensionInterface-setParameters>`
   * - ``std::string``
     - :ref:`getName() const<PlayerExtensionInterface-getName>`

.. _PlayerExtensionInterface-PlayerExtensionInterface:

PlayerExtensionInterface(LimonAPI \*limonAPI)
=============================================
The constructor of the interface. If the extension exposes editor-configurable settings, this is where it seeds their **defaults**: build each ``LimonTypes::GenericParameter`` descriptor and ``push_back`` it onto the protected ``this->parameters`` member.

.. note::
    All Player Extension must have the same signature, no other parameters should be required.

.. _PlayerExtensionInterface-processInput:

void processInput(const InputStates &inputState, const PlayerInformation &playerInformation, long time)
========================================================================================================

Called each frame with updated input information, current player state, and the frame time in milliseconds.

Parameters:

#. const InputStates &inputState: Current input state for this frame.
#. const PlayerInformation &playerInformation: Current player position and look direction. See :ref:`PlayerInformation struct<PlayerExtensionInterface-PlayerInformation>` below.
#. long time: Frame time in milliseconds.

.. _PlayerExtensionInterface-interact:

void interact(std::vector<LimonTypes::GenericParameter> &interactionData)
=========================================================================

Called by other entities to interact with player.

.. _PlayerExtensionInterface-getParameters:

std::vector<LimonTypes::GenericParameter> getParameters() const
===============================================================

Returns the configurable parameters of this extension. These are rendered by the editor under the selected extension and persisted with the map. The base implementation returns the instance's protected ``parameters`` member - the defaults you seeded in the constructor, or the configured values after an edit or load - so you normally do not override it. Override only to expose typed members as descriptors (Actor-style). An empty member means the extension has no editor-exposed configuration.

.. _PlayerExtensionInterface-setParameters:

void setParameters(std::vector<LimonTypes::GenericParameter>parameters)
=======================================================================

Stores the configured parameter values on the extension instance. Called when the map designer edits values in the editor and when a map is loaded. The base implementation keeps the values in the protected ``parameters`` member - the single source of truth for load, serialize, and editor edits. Override only if the extension needs to react to value changes.

.. _PlayerExtensionInterface-getName:

std::string getName() const
===========================

Returns the name of the Player Extension.

.. warning::
    The name must be unique, or the results will be undefined.

.. note::
   To drive the camera from a player extension, activate a :ref:`camera rig <implementCameraAttachment>` at runtime with ``createCameraRig`` / ``activateCameraRig`` (for example from ``processInput``). The old ``getCustomCameraAttachment`` mechanism has been removed.

.. _PlayerExtensionInterface-PlayerInformation:

PlayerInformation struct
________________________

Passed to :ref:`processInput <PlayerExtensionInterface-processInput>` each frame.

+-----------------------------+------------------------+---------------------------------------------------+
| Type                        | Name                   | Description                                       |
+-----------------------------+------------------------+---------------------------------------------------+
| LimonTypes::Vec4            | position               | Current world-space position of the player.       |
+-----------------------------+------------------------+---------------------------------------------------+
| LimonTypes::Vec4            | lookDirection          | Normalized direction the player is looking at.    |
|                             |                        | w component unused.                               |
+-----------------------------+------------------------+---------------------------------------------------+

.. _ActorInterface-InputStatesUsage:

InputStates Class Usage
_______________________

InputStates is a thin wrapper around SDL2 input events. It has 4 main methods that can be used:

#. getInputStatus: Allows checking if a key is down or up, for keys used by engine. 3 buttons of mouse is included.
#. getInputEvents: Allows if a key state changed in last frame, for keys used by engine. 3 buttons of mouse is included.
#. getRawKeyStates: Allows to check all key states for current frame.
#. getMouseChange: Allows checking for relative or absolute position of the mouse, depending of the mode(Menu player uses absolute).

Full list of supported keys can be checked from src/InputStates.h

.. _PlayerExtensionInterface-enableDynamicDiscovery:

How to enable Dynamic Library discovery
_______________________________________

Limon engine will try to load custom player extensions on engine startup, from libcustomTriggers file (extension based on platform). If the file is found, engine will check for a method with following signature:
::

    void registerPlayerExtensions(std::map<std::string, PlayerExtensionInterface*(*)(LimonAPI*)>* playerExtensionMap)

This method should fill the actorMap passed, with all the custom actors, like this:
::

    (*playerExtensionMap)["$EXTENSION_NAME1$"] = &createPlayerExtension<$ExtensionClass1$>;
    (*playerExtensionMap)["$EXTENSION_NAME2$"] = &createPlayerExtension<$ExtensionClass2$>;

.. note::
    Every registered extension name is available through the static ``PlayerExtensionInterface::getExtensionNames()`` (Python: ``get_extension_names()``). The editor uses this list to present the launch-time extension as a drop-down in Player Properties, so the registered name you use here is the one a map designer will pick from. See :ref:`UsingBuiltinEditor`.

.. note::
    ``getExtensionNames()`` was previously named ``getTriggerNames()``. It returns registered player-extension names, not trigger names; the old name was a misnomer and has been corrected.

.. _PlayerExtensionInterface-samples:

Sample Player Extensions
________________________

The engine ships with sample player extensions under ``samples/`` that implement ``PlayerExtensionInterface``:

* `ShooterPlayerExtension <https://github.com/enginmanap/limonEngine/blob/master/samples/ShooterPlayerExtension.cpp>`_ - a first-person shooter player controller.
* `CowboyShooterExtension <https://github.com/enginmanap/limonEngine/blob/master/samples/CowboyShooterExtension.cpp>`_ - the western-demo shooter controller, which also activates a third-person :ref:`camera rig <implementCameraAttachment>` at runtime (``createCameraRig`` / ``activateCameraRig``).
* `WesternMenuPlayerExtension <https://github.com/enginmanap/limonEngine/blob/master/samples/WesternMenuPlayerExtension.cpp>`_ - a menu controller using absolute mouse input for the western demo's menus.

A Python player-extension sample ships under ``Engine/Scripts/`` as `python_player_extension.py <https://github.com/enginmanap/limonEngine/blob/master/Engine/Scripts/python_player_extension.py>`_ (the ``PythonPlayerExtension`` class), subclassing the Python base in `player_extension_interface.py <https://github.com/enginmanap/limonEngine/blob/master/Engine/Scripts/player_extension_interface.py>`_.