.. _implementAction:

==========================
How to Implement an Action
==========================

Actions are generalized by the class TriggerInterface, under src/GamePlay of the engine. Each new action must implement this interface. These actions can be assigned to trigger volumes or GUI button.They can also be run on map load.

Action constructors will get a populated LimonAPI instance for the world they are to be run in. Using this instance, API calls can be made to interact or change the world to game design.

Actions never get persisted, but parameters to pass to actions are persisted with maps.

TriggerInterface Class
______________________

+---------------------------------------------------+-----------------------------------------------------------------------------------------------+
|                                                   |:ref:`TriggerInterface(LimonAPI \*limonAPI)<TriggerInterface-TriggerInterface>`                |
+---------------------------------------------------+-----------------------------------------------------------------------------------------------+
|std::vector<LimonAPI::ParameterRequest>            |:ref:`getParameters()<TriggerInterface-getParameters>`                                         |
+---------------------------------------------------+-----------------------------------------------------------------------------------------------+
|bool                                               |:ref:`run(std::vector\<LimonAPI::ParameterRequest\>parameters)<TriggerInterface-run>`          |
+---------------------------------------------------+-----------------------------------------------------------------------------------------------+
|std::vector<LimonAPI::ParameterRequest>            |:ref:`getResults()<TriggerInterface-getResults>`                                               |
+---------------------------------------------------+-----------------------------------------------------------------------------------------------+
|std::string                                        |:ref:`getName() const<TriggerInterface-getName>`                                               |
+---------------------------------------------------+-----------------------------------------------------------------------------------------------+

.. _TriggerInterface-TriggerInterface:

TriggerInterface(LimonAPI \*limonAPI)
=====================================
The constructor of the interface.

.. note::
    All actions must have the same signature, no other parameters should be required.

.. _TriggerInterface-getParameters:

getParameters()
===============

Returns a vector of :ref:`ParameterRequest`, These parameters are going to be set by map designer using the editor.

.. _TriggerInterface-run:

run(std::vector<LimonAPI::ParameterRequest>parameters)
======================================================

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