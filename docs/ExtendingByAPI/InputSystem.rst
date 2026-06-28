.. _InputSystem:

==========================
Input System
==========================

Limon's input system is built around **named actions**: string names hashed to ``uint64_t`` at compile time (or load time for XML-defined actions). Plugins query by hash, never by SDL keycode — this keeps game code independent of which physical key is bound to an action, and lets bindings be changed in ``Engine/inputBindings.xml`` without recompiling anything.

Inputs are split into two kinds:

* **Digital** — ``bool`` state (pressed/released) and a one-frame event (state changed this frame).
* **Analog** — ``float`` value accumulated each frame (mouse delta, gamepad stick position).

Mouse motion and gamepad sticks both feed the same analog store, so the same plugin code handles either input device.

.. _InputSystem-built-in-actions:

Built-in Action Names
=====================

These constants are defined in ``src/limonAPI/InputStates.h`` as ``constexpr uint64_t`` in the ``InputActions`` namespace. They match the names in ``Engine/inputBindings.xml``.

.. list-table::
   :header-rows: 1
   :widths: 30 12 58

   * - Name
     - Kind
     - Description
   * - ``QUIT``
     - Digital
     - Exit the application (Escape key).
   * - ``MOVE_FORWARD``
     - Digital
     - Move forward (W key, gamepad left stick up).
   * - ``MOVE_BACKWARD``
     - Digital
     - Move backward (S key, gamepad left stick down).
   * - ``MOVE_LEFT``
     - Digital
     - Strafe left (A key, gamepad left stick left).
   * - ``MOVE_RIGHT``
     - Digital
     - Strafe right (D key, gamepad left stick right).
   * - ``JUMP``
     - Digital
     - Jump (Space, gamepad A button).
   * - ``RUN``
     - Digital
     - Run modifier (Shift, gamepad LB).
   * - ``MOUSE_BUTTON_LEFT``
     - Digital
     - Left mouse button or gamepad right trigger.
   * - ``MOUSE_BUTTON_MIDDLE``
     - Digital
     - Middle mouse button.
   * - ``MOUSE_BUTTON_RIGHT``
     - Digital
     - Right mouse button or gamepad RB.
   * - ``MOUSE_MOVE``
     - Digital
     - Set for one frame whenever the mouse moves. **Engine-internal** — the engine sets this from ``SDL_MOUSEMOTION`` directly; adding an ``inputBindings.xml`` entry for it has no effect.
   * - ``MOUSE_WHEEL_UP``
     - Digital
     - Scroll wheel up.
   * - ``MOUSE_WHEEL_DOWN``
     - Digital
     - Scroll wheel down.
   * - ``KEY_SHIFT``
     - Digital
     - Shift key held (left or right).
   * - ``KEY_CTRL``
     - Digital
     - Ctrl key held (left or right).
   * - ``KEY_ALT``
     - Digital
     - Alt key held.
   * - ``KEY_SUPER``
     - Digital
     - Super/GUI key held.
   * - ``TEXT_INPUT``
     - Digital
     - Set for one frame when SDL delivers a text input event. **Engine-internal** — set automatically from ``SDL_TEXTINPUT``; not configurable via ``inputBindings.xml``. Use ``getTextInput()`` / ``get_text_input()`` to read the typed character(s).
   * - ``NUMBER_1``
     - Digital
     - ``1`` key.
   * - ``NUMBER_2``
     - Digital
     - ``2`` key.
   * - ``F4``
     - Digital
     - F4 key.
   * - ``F5``
     - Digital
     - F5 key.
   * - ``DEBUG_MODE``
     - Digital
     - Toggle debug mode (``0`` key).
   * - ``EDITOR``
     - Digital
     - Toggle in-game editor (F2 key).
   * - ``LOOK_X``
     - Analog
     - Horizontal look delta this frame (mouse X + gamepad right stick X).
   * - ``LOOK_Y``
     - Analog
     - Vertical look delta this frame (mouse Y + gamepad right stick Y).

.. _InputSystem-reading-input:

Reading Input in Plugins
========================

All extension types receive a ``const InputStates &`` from the engine each frame (as ``inputState`` in C++, ``input_states`` in Python). Query it with the action name hash:

**C++** — use the compile-time ``HASH()`` macro or the ``InputActions::`` constants:

.. code-block:: cpp

    // Check whether a key is currently held
    if (inputState.getInputStatus(InputActions::JUMP)) { ... }

    // Check for a state change this frame (e.g. fire on first press only)
    if (inputState.getInputEvents(InputActions::MOUSE_BUTTON_LEFT)
        && inputState.getInputStatus(InputActions::MOUSE_BUTTON_LEFT)) { ... }

    // Read the analog look delta this frame
    float lookX = inputState.getAnalogValue(InputActions::LOOK_X);
    float lookY = inputState.getAnalogValue(InputActions::LOOK_Y);

    // Query a game-specific action that exists only in XML
    if (inputState.getInputStatus(HASH("RELOAD"))) { ... }

**Python** — use ``limon.InputActions.*`` for built-in names; ``limon.hash("RELOAD")`` for XML-only actions:

.. code-block:: python

    if input_states.get_input_status(limon.InputActions.JUMP):
        ...

    if (input_states.get_input_events(limon.InputActions.MOUSE_BUTTON_LEFT)
            and input_states.get_input_status(limon.InputActions.MOUSE_BUTTON_LEFT)):
        ...

    look_x = input_states.get_analog_value(limon.InputActions.LOOK_X)

.. list-table::
   :header-rows: 1
   :widths: 38 62

   * - Method (C++ / Python)
     - Description
   * - ``getInputStatus(hash)`` / ``get_input_status``
     - Returns ``true`` if the action is currently active (key held, button pressed).
   * - ``getInputEvents(hash)`` / ``get_input_events``
     - Returns ``true`` for exactly one frame when the action state changes.
   * - ``getAnalogValue(hash)`` / ``get_analog_value``
     - Returns the accumulated float value this frame. Zero if no input this frame.
   * - ``getActiveDevice()`` / ``get_active_device``
     - Returns ``InputStates::ActiveDevice::KEYBOARD_MOUSE`` or ``GAMEPAD``, reflecting which device last sent input. Useful for switching between prompt styles (show ``[A]`` vs ``[Space]``).
   * - ``getMouseChange(xPos, yPos, xChange, yChange)`` / ``get_mouse_change``
     - Fills four floats: absolute cursor position (``xPos``, ``yPos``) and relative delta (``xChange``, ``yChange``). Use this in cursor-mode UIs (menu players, free-cursor overlays) where you need screen-space coordinates, not normalised look deltas.
   * - ``getTextInput()`` / ``get_text_input``
     - Returns the UTF-8 string typed this frame (non-empty only when ``TEXT_INPUT`` is set). Use for text fields in menus.

.. note::
   ``getInputStatus``, ``getInputEvents``, and ``getAnalogValue`` return a default value (``false`` / ``0.0f``) for unknown hashes and never throw.

.. _InputSystem-active-device:

Detecting Active Input Device
==============================

The engine tracks which device the player last used. You can read it to switch UI prompts or control schemes at runtime:

.. code-block:: cpp

    if (inputState.getActiveDevice() == InputStates::ActiveDevice::GAMEPAD) {
        showButtonPrompt("[A] to jump");
    } else {
        showButtonPrompt("[Space] to jump");
    }

.. code-block:: python

    if input_states.get_active_device() == limon.ActiveDevice.GAMEPAD:
        show_prompt("[A] to jump")
    else:
        show_prompt("[Space] to jump")

The device switches as soon as any input above the dead zone arrives from that device. Your code can add debounce logic (e.g. require the new device to be active for N frames) if you want to avoid flickering prompts when a connected-but-idle gamepad is present.

.. _InputSystem-simulate-input:

Simulating and Mutating Input (Python)
=======================================

The Python API exposes additional ``InputStates`` methods that let scripts construct or inject synthetic input. These are primarily used with ``limon.simulate_input(input_states)`` to drive automated tests or replay sequences:

.. code-block:: python

    states = limon.InputStates()
    limon.set_mouse_change(states, xPos=0.5, yPos=0.5, xChange=0.01, yChange=0.0)
    limon.set_text_input(states, "a")
    states.reset_all_input_events()   # clear all digital events (not analog, not active device)
    limon.simulate_input(states)

.. list-table::
   :header-rows: 1
   :widths: 40 60

   * - Method
     - Description
   * - ``limon.set_mouse_change(states, xPos, yPos, xChange, yChange)``
     - Writes absolute and relative mouse values into an ``InputStates`` object.
   * - ``limon.set_text_input(states, text)``
     - Sets the typed text string on an ``InputStates`` object and raises ``TEXT_INPUT``.
   * - ``states.reset_all_input_events()``
     - Clears all one-frame digital events. Called by the engine each tick; call manually when constructing synthetic states.
   * - ``limon.simulate_input(states)``
     - Injects the constructed ``InputStates`` into the engine as if it arrived from hardware. See :ref:`pythonApi` for full details.

.. note::
   These mutation methods are Python-only. In C++ plugins the ``InputStates`` received in ``processInput`` is ``const`` — it cannot be written to.

.. _InputSystem-custom-actions:

Custom Game Actions
===================

To add a game-specific action (such as ``RELOAD``), add it to ``Engine/inputBindings.xml`` with the bindings you want. No engine recompile is needed.

.. code-block:: xml

    <Action name="RELOAD">
        <Binding source="keyboard"       key="R"/>
        <Binding source="gamepad_button" button="X"/>
    </Action>

In your plugin, query it with the same name:

.. code-block:: cpp

    if (inputState.getInputEvents(HASH("RELOAD"))
        && inputState.getInputStatus(HASH("RELOAD"))) {
        startReloadAnimation();
    }

.. code-block:: python

    reload_hash = limon.hash("RELOAD")
    if input_states.get_input_events(reload_hash) and input_states.get_input_status(reload_hash):
        start_reload_animation()

.. note::
   ``HASH("RELOAD")`` in C++ and ``limon.hash("RELOAD")`` in Python both produce the same ``uint64_t``. The XML parser uses the same runtime hash function, so the integer is identical at load time.

.. _InputSystem-xml-format:

inputBindings.xml Format
========================

``Engine/inputBindings.xml`` is loaded once at startup. If it is absent or unparseable the engine falls back to built-in defaults (identical to the shipped XML). Changes take effect on the next launch.

Root element: ``<InputBindings version="1">``.

Each ``<Action>`` element names one logical action:

.. code-block:: none

    <Action name="ACTION_NAME" type="digital|analog">
        <Binding source="..." .../>
        ...
    </Action>

``type`` defaults to ``digital`` and may be omitted for digital actions. ``type="analog"`` is required only for actions whose bindings carry a ``scale`` attribute (it has no effect on the behaviour — it serves as documentation).

.. _InputSystem-xml-sources:

Binding Sources
---------------

**source="keyboard"**

.. code-block:: xml

    <Binding source="keyboard" key="W"/>
    <Binding source="keyboard" key="Left Shift"/>
    <!-- Optional: keyboard key that adds a fixed float to an analog action each frame it is held -->
    <Binding source="keyboard" key="D" analog_value="1.0"/>

Key names follow SDL naming (case-insensitive). Common names:

.. list-table::
   :widths: 30 70

   * - Letters
     - ``A`` .. ``Z``
   * - Digits
     - ``0`` .. ``9``
   * - Special
     - ``Space``, ``Escape``, ``Return``, ``Tab``, ``Backspace``, ``Delete``
   * - Modifiers
     - ``Left Shift``, ``Right Shift``, ``Left Ctrl``, ``Right Ctrl``, ``Left Alt``
   * - Function
     - ``F1`` .. ``F12``
   * - Numpad
     - ``KP 0`` .. ``KP 9``, ``KP Plus``, ``KP Minus``, ``KP Enter``

----

**source="mouse_button"**

.. code-block:: xml

    <Binding source="mouse_button" button="LEFT"/>
    <Binding source="mouse_button" button="X1"/>   <!-- side button 4 -->
    <Binding source="mouse_button" button="7"/>    <!-- numeric fallback for 6+ button mice -->

Button names: ``LEFT``, ``MIDDLE``, ``RIGHT``, ``X1`` (button 4), ``X2`` (button 5). For mice with more buttons use a numeric index (``"6"``, ``"7"``, …).

----

**source="mouse_axis"**

Wires normalised mouse motion to an analog action. Scale is automatic (``xrel / screenWidth*0.5``).

.. code-block:: xml

    <Binding source="mouse_axis" axis="X"/>   <!-- horizontal delta -->
    <Binding source="mouse_axis" axis="Y"/>   <!-- vertical delta -->

----

**source="mouse_wheel"**

.. code-block:: xml

    <Binding source="mouse_wheel" axis="UP"/>
    <Binding source="mouse_wheel" axis="DOWN"/>
    <Binding source="mouse_wheel" axis="LEFT"/>    <!-- horizontal scroll -->
    <Binding source="mouse_wheel" axis="RIGHT"/>

----

**source="gamepad_button"**

.. code-block:: xml

    <Binding source="gamepad_button" button="A"/>
    <Binding source="gamepad_button" button="L3"/>

Button names:

.. list-table::
   :widths: 30 70

   * - Face buttons
     - ``A``, ``B``, ``X``, ``Y``
   * - Shoulders
     - ``LEFTSHOULDER`` (LB), ``RIGHTSHOULDER`` (RB)
   * - Stick clicks
     - ``LEFTSTICK`` or ``L3``, ``RIGHTSTICK`` or ``R3``
   * - System buttons
     - ``BACK``, ``START``, ``GUIDE`` (home / Xbox / PS button)
   * - D-pad
     - ``DPAD_UP``, ``DPAD_DOWN``, ``DPAD_LEFT``, ``DPAD_RIGHT``
   * - Extra / elite
     - ``MISC1`` (Xbox Series X share, PS5 mic, Switch capture), ``PADDLE1``..``PADDLE4`` (Xbox Elite), ``TOUCHPAD`` (PS4/PS5 click)

----

**source="gamepad_axis"**

A gamepad axis can appear in a digital binding (with ``threshold``) and an analog binding (with ``scale``) simultaneously, even in different actions.

.. code-block:: xml

    <!-- Digital: fires MOVE_FORWARD when left stick is pushed up past 30 % -->
    <Binding source="gamepad_axis" axis="LEFT_Y" threshold="-0.3"/>

    <!-- Analog: accumulates scaled stick value into LOOK_X each frame -->
    <Binding source="gamepad_axis" axis="RIGHT_X" scale="0.0104"/>

``threshold``: positive triggers when value ≥ threshold; negative triggers when value ≤ threshold. ``scale``: per-frame multiplier applied to the normalised axis value ``[-1 .. 1]``.

Axis names: ``LEFT_X``, ``LEFT_Y``, ``RIGHT_X``, ``RIGHT_Y``, ``LEFT_TRIGGER``, ``RIGHT_TRIGGER``.

----

**source="joystick_button"**

For buttons outside SDL's GameController mapping — proprietary or extra buttons on flight sticks, racing wheels, etc.

.. code-block:: xml

    <Binding source="joystick_button" index="8"/>

``index`` is the raw SDL joystick button index (0-based). For standard gamepad buttons that SDL already maps (A, B, X, Y, …) prefer ``source="gamepad_button"`` instead to avoid double-firing.

.. _InputSystem-look-speed:

Look Speed and Analog Alignment
=================================

Mouse and gamepad stick both contribute to ``LOOK_X``/``LOOK_Y`` through the same analog store and both pass through ``player_lookAroundSpeed`` in ``Engine/Options.xml``. The analog values are expressed in the same unit (mouse pixel displacement normalised by ``screenWidth / 2``), so a single ``player_lookAroundSpeed`` tuning applies to both devices equally.

The default gamepad look scale in ``inputBindings.xml`` is ``0.0104``, computed as ``10.0 / (1920 / 2)``. For other screen resolutions adjust it proportionally: ``scale = 10.0 / (screenWidth / 2)``.

The gamepad dead zone is configurable via the ``gamepad_deadZone`` option (default ``0.1``). Values below this threshold on any analog axis are ignored.

.. seealso::
   :ref:`OptionsReference` for ``player_lookAroundSpeed`` and ``gamepad_deadZone``.

.. _InputSystem-reference-tables:

Complete Input Reference
========================

.. _InputSystem-ref-keyboard:

Keyboard Keys  (``source="keyboard"  key="…"``)
------------------------------------------------

Key names are case-insensitive. Use them verbatim in the ``key`` attribute.

**Letters**

``A`` ``B`` ``C`` ``D`` ``E`` ``F`` ``G`` ``H`` ``I`` ``J`` ``K`` ``L`` ``M``
``N`` ``O`` ``P`` ``Q`` ``R`` ``S`` ``T`` ``U`` ``V`` ``W`` ``X`` ``Y`` ``Z``

**Digits and function keys**

.. list-table::
   :widths: 25 75

   * - Digits
     - ``0`` ``1`` ``2`` ``3`` ``4`` ``5`` ``6`` ``7`` ``8`` ``9``
   * - Function
     - ``F1`` ``F2`` ``F3`` ``F4`` ``F5`` ``F6`` ``F7`` ``F8`` ``F9`` ``F10`` ``F11`` ``F12``

**Special and navigation keys**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Key name
     - Description
   * - ``Space``
     - Spacebar
   * - ``Escape``
     - Escape
   * - ``Return``
     - Enter / Return
   * - ``Tab``
     - Tab
   * - ``Backspace``
     - Backspace
   * - ``Delete``
     - Delete
   * - ``Insert``
     - Insert
   * - ``Home``
     - Home
   * - ``End``
     - End
   * - ``Page Up``
     - Page Up
   * - ``Page Down``
     - Page Down
   * - ``Up``
     - Arrow Up
   * - ``Down``
     - Arrow Down
   * - ``Left``
     - Arrow Left
   * - ``Right``
     - Arrow Right
   * - ``Caps Lock``
     - Caps Lock
   * - ``Num Lock``
     - Num Lock
   * - ``Scroll Lock``
     - Scroll Lock
   * - ``Pause``
     - Pause / Break
   * - ``Print Screen``
     - Print Screen

**Modifier keys**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Key name
     - Description
   * - ``Left Shift``
     - Left Shift
   * - ``Right Shift``
     - Right Shift
   * - ``Left Ctrl``
     - Left Control
   * - ``Right Ctrl``
     - Right Control
   * - ``Left Alt``
     - Left Alt
   * - ``Right Alt``
     - Right Alt
   * - ``Left GUI``
     - Left Super / Windows / Command key
   * - ``Right GUI``
     - Right Super / Windows / Command key

**Numpad**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Key name
     - Description
   * - ``KP 0`` .. ``KP 9``
     - Numpad digit keys
   * - ``KP Plus``
     - Numpad ``+``
   * - ``KP Minus``
     - Numpad ``-``
   * - ``KP Multiply``
     - Numpad ``*``
   * - ``KP Divide``
     - Numpad ``/``
   * - ``KP Period``
     - Numpad ``.``
   * - ``KP Enter``
     - Numpad Enter

**Punctuation and symbols**

.. list-table::
   :header-rows: 1
   :widths: 30 70

   * - Key name
     - Description
   * - ``-``
     - Minus / Hyphen
   * - ``=``
     - Equals
   * - ``[``
     - Left bracket
   * - ``]``
     - Right bracket
   * - ``\``
     - Backslash
   * - ``;``
     - Semicolon
   * - ``'``
     - Apostrophe
   * - `` ` ``
     - Grave / Backtick
   * - ``,``
     - Comma
   * - ``.``
     - Period
   * - ``/``
     - Slash

.. note::
   The complete SDL key name list is documented at https://wiki.libsdl.org/SDL2/SDL_Keycode.
   SDL accepts key names case-insensitively, so ``"space"``, ``"Space"``, and ``"SPACE"`` are all valid.

.. _InputSystem-ref-mouse:

Mouse  (``source="mouse_button"`` / ``source="mouse_axis"`` / ``source="mouse_wheel"``)
----------------------------------------------------------------------------------------

**Mouse buttons**  (``source="mouse_button"  button="…"``)

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Value
     - Description
   * - ``LEFT``
     - Primary (left) mouse button
   * - ``MIDDLE``
     - Middle mouse button / scroll wheel click
   * - ``RIGHT``
     - Secondary (right) mouse button
   * - ``X1``
     - Side button 4 (back button on most gaming mice)
   * - ``X2``
     - Side button 5 (forward button on most gaming mice)
   * - ``6``, ``7``, …
     - Numeric index for additional buttons on mice with more than five buttons

**Mouse axes**  (``source="mouse_axis"  axis="…"``)

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Value
     - Description
   * - ``X``
     - Horizontal motion delta this frame, normalised by ``screenWidth / 2``
   * - ``Y``
     - Vertical motion delta this frame, normalised by ``screenHeight / 2``

**Mouse wheel**  (``source="mouse_wheel"  axis="…"``)

.. list-table::
   :header-rows: 1
   :widths: 20 80

   * - Value
     - Description
   * - ``UP``
     - Scroll wheel rolled away from the user
   * - ``DOWN``
     - Scroll wheel rolled toward the user
   * - ``LEFT``
     - Horizontal scroll left (tilt wheel or touchpad)
   * - ``RIGHT``
     - Horizontal scroll right (tilt wheel or touchpad)

.. _InputSystem-ref-gamepad:

Gamepad  (``source="gamepad_button"`` / ``source="gamepad_axis"``)
------------------------------------------------------------------

**Gamepad buttons**  (``source="gamepad_button"  button="…"``)

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Value
     - Description
   * - ``A``
     - A button (cross on PlayStation)
   * - ``B``
     - B button (circle on PlayStation)
   * - ``X``
     - X button (square on PlayStation)
   * - ``Y``
     - Y button (triangle on PlayStation)
   * - ``LEFTSHOULDER``
     - Left shoulder button (LB / L1)
   * - ``RIGHTSHOULDER``
     - Right shoulder button (RB / R1)
   * - ``LEFTSTICK`` or ``L3``
     - Left analog stick click
   * - ``RIGHTSTICK`` or ``R3``
     - Right analog stick click
   * - ``BACK``
     - Back / Select / Share button
   * - ``START``
     - Start / Options / Menu button
   * - ``GUIDE``
     - Home / Xbox / PS button (may not fire on all platforms)
   * - ``DPAD_UP``
     - D-pad up
   * - ``DPAD_DOWN``
     - D-pad down
   * - ``DPAD_LEFT``
     - D-pad left
   * - ``DPAD_RIGHT``
     - D-pad right
   * - ``MISC1``
     - Xbox Series X share button; PS5 microphone button; Nintendo Switch Pro capture button; Amazon Luna microphone button
   * - ``PADDLE1``
     - Xbox Elite upper-left paddle (P1)
   * - ``PADDLE2``
     - Xbox Elite upper-right paddle (P3)
   * - ``PADDLE3``
     - Xbox Elite lower-left paddle (P2)
   * - ``PADDLE4``
     - Xbox Elite lower-right paddle (P4)
   * - ``TOUCHPAD``
     - PS4 / PS5 touchpad click

**Gamepad axes**  (``source="gamepad_axis"  axis="…"``)

Each axis delivers a normalised value in ``[-1.0 .. 1.0]``. Triggers deliver ``[0.0 .. 1.0]``.

.. list-table::
   :header-rows: 1
   :widths: 25 75

   * - Value
     - Description
   * - ``LEFT_X``
     - Left analog stick horizontal (left = −1, right = +1)
   * - ``LEFT_Y``
     - Left analog stick vertical (up = −1, down = +1)
   * - ``RIGHT_X``
     - Right analog stick horizontal (left = −1, right = +1)
   * - ``RIGHT_Y``
     - Right analog stick vertical (up = −1, down = +1)
   * - ``LEFT_TRIGGER``
     - Left analog trigger (LT / L2). Rest = 0, fully pressed = +1
   * - ``RIGHT_TRIGGER``
     - Right analog trigger (RT / R2). Rest = 0, fully pressed = +1

.. _InputSystem-ref-joystick:

Raw Joystick Buttons  (``source="joystick_button"  index="…"``)
----------------------------------------------------------------

Raw SDL joystick button indices (0-based integers). Use for buttons not covered by the GameController mapping above — extra buttons on flight sticks, racing wheels, or proprietary peripherals.

The index corresponds to SDL's internal joystick button numbering for the device, which may differ from the physical label printed on the hardware. Use a tool such as ``sdl2-jstest`` or SDL's ``ControllerMap`` utility to discover the raw indices for a specific device.

.. note::
   For standard gamepad buttons already covered by ``source="gamepad_button"`` (A, B, X, Y, …), SDL delivers both a ``SDL_CONTROLLERBUTTONDOWN`` event and a ``SDL_JOYBUTTONDOWN`` event for the same physical press. Binding the same button via both ``gamepad_button`` and ``joystick_button`` will fire the action twice per press.
