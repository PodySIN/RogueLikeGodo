extends Node2D

var world = preload("res://Scenes/world.tscn")
func _ready():
	Input.set_custom_mouse_cursor(load("res://Assets/Other/Gui/1 cursor.png"), 0,Vector2(0,0))
	
func _process(delta):
	pass


func _on_play_pressed():
	$ChangeSceneMusic.play()
	await $ChangeSceneMusic.finished
	get_tree().change_scene_to_file("res://Scenes/set_class_menu.tscn")


func _on_exit_pressed():
	$ChangeSceneMusic.play()
	await $ChangeSceneMusic.finished
	get_tree().quit()


func _on_guide_pressed():
	$ChangeSceneMusic.play()
	await $ChangeSceneMusic.finished
	get_tree().change_scene_to_file("res://Scenes/guide.tscn")
