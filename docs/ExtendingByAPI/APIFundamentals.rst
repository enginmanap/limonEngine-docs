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

Placing and Controlling Sounds
------------------------------

``playSound`` is the primary way to create a sound from an extension. It returns a sound world-object ID used for all subsequent control calls.

.. list-table::
   :header-rows: 1
   :widths: 55 45

   * - Method
     - Description
   * - ``playSound(soundPath, position, positionRelative, looped, referenceDistance=2.0, maxDistance=50.0, channel=SFX)``
     - Create and play a sound. Returns a sound world-object ID, or 0 on failure. (:ref:`C++ <LimonAPI-playSound>` | :ref:`Python <pythonApi-play_sound>`)
   * - ``stopSound(soundID)``
     - Stop and remove the sound from the world. (:ref:`C++ <LimonAPI-stopSound>` | :ref:`Python <pythonApi-stop_sound>`)
   * - ``pauseSound(soundID)``
     - Pause a playing sound. Can be resumed from the same position. (:ref:`C++ <LimonAPI-pauseSound>` | :ref:`Python <pythonApi-pause_sound>`)
   * - ``resumeSound(soundID)``
     - Resume a paused sound. (:ref:`C++ <LimonAPI-resumeSound>` | :ref:`Python <pythonApi-resume_sound>`)
   * - ``setSoundVolume(soundID, volume)``
     - Set per-sound gain. Effective gain = this × channel volume × master volume. (:ref:`C++ <LimonAPI-setSoundVolume>` | :ref:`Python <pythonApi-set_sound_volume>`)
   * - ``setSoundLooped(soundID, looped)``
     - Change loop state. Can transition a looping sound to one-shot after the current cycle. (:ref:`C++ <LimonAPI-setSoundLooped>` | :ref:`Python <pythonApi-set_sound_looped>`)
   * - ``isSoundPlaying(soundID)``
     - Returns ``True`` if currently playing or finishing a non-looped playthrough. (:ref:`C++ <LimonAPI-isSoundPlaying>` | :ref:`Python <pythonApi-is_sound_playing>`)

The ``positionRelative`` Parameter
-----------------------------------

``playSound`` accepts a boolean ``positionRelative`` argument:

* ``positionRelative = False`` - the position is a **world-space** coordinate. The sound stays fixed at that location regardless of where the player moves. Use for ambient sounds tied to geometry.
* ``positionRelative = True`` - the position is **relative to the player**. The sound moves with the player and is always heard at the same relative offset. Use for UI feedback sounds, HUD beeps, or any sound that should follow the player.

Attaching a Sound to a Moving Object
-------------------------------------

Sound is a first-class world object and participates in the standard attachment system. To make a sound follow a model or bone, create it with ``playSound`` and then attach it:

.. code-block:: cpp

   uint32_t soundID = limonAPI->playSound("footstep.wav", glm::vec3(0,0,0), false, true);
   limonAPI->attachObjectToObject(soundID, modelID);

The sound follows the model's transform every frame. To stop it, call ``stopSound(soundID)`` — this removes the sound from the world. Multiple sounds can be attached to the same model by attaching multiple sound world objects.

Audio Channels
--------------

Every sound is mixed on one of five channels. The effective gain of a sound is:
**per-sound gain × channel volume × master volume**.

.. list-table::
   :header-rows: 1
   :widths: 15 25 15 45

   * - Channel
     - Option name
     - ``playSound``
     - Description
   * - ``MASTER``
     - ``soundVolumeMaster``
     - **invalid**
     - Global volume multiplier applied to all channels. Not an assignable channel — passing it to ``playSound`` returns 0.
   * - ``MUSIC``
     - ``soundVolumeMusic``
     - **invalid**
     - Dedicated music channel. Managed exclusively by ``setMusic()`` / ``stopMusic()``. Passing it to ``playSound`` returns 0.
   * - ``SFX``
     - ``soundVolumeSFX``
     - default
     - Sound effects. Default channel for sounds played via ``playSound()``.
   * - ``SPEECH``
     - ``soundVolumeSpeech``
     - valid
     - Speech and voice-over.
   * - ``AMBIENT``
     - ``soundVolumeAmbient``
     - valid
     - Environmental / ambient sounds.

Channel volumes are global options, not API calls. Change them via ``getOptions()`` / ``saveOptions()`` using the option names above. See :ref:`OptionsReference` for the defaults.

.. note::
   Only mono audio files are spatialized by OpenAL. Stereo files play at a fixed volume regardless of position — ``positionRelative``, ``referenceDistance``, and ``maxDistance`` have no spatial effect on stereo sources. Use mono audio for any sound that needs 3D positioning.

.. note::
   The sound attenuation **model** (the mathematical curve — linear, inverse, etc.) is world-level and configured under World Properties in the editor. OpenAL does not support per-sound attenuation models. The per-sound ``referenceDistance`` and ``maxDistance`` parameters control the distances at which full volume and full attenuation are reached within whatever model the world uses.

Music API
---------

Each level has a single dedicated music track playing on the MUSIC channel, looped by default. Set in the editor under World Properties, or switched at runtime:

.. list-table::
   :header-rows: 1
   :widths: 55 45

   * - Method
     - Description
   * - ``setMusic(musicPath, fadeSeconds=0.0, looped=True)``
     - Switch level music. ``fadeSeconds=0``: immediate switch. ``fadeSeconds>0``: crossfade — outgoing track fades out while the new one fades in. Pass empty string to clear music. (:ref:`C++ <LimonAPI-setMusic>` | :ref:`Python <pythonApi-set_music>`)
   * - ``stopMusic(fadeSeconds=0.0)``
     - Stop level music with optional fade-out. Returns ``True`` if music was playing. (:ref:`C++ <LimonAPI-stopMusic>` | :ref:`Python <pythonApi-stop_music>`)
   * - ``getMusicName()``
     - Returns the current music asset path, or empty string if no music is set. (:ref:`C++ <LimonAPI-getMusicName>` | :ref:`Python <pythonApi-get_music_name>`)
   * - ``isMusicPlaying()``
     - Returns ``True`` if level music is currently playing. (:ref:`C++ <LimonAPI-isMusicPlaying>` | :ref:`Python <pythonApi-is_music_playing>`)

Named Variables
===============

The engine provides a world-scoped variable store for communicating state between extensions without direct coupling. Any extension can read or write a variable by name through the same API instance.

.. code-block:: cpp

   // Writer (e.g. an AI Actor that spotted the player)
   limonAPI->getVariable("alerted").value.boolValue = true;
   limonAPI->getVariable("alerted").valueType = LimonTypes::GenericParameter::ValueTypes::BOOLEAN;
   limonAPI->getVariable("alerted").isSet = true;

   // Reader (e.g. a Trigger that reacts to the alert)
   auto& v = limonAPI->getVariable("alerted");
   if(v.isSet && v.value.boolValue) { ... }

**C++**: ``getVariable(name)`` returns a **mutable reference** directly into the store. Assigning to the returned reference is the setter — there is no separate ``setVariable``.

**Python**: ``get_variable(name)`` and ``set_variable(name, value)`` are separate methods.

.. warning::
   Named variables are **not saved with the world**. They are runtime-only and reset to empty on every world load. Do not use them to carry state that must survive a level transition.

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
