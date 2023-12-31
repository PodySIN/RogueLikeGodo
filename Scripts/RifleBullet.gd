extends Area2D

@export var speed = 850

	
func _process(delta):
	position += transform.x * speed * delta
	$AnimatedSprite2D.play()

func _on_area_entered(area):
	Global.Rifle_damage_crit = Global.Rifle_damage
	Global.player_get_random_crit = randi_range(0,100)
	if Global.player_get_random_crit <= Global.player_crit_chance:
		Global.Rifle_damage_crit *= Global.player_crit_damage
	Signals.emit_signal('Riflebullet_hit', Global.Rifle_damage_crit)
	queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
