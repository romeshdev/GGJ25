class_name TitleBehaviour extends Control

func _ready():
	Jukebox.playTitleMusic()

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_quit()

func _quit():
	_quit()

func _on_button_play_pressed():
	var game = load("res://game/RootGame.tscn").instantiate()
	get_tree().root.add_child(game)
	queue_free()

func _on_button_quit_pressed():
	get_tree().quit()
