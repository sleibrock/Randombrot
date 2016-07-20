#!/usr/bin/env python
#-*- coding: utf-8 -*-

# Import blenderpy
import bpy
from math import pi, cos, sin, atan2
from random import random

# De-select all objects from the scene first
for obj in bpy.data.objects:
    obj.select = False

# Clear the scene of extra meshes
meshes = [c.name for c in bpy.data.objects if c.type == "MESH"]
for o_name in meshes:
    bpy.data.objects[o_name].select = True
bpy.ops.object.delete()

# Import the obj file
bpy.ops.import_scene.obj(filepath="fractal.obj")

# Find and modify the camera's location
camera = bpy.data.objects["Camera"]
# camera.rotation_euler = (0,0,0) # reset the rotation to point down
# camera.location = (0,0,10.0) # reset camera's location to be above

# Randomize the light location
lamp = bpy.data.objects["Lamp"]
lamp.location = (0,0,0) # reset itl
lamp.location[0] = (16 * random()) - 8
lamp.location[1] = (16 * random()) - 8
lamp.location[2] = (1  + 2*random())
lamp.rotation_euler[2] = random() * (2*pi)
lamp.data.type = 'SUN'
lamp.data.sky.use_atmosphere = True
lamp.data.sky.atmosphere_distance_factor = random() * 100.0
lamp.data.color = (random(), random(), random())
lamp.data.energy = random()
lamp.data.shadow_color = (0.2*random(), 0.2*random(), 0.2*random())

# Set the rotation of the camera to be around the (0,0,0) point
# We will have to use some basic math to pick a random number between 0 and 2*PI to
# pick the position
rand_angle = random() * (2*pi)
r = 10.0
camera.location[0] = r * cos(rand_angle)
camera.location[1] = r * sin(rand_angle)
camera.rotation_euler[0] = 0.9500 # downwards angle
camera.rotation_euler[2] = atan2(*reversed(camera.location[:2])) + (pi/2)

# Render output
bpy.ops.render.render(write_still=True)
