.. _APIUsage:

================
Limon API Usage
================

Limon Engine provides an C++ API for extending and customising it to fit your game. The API has a parameter system for requesting and providing variables, and the parameters are connected to both editor and serialize/deserialize subsystem so saving and loading is handled by the engine.

LimonAPI class
##############

The LimonAPI class has all the methods available for usage. It also provides means to pass data around, namely ParameterRequest struct. This struct is used for both asking for and providing data. This struct is de/serialized by the engine, and editor can build graphical interfaces for it, there is no need to worry about that aspects of development.

.. _ParameterRequest:

ParameterRequest struct
_______________________

The struct is main means of data transfer. The serialize and deserialize methods are meant to be used by engine internals, they should be ignored for API usage purposes.

.. note::
    The value of any instance is initialized to 0.

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
* double doubleValue
* bool boolValue
* Vec4 vectorValue
* Mat4 matrixValue

.. note::
    if long values array is used, first element should be used element count.

isSet
=====

Used to indicate if the variable is set or or not. If default value is considered valid then should be initialized true.

.. warning::
    If a variable is not required aka optional, this should be initialized with true, because editor doesn't allow saving a trigger with any parameter not set.