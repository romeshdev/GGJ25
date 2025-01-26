class_name EggBehaviour extends RigidBody3D

@export var fallingSound: AudioStreamPlayer3D

var fallSoundPlayed : bool = false
var startPosition : Vector3

func _ready():
	assert(fallingSound != null)
	startPosition = global_position

func _process(delta):
	# Play falling sound
	if position.y < 70 && !fallSoundPlayed:
		fallingSound.play()
		fallSoundPlayed = true
	
	# Restore position if the egg falls off a cliff
	if position.y < 9:
		global_position = startPosition
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
		fallSoundPlayed = false
