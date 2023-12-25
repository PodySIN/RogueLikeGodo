extends CharacterBody2D

#-----signals-------------------------
signal health_changed (new_health)
#-----signals-------------------------

#-----onready-------------------------
@onready var ap = $AnimatedSprite2D
#-----onready-------------------------

#-----vars-------------------------
var alive = true
var counter_of_death = 0
#-----vars-------------------------

#-----stats-------------------------
@export var speed = 400
@export var health = 100
@export var max_health = 100
@export var hp_regen = 10
#-----stats-------------------------

func _ready():
	health = max_health
func _physics_process(delta):
	helth_control()
	movement()
	
func movement():
	var direction = Input.get_vector("Left","Right",'Up',"Down")
	if alive:
		velocity = speed * direction
		if direction:
			ap.play('run')
			
		else:
			ap.play('idle')
			if alive:
				$AudioStreamPlayer.play()
		if direction.x < 0:
			ap.flip_h = true
		elif direction.x > 0:
			ap.flip_h = false
		velocity = velocity.normalized() * speed
	else:
		velocity = Vector2.ZERO
	move_and_slide()
	
func helth_control():
	if health > max_health:
		health = max_health
	if health <= 0:
		health = 0
		counter_of_death+=1
		alive = false
		if counter_of_death == 1:
			get_death()
	emit_signal("health_changed", health)

func get_death():
	ap.play("death")
	$death_timer.start()

func _on_death_timer_timeout():
	queue_free()
	get_tree().change_scene_to_file('res://Scenes/end_screen.tscn')


func _on_hp_regen_timeout():
	health+=hp_regen
