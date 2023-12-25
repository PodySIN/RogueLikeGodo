extends Node

var game_paused: bool = false
@onready var pause_menu = $"../UI/PauseMenu"


func _process(delta):
	if Input.is_action_just_pressed('ui_cancel'):
		game_paused = !game_paused
		pause_menu.show()
	if game_paused:
		get_tree().paused = true
	else:
		get_tree().paused = false
		pause_menu.hide()


func _on_resume_pressed():
	$"../UI/PauseMenu/PressButtonSound".play()
	await $"../UI/PauseMenu/PressButtonSound".finished
	game_paused = !game_paused


func _on_quit_pressed():
	$"../UI/PauseMenu/PressButtonSound".play()
	await $"../UI/PauseMenu/PressButtonSound".finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_menu_button_pressed():
	game_paused = !game_paused
	pause_menu.show()
