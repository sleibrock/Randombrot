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
bpy.ops.import_scene.obj(filepath="fractal.obj")

# Find and modify the camera's location
camera = bpy.data.objects["Camera"]
camera.rotation_euler = (0,0,0)
camera.location = (0,0,10.0)

# Randomize the light location
light = bpy.data.objects["Lamp"]
light.location = (0,0,0) # reset it
