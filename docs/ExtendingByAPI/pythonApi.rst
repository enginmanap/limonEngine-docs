Limon Engine Python API Documentation
=====================================

This page is the API reference for Python users.

.. contents:: Table of Contents
   :depth: 3
   :local:

Core Types
----------

Enums
~~~~~

RequestParameterType
^^^^^^^^^^^^^^^^^^^

.. code-block:: python

    class RequestParameterType:
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

ValueType
^^^^^^^^^

.. code-block:: python

    class ValueType:
        STRING = 0
        DOUBLE = 1
        LONG = 2
        LONG_ARRAY = 3
        BOOLEAN = 4
        VEC4 = 5
        MAT4 = 6

GenericParameter
~~~~~~~~~~~~~~~~
A flexible parameter type that can hold different types of values.

.. code-block:: python

    param = limon.GenericParameter()
    param.request_type = limon.RequestParameterType.FREE_TEXT
    param.description = "Parameter description"
    param.value_type = limon.ValueType.STRING
    param.value = "Default value"  # Automatically handles type conversion
    param.is_set = True

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

.. code-block:: python

    # Set if an object is temporary
    set_object_temporary(object_id: int, temporary: bool)

    # Attach one object to another
    attach_object_to_object(object_id: int, object_to_attach_to_id: int)

    # Remove a trigger object
    remove_trigger_object(trigger_object_id: int)

    # Disable physics for an object
    disconnect_object_from_physics(object_id: int)

    # Re-enable physics for an object
    reconnect_object_to_physics(object_id: int)

    # Apply force to an object
    apply_force(object_id: int, force_position: Vec4, force_amount: Vec4) -> bool

    # Apply force to the player
    apply_force_to_player(force_amount: Vec4) -> bool

    # Add to an object's position
    add_object_translate(object_id: int, translation: Vec4) -> bool

    # Add to an object's scale
    add_object_scale(object_id: int, scale: Vec4) -> bool

    # Add to an object's orientation (quaternion)
    add_object_orientation(object_id: int, orientation: Vec4) -> bool

    # Get an object's transformation matrix
    get_object_transformation_matrix(object_id: int) -> list

    # Get children of a model
    get_model_children(model_id: int) -> list

    # Set an animation for a model
    set_model_animation(model_id: int, animation_name: str, looped: bool = True)

    # Set an animation for a model with blending
    set_model_animation_with_blend(model_id: int, animation_name: str, looped: bool = True, blend_time: int = 100)

    # Set the animation speed for a model
    set_model_animation_speed(model_id: int, speed: float)

Sound
~~~~~

.. code-block:: python

    # Attach and play a sound on an object
    attach_sound_to_object(object_id: int, sound_path: str)

    # Detach sound from an object
    detach_sound_from_object(object_id: int)

    # Play a sound at a position
    play_sound(sound_path: str, position: tuple, position_relative: bool = False, looped: bool = False)

AI Interaction
~~~~~~~~~~~~~~

.. code-block:: python

    # Interact with an AI
    interact_with_ai(ai_id: int, interaction_information: dict)

Particle Systems
~~~~~~~~~~~~~~~~

.. code-block:: python

    # Disable a particle emitter
    disable_particle_emitter(emitter_id: int)

    # Enable a particle emitter
    enable_particle_emitter(emitter_id: int)

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
    ) -> int

    # Remove a particle emitter
    remove_particle_emitter(emitter_id: int)

    # Set particle speed for an emitter
    set_emitter_particle_speed(emitter_id: int, speed_multiplier: float, speed_offset: float)

    # Set particle gravity for an emitter
    set_emitter_particle_gravity(emitter_id: int, gravity: float)

Ray Casting
~~~~~~~~~~~

.. code-block:: python

    # Cast a ray from camera to cursor position
    ray_cast_to_cursor()

    # Cast a ray from start point in direction
    ray_cast(start: tuple, direction: tuple)

Lighting
~~~~~~~~

.. code-block:: python

    # Translate a light
    add_light_translate(light_id: int, translation: tuple)

    # Set a light's color
    set_light_color(light_id: int, color: tuple)

World Management
~~~~~~~~~~~~~~~~

.. code-block:: python

    # Load a new world and remove the current one
    load_and_remove_world(world_file_name: str)

    # Return to the previously loaded world
    return_to_previous_world()

    # Quit the game
    quit_game()

    # Change the render pipeline
    change_render_pipeline(pipeline_file_name: str)

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

Player Related
~~~~~~~~~~~~~~

.. code-block:: python

    # Kill the player
    kill_player()

Variable Management
~~~~~~~~~~~~~~~~~~

.. code-block:: python

    # Get a script variable by name
    get_variable(variable_name: str) -> any

    # Set a script variable
    set_variable(variable_name: str, value: any)

Input System
------------

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
        KEY_ESCAPE = 7
        KEY_F1 = 8
        # ... (other key codes)

    # Example usage:
    if input_states.get_input_status(limon.Inputs.KEY_W):
        # Move forward
        pass

Camera System
-------------

CameraAttachment
~~~~~~~~~~~~~~~~
Base class for custom camera attachments.

.. code-block:: python

    class MyCamera(limon.CameraAttachment):
        def __init__(self):
            super().__init__()
            
        def is_dirty(self) -> bool:
            """Return True if the camera parameters have changed."""
            return True
            
        def clear_dirty(self) -> None:
            """Mark the camera parameters as clean."""
            pass
            
        def get_camera_variables(self) -> tuple:
            """
            Get camera position and orientation.
            
            Returns:
                tuple: (position, center, up, right) vectors
            """
            return position, center, up, right

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
            param = limon.GenericParameter()
            param.request_type = limon.RequestParameterType.FREE_TEXT
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
