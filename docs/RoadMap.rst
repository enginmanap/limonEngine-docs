========
Road Map
========

Latest release of the Limon Engine is 0.6. This page is meant to indicate the development plan up until 1.0. Please note information in this page is subject to change, and should not be considered final.

Version 0.6
===========

Main goal of this release was fighting. All of the listed functionality implemented.

#. Asset discovery should be automatic, instead of current asset list approach.
#. Allow attaching models to player. Should be used to carry weapons around.
#. Allow listening for input by triggers. Should be used for attack
#. Provide what is under the cursor, with its distance to player. Should allow checking for whether player hit something or not
#. Provide "distance to player" to Actors, so AI can determine melee attack.
#. Allow trigger <-> Actor communication for hits.
#. Allow adding quad/s as bullet holes etc.
#. There is no way to implement Player getting hit. A way should be exposed.

Version 0.7
===========

#. Material editor.
#. Particle emitters.
#. Shadow mapping improvements.


Before 1.0
==========

#. Generate AI navigation mesh from AI navigation grid. Serialize it with map. Done
#. Make world a tree, and allow modifications to groups. Done
#. Options can't be set using GUI, they should have.
#. Mixamo support. Done
#. Directory listings should auto generate for assets, and it should be able to refresh. Partially done, no refresh.
#. There is no stair support, there should be.
#. Editor should support undo/redo.
#. Auto Align objects.
#. Spot lights should be added.
#. Debug draw needs improvements, like duration.
#. Opacity should be better handled.
#. Object culling should be implemented.
#. File logger should be implemented.

Possible Additions
==================

#. Custom shaders
#. Vulkan backend
#. Python scripting support
#. Android support
#. Emscripten/webassembly support