================
Action API Usage
================

Limon Engine provides an C++ API for extending and customising it to fit your game. The API has a parameter system for requesting and providing variables, and the parameters are connected to both editor and serialize/deserialize subsystem so saving and loading is handled by the engine.

LimonAPI class
##############

The LimonAPI class has all the methods available for usage. It also provides means to pass data around, namely ParameterRequest struct. This struct is used for both asking for and providing data. This struct is de/serialized by the engine, and editor can build graphical interfaces for it, there is no need to worry about that aspects of development.

.. _ParameterRequest:

ParameterRequest struct
_______________________

The struct is main means of data transfer. The serialize and deserialize methods are meant to be used by engine internals, they should be ignored for API usage purposes.

.. note:
    The value of any instance is initialized to 0.

RequestParameterTypes Enum
==========================

Used to indicate the semantic meaning of the parameter. Used to render editor interface accordingly. The *requestType* variable keeps the value.

Possible values:

* MODEL: Lists the models in the map. Uses variable type LONG, sets handle id.
* ANIMATION: Lists the custon animations loaded in the map. Uses variable type LONG, sets handle id.
* SWITCH: Renders tick box. Uses variable type BOOLEAN, sets is ticked.
* FREE_TEXT: Renders input box. Uses variable type STRING. Sets the input text.
* TRIGGER: Lists the trigger volumes in the map, and selector for "first enter", "enter", "exit". Uses variable type LONG_ARRAY, sets handle id, and selected trigger. for details refer to :ref:`Trigger Object Editor`
* GUI_TEXT: Lists the GUI Text elements in the map. Uses variable type LONG, sets handle id
* FREE_NUMBER: Renders input box for number. Uses variable type LONG. Sets the number entered.

ValueTypes Enum
===============

Used to determine how to handle Value union. *valueType* variable keeps the value.

Possible values:

* STRING
* DOUBLE
* LONG
* LONG_ARRAY
* BOOLEAN

Description String
==================

Used in editor and shown to user directly.

Value Union
===========

Union to store value set by editor or other triggers or engine itself. *value* variable keeps it.

Union variables

* char stringValue[64]
* long longValue
* long longValues[16]
* double doubleValue
* bool boolValue

.. note:
    if long values array is used, first element should be used element count.

isSet
=====

Used to indicate if the variable is set or or not. If default value is considered valid then should be initialized true.

.. warning:
    If a variable is not reqired aka optional, this should be initialized with true, because editor doesn't allow saving a trigger with any parameter not set.

API Methods
___________

+---------------------+------------------------------------+
|uint32_t             |removeGuiElement(uint32_t)          |
+---------------------+------------------------------------+

How to Implement an action
##########################

Actions are generalized by the class TriggerInterface, under src/GamePlay of the engine. Each new action must implement this interface.

TriggerInterface Class
______________________

+---------------------------------------------------+-------------------------------------------------------------------------------------+
|                                                   |:ref:`TriggerInterface(LimonAPI \*limonAPI)<TriggerInterface-TriggerInterface>`      |
+---------------------------------------------------+-------------------------------------------------------------------------------------+
|std::vector<LimonAPI::ParameterRequest>            |:ref:`getParameters()<TriggerInterface-getParameters>`                               |
+---------------------------------------------------+-------------------------------------------------------------------------------------+
|bool                                               |:ref:`run(std::vector<LimonAPI::ParameterRequest>parameters)<TriggerInterface-run>`  |
+---------------------------------------------------+-------------------------------------------------------------------------------------+
|std::vector<LimonAPI::ParameterRequest>            |:ref:`getResults()<TriggerInterface-getResults>`                                     |
+---------------------------------------------------+-------------------------------------------------------------------------------------+
|std::string                                        |:ref:`getName() const<TriggerInterface-getName>`                                     |
+---------------------------------------------------+-------------------------------------------------------------------------------------+

.. _TriggerInterface-TriggerInterface:

TriggerInterface(LimonAPI \*limonAPI)
=====================================
The constructor of the interface.

.. note:
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

.. warning:
    The name must be unique, or the results will be undefined.