class_name CameraMan extends Node3D

@export var target : Node3D
@export var boomBack : Node3D
@export var boomUp : Node3D
@export var camera : Camera3D

@export var boomBackNear : Node3D
@export var boomUpNear : Node3D
@export var boomBackFar : Node3D
@export var boomUpFar : Node3D

const ZOOM_SPEED : float = 2

var targetZoom : float = 0
var currentZoom : float = 1

func _ready():
	assert(target != null)
	assert(boomBack != null)
	assert(boomUp != null)
	assert(camera != null)
	assert(boomUpNear != null)
	assert(boomUpNear != null)
	assert(boomUpFar != null)
	assert(boomUpFar != null)
	
func _process(delta):
	# Face the target
	camera.look_at(target.global_position)
	
	# Zoom in and out
	currentZoom = lerp(currentZoom, targetZoom, ZOOM_SPEED * delta)
	boomBack.global_position = boomBackFar.global_position.lerp(boomBackNear.global_position, currentZoom)
	boomUp.global_position = boomUpFar.global_position.lerp(boomUpNear.global_position, currentZoom)
