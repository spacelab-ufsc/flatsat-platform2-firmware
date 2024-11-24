# Zynq Programmable Logic Design

## Table of Contents
- [Recreating the Project](#recreating-the-project)
- [Updating the Design](#updating-the-design)

## Recreating the Project 
To recreate the project Vivado 2023.1 is a prerequisite, having it installed the process should be as simple as running the following in its TCL Console:

``` tcl
source /path-to-build-script/build.tcl
```

## Updating the Design 

### TODO {Better Documentation and Automation is needed!!}

After recreating the project and editing it is necessary to generate the TCL build script from Vivado using the following command in the TCL console:

``` tcl
write_project_tcl {/path-to-flatsat-repo/flatsat-platform2/firmware/fpga/create}

```
You also need to edit it in the following sections:

- Look at the necessary files listed by Vivado in the first comments, also remove the first comments from the file.

- Unless your modifications added a new IP Core, new constraints, etc. you just need to follow the build.tcl file adjusting the different entries comparing both files. They will differ manly on file paths.

After editing it and making sure it will generate the project correctly, rename the create.tcl file to build.tcl. You will also need to export the project to be used as a hardware description for petalinux.


