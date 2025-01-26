class_name EggBehaviour extends RigidBody3D

var startPosition : Vector3

func _ready():
	startPosition = global_position

func _process(delta):
	# Restore position if the egg falls off a cliff
	if position.y < 9:
		global_position = startPosition
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
