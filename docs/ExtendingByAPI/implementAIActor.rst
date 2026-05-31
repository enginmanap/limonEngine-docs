.. _implementAIActor:

============================
How to Implement an AI Actor
============================

AI Actor is the way Limon enables custom behaviour for NPCs or enemies. Limon engine has a class named ActorInterface under src/AI, that it used to implement custom AI behaviour.

Limon editor allows selecting Actor per model. After Actor selected, a new instance of the selected Actor is created, and called each frame with current information about the world. It is also possible to expose some settings to be filled by level designer using the same interface of editor.

Actors follow the :ref:`unified parameter contract <GenericParameter-unified-contract>`. Like Triggers and Player Extensions, ``ActorInterface`` provides a protected ``parameters`` member with base ``getParameters()`` / ``setParameters()`` implementations, so a simple actor can seed its defaults into that member in the constructor and rely on the base methods - no override required.

Most actors, however, read their configuration every frame in ``play()`` and prefer real typed members (``float aggroRange``, ``int health``, ...) over scanning an untyped vector. Because both methods are ``virtual``, an actor is free to keep its configuration in whatever form it likes: override ``getParameters()`` to convert its typed members into a ``GenericParameter`` vector - each entry filled with its current value - and override ``setParameters()`` to apply edited or loaded values back onto those members. The same vector drives editor widgets, map serialization, and load either way. The bundled actors use this "typed-member" style, and it is the recommended approach for non-trivial AI.

ActorInterface Class
____________________

ActorInterface class has two helper structs used to pass information between engine and AI. Those are :ref:`ActorInterface-ActorInformation` and :ref:`ActorInterface-InformationRequest`. details are below.

.. warning::
    Information requests are prepared by separate threads, and no guarantees made for when they will return. Check routeReady flag on ActorInformation before using the route.

.. list-table::
   :widths: 35 65

   * -
     - :ref:`ActorInterface(uint32_t id, LimonAPI *limonAPI)<ActorInterface-ActorInterface>`
   * - ``std::vector<LimonTypes::GenericParameter>``
     - :ref:`getParameters()<ActorInterface-getParameters>`
   * - ``void``
     - :ref:`setParameters(std::vector\<LimonTypes::GenericParameter\>parameters)<ActorInterface-setParameters>`
   * - ``void``
     - :ref:`play(long time, ActorInformation& information)<ActorInterface-play>`
   * - ``bool``
     - :ref:`interaction(std::vector\<LimonTypes::GenericParameter\>parameters)<ActorInterface-interaction>`
   * - ``std::string``
     - :ref:`getName() const<ActorInterface-getName>`

.. _ActorInterface-ActorInterface:

ActorInterface(uint32_t id, LimonAPI \*limonAPI)
================================================
The constructor of the interface.

.. note::
    All Actors must have the same signature, no other parameters should be required.

.. _ActorInterface-getParameters:

std::vector<LimonTypes::GenericParameter> getParameters()
=========================================================

Returns a vector of ``LimonTypes::GenericParameter``. These parameters are going to be set by the map designer using the editor, and must be filled with their current values, because the Load/Save logic uses them to persist AI information. The base implementation returns the protected ``parameters`` member - seed your defaults into it in the constructor and they are returned here, exactly as for Triggers and Player Extensions. Override this method when the actor owns its configuration as its own typed members and assembles the vector from them; this is what the bundled actors do.

.. _ActorInterface-setParameters:

void setParameters(std::vector<LimonTypes::GenericParameter> parameters)
========================================================================

The parameters set by map designer will be passed to this method. It might be just set, or they might be loading as part of map load. The base implementation stores them in the protected ``parameters`` member; override it to apply the values onto the actor's own typed members instead.

.. _ActorInterface-play:

void play(long time, ActorInformation &information)
===================================================

Called on each frame, with current information about player and world, in form of :ref:`ActorInterface-ActorInformation`

.. _ActorInterface-interaction:

bool interaction(std::vector<LimonTypes::GenericParameter> &interactionInformation)
===================================================================================

called by other entities, like Actors or Player. Used to pass information like hits, or alarming etc.

.. _ActorInterface-getName:

std::string getName() const
===========================

Returns the name of the Actor.

.. warning::
    The name must be unique, or the results will be undefined.

.. _ActorInterface-ActorInformation:

ActorInformation struct
_______________________

This struct is feeded for each frame, and meant to contain information to trigger AI behaviour. It contains the following information

+------------------------+-----------------------------+--------------------------------------------------------------------------+
| Type                   | Name                        | Description                                                              |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|bool                    | canSeePlayerDirectly        | Is there any object between Actor and Player.                            |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|bool                    | isPlayerLeft                | Is Player at left of Actor.                                              |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|bool                    | isPlayerRight               | Is Player at right of Actor.                                             |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|bool                    | isPlayerUp                  | Is Player higher up than Actor.                                          |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|bool                    | isPlayerDown                | Is Player lower than Actor.                                              |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|bool                    | isPlayerFront               | Is Player in front of the Actor.                                         |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|bool                    | isPlayerBack                | Is Player at back of the Actor.                                          |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|float                   | cosineBetweenPlayer         | What is the cosine of player and actor front vector.                     |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|glm::vec3               | playerDirection             | What is the direction vector from actor to player.                       |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|float                   | playerDistance              | What is the distance between actor and player (unit is close to meters). |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|float                   | cosineBetweenPlayerForSide  | cosine of the angle between right vector of actor and player.            |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|bool                    | playerDead                  | Is player dead?                                                          |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
|                        |                             |                                                                          |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
| uint32_t               | maximumRouteDistance(128)   | how deep the route search should go. (maximum ~128 meters default)       |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
| std::vector<glm::vec3> | routeToRequest              | Points to follow to reach the player.                                    |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
| bool                   | routeFound                  | Was route course successful?                                             |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
| bool                   | routeReady                  | Was route course done?                                                   |
+------------------------+-----------------------------+--------------------------------------------------------------------------+

The first part of the information will be filled for each frame. The Route will not be filled until requested, and routeFound/routeReady will be false. To request route to player, check InformationRequest struct below.

.. _ActorInterface-InformationRequest:

InformationRequest struct
_________________________

This struct is part of ActorInterface, and each frame Limon Engine checks all Actors for request changes. When a request is checked, its information will be reset to prevent multiple requests.

+------------------------+-----------------------------+--------------------------------------------------------------------------+
| Type                   | Name                        | Description                                                              |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
| bool                   | routeToPlayer               | Request a route to Player                                                |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
| bool                   | routeToCustomPosition       | Request a route to custom position                                       |
+------------------------+-----------------------------+--------------------------------------------------------------------------+
| glm::vec3              | customPosition              | Position to course path                                                  |
+------------------------+-----------------------------+--------------------------------------------------------------------------+

.. _ActorInterface-enableDynamicDiscovery:

How to enable Dynamic Library discovery
_______________________________________

Limon engine will try to load custom actors on engine startup, from libcustomTriggers file (extension based on platform). If the file is found, engine will check for a method with following signature:
::

    void registerActors(std::map<std::string, ActorInterface*(*)(uint32_t, LimonAPI*)>* actorMap)

This method should fill the actorMap passed, with all the custom actors, like this:
::

    (*actorMap)["$ACTOR_NAME1$"] = &createActorT<$ActorClass1$>;
    (*actorMap)["$ACTOR_NAME2$"] = &createActorT<$ActorClass2$>;