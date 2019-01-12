.. _implementPlayerExtension:

===================================
How to Implement a Player Extension
===================================

Player extensions are main ways of handling input in Limon Engine. Input from player is first handled by PhysicalPlayer class, which governs look around and movement, then all input information is passed to selected extension, so it can handle custom interactions, like pickups, shooting etc. On the other side, any interaction send by other entities to player is directly passed to player extension for handling.

PlayerExtensionInterface Class
______________________________

+---------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+
|                                                   |:ref:`PlayerExtensionInterface(LimonAPI \*limonAPI)<PlayerExtensionInterface-PlayerExtensionInterface>`             |
+---------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+
| void                                              |:ref:`processInput(InputHandler &inputHandler, long time)<PlayerExtensionInterface-processInput>`                   |
+---------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+
| bool                                              |:ref:`interact(std::vector\<LimonAPI::ParameterRequest\> &parameters)<PlayerExtensionInterface-interact>`           |
+---------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+
| std::string                                       |:ref:`getName() const<PlayerExtensionInterface-getName>`                                                            |
+---------------------------------------------------+--------------------------------------------------------------------------------------------------------------------+

.. _PlayerExtensionInterface-PlayerExtensionInterface:

PlayerExtensionInterface(LimonAPI \*limonAPI)
================================================
The constructor of the interface.

.. note::
    All Player Extension must have the same signature, no other parameters should be required.

.. _PlayerExtensionInterface-processInput:

void processInput(InputHandler &inputHandler, long time)
=======================================================

Called each frame with updated input information, and time of frame in milliseconds.

.. _PlayerExtensionInterface-interact:

void interact(std::vector<LimonAPI::ParameterRequest> &interactionData)
=======================================================================

Called by other entities to interact with player.

.. _PlayerExtensionInterface-getName:

std::string getName() const
===============

Returns the name of the Player Extension.

.. warning::
    The name must be unique, or the results will be undefined.

.. _ActorInterface-enableDynamicDiscovery:

How to enable Dynamic Library discovery
_______________________________________

Limon engine will try to load custom player extensions on engine startup, from libcustomTriggers file (extension based on platform). If the file is found, engine will check for a method with following signature:
::

    void registerPlayerExtensions(std::map<std::string, PlayerExtensionInterface*(*)(LimonAPI*)>* playerExtensionMap)

This method should fill the actorMap passed, with all the custom actors, like this:
::

    (*playerExtensionMap)["$EXTENSION_NAME1$"] = &createPlayerExtension<$ExtensionClass1$>;
    (*playerExtensionMap)["$EXTENSION_NAME2$"] = &createPlayerExtension<$ExtensionClass2$>;
