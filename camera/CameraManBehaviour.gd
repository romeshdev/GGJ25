class_name CameraMan extends Node3D

@export var target : Node3D
@export var camera : Camera3D

func _ready():
	assert(target != null)
	assert(camera != null)

func _process(delta):
	camera.look_at(target.global_position)
