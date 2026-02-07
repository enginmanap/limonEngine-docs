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
        BOOLEAN = 4
        VEC4 = 5
        MAT4 = 6

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
            rotation: Rotation in degrees. Defaults to 0.0.

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
            rotation: Rotation in degrees. Defaults to 0.0.

        Returns:
            int: ID of the created GUI element
        """

update_gui_text
^^^^^^^^^^^^^^^

.. code-block:: python

    def update_gui_text(gui_text_id: int, new_text: str) -> None:
        """
        Update the text of a GUI text element.

        Args:
            gui_text_id: ID of the GUI text element
            new_text: New text to display
        """

remove_gui_element
^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def remove_gui_element(gui_element_id: int) -> None:
        """
        Remove a GUI element.

        Args:
            gui_element_id: ID of the GUI element to remove
        """

Object Manipulation
~~~~~~~~~~~~~~~~~~~

set_object_temporary
^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_object_temporary(object_id: int, temporary: bool) -> None:
        """
        Set if an object is temporary (will be removed when world changes).

        Args:
            object_id: ID of the object
            temporary: True if object should be temporary
        """

attach_object_to_object
^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def attach_object_to_object(object_id: int, object_to_attach_to_id: int) -> None:
        """
        Attach one object to another.

        Args:
            object_id: ID of the object to attach
            object_to_attach_to_id: ID of the object to attach to
        """

remove_trigger_object
^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def remove_trigger_object(trigger_object_id: int) -> None:
        """
        Remove a trigger object.

        Args:
            trigger_object_id: ID of the trigger object
        """

disconnect_object_from_physics
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def disconnect_object_from_physics(object_id: int) -> None:
        """
        Disable physics for an object.

        Args:
            object_id: ID of the object
        """

reconnect_object_to_physics
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def reconnect_object_to_physics(object_id: int) -> None:
        """
        Re-enable physics for an object.

        Args:
            object_id: ID of the object
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

get_object_transformation_matrix
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

    def set_model_animation(model_id: int, animation_name: str, looped: bool = True) -> None:
        """
        Set an animation for a model.

        Args:
            model_id: ID of the model
            animation_name: Name of the animation to play
            looped: Whether the animation should loop
        """

set_model_animation_with_blend
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_model_animation_with_blend(model_id: int, animation_name: str, looped: bool = True, blend_time: int = 100) -> None:
        """
        Set an animation for a model with blending.

        Args:
            model_id: ID of the model
            animation_name: Name of the animation to play
            looped: Whether the animation should loop
            blend_time: Time in milliseconds for blending animations
        """

set_model_animation_speed
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    def set_model_animation_speed(model_id: int, speed: float) -> None:
        """
        Set the animation speed for a model.

        Args:
            model_id: ID of the model
            speed: Animation speed multiplier (1.0 = normal speed)
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

animate_model
^^^^^^^^^^^^^

.. code-block:: python

    def animate_model(model_id: int, animation_id: int, looped: bool = False, sound_path: str = None) -> None:
        """
        Animate a model with specific animation ID.

        Args:
            model_id: ID of the model
            animation_id: ID of the animation to play
            looped: Whether the animation should loop
            sound_path: Optional path to sound file to play with animation
        """

    # Add a new object to the scene
    add_object(model_file_path: str, model_weight: float = 1.0, physical: bool = True,
               position: tuple = (0, 0, 0), scale: tuple = (1, 1, 1),
               orientation: tuple = (1.0, 0.0, 0.0, 0.0)) -> int

    # Remove an object from the scene
    remove_object(object_id: int, remove_children: bool = True)

    # Get player position and orientation
    get_player_position() -> tuple  # Returns (position, center, up, right) as dictionaries

    # Get the ID of the model attached to the player
    get_player_attached_model() -> int

    # Get the offset of the model attached to the player
    get_player_attached_model_offset() -> tuple

    # Set the offset of the model attached to the player
    set_player_attached_model_offset(new_offset: tuple)

    # Load and switch to a new world
    load_and_switch_world(world_file_name: str)

    # Return to a previously loaded world
    return_to_world(world_file_name: str)

    # Get result of a trigger
    get_result_of_trigger(trigger_object_id: int, trigger_code_id: int) -> list

    # Get engine options
    get_options() -> any

Sound
~~~~~

.. code-block:: python

    # Attach and play a sound on an object
    attach_sound_to_object(object_id: int, sound_path: str) -> None

    # Detach sound from an object
    detach_sound_from_object(object_id: int) -> None

    # Play a sound at a position
    play_sound(sound_path: str, position: tuple, position_relative: bool = False, looped: bool = False) -> None

AI Interaction
~~~~~~~~~~~~~~

.. code-block:: python

    # Interact with an AI
    interact_with_ai(ai_id: int, interaction_information: dict) -> None

Particle Systems
~~~~~~~~~~~~~~~~

.. code-block:: python

    # Disable a particle emitter
    disable_particle_emitter(emitter_id: int) -> None

    # Enable a particle emitter
    enable_particle_emitter(emitter_id: int) -> None

    # Add a new particle emitter
    add_particle_emitter(
        name: str,
        texture_file: str,
        start_position: tuple,
        max_start_distances: tuple,
        size: float,
        count: int,
        life_time: float,
        particles_per_ms: float,
        continuously_emit: bool
    ) -> int  # Returns emitter ID

    # Remove a particle emitter
    remove_particle_emitter(emitter_id: int) -> None

    # Set particle speed for an emitter
    set_emitter_particle_speed(emitter_id: int, speed_multiplier: float, speed_offset: float) -> None

    # Set particle gravity for an emitter
    set_emitter_particle_gravity(emitter_id: int, gravity: float) -> None

Ray Casting
~~~~~~~~~~~

ray_cast_to_cursor
^^^^^^^^^^^^^^^^

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

ray_cast
^^^^^^^^

.. code-block:: python

    def ray_cast(start: tuple, direction: tuple) -> list:
        """
        Cast a ray from start point in direction.

        Args:
            start: Starting position as (x, y, z, w)
            direction: Direction vector as (x, y, z, w)

        Returns:
            list: List of GenericParameter objects containing hit details such as:
                  - hit coordinates (VEC4)
                  - hit object ID (LONG)
                  - hit normal vector (VEC4)
                  - distance to hit (DOUBLE)
        """

Lighting
~~~~~~~~

.. code-block:: python

    # Translate a light
    add_light_translate(light_id: int, translation: tuple) -> None

    # Set a light's color
    set_light_color(light_id: int, color: tuple) -> None

World Management
~~~~~~~~~~~~~~~~

.. code-block:: python

    # Load a new world and remove the current one
    load_and_remove_world(world_file_name: str) -> None

    # Return to the previously loaded world
    return_to_previous_world() -> None

    # Quit the game
    quit_game() -> None

    # Change the render pipeline
    change_render_pipeline(pipeline_file_name: str) -> None

Timed Events
~~~~~~~~~~~~

add_timed_event
^^^^^^^^^^^^^^^

.. code-block:: python

    def add_timed_event(wait_time: int, use_wall_time: bool, callback: callable,
                      parameters: list = []) -> int:
        """
        Schedule a function to be called after a specified delay.

        Args:
            wait_time: Time to wait before triggering the event, in milliseconds
            use_wall_time: If True, uses real-world time. If False, uses in-game time
                         (affected by game speed/pause state)
            callback: Python function to call when the timer expires.
                     The function should accept a single parameter which will be the
                     list of parameters provided.
            parameters: Optional list of GenericParameter objects to pass to the callback.
                       Each parameter's value will be passed to the callback function.

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

        Note:
            This method exists in the C++ API but is not yet bound to Python.
            It needs to be added to the Python bindings in ScriptManager.cpp.
        """

Player Related
~~~~~~~~~~~~~~

.. code-block:: python

    # Kill the player
    kill_player() -> None

Variable Management
~~~~~~~~~~~~~~~~~~

.. code-block:: python

    # Get a script variable by name
    get_variable(variable_name: str) -> any

Input System
------------

Input Methods
~~~~~~~~~~~~~

.. code-block:: python

    # Simulate input events
    simulate_input(input_states: InputStates) -> None

    # Get mouse change information
    changed, x_pos, y_pos, x_change, y_change = input_states.get_mouse_change()  # Returns tuple

    # Set mouse change
    input_states.set_mouse_change(x_pos: float, y_pos: float, x_change: float, y_change: float) -> None

    # Get text input
    text = input_states.get_text() -> str

    # Set text input
    input_states.set_text(text: str) -> None

    # Reset all input events
    input_states.reset_all_events() -> None

    # Get input events for a specific input
    events = input_states.get_input_events(input_code: int) -> bool

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
