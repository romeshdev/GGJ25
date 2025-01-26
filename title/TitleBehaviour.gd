class_name TitleBehaviour extends Control

func _ready():
	Jukebox.playTitleMusic()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		_quit()
	if Input.is_action_just_pressed("ui_accept"):
		var focus = get_viewport().gui_get_focus_owner() as Button
		if focus != null:
			focus.pressed.emit()		


func _quit():
	get_tree().quit()

func _on_button_play_pressed():
	var game = load("res://game/RootGame.tscn").instantiate()
	get_tree().root.add_child(game)
	queue_free()

func _on_button_quit_pressed():
	_quit()
