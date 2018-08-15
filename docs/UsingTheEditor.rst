.. _UsingBuiltinEditor:

====================
Using Builtin Editor
====================

Builtin editor can be used to create maps, interfaces and menus. 3D and 2D components share the tooling, and they can be mixed and matched, meaning it is possible to build 3d world as background in menus, or using menus with in game play.


Editor Basics
#############

The editor has 3 main windows. By default left of the screen is object properties, right is world properties and bottom is animation sequencer. As expected you can drag and drop and resize the windows. If no object is selected, only the world properties window is visible. Animation sequencer is visible only when creating an animation.

.. figure:: _static/media/images/editor-world-withAnimation.jpg
    :align: center

World Editor Details
####################

World editor loads up with almost all the features hidden by the titles. The fresh loaded window looks like this:

.. figure:: _static/media/images/editor-world-nonSelected.jpg
    :align: center

There are 2 main types of elements that can be used to build the world.

* 3D Objects
* GUI elements

To make selection easier, click to select doesn't work for both types at the same time. At launch you can select Objects. If you click "Switch to GUI selection mode", you will be able to select GUI elements, but not Objects. The button will be replaced by "Switch to World selection mode".

Adding 3D objects
_________________

There are 2 types of 3D object you can add to the world.

* Models
* Trigger volumes

.. figure:: _static/media/images/editor-addObject.png
    :align: center

Models list is loaded from "./Data/Models/" directory. You can select a model from the drop down list. When mass is set to 0, the object will be marked "static" by physics system. This means the model will not be able to move, outside of the editor. It is the default setting, to be used for building the world. Any other value will mark the object as "dynamic", meaning the objects movements will be governed by physics engine.

If an object is already selected, "Copy position offsets" settings and "Copy Selected Objects" button is shown. These are used to copy selected object, with given offsets. Offsets can be used to make copy automatically position so a grid or a wall can be created.

.. figure:: _static/media/images/physics-hull_vs_full.png
    :align: center

    Dynamic object have Convex hulls (left), while static objects have full mesh as collision mesh (right).

.. figure:: _static/media/images/physics-hull_vs_baked.png
    :align: center

    Static objects can use baked collision meshes(right)

.. figure:: _static/media/images/physics-animated.png
    :align: center

    animated object has per bone convex hulls

Dynamic objects physical representations are simplified automatically. For inanimate models, the simplified representation will be a convex hull. This means the cavities, crannies etc. will not be calculated for them. For animated models, each vertex will be assigned the bone that has the most weight on it, and for each bone a convex hull will be created. It means separate members of the model will be calculates as such.

Static object have a full mesh representing physical object. It is possible to replace this with a simplified mesh. To do so, bake meshes with names prefixed with "UCX_". They will be used for physics.

.. note::
    Models with animations, both from the asset itself and custom using the editor are considered "kinematic" It means the object is allowed to move, but the movement is not governed by physics engine. Those types of objects can't be moved by physical interactions like pushing or pulling, but they can effect physical objects.

.. note::
    Because physical representation is dependent on the mass, mass setting cant be changed once an model is added to the world. If you need to change the mass, remove and add again.

Add Trigger Volume button will create an empty cube. That cube can be used to trigger custom code paths. The details are at :ref:`Trigger Object Editor`.

Adding GUI Elements
___________________

GUI elements are rendered using layers. Each layer has a level, with default layer at level 0. Bigger levels are higher up, meaning when overlapped, the one with the higher level will be rendered.

.. figure:: _static/media/images/editor-addGUI.png
    :align: center

You can add the following using the editor:

* Layer
* Text
* Image
* Button

Add GUI layer menu allows you to add a new layer, with set level.

To add GUI text, you need to set the font, font size and name. The layer of the text can be selected from the drop down.

.. note::
    Since the font renderer is building the text using the set font size. GUI texts are not scalable.

To add GUI Image, you need to set the name and image files path relative to the engine. The layer of the image can be selected from the drop down.

To add GUI Button, you need to set the name, and normal image file path relative to the engine.

The Button can be interactive, depending on the player state. If player is set interactive, the following logic is used:

#. If The button doesn't have an trigger, and have a disabled image set, the disabled image will be shown.
#. If on click image is set, and mouse is down over the button, on click image is shown. Also Trigger will be run. For details, please check :ref:`Triggers`.
#. If on hover image is set, and mouse cursor is over the button, that image will be shown.
#. If all else were wrong, the normal image will be shown.

The layer of the button can be selected from the drop down.

Setting Up Map Properties
_________________________

.. figure:: _static/media/images/editor-world.png
    :align: center

You can set the following using the world editor.

#. You can add triggers to run after the world load finished. For details please check  :ref:`Triggers`.
#. You can set the music that will be playing after map load finished.
#. You can set what kind of interaction will be possible at the launch of the map. Possible values are
  * Physical: Normal Player for game play
  * Debug: The player that controls exactly like physical, but doesn't interact with physics, so can fly and walkthrough objects. Also renders physics meshes, GUI borders and AI walk grid to allow debugging issues.
  * Editor: Builtin editor.
  * Menu: Menu interaction is allowed, and animation, AI and Physics subsystems are stopped.
#. You can set what should be done when player press ESC key.
  * Quit Game: exits the game immediately without asking for a verification
  * Return Previous: Loaded maps list is kept within the engine. This option returns the world before current one. If this is the first world, or this world is loaded with force new directive, this option does nothing.
  * Load World: This option add a new text input to the editor. The map at the path entered will be loaded if not already, and the current map will switch to the entered one.

.. warning::
    For a game release, Debug and Editor types should be removed. Those types are only for development purposes.

Other editor controls
_____________________

.. figure:: _static/media/images/editor-others.png
    :align: center

Loaded custom animations will be listed under custom animations for convenience. You can load other custom animation by entering the file path.

Saving the map
______________

The map will be saved at the path when save world is clicked, overriding if it already exists.

.. warning::
    It is worth repeating. The save button overrides if there is a file with same name. Please pay attention.

Object Editor Details
####################

Object editor has two parts. One is the window that is on the left by default, and the other is the gizmos that appear at the position of the object. The window content changes based on the selected object. Each possible object type is documented separately below.

.. figure:: _static/media/images/editor-object_marked.png
    :align: center

Model Object Editor
___________________

.. figure:: _static/media/images/editor-object_model.png
    :align: center

    The model window with all options visible

Model Object editor has selected object in a drop-down that lists all the game objects.

After that, there are 3 radio buttons. These are "Translate", "Rotate", "Scale". Based on the selected mode, the 6 elements below change, but their usage is the same. First 3 are used for precise settings by dragging, or entering exact value by typing. **To enter typing mode, you should double click the item.** The second 3 items are for setting the values with bigger differences.

Just under these settings, there is snap settings. It is used by gizmo. For details check :ref:`Gizmo Usage`.

If the loaded model contains animations within, these animations are listed under the "Model animation properties", and the speed of this animation can be set using "Animation time scale".

AI properties only contain "AI Driven" at the current version.

.. note::
    If model has no animation, it can't be assigned an AI. Both Animation properties and AI properties will be hidden in that case.

Under AI settings, there is "Step on Sound" setting. This is used as step sound when "Physical player" move on top of the model.

After That there is "Custom animation properties". This section lists currently available animations, you can apply any of the custom animations to any number of models. If you want to create a new custom animation, you can do so by using "Create new" button. This button will open animation sequencer. For details please check :ref:`TriggerVolumes`.

Disconnect from physics button removes the collision mesh from map so the object won't be interacting with physics engine. This can be useful for small probes that should be ignored.

Last button is "Remove This Object", which removes the object from the map.

Trigger Object Editor
_____________________

.. figure:: _static/media/images/editor-object_trigger.png
    :align: center

The trigger object has same interfaces with model for transformation settings. The difference is at "Trigger Properties" section.

This section has 3 Trigger settings.

#. First Enter Trigger.
#. Enter Trigger.
#. Exit Trigger.

The details of Triggers settings are not predefined, triggers can define their own settings. For details, please refer to :ref:`Triggers`. Any or all of the triggers can be left unset.

The logic of triggers is as follows:
#. If player is not detected, and wasn't detected last frame, do nothing.
#. If player is not detected, and was detected last frame, and *Exit Trigger* is set, run it.
#. If player is detected, and was detected last frame, do nothing.
#. If player is detected, and wasn't detected last frame
    #. If player was not detected ever before, and *First Enter Trigger* is set, run it.
    #. If player was not detected ever before, but *First Enter Trigger* is not set, and *Enter Trigger* is set, run *Enter Trigger*.
    #. If player was detected before, if *Enter Trigger* is set, run *Enter Trigger*.

Gizmo Usage
___________

The gizmo have 3 modes, translate(move), scale and rotate. These modes are

Animation Sequencer Details
###########################