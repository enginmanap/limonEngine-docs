========
Road Map
========

Latest release of the Limon Engine is 0.5. This page is meant to indicate the development plan up until 1.0. Please note information in this page is subject to change, and should not be considered final.

Version 0.6
===========

Main goal of this release is fighting.

#. Asset discovery should be automatic, instead of current asset list approach.
#. Allow attaching models to player. Should be used to carry weapons around.
#. Allow listening for input by triggers. Should be used for attack
#. Provide what is under the cursor, with its distance to player. Should allow checking for whether player hit something or not
#. Provide "distance to player" to Actors, so AI can determine melee attack.
#. Allow trigger <-> Actor communication for hits.
#. Allow adding quad/s as bullet holes etc.
#. There is no way to implement Player getting hit. A way should be exposed.

Before 1.0
==========

#. Shadow mapping improvements.
#. Generate AI navigation mesh from AI navigation grid. Serialize it with map.
#. Make world a tree, and allow modifications to groups.
#. Directory listings should auto generate for assets, and it should be able to refresh.
#. Options can't be set using GUI, they should have.
#. There is no stair support, there should be.
#. Mixamo support.
#. Particle emitters.

Possible features
=================

#. Custom shaders and material editor.
