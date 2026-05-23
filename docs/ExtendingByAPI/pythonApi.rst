Limon Engine Python API Documentation
=====================================

This page is the API reference for Python users.

.. contents:: Table of Contents
   :depth: 3
   :local:

Core Types
----------

Vec3
~~~~
3D vector class with comprehensive mathematical operations.

.. code-block:: python

    # Create Vec3 objects
    vec = Vec3(x=1.0, y=2.0, z=3.0)
    vec = Vec3()  # Defaults to (0, 0, 0)

    # Access components
    x, y, z = vec.x, vec.y, vec.z

    # Mathematical operations
    vec1 = Vec3(1, 2, 3)
    vec2 = Vec3(4, 5, 6)

    # Addition
    result = vec1 + vec2  # Vec3(5, 7, 9)
    vec1 += vec2          # In-place addition

    # Subtraction
    result = vec1 - vec2  # Vec3(-3, -3, -3)

    # Scalar multiplication
    result = vec1 * 2.0   # Vec3(2, 4, 6)

    # Vector operations
    dot_product = vec1.dot(vec2)
    cross_product = vec1.cross(vec2)

    # Length and normalization
    length = vec1.length()
    normalized = vec1.normalized()
    vec1.normalize()  # In-place normalization

    # Utility methods
    tuple_vec = vec1.to_tuple()
    list_vec = vec1.to_list()

    # Class methods for common vectors
    zero = Vec3.zero()      # (0, 0, 0)
    one = Vec3.one()        # (1, 1, 1)
    up = Vec3.up()          # (0, 1, 0)
    right = Vec3.right()    # (1, 0, 0)
    forward = Vec3.forward() # (0, 0, 1)

    # Create from GenericParameter
    vec3 = Vec3.from_generic_parameter(param)

Enums
~~~~~

**ValueType** and **RequestParameterType** are now defined as Python enums in the ``generic_parameter`` module:

.. code-block:: python

    from generic_parameter import RequestParameterType, ValueType, GenericParameter

    # ValueType enum
    class ValueType(Enum):
        STRING = 0
        DOUBLE = 1
        LONG = 2
        LONG_ARRAY = 3
        FLOAT_ARRAY = 4
        BOOLEAN = 5
        VEC4 = 6
        MAT4 = 7

    # RequestParameterType enum
    class RequestParameterType(Enum):
        MODEL = 0
        ANIMATION = 1
        SWITCH = 2
        FREE_TEXT = 3
        TRIGGER = 4
        GUI_TEXT = 5
        FREE_NUMBER = 6
        COORDINATE = 7
        TRANSFORM = 8
        MULTI_SELECT = 9

LogSubsystem
~~~~~~~~~~~~

Identifies which engine subsystem a log message belongs to. Used as the first argument to ``api.log()``.

.. code-block:: python

    import limon

    limon.LogSubsystem.RENDER    # graphics/rendering
    limon.LogSubsystem.MODEL     # model loading
    limon.LogSubsystem.INPUT     # input handling
    limon.LogSubsystem.SETTINGS  # options/settings
    limon.LogSubsystem.AI        # actor/AI system
    limon.LogSubsystem.LOAD_SAVE # world load/save
    limon.LogSubsystem.EDITOR    # editor
    limon.LogSubsystem.ANIMATION # animation system

LogLevel
~~~~~~~~

Severity level for a log message. Used as the second argument to ``api.log()``.

.. code-block:: python

    import limon

    limon.LogLevel.TRACE  # very verbose, internal tracing
    limon.LogLevel.DEBUG  # debug information
    limon.LogLevel.INFO   # general information
    limon.LogLevel.WARN   # warnings
    limon.LogLevel.ERROR  # errors

GenericParameter
~~~~~~~~~~~~~~~~
A flexible parameter type that can hold different types of values.

.. code-block:: python

    from generic_parameter import RequestParameterType, ValueType, GenericParameter

    # Create with enum values
    param = GenericParameter(
        request_type=RequestParameterType.FREE_TEXT,
        description="Parameter description",
        value_type=ValueType.STRING,
        value="Default value",
        is_set=True
    )

    # Create with integer values (backward compatibility)
    param = GenericParameter(
        request_type=3,  # RequestParameterType.FREE_TEXT
        description="Parameter description",
        value_type=0,    # ValueType.STRING
        value="Default value",
        is_set=True
    )

    # Type checking methods
    if param.is_string():
        text = param.get_string()
    elif param.is_vec4():
        vec4 = param.get_vec4()
    elif param.is_double():
        number = param.get_double()
    elif param.is_boolean():
        flag = param.get_boolean()
    elif param.is_long():
        integer = param.get_long()
    elif param.is_mat4():
        matrix = param.get_mat4()
    elif param.is_long_array():
        array = param.get_long_array()
    elif param.is_float_array():
        array = param.get_float_array()

Vec4
~~~~
4-component vector class.

.. code-block:: python

    vec = limon.Vec4(x=1.0, y=2.0, z=3.0, w=4.0)
    # Or using default values (0,0,0,0)
    vec = limon.Vec4()

    # Access components
    x, y, z, w = vec.x, vec.y, vec.z, vec.w

LimonAPI
--------

GUI Methods
~~~~~~~~~~~

add_gui_text
^^^^^^^^^^^^

.. code-block:: python

    def add_gui_text(font_file_path: str, font_size: int, name: str, text: str,
                    color: tuple = None, position: tuple = None, rotation: float = 0.0) -> int:
        """
        Add a text element to the GUI.

        Args:
            font_file_path: Path to the font file
            font_size: Size of the font
            name: Name of the text element
            text: The text to display
            color: RGB color as (r, g, b). Defaults to white (1.0, 1.0, 1.0).
            position: Position as (x, y). Defaults to (0.0, 0.0).
            rotation: Rotation in radians, clockwise. Defaults to 0.0.

        Returns:
            int: ID of the created GUI element
        """

add_gui_image
^^^^^^^^^^^^^

.. code-block:: python

    def add_gui_image(image_file_path: str, name: str, position: tuple = None,
                     scale: tuple = None, rotation: float = 0.0) -> int:
        """
        Add an image to the GUI.

        Args:
            image_file_path: Path to the image file
            name: Name of the image element
            position: Position as (x, y). Defaults to (0.0, 0.0).
            scale: Scale as (x, y). Defaults to (1.0, 1.0).
            rotation: Rotation in radians, clockwise. Defaults to 0.0.

        Returns:
            int: ID of the created GUI element
        """

update_gui_text
^^^^^^^^^^^^^^^

.. code-block:: python

    def update_gui_text(gui_text_id: int, new_text: str) -> bool:
        """
        Update the text of a GUI text element.

        Args:
            gui_text_id: ID of the GUI text element
            new_text: New text to display

        Returns:
            bool: True if the element was found and updated, False if ID is invalid
        """

remove_gui_element
^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def remove_gui_element(gui_element_id: int) -> bool:
        """
        Remove a GUI element.

        Args:
            gui_element_id: ID of the GUI element to remove

        Returns:
            bool: True if the element was found and removed, False if ID is invalid
        """

get_gui_element_position
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_gui_element_position(gui_element_id: int) -> Vec4:
        """
        Returns the screen position of a GUI element as Vec4 (x, y, 0, 1).

        Args:
            gui_element_id: ID of the GUI element

        Returns:
            Vec4: Screen position with w=1, or zero Vec4 if not found
        """

set_gui_element_position
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_gui_element_position(gui_element_id: int, position: Vec4) -> bool:
        """
        Set the screen position of a GUI element. x and y are used; z and w are ignored.

        Args:
            gui_element_id: ID of the GUI element
            position: Target screen-space position

        Returns:
            bool: True if the element was found and updated
        """

set_gui_element_visible
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_gui_element_visible(gui_element_id: int, visible: bool) -> bool:
        """
        Show or hide a GUI element. Hidden elements are not rendered but remain
        in the world and can be made visible again.

        Args:
            gui_element_id: ID of the GUI element
            visible: True to show, False to hide

        Returns:
            bool: True if the element was found and updated
        """

Object Manipulation
~~~~~~~~~~~~~~~~~~~

set_object_temporary
^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_object_temporary(object_id: int, temporary: bool) -> bool:
        """
        Set if an object is temporary (will be removed when world changes).

        Args:
            object_id: ID of the object
            temporary: True if object should be temporary

        Returns:
            bool: True if the object was found and updated
        """

attach_object_to_object
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def attach_object_to_object(object_id: int, object_to_attach_to_id: int) -> bool:
        """
        Attach one object to another.

        Args:
            object_id: ID of the object to attach
            object_to_attach_to_id: ID of the object to attach to

        Returns:
            bool: True if attachment succeeded
        """

remove_trigger_object
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def remove_trigger_object(trigger_object_id: int) -> bool:
        """
        Remove a trigger object.

        Args:
            trigger_object_id: ID of the trigger object

        Returns:
            bool: True if the object was found and removed
        """

is_inside_trigger
^^^^^^^^^^^^^^^^^

.. code-block:: python

    def is_inside_trigger(trigger_id: int) -> bool:
        """
        Returns True if a player is currently inside the trigger volume.

        Args:
            trigger_id: ID of the trigger object

        Returns:
            bool: True if the player is inside the volume, False if not or trigger not found
        """

get_object_by_name
^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_object_by_name(name: str) -> int:
        """
        Find an object by name. Searches models, GUI elements, and triggers.

        Args:
            name: The object name (for models: ``modelName_ID`` as shown in the editor)

        Returns:
            int: World object ID if found, 0 if not found
        """

get_object_parent
^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_object_parent(object_id: int) -> int:
        """
        Returns the parent object ID of the given object.

        Args:
            object_id: ID of the object

        Returns:
            int: Parent object ID, or 0 if no parent or object not found
        """

is_object_physics_connected
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def is_object_physics_connected(object_id: int) -> bool:
        """
        Returns True if the object is active in the physics simulation.

        Args:
            object_id: ID of the object

        Returns:
            bool: True if physics-connected, False if disconnected or not found
        """

get_object_linear_velocity
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_object_linear_velocity(object_id: int) -> Vec4:
        """
        Returns the linear velocity of an object's rigid body as Vec4 (w=0).
        Returns zero Vec4 if the object is not found or has no rigid body.

        Args:
            object_id: ID of the object

        Returns:
            Vec4: Linear velocity in world space, w=0
        """

set_object_linear_velocity
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_object_linear_velocity(object_id: int, velocity: Vec4) -> bool:
        """
        Set the linear velocity of an object's rigid body. Wakes the body if sleeping.

        Args:
            object_id: ID of the object
            velocity: Desired velocity in world space (w is ignored)

        Returns:
            bool: True if the object was found and velocity set
        """

get_object_mass
^^^^^^^^^^^^^^^

.. code-block:: python

    def get_object_mass(object_id: int) -> float:
        """
        Returns the mass of an object in kilograms. Returns 0.0 for static objects or if not found.

        Args:
            object_id: ID of the object

        Returns:
            float: Mass in kg, or 0.0 for static objects / not found
        """

disconnect_object_from_physics
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def disconnect_object_from_physics(object_id: int) -> bool:
        """
        Disable physics for an object.

        Args:
            object_id: ID of the object

        Returns:
            bool: True if the object was found and disconnected
        """

reconnect_object_to_physics
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def reconnect_object_to_physics(object_id: int) -> bool:
        """
        Re-enable physics for an object.

        Args:
            object_id: ID of the object

        Returns:
            bool: True if the object was found and reconnected
        """

apply_force
^^^^^^^^^^^

.. code-block:: python

    def apply_force(object_id: int, force_position: Vec4, force_amount: Vec4) -> bool:
        """
        Apply force to an object.

        Args:
            object_id: ID of the object
            force_position: Position where force is applied
            force_amount: Force vector and magnitude

        Returns:
            bool: True if force was applied successfully
        """

apply_force_to_player
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def apply_force_to_player(force_amount: Vec4) -> bool:
        """
        Apply force to the player.

        Args:
            force_amount: Force vector and magnitude

        Returns:
            bool: True if force was applied successfully
        """

add_object_translate
^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def add_object_translate(object_id: int, translation: Vec4) -> bool:
        """
        Add to an object's position.

        Args:
            object_id: ID of the object
            translation: Translation vector to add

        Returns:
            bool: True if translation was applied successfully
        """

add_object_scale
^^^^^^^^^^^^^^^^

.. code-block:: python

    def add_object_scale(object_id: int, scale: Vec4) -> bool:
        """
        Add to an object's scale.

        Args:
            object_id: ID of the object
            scale: Scale vector to add

        Returns:
            bool: True if scale was applied successfully
        """

add_object_orientation
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def add_object_orientation(object_id: int, orientation: Vec4) -> bool:
        """
        Add to an object's orientation (quaternion).

        Args:
            object_id: ID of the object
            orientation: Quaternion orientation to add

        Returns:
            bool: True if orientation was applied successfully
        """

get_object_transformation
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_object_transformation(object_id: int) -> list:
        """
        Get an object's transformation as three Vec4 parameters.

        Args:
            object_id: ID of the object

        Returns:
            list: [translate (Vec4), scale (Vec4), orientation quaternion (Vec4 x,y,z,w)],
                  or empty list if object not found.

        Note:
            Prefer get_object_transformation_matrix() when you need the final world matrix.
            Physical objects can define collision-shape offsets that are baked into the matrix
            but are not reflected in the decomposed TRS values returned here. Use this method
            only when you specifically need the individual translate/scale/orientation components.
        """

set_object_translate
^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_object_translate(object_id: int, position: Vec4) -> bool:
        """
        Set an object's world position.

        Args:
            object_id: ID of the object
            position: New world position (w component ignored)

        Returns:
            bool: True if successful, False if object not found
        """

set_object_scale
^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_object_scale(object_id: int, scale: Vec4) -> bool:
        """
        Set an object's scale.

        Args:
            object_id: ID of the object
            scale: New scale (w component ignored)

        Returns:
            bool: True if successful, False if object not found
        """

set_object_orientation
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_object_orientation(object_id: int, orientation: Vec4) -> bool:
        """
        Set an object's orientation as a quaternion.

        Args:
            object_id: ID of the object
            orientation: Quaternion as Vec4 (x, y, z, w)

        Returns:
            bool: True if successful, False if object not found
        """

get_object_transformation_matrix
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_object_transformation_matrix(object_id: int) -> list:
        """
        Get an object's transformation matrix.

        Args:
            object_id: ID of the object

        Returns:
            list: List of GenericParameter objects containing the 4x4 transformation matrix
        """

get_model_children
^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_model_children(model_id: int) -> list:
        """
        Get children of a model.

        Args:
            model_id: ID of the model

        Returns:
            list: List of child object IDs
        """

set_model_animation
^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_model_animation(model_id: int, animation_name: str, looped: bool = True) -> bool:
        """
        Set an animation for a model.

        Args:
            model_id: ID of the model
            animation_name: Name of the animation to play
            looped: Whether the animation should loop

        Returns:
            bool: True if the model was found and animation applied
        """

set_model_animation_with_blend
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_model_animation_with_blend(model_id: int, animation_name: str, looped: bool = True, blend_time: int = 100) -> bool:
        """
        Set an animation for a model with blending.

        Args:
            model_id: ID of the model
            animation_name: Name of the animation to play
            looped: Whether the animation should loop
            blend_time: Time in milliseconds to blend from the previous animation

        Returns:
            bool: True if the model was found and animation applied
        """

set_model_animation_speed
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_model_animation_speed(model_id: int, speed: float) -> bool:
        """
        Set the animation speed for a model.

        Args:
            model_id: ID of the model
            speed: Animation speed multiplier (1.0 = normal speed)

        Returns:
            bool: True if the model was found and speed applied
        """

get_model_animation_name
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_model_animation_name(model_id: int) -> str:
        """
        Get the name of the current animation for a model.

        Args:
            model_id: ID of the model

        Returns:
            str: Name of the current animation
        """

get_model_animation_finished
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_model_animation_finished(model_id: int) -> bool:
        """
        Check if model's animation has finished.

        Args:
            model_id: ID of the model

        Returns:
            bool: True if animation has finished
        """

get_model_animation_progress
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_model_animation_progress(model_id: int) -> float:
        """
        Returns the normalized progress [0.0, 1.0] of the custom animation currently
        running on the model (started via animate_model). For looped animations the
        value wraps back to 0.0 at the end of each cycle.

        Args:
            model_id: ID of the model

        Returns:
            float: Progress in [0.0, 1.0], or 0.0 if no active custom animation
        """

list_model_animations
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def list_model_animations(model_id: int) -> list:
        """
        Returns the names of all animations embedded in the model's asset file.
        These names can be passed to set_model_animation.

        Args:
            model_id: ID of the model

        Returns:
            list[str]: Animation names, or an empty list if the model is not found
        """

animate_model
^^^^^^^^^^^^^

.. code-block:: python

    def animate_model(model_id: int, animation_id: int, looped: bool = False, sound_path: str = "") -> int:
        """
        Animate a model with a specific animation ID (numeric, not by name).

        Args:
            model_id: ID of the model
            animation_id: Index of the animation in the world's loaded animation list
            looped: Whether the animation should loop
            sound_path: Path to a sound file to play with the animation. Pass "" for no sound.

        Returns:
            int: Animation status ID, or 0 on failure
        """

add_object
^^^^^^^^^^

.. code-block:: python

    def add_object(model_file_path: str, model_weight: float = 1.0, physical: bool = True,
                   position: tuple = (0, 0, 0), scale: tuple = (1, 1, 1),
                   orientation: tuple = (1.0, 0.0, 0.0, 0.0)) -> int:
        """
        Add a new object to the scene.

        Args:
            model_file_path: Path to the model file
            model_weight: Physics mass of the object
            physical: Whether the object participates in physics simulation
            position: Initial position as (x, y, z)
            scale: Initial scale as (x, y, z)
            orientation: Initial orientation as quaternion (w, x, y, z)

        Returns:
            int: ID of the created object, or 0 on failure
        """

remove_object
^^^^^^^^^^^^^

.. code-block:: python

    def remove_object(object_id: int, remove_children: bool = True) -> bool:
        """
        Remove an object from the scene.

        Args:
            object_id: ID of the object to remove
            remove_children: Whether to also remove child objects

        Returns:
            bool: True if the object was found and removed
        """

get_result_of_trigger
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_result_of_trigger(trigger_object_id: int, trigger_code_id: int) -> list:
        """
        Get the result parameters of a trigger.

        Args:
            trigger_object_id: ID of the trigger object
            trigger_code_id: Code ID selecting which result set to retrieve

        Returns:
            list: List of GenericParameter objects with the trigger's results
        """

Sound
~~~~~

attach_sound_to_object_and_play
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def attach_sound_to_object_and_play(object_id: int, sound_path: str, looped: bool = True) -> bool:
        """
        Attach a sound to an object and begin playing it.

        Args:
            object_id: ID of the object to attach the sound to
            sound_path: Path to the sound file
            looped: Whether the sound should loop. Defaults to True.

        Returns:
            bool: True if the sound was attached and started
        """

detach_sound_from_object
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def detach_sound_from_object(object_id: int) -> bool:
        """
        Detach a sound from an object and stop playing it.

        Args:
            object_id: ID of the object

        Returns:
            bool: True if a sound was found and detached
        """

play_sound
^^^^^^^^^^

.. code-block:: python

    def play_sound(sound_path: str, position: Vec4, position_relative: bool = False, looped: bool = False) -> int:
        """
        Play a non-attached sound at a world position.

        Args:
            sound_path: Path to the sound file
            position: World-space position to play the sound at
            position_relative: If True, position is relative to the listener
            looped: Whether the sound should loop

        Returns:
            int: Sound ID for use with stop_sound and set_sound_volume, or 0 on failure
        """

stop_sound
^^^^^^^^^^

.. code-block:: python

    def stop_sound(sound_id: int) -> bool:
        """
        Stop a playing sound.

        Args:
            sound_id: Sound ID returned by play_sound

        Returns:
            bool: True if the sound was found and stopped
        """

set_sound_volume
^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_sound_volume(sound_id: int, volume: float) -> bool:
        """
        Set the volume (gain) of a sound.

        Args:
            sound_id: Sound ID returned by play_sound
            volume: New gain value

        Returns:
            bool: True if the sound was found and volume updated. False if not found or sound not yet started
        """

is_sound_playing
^^^^^^^^^^^^^^^^

.. code-block:: python

    def is_sound_playing(sound_id: int) -> bool:
        """
        Returns True if the sound is currently playing.

        Args:
            sound_id: Sound ID returned by play_sound

        Returns:
            bool: True if playing, False if stopped or not found
        """

AI Interaction
~~~~~~~~~~~~~~

interact_with_ai
^^^^^^^^^^^^^^^^

.. code-block:: python

    def interact_with_ai(ai_id: int, interaction_information: list) -> bool:
        """
        Send interaction data to an AI actor.

        Args:
            ai_id: ID of the AI actor
            interaction_information: List of GenericParameter objects with interaction data

        Returns:
            bool: True if the actor was found and interaction delivered
        """

interact_with_player
^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def interact_with_player(interaction_information: list) -> None:
        """
        Send interaction data to the active player extension.

        Args:
            interaction_information: List of GenericParameter objects with interaction data
        """

Particle Systems
~~~~~~~~~~~~~~~~

disable_particle_emitter
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def disable_particle_emitter(emitter_id: int) -> bool:
        """
        Disable a particle emitter, stopping new particle emission.

        Args:
            emitter_id: ID of the particle emitter

        Returns:
            bool: True if the emitter was found and disabled
        """

enable_particle_emitter
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def enable_particle_emitter(emitter_id: int) -> bool:
        """
        Enable a particle emitter, resuming particle emission.

        Args:
            emitter_id: ID of the particle emitter

        Returns:
            bool: True if the emitter was found and enabled
        """

add_particle_emitter
^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def add_particle_emitter(name: str, texture_file: str, start_position: Vec4,
                             max_start_distances: Vec4, size: float, count: int,
                             life_time: float, particles_per_ms: float,
                             continuously_emit: bool) -> int:
        """
        Add a new particle emitter to the scene.

        Args:
            name: Name of the emitter
            texture_file: Path to the particle texture file
            start_position: World-space origin of the emitter
            max_start_distances: Maximum random spawn offsets per axis (Vec4)
            size: Size of each particle
            count: Maximum number of live particles
            life_time: Lifetime of each particle in seconds
            particles_per_ms: Emission rate in particles per millisecond
            continuously_emit: If True, emitter loops indefinitely

        Returns:
            int: Emitter ID, or 0 on failure
        """

remove_particle_emitter
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def remove_particle_emitter(emitter_id: int) -> bool:
        """
        Remove a particle emitter from the scene.

        Args:
            emitter_id: ID of the particle emitter

        Returns:
            bool: True if the emitter was found and removed
        """

set_emitter_particle_speed
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_emitter_particle_speed(emitter_id: int, speed_multiplier: Vec4, speed_offset: Vec4) -> bool:
        """
        Set the speed parameters for particles emitted by an emitter.

        Args:
            emitter_id: ID of the particle emitter
            speed_multiplier: Per-axis speed multiplier (Vec4)
            speed_offset: Per-axis constant speed offset (Vec4)

        Returns:
            bool: True if the emitter was found and updated
        """

set_emitter_particle_gravity
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_emitter_particle_gravity(emitter_id: int, gravity: Vec4) -> bool:
        """
        Set the per-axis gravity applied to particles from an emitter.

        Args:
            emitter_id: ID of the particle emitter
            gravity: Per-axis gravity vector (Vec4)

        Returns:
            bool: True if the emitter was found and updated
        """

Ray Casting
~~~~~~~~~~~

ray_cast_to_cursor
^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def ray_cast_to_cursor() -> list:
        """
        Cast a ray from camera to cursor position.

        Returns:
            list: List of GenericParameter objects containing hit details such as:
                  - hit coordinates (VEC4)
                  - hit object ID (LONG)
                  - hit normal vector (VEC4)
                  - distance to hit (DOUBLE)
        """

ray_cast_first_hit
^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def ray_cast_first_hit(start: Vec4, direction: Vec4) -> list:
        """
        Cast a ray from start point in direction and return the first hit.

        Args:
            start: Starting position as Vec4 (w component ignored)
            direction: Direction vector as Vec4 (w component ignored, need not be normalized)

        Returns:
            list: List of GenericParameter objects containing hit details:
                  - hit coordinates (VEC4)
                  - hit object ID (LONG)
                  - hit normal vector (VEC4)
                  - distance to hit (DOUBLE)
                  Empty list if nothing was hit.
        """

Lighting
~~~~~~~~

add_light
^^^^^^^^^

.. code-block:: python

    def add_light(light_type: int, position: Vec4, color: Vec4) -> int:
        """
        Add a new light to the scene.

        Args:
            light_type: Light type — 1 for directional, 2 for point
            position: World-space position of the light
            color: RGB color of the light (Vec4; w is ignored)

        Returns:
            int: Light ID, or 0 on failure
        """

remove_light
^^^^^^^^^^^^

.. code-block:: python

    def remove_light(light_id: int) -> bool:
        """
        Remove a light from the scene.

        Args:
            light_id: Handle ID of the light

        Returns:
            bool: True if the light was found and removed
        """

add_light_translate
^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def add_light_translate(light_id: int, translation: Vec4) -> bool:
        """
        Translate a light by adding to its current position.

        Args:
            light_id: Handle ID of the light
            translation: Translation to add (w component ignored)

        Returns:
            bool: True if the light was found and moved
        """

set_light_color
^^^^^^^^^^^^^^^

.. code-block:: python

    def set_light_color(light_id: int, color: Vec4) -> bool:
        """
        Set a light's color.

        Args:
            light_id: Handle ID of the light
            color: RGB color with components in [0, 1] (w component ignored)

        Returns:
            bool: True if the light was found and updated
        """

get_light_position
^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_light_position(light_id: int) -> Vec4:
        """
        Returns the world-space position of a light as Vec4 (w=1).

        Args:
            light_id: Handle ID of the light

        Returns:
            Vec4: World-space position with w=1, or zero Vec4 if not found
        """

get_light_color
^^^^^^^^^^^^^^^

.. code-block:: python

    def get_light_color(light_id: int) -> Vec4:
        """
        Returns the color of a light as Vec4 (w=1).

        Args:
            light_id: Handle ID of the light

        Returns:
            Vec4: RGB color with w=1, or zero Vec4 if not found
        """

set_light_translate
^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_light_translate(light_id: int, position: Vec4) -> bool:
        """
        Set the absolute world-space position of a light. Unlike add_light_translate,
        this replaces the current position rather than adding to it.

        Args:
            light_id: Handle ID of the light
            position: Target world-space position (w component ignored)

        Returns:
            bool: True if the light was found and updated
        """

World Management
~~~~~~~~~~~~~~~~

load_and_switch_world
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def load_and_switch_world(world_file_name: str) -> bool:
        """
        Load a world and switch to it. If already loaded, resets it.

        Args:
            world_file_name: File name of the world to load

        Returns:
            bool: False if load fails or if the caller is part of the current world
                  (a world cannot remove itself)
        """

return_to_world
^^^^^^^^^^^^^^^

.. code-block:: python

    def return_to_world(world_file_name: str) -> bool:
        """
        Load a world if not already loaded, then switch to it.

        Args:
            world_file_name: File name of the world to switch to

        Returns:
            bool: False if load fails
        """

load_and_remove
^^^^^^^^^^^^^^^

.. code-block:: python

    def load_and_remove(world_file_name: str) -> bool:
        """
        Load a new world and remove the current one.

        Args:
            world_file_name: File name of the world to load

        Returns:
            bool: False if load fails
        """

return_previous_world
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def return_previous_world() -> None:
        """
        Return to the previously loaded world. No-op if no previous world exists.
        """

quit_game
^^^^^^^^^

.. code-block:: python

    def quit_game() -> None:
        """
        Quit the game.
        """

change_render_pipeline
^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def change_render_pipeline(pipeline_file_name: str) -> bool:
        """
        Change the active render pipeline.

        Args:
            pipeline_file_name: File name of the pipeline to load

        Returns:
            bool: False if the pipeline file could not be loaded
        """

get_options
^^^^^^^^^^^

.. code-block:: python

    def get_options() -> any:
        """
        Get the engine options object.

        Returns:
            Options object with current engine configuration
        """

Timed Events
~~~~~~~~~~~~

add_timed_event
^^^^^^^^^^^^^^^

.. code-block:: python

    def add_timed_event(wait_time: int, use_wall_time: bool, callback: callable,
                      parameters: list = None) -> int:
        """
        Schedule a function to be called after a specified delay.

        Args:
            wait_time: Time to wait before triggering the event, in milliseconds
            use_wall_time: If True, uses real wall-clock time and is unaffected by
                         game pause or world transitions. If False, uses in-game time
                         which stops when the game is paused or a menu world is loaded.
            callback: Python function to call when the timer expires.
                     The function should accept a single parameter which will be the
                     list of parameters provided.
            parameters: Optional list of GenericParameter objects to pass to the callback.
                       Pass None or omit to use no parameters.

        Returns:
            int: ID of the created timer event, which can be used to cancel it.
        """

cancel_timed_event
^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def cancel_timed_event(timer_id: int) -> bool:
        """
        Cancel a previously scheduled timed event.

        Args:
            timer_id: ID of the timer event to cancel (returned by add_timed_event)

        Returns:
            bool: True if the event was successfully cancelled, False if not found
        """

Profiling
~~~~~~~~~

profile_scope
^^^^^^^^^^^^^

.. code-block:: python

    def profile_scope(name: str):
        """
        Open a named Tracy profiler zone. Returns a context manager; the zone
        closes when the ``with`` block exits.

        Args:
            name: Label shown in the Tracy profiler timeline.

        Example:
            with api.profile_scope("MyActor::play"):
                # ... work being profiled ...
                pass
        """

Player Related
~~~~~~~~~~~~~~

kill_player
^^^^^^^^^^^

.. code-block:: python

    def kill_player() -> None:
        """
        Kill the player.
        """

get_player_position
^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_player_position() -> Vec4:
        """
        Returns the player's world position as Vec4 (w=1).

        Returns:
            Vec4: Player world position with w=1
        """

get_player_look_direction
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_player_look_direction() -> Vec4:
        """
        Returns the player's normalized look direction as Vec4 (w=0).

        Returns:
            Vec4: Normalized look direction with w=0
        """

get_camera_position
^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_camera_position() -> Vec4:
        """
        Returns the camera's world position as Vec4 (w=1). May differ from player position
        if a PlayerExtension overrides the camera attachment.

        Returns:
            Vec4: Camera world position with w=1
        """

get_camera_look_direction
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_camera_look_direction() -> Vec4:
        """
        Returns the camera's normalized look direction as Vec4 (w=0). May differ from player
        look direction if a PlayerExtension overrides the camera attachment.

        Returns:
            Vec4: Normalized camera look direction with w=0
        """

get_player_attached_model
^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_player_attached_model() -> int:
        """
        Get the ID of the model currently attached to the player.

        Returns:
            int: Model ID, or 0 if no model is attached
        """

get_player_attached_model_offset
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_player_attached_model_offset() -> Vec4:
        """
        Get the position offset of the model attached to the player.

        Returns:
            Vec4: Offset vector
        """

set_player_attached_model_offset
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_player_attached_model_offset(new_offset: Vec4) -> bool:
        """
        Set the position offset of the model attached to the player.

        Args:
            new_offset: New offset as Vec4

        Returns:
            bool: True if the offset was applied
        """

Variable Management
~~~~~~~~~~~~~~~~~~~

.. note::

    Variables are **not** saved with the world. They exist only for the lifetime of
    the current world session and are lost on world reload or world switch.
    Use them for transient in-session state only.

.. note::

    Any parameter passed to the editor must have ``is_set = True``.
    The editor will refuse to save a trigger if any parameter is not set.

get_variable
^^^^^^^^^^^^

.. code-block:: python

    def get_variable(variable_name: str) -> GenericParameter:
        """
        Get (or create) a script variable by name. Returns a reference — mutate it in place.

        Args:
            variable_name: Name of the variable

        Returns:
            GenericParameter: Reference to the variable's GenericParameter
        """

Logging
~~~~~~~

log
^^^

.. code-block:: python

    def log(subsystem: limon.LogSubsystem, level: limon.LogLevel, text: str) -> None:
        """
        Write a message to the engine log.

        Args:
            subsystem: Which subsystem the message belongs to (limon.LogSubsystem.*)
            level:     Severity of the message (limon.LogLevel.*)
            text:      The message text

        Example:
            api.log(limon.LogSubsystem.AI,    limon.LogLevel.INFO,  "actor reached waypoint")
            api.log(limon.LogSubsystem.INPUT, limon.LogLevel.WARN,  "unexpected input state")
        """

Debug Line Drawing
~~~~~~~~~~~~~~~~~~

Lines are stored in numbered buffers managed by the engine. Each buffer persists across frames
until explicitly removed. The typical per-frame pattern is **clear → draw**.

draw_debug_line
^^^^^^^^^^^^^^^

.. code-block:: python

    def draw_debug_line(from_pos: Vec4, to_pos: Vec4,
                        from_color: Vec4, to_color: Vec4,
                        require_camera_transform: bool = True) -> int:
        """
        Create a new debug line buffer containing one line segment.

        Args:
            from_pos:                 World-space start point (w ignored)
            to_pos:                   World-space end point (w ignored)
            from_color:               RGB color at the start vertex (w ignored)
            to_color:                 RGB color at the end vertex (w ignored)
            require_camera_transform: True for 3D world-space lines; False for 2D screen-space

        Returns:
            int: Buffer ID — pass to add_to_debug_line() or clear_debug_lines()
        """

add_to_debug_line
^^^^^^^^^^^^^^^^^

.. code-block:: python

    def add_to_debug_line(buffer_id: int,
                          from_pos: Vec4, to_pos: Vec4,
                          from_color: Vec4, to_color: Vec4,
                          require_camera_transform: bool = True) -> bool:
        """
        Append a line segment to an existing debug line buffer.

        Args:
            buffer_id:                ID returned by draw_debug_line()
            from_pos:                 World-space start point (w ignored)
            to_pos:                   World-space end point (w ignored)
            from_color:               RGB color at the start vertex (w ignored)
            to_color:                 RGB color at the end vertex (w ignored)
            require_camera_transform: Should match the value used when the buffer was created

        Returns:
            bool: True on success; False if buffer_id is not found
        """

clear_debug_lines
^^^^^^^^^^^^^^^^^

.. code-block:: python

    def clear_debug_lines(buffer_id: int) -> bool:
        """
        Remove a debug line buffer, hiding all its segments immediately.

        Args:
            buffer_id: ID returned by draw_debug_line()

        Returns:
            bool: True on success; False if buffer_id is not found

        Example (per-frame pattern inside an actor's play() or camera's getCameraVariables()):
            if self._line_buf != 0:
                api.clear_debug_lines(self._line_buf)
            self._line_buf = api.draw_debug_line(
                limon.Vec4(x1, y1, z1, 1), limon.Vec4(x2, y2, z2, 1),
                limon.Vec4(1, 0, 0, 1),    limon.Vec4(1, 0, 0, 1))
        """

Input System
------------

Input Methods
~~~~~~~~~~~~~

simulate_input
^^^^^^^^^^^^^^

.. code-block:: python

    def simulate_input(input_states: InputStates) -> None:
        """
        Simulate input events.

        Args:
            input_states: InputStates object with the events to inject
        """

get_mouse_change
^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_mouse_change() -> tuple:
        """
        Get mouse change information.

        Returns:
            tuple: (changed, x_pos, y_pos, x_change, y_change)
        """

set_mouse_change
^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_mouse_change(x_pos: float, y_pos: float, x_change: float, y_change: float) -> None:
        """
        Set mouse change on an InputStates object.

        Args:
            x_pos: Absolute X position
            y_pos: Absolute Y position
            x_change: Delta X since last frame
            y_change: Delta Y since last frame
        """

get_text
^^^^^^^^

.. code-block:: python

    def get_text() -> str:
        """
        Get the current text input from an InputStates object.

        Returns:
            str: Current text input string
        """

set_text
^^^^^^^^

.. code-block:: python

    def set_text(text: str) -> None:
        """
        Set text input on an InputStates object.

        Args:
            text: Text to inject
        """

reset_all_events
^^^^^^^^^^^^^^^^

.. code-block:: python

    def reset_all_events() -> None:
        """
        Reset all input events on an InputStates object.
        """

get_input_events
^^^^^^^^^^^^^^^^

.. code-block:: python

    def get_input_events(input_code: int) -> bool:
        """
        Get input events for a specific input code.

        Args:
            input_code: Input code to query (see Inputs class)

        Returns:
            bool: True if the input is currently active
        """

Input States
~~~~~~~~~~~~

.. code-block:: python

    class Inputs:
        QUIT = 0
        MOUSE_MOVE = 1
        MOUSE_BUTTON_LEFT = 2
        MOUSE_BUTTON_MIDDLE = 3
        MOUSE_BUTTON_RIGHT = 4
        MOUSE_WHEEL_UP = 5
        MOUSE_WHEEL_DOWN = 6
        MOVE_FORWARD = 7
        MOVE_BACKWARD = 8
        MOVE_LEFT = 9
        MOVE_RIGHT = 10
        JUMP = 11
        RUN = 12
        DEBUG = 13
        EDITOR = 14
        KEY_SHIFT = 15
        KEY_CTRL = 16
        KEY_ALT = 17
        KEY_SUPER = 18
        TEXT_INPUT = 19
        NUMBER_1 = 20
        NUMBER_2 = 21
        F4 = 22

    # Example usage:
    if input_states.get_input_status(limon.Inputs.MOVE_FORWARD):
        # Move forward
        pass

Camera System
-------------

CameraAttachment
~~~~~~~~~~~~~~~~
Base class for custom camera attachments.

.. code-block:: python

    class MyCamera(limon.CameraAttachment):
        def __init__(self, limon_api):
            super().__init__(limon_api)

        def is_dirty(self) -> bool:
            """Return True if the camera parameters have changed."""
            return True

        def clear_dirty(self) -> None:
            """Mark the camera parameters as clean."""
            pass

        def get_camera_variables(self, position: Vec3, center: Vec3, up: Vec3, right: Vec3) -> None:
            """
            Get camera position and orientation.

            The parameters are Vec3 objects that can be modified directly.
            Changes to these objects will be reflected in the camera.

            Args:
                position: Camera position vector (modifiable)
                center: Camera center/look-at point (modifiable)
                up: Camera up vector (modifiable)
                right: Camera right vector (modifiable)
            """

Trigger Interface
-----------------

Base class for creating custom triggers.

.. code-block:: python

    class MyTrigger(limon.TriggerInterface):
        def __init__(self, limon_api):
            super().__init__(limon_api)
            self._limon_api = limon_api

        def get_parameters(self) -> list:
            """
            Return a list of parameters this trigger requires.

            Returns:
                list: List of GenericParameter objects
            """
            from generic_parameter import RequestParameterType, ValueType, GenericParameter
            param = GenericParameter()
            param.request_type = RequestParameterType.FREE_TEXT
            param.description = "Message to display"
            param.value = "Hello from Python!"
            return [param]

        def run(self, parameters: list) -> bool:
            """
            Called when the trigger is activated.

            Args:
                parameters: List of GenericParameter objects with user-provided values

            Returns:
                bool: True if successful, False otherwise
            """
            if parameters and parameters[0].is_set:
                message = parameters[0].value
                print(f"Trigger activated: {message}")
            return True

        def get_results(self) -> list:
            """
            Return any results from the trigger execution.

            Returns:
                list: List of GenericParameter objects with results
            """
            return []

        def get_name(self) -> str:
            """
            Get the name of this trigger.

            Returns:
                str: The trigger's name
            """
            return "My Custom Trigger"

Player Extension Interface
--------------------------

Base class for creating player extensions.

.. code-block:: python

    class MyPlayerExtension(limon.PlayerExtensionInterface):
        def __init__(self, limon_api):
            super().__init__(limon_api)
            self._limon_api = limon_api

        def process_input(self, input_states, player_info, time):
            """
            Process input for the player.

            Args:
                input_states: InputStates object containing current input state
                player_info: PlayerInformation object with player state
                time: Current game time
            """
            if input_states.get_input_status(limon.Inputs.KEY_SPACE):
                print("Jump!")

        def interact(self, interaction_data):
            """
            Handle interaction with the player.

            Args:
                interaction_data: List of GenericParameter objects with interaction data
            """
            print(f"Player interaction: {interaction_data}")

        def get_name(self) -> str:
            """
            Get the name of this extension.

            Returns:
                str: The extension's name
            """
            return "My Player Extension"

        def get_custom_camera_attachment(self):
            """
            Get a custom camera attachment for this extension.

            Returns:
                CameraAttachment: A camera attachment, or None to use default
            """
            return None

Actor Interface
---------------

Base class for creating AI actors.

.. code-block:: python

    class MyActor(limon.ActorInterface):
        def __init__(self, limon_api):
            super().__init__(limon_api)
            self._limon_api = limon_api

        def get_name(self) -> str:
            """
            Get the name of this actor.

            Returns:
                str: The actor's name
            """
            return "My Custom Actor"

        def play(self, time: int, actor_information):
            """
            Called each frame to update the actor's behavior.

            Args:
                time: Current game time
                actor_information: ActorInformation object with environment state
            """
            if actor_information.can_see_player_directly:
                print("Player spotted!")
                # React to player

        def interaction(self, interaction_data):
            """
            Handle interaction with this actor.

            Args:
                interaction_data: List of GenericParameter objects with interaction data

            Returns:
                bool: True if interaction was successful
            """
            print(f"Actor interaction: {interaction_data}")
            return True

        def get_parameters(self):
            """
            Get the current parameters of this actor.

            Returns:
                list: List of GenericParameter objects
            """
            from generic_parameter import RequestParameterType, ValueType, GenericParameter
            param = GenericParameter()
            param.request_type = RequestParameterType.FREE_TEXT
            param.description = "Actor behavior"
            param.value = "friendly"
            return [param]

        def set_parameters(self, parameters):
            """
            Set the parameters of this actor.

            Args:
                parameters: List of GenericParameter objects to set
            """
            if parameters and parameters[0].is_set:
                behavior = parameters[0].value
                print(f"Setting actor behavior to: {behavior}")

ActorInformation
~~~~~~~~~~~~~~~~

Contains information about the actor's environment and player state, passed to the `play()` method of ActorInterface.

**Player Visibility and Position Detection**

``can_see_player_directly`` : bool
    True if the actor has direct line of sight to the player.

``is_player_left`` : bool
    True if the player is to the left of the actor.

``is_player_right`` : bool
    True if the player is to the right of the actor.

``is_player_up`` : bool
    True if the player is above the actor.

``is_player_down`` : bool
    True if the player is below the actor.

``is_player_front`` : bool
    True if the player is in front of the actor.

``is_player_back`` : bool
    True if the player is behind the actor.

**Player Relationship and Spatial Information**

``cosine_between_player`` : float
    Cosine of the angle between actor's forward vector and direction to player.
    Range: -1.0 (opposite direction) to 1.0 (same direction).

``player_direction`` : tuple
    Vector from actor to player position as (x, y, z).

``player_distance`` : float
    Distance from actor to player.

``cosine_between_player_for_side`` : float
    Cosine of the angle for side detection (left/right).

``player_dead`` : bool
    True if the player is dead.

**Pathfinding Information**

``route_to_request`` : list
    List of Vec3 waypoints for pathfinding route to requested destination.

``maximum_route_distance`` : int
    Maximum route distance in node count (default: 128).

``route_found`` : bool
    True if a valid route was found.

``route_ready`` : bool
    True if the route data is ready for use.

**Usage Example**

.. code-block:: python

    class MyActor(limon.ActorInterface):
        def play(self, time: int, actor_information):
            # Check if player is visible
            if actor_information.can_see_player_directly:
                print(f"Player spotted at distance {actor_information.player_distance}")

                # Check player position relative to actor
                if actor_information.is_player_front:
                    print("Player is in front")
                elif actor_information.is_player_back:
                    print("Player is behind")

                # Use cosine values for precise angle calculations
                if abs(actor_information.cosine_between_player) > 0.9:
                    print("Player is directly facing or opposite to actor")

            # Check pathfinding status
            if actor_information.route_ready and actor_information.route_found:
                print(f"Route found with {len(actor_information.route_to_request)} waypoints")

            # Check if player is dead
            if actor_information.player_dead:
                print("Player is dead")

Utility Functions
-----------------

.. code-block:: python

    # Create a new Vec4
    vec = limon.create_vec4(x=1.0, y=2.0, z=3.0, w=4.0)

    # Register custom trigger, extension and actor types
    limon.register_trigger_type(name: str, factory_function)
    limon.register_extension_type(name: str, factory_function)
    limon.register_actor_type(name: str, factory_function)

    # Get available trigger, extension and actor names
    trigger_names = limon.get_trigger_names()
    extension_names = limon.get_extension_names()
    actor_names = limon.get_actor_names()

    # Create player extension and actor dynamically
    extension = limon.PlayerExtensionInterface.create_extension(name: str, limon_api)
    actor = limon.ActorInterface.create_actor(name: str, id: int, limon_api)

Best Practices
--------------

1. **Error Handling**: Always wrap API calls in try-except blocks.
2. **Resource Management**: Clean up resources when they're no longer needed.
3. **Performance**: Cache frequently accessed values and avoid expensive operations in tight loops.
4. **Thread Safety**: The Python API is not thread-safe. Call API methods from the main thread.
5. **Memory Management**: Be careful with object references to prevent memory leaks.
6. **Error Reporting**: Provide meaningful error messages for debugging.
7. **Compatibility**: Test your scripts with different versions of the engine.
8. **Documentation**: Document your code and provide usage examples.
