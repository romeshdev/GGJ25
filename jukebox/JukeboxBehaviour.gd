class_name JukeboxBehaviour extends Node

@export var inGameMusic : AudioStreamPlayer
@export var titleMusic : AudioStreamPlayer

func playInGameMusic() -> void:
	titleMusic.stop()
	inGameMusic.play()

func playTitleMusic() -> void:
	inGameMusic.stop()
	titleMusic.play()

func _ready():
	assert(inGameMusic != null)
	assert(titleMusic != null)
	 
func _process(delta):
	pass
