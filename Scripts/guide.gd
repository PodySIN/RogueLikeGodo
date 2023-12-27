extends Node2D
func _process(delta):
	pass
func _on_quit_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
