extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	$AudioStreamPlayer.play()
	await $"../UI/PauseMenu/PressButtonSound".finished
	get_tree().paused = false
	Global.game_paused = !Global.game_paused
