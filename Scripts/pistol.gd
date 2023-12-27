extends CharacterBody2D

func _physics_process(delta):
	if ((global_position - get_global_mouse_position()).x < 0):
		$Sprite2D.flip_v = false
		look_at(get_global_mouse_position())
	else:
		$Sprite2D.flip_v = true
		look_at(get_global_mouse_position())
	move_and_slide()
