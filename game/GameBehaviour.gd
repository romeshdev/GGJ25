class_name GameBehaviour extends Node

@export var crab : CrabBehaviour
@export var akimbo : AkimboInterface

func _ready():
	assert(crab != null)
	assert(akimbo != null)

func _process(delta):
	crab.input_rotation = akimbo.rotation_axis
	crab.input_advance = akimbo.movement_axis
