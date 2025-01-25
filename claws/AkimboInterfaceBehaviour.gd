class_name AkimboInterface extends Control

##############################
# CONSTANTS
##############################

const ROTATION_DEAD_ZONE : float = 0.15


##############################
# EXPOSED IN INSPECTOR
##############################

@export var leftClaw : ClawInterface
@export var rightClaw : ClawInterface 


##############################
# PUBLIC ATTRIBUTES
##############################

var rotation_axis : float


##############################
# PUBLIC INTERFACE
##############################


##############################
# PRIVATE SUBROUTINES
##############################


##############################
# GODOT CALLBACKS
##############################

func _ready():
	assert(leftClaw != null)
	assert(rightClaw != null)

func _process(delta):
	# Parse rotation
	rotation_axis = (leftClaw.input.y - rightClaw.input.y) / 2
	rotation_axis = rotation_axis*rotation_axis*rotation_axis
	if abs(rotation_axis) < ROTATION_DEAD_ZONE:
		rotation_axis = 0
