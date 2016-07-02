#!/usr/bin/env python
#-*- coding: utf-8 -*-

# Import blenderpy
import bpy

# Clear the scene of extra meshes
meshes = [c.name for c in bpy.data.objects if c.type == "MESH"]
for o_name in meshes:
    bpy.data.objects[o_name].select = True
bpy.ops.object.delete()

# Import the obj file
bpy.ops.import_scene.obj(filepath="/home/steve/Code/Randombrot/fractal.obj")

# Find and modify the camera's location
camera = bpy.data.objects["Camera"]
# camera.rotation_euler = (0,0,0) # reset the rotation to point down
# camera.location = (0,0,10.0) # reset camera's location to be above

# Randomize the light location
lamp = bpy.data.objects["Lamp"]
lamp.location = (0,0,0) # reset it

# Set the rotation of the camera to be around the 3D point cursor
camera.select = True
bpy.context.space_data.pivot_point = 'CURSOR'
bpy.context.space_data.transform_manipulators = {'ROTATE'}

