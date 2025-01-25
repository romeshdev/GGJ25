class_name JukeboxBehaviour extends Node

@export var inGameMusic : AudioStreamPlayer
@export var titleMusic : AudioStreamPlayer

func playInGameMusic() -> void:
	titleMusic.stop()
	if !inGameMusic.playing:
		inGameMusic.play()

func playTitleMusic() -> void:
	inGameMusic.stop()
	if !titleMusic.playing:
		titleMusic.play()

func _ready():
	assert(inGameMusic != null)
	assert(titleMusic != null)
