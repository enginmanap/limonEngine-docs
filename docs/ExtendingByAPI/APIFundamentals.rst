.. _APIFundamentals:

================
API Fundamentals
================

This page covers engine behaviours that cut across multiple extension types and are important to understand before writing non-trivial extensions. Topics here are not tied to a single extension point but affect how animations, audio, and Python scripts behave at runtime.

Extension Parameters
====================

Every extension point exposes its configurable settings through ``LimonTypes::GenericParameter``. This single struct covers three concerns at once - loading saved configuration, serializing it back to disk, and building the editor interface to edit it - so an extension describes its parameters once and gets all three for free.

The pattern is uniform across extension points: ``getParameters()`` returns the extension's parameter vector - each entry carrying both its descriptor (request type, description, value type) and its value - and ``setParameters()`` stores edited or loaded values back. There is a single vector, not a separate schema and value list: right after construction it holds the **defaults** the extension seeded, and after an editor edit or a map load it holds the **configured values**. That one vector is the source of truth for editing, serialization, and runtime. Triggers, Actors, and Player Extensions hold it on a protected ``parameters`` member; RenderMethods persist theirs in both the editor node graph and the runtime pipeline file.

For the full contract and the per-extension-point breakdown, see :ref:`the unified parameter contract <GenericParameter-unified-contract>`.

Animation Blending
==================

The engine supports simultaneous playback of two animations during a transition. This allows smooth crossfades between, for example, an idle animation and a walk cycle.

How Blending Works
------------------

Blending is implemented by interpolating translation, scale, and rotation **separately** for each bone:

* **Translation and Scale** - linear interpolation between the two animations.
* **Rotation** - spherical linear interpolation (slerp). This avoids the candy-wrap artefact that occurs when linearly interpolating rotation matrices or quaternions.
* The final bone matrix is reconstructed from the three blended components.

This approach explicitly avoids dual-quaternion blending, which does not support scale animation.

.. note::
    The maximum number of simultaneously contributing animations is **two**. There are no blend trees, state machines, or additive layers in 0.7. Complex animation graphs must be managed manually by switching animations from extension code.

Blend API
---------

Animation blending is not configurable in the editor - it must be driven via API from a C++ or Python extension.

.. list-table::
   :header-rows: 1
   :widths: 55 45

   * - Method
     - Description
   * - ``setModelAnimation(modelID, animationName, isLooped)``
     - Apply an asset animation by name immediately (no blend). (:ref:`C++ <LimonAPI-setModelAnimation>` | :ref:`Python <pythonApi-set_model_animation>`)
   * - ``setModelAnimationWithBlend(modelID, animationName, isLooped, blendTime)``
     - Crossfade from the current animation to the named one. ``blendTime`` is in milliseconds. (:ref:`C++ <LimonAPI-setModelAnimationWithBlend>` | :ref:`Python <pythonApi-set_model_animation_with_blend>`)
   * - ``setModelAnimationSpeed(modelID, speed)``
     - Speed multiplier applied to the active animation. Values below 0.001 are rejected. (:ref:`C++ <LimonAPI-setModelAnimationSpeed>` | :ref:`Python <pythonApi-set_model_animation_speed>`)
   * - ``getModelAnimationName(modelID)``
     - Returns the name of the currently playing asset animation. Returns empty string if a custom sequencer animation is active. (:ref:`C++ <LimonAPI-getModelAnimationName>` | :ref:`Python <pythonApi-get_model_animation_name>`)
   * - ``getModelAnimationFinished(modelID)``
     - Returns ``True`` if the current animation has completed. Always ``False`` for looped animations. (:ref:`C++ <LimonAPI-getModelAnimationFinished>` | :ref:`Python <pythonApi-get_model_animation_finished>`)

Each animation's playback speed is independently configurable. The start point of the incoming animation relative to the outgoing one is also configurable via the blend parameters.

Sound
=====

The audio backend is OpenAL with a dedicated audio thread. Supported formats are OGG and WAV.

Two methods place sounds in the world - they differ in how the 3D position is interpreted:

.. list-table::
   :header-rows: 1
   :widths: 55 45

   * - Method
     - Description
   * - ``attachSoundToObjectAndPlay(objectID, soundPath, looped)``
     - Attaches sound to a world object. The sound follows the object's position automatically every frame. Use for footsteps, engines, or any sound that should move with geometry. (:ref:`C++ <LimonAPI-attachSoundToObjectAndPlay>` | :ref:`Python <pythonApi-attach_sound_to_object_and_play>`)
   * - ``playSound(soundPath, position, positionRelative, looped)``
     - Plays a sound at a fixed world position. Returns a sound ID for subsequent control. See note on ``positionRelative`` below. (:ref:`C++ <LimonAPI-playSound>` | :ref:`Python <pythonApi-play_sound>`)
   * - ``detachSoundFromObject(objectID)``
     - Stops and detaches the sound from the object. (:ref:`C++ <LimonAPI-detachSoundFromObject>` | :ref:`Python <pythonApi-detach_sound_from_object>`)
   * - ``stopSound(soundID)``
     - Stop a playing sound by ID. (:ref:`C++ <LimonAPI-stopSound>` | :ref:`Python <pythonApi-stop_sound>`)
   * - ``setSoundVolume(soundID, volume)``
     - Set volume of a sound by ID. (:ref:`C++ <LimonAPI-setSoundVolume>` | :ref:`Python <pythonApi-set_sound_volume>`)
   * - ``isSoundPlaying(soundID)``
     - Returns ``True`` if a sound is currently playing. (:ref:`C++ <LimonAPI-isSoundPlaying>` | :ref:`Python <pythonApi-is_sound_playing>`)

The ``positionRelative`` Parameter
-----------------------------------

``playSound`` accepts a boolean ``positionRelative`` argument:

* ``positionRelative = False`` - the position is a **world-space** coordinate. The sound stays fixed at that location regardless of where the player moves. Use for ambient sounds tied to geometry.
* ``positionRelative = True`` - the position is **relative to the player**. The sound moves with the player and is always heard at the same relative offset. Use for UI feedback sounds, HUD beeps, or any sound that should follow the player.

Multi-Interpreter Python
========================

Limon Python scripting is built on pybind11. Each world instance gets its own **isolated Python interpreter** - scripts from one world cannot access or interfere with scripts from another.

Key behaviours:

* When a world is unloaded, its Python interpreter is torn down. Any global state in scripts running in that world (module-level variables, open resources) is released at that point.
* When a world is loaded (or reloaded), a fresh interpreter starts. Scripts do not carry state across world loads unless they persist data externally (e.g., to a file or via the engine's ``setVariable`` / ``getVariable`` API).
* C++ extensions and Python extensions can coexist in the same user library. A C++ Action and a Python Player Extension running in the same world share the same engine API instance but have separate execution contexts.

All five extension types are implementable in Python: Actions, Player Extensions, AI Actors, Camera Attachments, and RenderMethods. Python extensions have full parity with the C++ API - the same GenericParameter contract, the same enums, and automatic type conversion via pybind11.

.. note::
    Because Python interpreter state is world-scoped, be careful with module-level singletons or caches that assume persistent lifetime. An extension that registers itself globally on first load will re-register on every world load, which may cause double-registration if the pattern is not world-aware.
