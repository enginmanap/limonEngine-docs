.. _MapConverter:

=============
Map Converter
=============

The map converter turns a level that was exported from another engine as one big model file into a world of separate objects: one model file per distinct mesh, and a world file that places them.

Why convert a map
=================

A level exported from another engine often arrives as a single model holding the whole map. Loaded as it is, the engine sees one object:

* **You can't edit it piece by piece.** Moving a building, removing a prop or changing one material means touching the whole map.
* **It is culled and sorted as one unit.** Frustum and occlusion culling decide per object, so a single huge object is drawn or skipped entirely. Splitting the map is what lets culling hide the parts behind you.
* **Nothing is shared.** A prop placed a thousand times is stored a thousand times.

After conversion:

* Every placement in the source is its own object, selectable and editable in the editor, culled and occlusion tested on its own.
* A mesh placed many times is stored once and placed by many objects, so a map with thousands of props needs a few hundred files.
* Every piece is a :ref:`limonmodel <limonmodel>`, with its own LOD levels and baked occluders.
* The source's hierarchy is kept as model groups, and animated meshes become animated models.

If your model is a single prop, a character or a vehicle, you do not need the converter. Place it in the editor like any other model. Use the converter when one file holds a whole map. The :ref:`occlusion options <OptionsReference>` also describe this case: a map imported as one model is better served by the converter.

Running the converter
=====================

The converter is started from the command line. It has no editor button.

::

    LimonEngine --convert <model file> [output directory] [--scale <factor>]

Run it from the engine directory. It opens the engine window as usual, writes the result and exits.

* Without an output directory, the result goes to a folder named after the source, next to it: ``Data/Maps/City.fbx`` converts into ``Data/Maps/City/``. The folder is created if it does not exist.
* ``--scale`` resizes the whole map around the map origin, positions included. The pieces themselves keep the source's units, only the objects placing them are scaled. It must be greater than 0, since a negative factor would mirror the whole map.
* The exit code is ``0`` when the world was written, and ``-1`` when the arguments are wrong, a package is mounted, the source was refused, or a piece failed to convert.
* The console prints how many model groups, static objects and pieces were found, one line per animated model, one line per piece as it is written, and a final line with the path of the world file.

The converter refuses to run while a package is mounted, which is the case whenever ``Data.pak`` sits next to the engine. It prints a message naming the package and stops. Move the package away to convert, and put it back afterwards.

Open the resulting world in the editor, or give its path to the engine as the first parameter.

What it writes
==============

The output folder receives:

* **One** ``limonmodel`` **per distinct mesh**, named ``<source>_<mesh number>_<node name>.limonmodel``. A mesh placed many times is stored once and placed by many objects, so a map with thousands of props needs a few hundred files. Meshes are matched by content as well, since some exporters write a separate copy of a skinned mesh for every placement.
* A mirrored placement gets its own ``_mirror`` file, because the mirror is in the vertices (see :ref:`Flipped models <FlippedModels>`).
* **A world file**, ``<source>.xml``. Every placement in the source becomes its own object, with no mass, so nothing in the map moves on its own. The world also gets one directional light and an editor player placed 2 units above the highest vertex of the map, and no sky. Add the rest, like a sky, the player and the gameplay, in the editor.
* **Model groups** from the source's hierarchy. A node holding more than one object, like a building base with its floors and roof attached, becomes a model group named after the node, so it can be selected and moved as one. A mesh the exporter split by material, like a car's body and glass, is grouped too and named after its parent, the car. As with any model group, the editor places its gizmo at the average of its members, not at the base mesh's origin.
* **Textures.** The textures the pieces use are not copied. A texture that was embedded in the source file is stored inside the pieces that use it, like in any ``limonmodel``, and a texture that the source names by path is still looked up by that path, so keep those files where the source expects them.

Like any ``limonmodel``, every piece carries its LOD levels and baked occluders, so converting a big map is slow. Pieces are converted in parallel, on every core of the machine. Expect minutes for a map with thousands of objects, and watch the console to see how far it is.

Do not run the converter again over the same output folder while you are editing the world it wrote. It rewrites the world file, and your edits to it would be lost.

Skinned and animated meshes
^^^^^^^^^^^^^^^^^^^^^^^^^^^

* A skinned mesh that no animation moves (vehicles are often exported this way) becomes an ordinary static piece. It keeps its bones, so animations can still be added to it later.
* Animated meshes are grouped. Meshes moved by the same animation, directly or through another mesh it also moves, become one animated model carrying every animation that touches them. Two animations that move separate things end up as two models. A keyframe that never leaves its node's rest pose doesn't count as movement, since exporters often key every node.
* An animated model placed many times shares one file. Its animations are stored once when the copies have identical ones. When copies have different animations under the same name, every variant is named ``<placement node>|<animation name>``.
* An animated model is written as ``<source>_animated<number>_<root node name>.limonmodel``.
* No object is given an animation. Pick one in the editor.
* Some exports bind every placed copy of a skinned mesh as if it stood at the map origin (Unreal level exports do). Such skins are rebound to their rest pose.

Refused input
^^^^^^^^^^^^^

The converter stops without writing anything, and lists every node at fault, when the source has:

* a placement with shear, which a non uniform scale above a rotated child produces
* ``UCX_`` physics proxy nodes
* a skinned mesh with a bone that is not in the node tree
* no mesh with triangles at all

It also stops when the map needs more objects than the engine's object ID limit allows, which is 65536 including the animated models, the model groups and one more for the light. The message names the number the map would need.

An animated model that can't be converted is left out with an error naming it, and the rest of the map still converts. That happens when:

* a bone of the animated meshes is not in the node tree

* a bone that carries skin weights would get a rig index of 128 or more
* its placement is mirrored or sheared, since animated models can't be flipped
* its root node is animated and has a non uniform scale
* a bone it skins with shares its name with a later node of the same rig


.. seealso::

   * :ref:`limonmodel` -the format every converted piece is written in
   * :ref:`LevelOfDetail` -the LOD levels each piece carries
   * :ref:`UsingBuiltinEditor` -editing the converted world
   * :ref:`GettingStarted` -launching the engine
