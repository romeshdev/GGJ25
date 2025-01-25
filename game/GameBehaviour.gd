class_name GameBehaviour extends Node

@export var crab : CrabBehaviour
@export var akimbo : AkimboInterface

func _goToVictory():
	var victory = load("res://victory/RootVictory.tscn").instantiate()
	get_tree().root.add_child(victory)
	queue_free()

func _ready():
	assert(crab != null)
	assert(akimbo != null)
	Jukebox.playInGameMusic()

func _process(_delta):
	# Send information from UI to crab
	crab.input_rotation = akimbo.rotation_axis
	crab.input_advance = akimbo.movement_axis
	
	# Exit game is requested
	if Input.is_action_just_pressed("ui_cancel"):
		var game = load("res://title/RootTitle.tscn").instantiate()
		get_tree().root.add_child(game)
		queue_free()

func _on_timer_inferface_timeout():
	var defeat = load("res://defeat/RootDefeat.tscn").instantiate()
	get_tree().root.add_child(defeat)
	queue_free()

func _on_root_crab_fell_off_cliff():
	_goToVictory()
