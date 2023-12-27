extends Area2D

@export var speed = 450

func _process(delta):
	position += transform.x * speed * delta
	$AnimatedSprite2D.play()

func _on_area_entered(area):
	Signals.emit_signal('bullet_hit', Global.Pistol_damage)
	queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
