extends CharacterBody2D


#-----подгрузка-------------------------
@onready var ap = $AnimatedSprite2D
@export var bullet_scene: PackedScene
#-----подгрузка-------------------------

#-----vars-------------------------
var alive = true
var counter_of_death = 0
#-----vars-------------------------


func _ready():
	Global.player_health = Global.player_max_health
	
func _physics_process(delta):
	mousepos_andETC() # set mouse pos for guns
	helth_control() # control live of character
	control_state() # for movement of character
	move_and_slide()
	

func mousepos_andETC():
	var mouse_pos = get_global_mouse_position()
	$Muzzle.look_at(mouse_pos)
	
func control_state():
	if alive:
		movement()
	else:
		velocity = Vector2.ZERO


func movement():
	var direction = Input.get_vector("Left","Right",'Up',"Down")
	velocity = Global.player_speed * direction
	if direction:
		ap.play('run')
	else:
		ap.play('idle')
		if alive:
			$Sounds/Steps.play()
	if direction.x < 0:
		ap.flip_h = true
	elif direction.x > 0:
		ap.flip_h = false
	velocity = velocity.normalized() * Global.player_speed

func PistolShoot():
	$Sounds/Pistol.play()
	var bullet = bullet_scene.instantiate()
	bullet.transform = $Muzzle.global_transform
	get_tree().root.add_child(bullet)
	
func helth_control():
	if Global.player_health > Global.player_max_health:
		Global.player_health = Global.player_max_health
	if Global.player_health <= 0:
		Global.player_health = 0
		counter_of_death+=1
		alive = false
		if counter_of_death == 1:
			get_death()
	Signals.emit_signal("health_changed", Global.player_health)

func get_death():
	ap.play("death")
	$death_timer.start()

func _on_death_timer_timeout():
	queue_free()
	get_tree().change_scene_to_file('res://Scenes/end_screen.tscn')

func _on_hp_regen_timeout():
	Global.player_health += Global.player_hp_regen

func _on_pistol_timer_timeout():
	PistolShoot()
