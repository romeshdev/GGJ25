class_name AkimboInterface extends Control

@export var leftClaw : ClawInterface
@export var rightClaw : ClawInterface 

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
	pass
