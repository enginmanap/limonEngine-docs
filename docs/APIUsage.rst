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

API Methods
___________

+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|uint32_t                       |:ref:`animateModel(uint32_t modelID, uint32_t animationID, bool looped, const std::string \*soundPath)<LimonAPI-animateModel>`                                                                                     |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|uint32_t                       |:ref:`addGuiText(const std::string &fontFilePath, uint32_t fontSize, const std::string &name, const std::string &text, const glm::vec3 &color, const glm::vec2 &position, float rotation)<LimonAPI-addGuiText>`    |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`updateGuiText(uint32_t guiTextID, const std::string &newText)<LimonAPI-updateGuiText>`                                                                                                                       |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|uint32_t                       |:ref:`removeGuiElement(uint32_t guiElementID)<LimonAPI-removeGuiElement>`                                                                                                                                          |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`removeObject(uint32_t objectID)<LimonAPI-removeObject>`                                                                                                                                                      |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`removeTriggerObject(uint32_t TriggerObjectID)<LimonAPI-removeTriggerObject>`                                                                                                                                 |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`disconnectObjectFromPhysics(uint32_t modelID)<LimonAPI-disconnectObjectFromPhysics>`                                                                                                                         |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`reconnectObjectToPhysics(uint32_t modelID)<LimonAPI-reconnectObjectToPhysics>`                                                                                                                               |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`attachSoundToObjectAndPlay(uint32_t objectWorldID, const std::string &soundPath)<LimonAPI-attachSoundToObjectAndPlay>`                                                                                       |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`detachSoundFromObject(uint32_t objectWorldID)<LimonAPI-detachSoundFromObject>`                                                                                                                               |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|uint32_t                       |:ref:`playSound(const std::string &soundPath, const glm::vec3 &position, bool looped)<LimonAPI-playSound>`                                                                                                         |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`loadAndSwitchWorld(const std::string& worldFileName)<LimonAPI-loadAndSwitchWorld>`                                                                                                                           |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`returnToWorld(const std::string& worldFileName)<LimonAPI-returnToWorld>`                                                                                                                                     |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`LoadAndRemove(const std::string& worldFileName)<LimonAPI-LoadAndRemove>`                                                                                                                                     |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|void                           |:ref:`returnPreviousWorld()<LimonAPI-returnPreviousWorld>`                                                                                                                                                         |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|void                           |:ref:`quitGame()<LimonAPI-quitGame>`                                                                                                                                                                               |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|std::vector<ParameterRequest>  |:ref:`getResultOfTrigger(uint32_t TriggerObjectID, uint32_t TriggerCodeID)<LimonAPI-getResultOfTrigger>`                                                                                                           |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|LimonAPI::ParameterRequest&    |:ref:`getVariable(const std::string& variableName)<LimonAPI-getVariable>`                                                                                                                                          |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _LimonAPI-animateModel:

uint32_t animateModel(uint32_t modelID, uint32_t animationID, bool looped, const std::string \*soundPath)
=========================================================================================================

Adds an animation to a model. returns model handle ID.

Parameters:

#. uint32_t modelID: handle ID of the model to animate
#. uint32_t animationID: handle ID of the animation
#. bool looped: whether the animation is looped or one off.
#. const std::string \*soundPath: sound to play while animation goes.  If NULL, no sound plays. Otherwise sound will be played in loop until the animation stops.

.. _LimonAPI-addGuiText:

uint32_t addGuiText(const std::string &fontFilePath, uint32_t fontSize, const std::string &name, const std::string &text, const glm::vec3 &color, const glm::vec2 &position, float rotation)
============================================================================================================================================================================================

Adds GUI Text to world. Returns created GUITexts handle ID.

Parameters:

#. const std::string &fontFilePath: Font file to use while rendering the text.
#. uint32_t fontSize: Font size
#. const std::string &name: Name of the GameObject GUIText
#. const std::string &text: Text to render
#. const glm::vec3 &color: Text color
#. const glm::vec2 &position: Position of the Text. This values will be between 0 and 1. 0,0 means left bottom and 1,1 means right top
#. float rotation: Rotation of the text. 0 is upwards. it is in rads and clockwise.

.. _LimonAPI-updateGuiText:

bool updateGuiText(uint32_t guiTextID, const std::string &newText)
==================================================================

Updates rendered text of the GUIText provided by the handle ID. Returns true if successful, false if handle ID invalid.

Parameters:

#. uint32_t guiTextID
#. const std::string &newText

.. _LimonAPI-removeGuiElement:

uint32_t removeGuiElement(uint32_t guiElementID)
================================================

Removes the GUIText indicated by the handle ID. Returns 0 for success, 1 for invalid Handle ID

Parameters:

#. uint32_t guiElementID: GUIText handle ID

.. _LimonAPI-removeObject:

bool removeObject(uint32_t objectID)
====================================

Removes object indicated by the handle ID passed. Returns true for success, false for invalid Handle ID.

Parameters:

#. uint32_t objectID: handle id of the object to remove. Note the variable name is wrong.


.. _LimonAPI-removeTriggerObject:

bool removeTriggerObject(uint32_t TriggerObjectID)
==================================================

Removes trigger volume indicated by the handle ID passed. Returns true for success, false if trigger handle ID invalid.

Parameters:

#. uint32_t TriggerObjectID: handle id of the trigger volume to remove.

.. _LimonAPI-disconnectObjectFromPhysics:

bool disconnectObjectFromPhysics(uint32_t modelID)
==================================================

Disconnects the model from physics, but it will be rendered as usual. Including custom and asset builtin animations. Returns true for success, false for fail. Fail can be either Handle ID invalid or the object is not a model, and can't be disconnected.

Parameters:

#. uint32_t modelID: handle id of the model to disconnect.


.. _LimonAPI-reconnectObjectToPhysics:

bool reconnectObjectToPhysics(uint32_t modelID)
===============================================

Connects the model from physics. Returns true for success, false for fail. Fail can be either Handle ID invalid or the object is not a model, and can't be connected. Does nothing if already connected, returns true.

Parameters:

#. uint32_t modelID: handle id of the model to connect.

.. _LimonAPI-attachSoundToObjectAndPlay:

bool attachSoundToObjectAndPlay(uint32_t objectWorldID, const std::string &soundPath)
=====================================================================================

Creates a sound, attaches it to an object and plays. The sound is played in loop. Attaching an object means the sound source position and velocity will follow the object. Returns false if the object is not found.

Parameter:

#. uint32_t objectWorldID: Handle id of the object to attach.
#. const std::string &soundPath: Path of the sound to play.

.. _LimonAPI-detachSoundFromObject:

bool detachSoundFromObject(uint32_t objectWorldID)
==================================================

Removes the sound already attached from the object, and stops the sound. Returns false if the object is not found.

Parameter:

#. uint32_t objectWorldID: Handle id of the object to remove.

.. _LimonAPI-playSound:

uint32_t playSound(const std::string &soundPath, const glm::vec3 &position, bool looped)
====================================================================================

Creates and plays a sound. Returns uin32_t playing sound ID.

Parameters:

#. const std::string &soundPath: Path of the sound to play.
#. const glm::vec3 &position: World position of the sound source.
#. bool looped: Play once or play in a loop

.. _LimonAPI-loadAndSwitchWorld:

bool loadAndSwitchWorld(const std::string& worldFileName)
=========================================================

Loads a world file, then switches the current world to the newly loaded one. If the world file was already loaded, removes the old one, effectively resetting the world. Returns false if the world file couldn't be loaded.

Parameters:

#. const std::string& worldFileName: The file path+name of the world to load.

.. _LimonAPI-returnToWorld:

bool returnToWorld(const std::string& worldFileName)
====================================================

Checks if the world file is loaded. If it is not, loads the world. Then changes the current world to requested one. Returns false if the world file couldn't be loaded.

Parameters:

#. const std::string& worldFileName: The file path+name of the world to load.

.. _LimonAPI-LoadAndRemove:

bool LoadAndRemove(const std::string& worldFileName)
====================================================

Loads the world requested, and removes the current world. Returns true if load successful, false if not. If not successful, world doesn't change.

It is used to switch between big worlds, like game maps. It is not necessary to clear menu worlds since they use very little memory.

.. note::
    This method clears the return previous world stack.

Parameters:

#. const std::string& worldFileName: The file path+name of the world to load.

.. _LimonAPI-returnPreviousWorld:

void returnPreviousWorld()
==========================

Returns to the world that was running before current. If no world is found, it will be a noop.

Parameters:

none

.. _LimonAPI-quitGame:

void quitGame()
===============

Clears the open devices and quits the game, shutting down the engine process.

.. _LimonAPI-getResultOfTrigger:

std::vector<LimonAPI::ParameterRequest> getResultOfTrigger(uint32_t TriggerObjectID, uint32_t TriggerCodeID)
============================================================================================================

Returns the result of the trigger object. For details, check :ref:`trigger object editor<Trigger Object Editor>`

Parameters:

#. uint32_t TriggerObjectID: The handleID of trigger object
#. uint32_t TriggerCodeID: Which triggers result is requested. 1-> first enter, 2-> enter, 3-> exit.


.. _LimonAPI-getVariable:

LimonAPI::ParameterRequest& getVariable(const std::string& variableName)
========================================================================

Returns variable from global variable store. If the variable is never set, it will be 0 initialized. Returned reference can be updated, doing so will be setting the parameter.

The variables are accessible by all triggers, and there are no safety checks. User is fully responsible for use of them.

.. warning::
    The variables are not save with world itself, so they should be considered temporary.

Parameters:

#. const std::string& variableName: The name of the variable that should be returned.

.. _LimonAPI-HowToImplementAnAction:

How to Implement an action
##########################

Actions are generalized by the class TriggerInterface, under src/GamePlay of the engine. Each new action must implement this interface.

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