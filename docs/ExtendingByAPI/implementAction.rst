.. _implementAction:

==========================
How to Implement an Action
==========================

Actions are generalized by the class TriggerInterface, under src/GamePlay of the engine. Each new action must implement this interface. These actions can be assigned to trigger volumes or GUI button.They can also be run on map load.

Action constructors will get a populated LimonAPI instance for the world they are to be run in. Using this instance, API calls can be made to interact or change the world to game design.

The action object itself is never persisted, but its parameters are. Triggers follow the :ref:`unified parameter contract <GenericParameter-unified-contract>`: you seed the action's default parameters into the protected ``parameters`` member in the **constructor**. The base ``getParameters()`` returns that member, the engine overwrites it through ``setParameters()`` when the map designer edits values or a map is loaded, and the same member is read back when serializing the map.

.. note::
    This is a breaking change from earlier releases. Actions used to build and return their parameter descriptors from ``getParameters()`` on every call; now they seed those descriptors once in the constructor and let the inherited ``getParameters()`` return the stored member. If you are porting an older action, move the body of your old ``getParameters()`` into the constructor, assigning into ``this->parameters`` instead of a local vector, and delete the ``getParameters()`` override.

TriggerInterface Class
______________________

.. list-table::
   :widths: 35 65

   * -
     - :ref:`TriggerInterface(LimonAPI *limonAPI)<TriggerInterface-TriggerInterface>`
   * - ``std::vector<LimonTypes::GenericParameter>``
     - :ref:`getParameters()<TriggerInterface-getParameters>`
   * - ``void``
     - :ref:`setParameters(std::vector\<LimonTypes::GenericParameter\>parameters)<TriggerInterface-setParameters>`
   * - ``bool``
     - :ref:`run(std::vector\<LimonTypes::GenericParameter\>parameters)<TriggerInterface-run>`
   * - ``std::vector<LimonTypes::GenericParameter>``
     - :ref:`getResults()<TriggerInterface-getResults>`
   * - ``std::string``
     - :ref:`getName() const<TriggerInterface-getName>`

.. _TriggerInterface-TriggerInterface:

TriggerInterface(LimonAPI \*limonAPI)
=====================================
The constructor of the interface. This is where an action seeds its **default parameters**: build each ``LimonTypes::GenericParameter`` descriptor and ``push_back`` it onto the protected ``this->parameters`` member. Those defaults are what the editor shows before the designer configures anything, and what serialization falls back to if the action is saved untouched.

.. note::
    All actions must have the same signature, no other parameters should be required.

.. _TriggerInterface-getParameters:

getParameters()
===============

Provided by the base class - it returns the instance's ``parameters`` member directly: the defaults you seeded in the constructor, or the configured values after the designer edits them or a map is loaded. The editor and the serializer both read this vector, so it always reflects what is actually configured. You normally do **not** override ``getParameters()`` for an action; seed your descriptors in the constructor instead. Override it only when you build the vector from typed members (the Actor style described in :ref:`implementAIActor`).

.. _TriggerInterface-setParameters:

setParameters(std::vector<LimonTypes::GenericParameter>parameters)
==================================================================

Stores the configured parameter values on the trigger instance. This is called when the map designer edits values in the editor and when a map is loaded from disk. The base implementation keeps the values in the protected ``parameters`` member, which is the single source of truth for load, serialize, and editor edits. Override it only if your action needs to react to value changes rather than simply hold them.

.. note::
    ``run()`` still receives the parameter vector as an argument for backwards compatibility with existing actions. New actions can rely on the instance-owned ``parameters`` member instead, which is kept in sync by ``setParameters()``.

.. _TriggerInterface-run:

run(std::vector<LimonTypes::GenericParameter>parameters)
========================================================

The parameters with their set values will be provided. The logic of the action should be this method. Return true if run succesfully. Return false if the run failed for some reason.

.. _TriggerInterface-getResults:

getResults()
============

The actions result might be queried by other actions. This method should return the results. Engine itself doesn't use this method, so it can return an empty vector. The usage of this method is game specific.

For example if the action adds a GUI element, and another action wants to remove this element, the other action might query for gui element id.

.. _TriggerInterface-getName:

getName() const
===============

Returns the name of the action.

.. warning::
    The name must be unique, or the results will be undefined.

.. _TriggerInterface-enableDynamicDiscovery:

How to enable Dynamic Library discovery
_______________________________________

Limon engine will try to load custom actions on engine startup, from libcustomTriggers file (extension based on platform). If the file is found, engine will check for a method with following signature:
::

    void registerAsTrigger(std::map<std::string, TriggerInterface*(*)(LimonAPI*)>* triggerMap)

This method should fill the triggerMap passed, with all the custom actions, like this:
::

    (*triggerMap)["$ACTION_NAME1$"] = &createT<$ActionClass1$>;
    (*triggerMap)["$ACTION_NAME2$"] = &createT<$ActionClass2$>;

