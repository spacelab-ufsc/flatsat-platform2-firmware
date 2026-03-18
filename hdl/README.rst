Zynq Programmable Logic Design
====================================

.. contents:: Table of Contents
   :local:

Recreating the Project
----------------------
The Programmable Logic implementation is based on tcl scripts, aiming to facilitate version control and reusability. To recreate and build the project a Makefile is provided. The targets are ``xsa``, ``sdt`` and ``all``, with xsa being used to create the project, launch synthesis, launch implementation, writing the bitstream and exporting hardware platform. Target sdt generates the System Device Tree from the xsa file generated, this enables the integration with the newer yocto flow for AMD Xilinx layers. Target all simple runs both targets in sucession.

To run any target of the Makefile the Vivado environment should be sourced:

.. code-block:: bash

   source <vivado-path>/settings64.sh

To build all the artifacts run:

.. code-block:: bash

   make all

.. note:: The SDT target will only run on recent versions of Vivado, any version after 2024.2 should work fine.

Makefile Options
~~~~~~~~~~~~~~~~

Options for customizing the design are available below:

    * JOBS: Number of threads used by Vivado during runs.
    * PROJ_NAME: Name of the project, also names the block design and hardware files.
    * PLATFORM_NAME: Platform name, used for design customization (See `Updating the Design`_ for more details).

.. _update_design:

Updating the Design
-------------------

Since the FlatSat project was designed to be reusable and adaptable, means were provided so that it is easy to extend the base design for the platform.

The tcl scripts handle the project configuration, constraint files and necessary blocks for an "empty" FlatSat, besides that the scripts expect a platform to be defined so it can source the platform specific scripts.

A platform is included after the base block design is configured but before its validation and saving. This was done so that the platform scripts can add IP Blocks, extend configuration from already existing IPs, add constraints, etc.

Adding a new Platform
~~~~~~~~~~~~~~~~~~~~~

Adding a new platform is quite simple, just create a new directory under ``scripts/designs`` with the name of the platform, then create a tcl script named ``platform.tcl``, which is the script to be sourced by the main script.

One example on how to do this can be seen looking at ``scripts/designs/floripasat-2``, which contains the PL design for the FloripaSat-2 platform.

Vivado's Docker
---------------

A docker image to run Vivado is available on the ``docker`` directory, please refer to its README for details.
