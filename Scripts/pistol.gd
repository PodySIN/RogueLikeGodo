extends CharacterBody2D

func _ready():
	Signals.connect('pistol_fire', Callable(self, 'pistol_anim'))

func _physics_process(delta):
	if ((global_position - get_global_mouse_position()).x < 0):
		$pistol_anim.flip_v = false
		look_at(get_global_mouse_position())
	else:
		$pistol_anim.flip_v = true
		look_at(get_global_mouse_position())
	move_and_slide()

func pistol_anim():
	$pistol_anim.play('fire')
	await get_tree().create_timer(0.7).timeout
	$pistol_anim.stop()
