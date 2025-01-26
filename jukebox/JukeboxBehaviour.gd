class_name JukeboxBehaviour extends Node

@export var inGameMusic : AudioStreamPlayer
@export var titleMusic : AudioStreamPlayer
@export var defeatJingle : AudioStreamPlayer
@export var victoryJingle : AudioStreamPlayer
@export var jumpSound : AudioStreamPlayer
@export var spinSound : AudioStreamPlayer

func stopAllMusic() -> void:
	titleMusic.stop()
	inGameMusic.stop()
	defeatJingle.stop()
	victoryJingle.stop()

func playInGameMusic() -> void:
	titleMusic.stop()
	if !inGameMusic.playing:
		inGameMusic.play()

func playTitleMusic() -> void:
	inGameMusic.stop()
	if !titleMusic.playing:
		titleMusic.play()

func playDefeatJingle() -> void:
	inGameMusic.stop()
	titleMusic.stop()
	if !defeatJingle.playing:
		defeatJingle.play()

func playVictoryJingle() -> void:
	inGameMusic.stop()
	titleMusic.stop()
	if !victoryJingle.playing:
		victoryJingle.play()

func _ready():
	assert(inGameMusic != null)
	assert(titleMusic != null)
	assert(defeatJingle != null)
	assert(victoryJingle != null)
	assert(jumpSound != null)
	assert(spinSound != null)
