.. _APIReference:

==========================
Limon Engine API Reference
==========================

+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|uint32_t                       |:ref:`animateModel(uint32_t modelID, uint32_t animationID, bool looped, const std::string \*soundPath)<LimonAPI-animateModel>`                                                                                     |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|std::string                    |:ref:`getModelAnimationName(uint32_t modelID)<LimonAPI-getModelAnimationName>`                                                                                                                                     |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`getModelAnimationFinished(uint32_t modelID)<LimonAPI-getModelAnimationFinished>`                                                                                                                             |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`setModelAnimation(uint32_t modelID, const std::string& animationName, bool isLooped = true)<LimonAPI-setModelAnimation>`                                                                                     |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`setModelAnimationWithBlend(uint32_t modelID, const std::string& animationName, bool isLooped = true, long blendTime = 100)<LimonAPI-setModelAnimationWithBlend>`                                             |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`setModelAnimationSpeed(uint32_t modelID, float speed)<LimonAPI-setModelAnimationSpeed>`                                                                                                                      |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|std::vector<uint32_t>          |:ref:`getModelChildren(uint32_t modelID)<LimonAPI-getModelChildren>`                                                                                                                                               |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|uint32_t                       |:ref:`addGuiText(const std::string &fontFilePath, uint32_t fontSize, const std::string &name, const std::string &text, const glm::vec3 &color, const glm::vec2 &position, float rotation)<LimonAPI-addGuiText>`    |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|uint32_t                       |:ref:`addGuiImage(const std::string &imageFilePath, const std::string &name, const glm::vec2 &position, const glm::vec2 &scale, float rotation)<LimonAPI-addGuiImage>`                                             |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`updateGuiText(uint32_t guiTextID, const std::string &newText)<LimonAPI-updateGuiText>`                                                                                                                       |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|uint32_t                       |:ref:`removeGuiElement(uint32_t guiElementID)<LimonAPI-removeGuiElement>`                                                                                                                                          |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|uint32_t                       |:ref:`addObject(const std::string &modelFilePath, float modelWeight, bool physical, const glm::vec3 &position, const glm::vec3 &scale, const glm::quat &orientation)<LimonAPI-addObject>`                          |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`attachObjectToObject(uint32_t objectID, uint32_t objectToAttachToID)<LimonAPI-attachObjectToObject>`                                                                                                         |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`setObjectTemporary(uint32_t objectID, bool temporary)<LimonAPI-setObjectTemporary>`                                                                                                                          |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|std::vector<ParameterRequest>  |:ref:`getObjectTransformation(uint32_t objectID)<LimonAPI-getObjectTransformation>`                                                                                                                                |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|std::vector<ParameterRequest>  |:ref:`getObjectTransformationMatrix(uint32_t objectID)<LimonAPI-getObjectTransformationMatrix>`                                                                                                                    |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`setObjectTranslate(uint32_t objectID, const LimonAPI::Vec4& position)<LimonAPI-setObjectTranslate>`                                                                                                          |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`setObjectScale(uint32_t objectID, const LimonAPI::Vec4& scale)<LimonAPI-setObjectScale>`                                                                                                                     |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`setObjectOrientation(uint32_t objectID, const LimonAPI::Vec4& orientation)<LimonAPI-setObjectOrientation>`                                                                                                   |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`addObjectTranslate(uint32_t objectID, const LimonAPI::Vec4& position)<LimonAPI-addObjectTranslate>`                                                                                                          |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`addObjectScale(uint32_t objectID, const LimonAPI::Vec4& scale)<LimonAPI-addObjectScale>`                                                                                                                     |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`addObjectOrientation(uint32_t objectID, const LimonAPI::Vec4& orientation)<LimonAPI-addObjectOrientation>`                                                                                                   |
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
|uint32_t                       |:ref:`getPlayerAttachedModel()<LimonAPI-getPlayerAttachedModel>`                                                                                                                                                   |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|LimonAPI::Vec4                 |:ref:`getPlayerAttachedModelOffset()<LimonAPI-getPlayerAttachedModelOffset>`                                                                                                                                       |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`setPlayerAttachedModelOffset(LimonAPI::Vec4 &newOffset)<LimonAPI-setPlayerAttachedModelOffset>`                                                                                                              |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|void                           |:ref:`interactWithPlayer(std::vector<ParameterRequest>& input)<LimonAPI-interactWithPlayer>`                                                                                                                       |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|void                           |:ref:`killPlayer()<LimonAPI-killPlayer>`                                                                                                                                                                           |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`interactWithAI(uint32_t AIID, std::vector\<LimonAPI::ParameterRequest\> &interactionInformation)<LimonAPI-interactWithAI>`                                                                                   |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`addLightTranslate(uint32_t lightID, const LimonAPI::Vec4& translate)<LimonAPI-addLightTranslate>`                                                                                                            |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|bool                           |:ref:`setLightColor(uint32_t lightID, const LimonAPI::Vec4& color)<LimonAPI-setLightColor>`                                                                                                                        |
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
|std::vector<ParameterRequest>  |:ref:`rayCastToCursor()<LimonAPI-rayCastToCursor>`                                                                                                                                                                 |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|void                           |:ref:`addTimedEvent(long waitTime, std::function\<void(const std::vector\<LimonAPI::ParameterRequest\>&)\> methodToCall, std::vector\<LimonAPI::ParameterRequest\> parameters)<LimonAPI-addTimedEvent>`            |
+-------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _LimonAPI-animateModel:

uint32_t animateModel(uint32_t modelID, uint32_t animationID, bool looped, const std::string \*soundPath)
=========================================================================================================

Applies an custom animation to a model. returns model handle ID.

Parameters:

#. uint32_t modelID: handle ID of the model to animate
#. uint32_t animationID: handle ID of the animation
#. bool looped: whether the animation is looped or one off.
#. const std::string \*soundPath: sound to play while animation goes.  If NULL, no sound plays. Otherwise sound will be played in loop until the animation stops.

.. _LimonAPI-getModelAnimationName:

std::string getModelAnimationName(uint32_t modelID)
===================================================

Returns current "Asset" animation name of the model. If a custom animation is applied to the model, it is not returned. Returns empty string when model is not found.

Parameters:

#. uint32_t modelID: handle ID of the model to check for animation name

.. note::
    Asset Animation names are not managed by Limon, so it is possible empty string to be name of an animation.

.. _LimonAPI-getModelAnimationFinished:

bool getModelAnimationFinished(uint32_t modelID)
================================================

Returns true if model finished playing animation. For looped animations always returns false. Also returns false if model is not found.

Parameters:

#. uint32_t modelID: handle ID of the model to check for animation state

.. _LimonAPI-setModelAnimation:

bool setModelAnimation(uint32_t modelID, const std::string& animationName, bool isLooped = true)
=========================================================================================

Applies an "Asset" animation to a model. Returns false if model is not found.

Parameters:

#. uint32_t modelID: handle ID of the model to animate
#. const std::string& animationName: Name of the animation to play
#. bool isLooped: Whether play animation and stop, or play in a loop

.. _LimonAPI-setModelAnimationWithBlend:

bool setModelAnimationWithBlend(uint32_t modelID, const std::string& animationName, bool isLooped = true, long blendTime = 100)
========================================================================================================================

Applies an "Asset" animation to a model, blending it (using linear interpolation) with the previous animation. Returns false if model is not found.

Parameters:

#. uint32_t modelID: handle ID of the model to animate
#. const std::string& animationName: Name of the animation to play
#. bool isLooped: Whether play animation and stop, or play in a loop
#. long blendTime: How long the previous animation will effect state.

.. _LimonAPI-setModelAnimationSpeed:

bool setModelAnimationSpeed(uint32_t modelID, float speed)
==========================================================

Changes animation speed by given factor. speed=2.0 will double the animation speed. Speed values < 0.001f will be rejected and return false. If model is not found it will return false

Parameters:

#. uint32_t modelID: handle ID of the model to animate
#. float speed: Animation time multiplier


.. _LimonAPI-getModelChildren:

std::vector<uint32_t> getModelChildren(uint32_t modelID)
========================================================

Returns a vector of IDs with all children of model. Returns empty list for Model not found, as well as no children found.

Parameters:

#. uint32_t modelID: handle ID of the model to check for children

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

.. _LimonAPI-addGuiImage:

uint32_t addGuiImage(const std::string &imageFilePath, const std::string &name, const glm::vec2 &position, const glm::vec3 &scale, float rotation)
============================================================================================================================================================================================

Adds GUI Image to world. Returns created GUIImage handle ID.

Parameters:

#. const std::string &imageFilePath: Image files path.
#. const std::string &name: Name of the GameObject GUIImage
#. const glm::vec2 &position: Position of the Text. This values will be between 0 and 1. 0,0 means left bottom and 1,1 means right top
#. const glm::vec2 &scale: scale of the image.
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

.. _LimonAPI-addObject:

uint32_t addObject(const std::string &modelFilePath, float modelWeight, bool physical, const glm::vec3 &position, const glm::vec3 &scale, const glm::quat &orientation)
============================================================================================================================================================================================

Adds Model to world. Returns created Model handle ID.

Parameters:

#. const std::string &modelFilePath: Model files path.
#. float modelWeight: Weight of the model. 0 means object is static, and it won't move.
#. bool physical: Whether model has physical interactions or not. If set to false, it won't collide with anything.
#. const glm::vec3 &position: World position of the Object. Please note some objects has their center set to their feet.
#. const glm::vec3 &scale: scale of the object.
#. const glm::quat &orientation: Rotation of the model.


.. _LimonAPI-attachObjectToObject:

bool attachObjectToObject(uint32_t objectID, uint32_t objectToAttachToID)
====================================

Attaches object indicated by the handle ID, to another object indicated by second parameter. Returns true for success, false for invalid Handle ID for either parameter. Attachment means if parent object move, child will move too. Example usage: bullet hole decals to dynamic objects. The object should have a transformation relative to the object it will be attached.

Parameters:

#. uint32_t objectID: handle id of the object to attach as child.
#. uint32_t objectToAttachToID: handle id of the object to attach as parent.

.. _LimonAPI-setObjectTemporary:

bool setObjectTemporary(uint32_t objectID, bool temporary)
====================================

Changes objects temporary flag. If an object is temporary, it won't be saved with map save. There is no other difference. Returns false if object can't be found. Returns true if successful.

Parameters:

#. uint32_t objectID: handle id of the object to change flag.
#. bool temporary: whether flag is set or not. True value will prevent save with the map.

.. _LimonAPI-getObjectTransformation:

std::vector<LimonAPI::ParameterRequest> getObjectTransformation(uint32_t objectID)
====================================

returns objects transformation information. If the object ID is valid, the returned vector will contain 3 vec4 parameters, translate, scale, orientation in respective order. For translate and scale, w component is not used. Orientation is in quaternion form. Returns empty vector if object not found.

Parameters:

#. uint32_t objectID: handle id of the object to get transformation.

.. _LimonAPI-getObjectTransformationMatrix:

std::vector<LimonAPI::ParameterRequest> getObjectTransformationMatrix(uint32_t objectID)
====================================

returns objects transformation matrix. If object has custom matrix generation (Physical object can define offsets), transformation might not be enough to build the matrix. This method provides objects matrix as Limon Engine has it. Returns empty vector if object not found.

Parameters:

#. uint32_t objectID: handle id of the object to get transformation matrix.

.. _LimonAPI-setObjectTranslate:

bool setObjectTranslate(uint32_t objectID, const LimonAPI::Vec4& position)
====================================

Sets objects world position to 2. parameter. Returns false if object is not found.

Parameters:

#. uint32_t objectID: handle id of the object to change position.
#. const LimonAPI::Vec4& position: new position of the object

.. note::
    Fourth element in the vector is ignored.

.. _LimonAPI-setObjectScale:

bool setObjectScale(uint32_t objectID, const LimonAPI::Vec4& scale)
====================================

Sets objects scale to 2. parameter. Returns false if object is not found.

Parameters:

#. uint32_t objectID: handle id of the object to change scale.
#. const LimonAPI::Vec4& scale: new scale of the object

.. note::
    Fourth element in the vector is ignored.

.. _LimonAPI-setObjectOrientation:

bool setObjectOrientation(uint32_t objectID, const LimonAPI::Vec4& orientation)
====================================

Sets object world orientation to 2. parameter, aka rotates it. Returns false if object is not found.

Parameters:

#. uint32_t objectID: handle id of the object to change orientation.
#. const LimonAPI::Vec4& orientation: new orientation of the object

.. _LimonAPI-addObjectTranslate:

bool addObjectTranslate(uint32_t objectID, const LimonAPI::Vec4& position)
====================================

Adds given vector to objects current world position, effectively moving it. Returns false if object is not found.

Parameters:

#. uint32_t objectID: handle id of the object to change position.
#. const LimonAPI::Vec4& position: position change desired for the object

.. note::
    Fourth element in the vector is ignored.

.. _LimonAPI-addObjectScale:

bool addObjectScale(uint32_t objectID, const LimonAPI::Vec4& scale)
====================================

Scales the object, in respect to its current scale. If object is scaled to double of its original size before this call, and this call scales it to half, object will be at its original size afterwards. Returns false if object is not found.

Parameters:

#. uint32_t objectID: handle id of the object to change scale.
#. const LimonAPI::Vec4& scale: scale of object in respect to current scale.

.. note::
    Fourth element in the vector is ignored.

.. _LimonAPI-addObjectOrientation:

bool addObjectOrientation(uint32_t objectID, const LimonAPI::Vec4& orientation)
====================================

Rotates the object from current orientation. Returns false if object ID not found.

Parameters:

#. uint32_t objectID: handle id of the object to change orientation.
#. const LimonAPI::Vec4& orientation: new position of the object

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

.. _LimonAPI-getPlayerAttachedModel:

uint32_t getPlayerAttachedModel()
====================================================================================

Returns the model ID of player attachment. return 0 if player has no attachment.

Parameters:

none

.. note::
    Player attachment might have children, check :ref:`getModelChildren method <LimonAPI-getModelChildren>`

.. _LimonAPI-getPlayerAttachedModelOffset:

LimonAPI::Vec4 getPlayerAttachedModelOffset()
====================================================================================

Returns offset of the model attached to player. returns Vec4(0,0,0,0) if player has no attachment.

Parameters:

none

.. _LimonAPI-setPlayerAttachedModelOffsetWithAI:

bool setPlayerAttachedModelOffset(LimonAPI::Vec4 newOffset)
====================================================================================

Sets offset to player attachment. Returns false if player has no attachment.

Parameters:

#. LimonAPI::Vec4: offset to set. w component of parameter ignored.

.. _LimonAPI-interactWithPlayer:

void interactWithPlayer(std::vector<LimonAPI::ParameterRequest> &interactionInformation)
====================================================================================

Sends the interaction information to player Extension. If no extension is loaded, it will not have any effect.

Parameters:

#. std::vector<LimonAPI::ParameterRequest> &interactionInformation: Parameters to pass.

.. _LimonAPI-killPlayer:

void killPlayer()
====================================================================================

Kills the player.

Parameters:

none

.. _LimonAPI-interactWithAI:

bool interactWithAI(uint32_t AIID, std::vector<LimonAPI::ParameterRequest> &interactionInformation)
====================================================================================

Sends the parameters to AI as new interaction. Since AI is an extension point, the parameters required are not defined by Limon engine. Returns false if no AI actor with given ID found.

Parameters:

#. uint32_t AIID: ID of AI actor to send the data
#. std::vector<LimonAPI::ParameterRequest> &interactionInformation: Parameters to pass.

.. _LimonAPI-addLightTranslate:

bool addLightTranslate(uint32_t lightID, const LimonAPI::Vec4& translate)
=========================================================================

Adds given translate to current position of the light indicated by the lightID. Returns false if no light with given ID found.

Parameters:

#. uint32_t lightID: ID of light to translate
#. const LimonAPI::Vec4& translate: Translate vector to add. W component will be ignored.

.. _LimonAPI-setLightColor:

bool setLightColor(uint32_t lightID, const LimonAPI::Vec4& color)
=================================================================

Sets the color of the light, indicated by lightID parameter. Returns false if no light with given ID found.

Parameters:

#. uint32_t lightID: ID of light to change color
#. const LimonAPI::Vec4& color: RGB color to set. W component will be ignored.

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

.. _LimonAPI-rayCastToCursor:

std::vector<ParameterRequest> rayCastToCursor()
===============================================

Returns information about what is under player cursor (crosshair). If nothing is found, empty vector is returned.
if something is hit, return vector will have the following information:

#. ObjectID of the hit object
#. hit coordinates
#. hit normal
#. if Object has AI, AI id. If not, this parameter will not be in the vector.

Parameters:

none

.. _LimonAPI-addTimedEvent:

void addTimedEvent(long waitTime, std::function<void(const std::vector<LimonAPI::ParameterRequest>&)> methodToCall, std::vector<LimonAPI::ParameterRequest> parameters)
=======================================================================================================================================================================

Runs the given method, with passed parameters, after a given amount of time.

Parameters:

#. long waitTime: How long to wait before call, in milliseconds.
#. std::function<void(const std::vector<LimonAPI::ParameterRequest>&)> methodToCall: function to call.
#. std::vector<LimonAPI::ParameterRequest> parameters: parameters of that function call.

.. note::
    Wait time is not precise beyond game ticks. Limon Engine internally ticks each 1/60 seconds.

.. warning::
    If function is part of an object, and that object is removed, engine might crash. Avoiding those situations are game developers responsibility.