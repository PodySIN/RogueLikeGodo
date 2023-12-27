extends CharacterBody2D

#-----signals-------------------------
signal health_changed (health)
#-----signals-------------------------

#-----onready-------------------------
@onready var ap = $AnimatedSprite2D
@export var bullet_scene: PackedScene
#-----onready-------------------------

#-----vars-------------------------
var alive = true
var counter_of_death = 0
var Level_hp = 10
#-----vars-------------------------

#-----stats-------------------------
@export var speed = 300
@export var health = 100
@export var max_health = 100
@export var hp_regen = 10
#-----stats-------------------------

func _ready():
	health = max_health
	
func _physics_process(delta):
	print(Global.Level, ' ', Global.EXP)
	mousepos_andETC()
	update_player_level()
	helth_control()
	control_state()
	move_and_slide()
	

func mousepos_andETC():
	var mouse_pos = get_global_mouse_position()
	$Muzzle.look_at(mouse_pos)
	
func control_state():
	if alive:
		movement()
	else:
		velocity = Vector2.ZERO

func update_player_level():
	var previous_level = Global.Level
	for i in range(len(Global.exp_brackers)):
		if Global.EXP < Global.exp_brackers[i]:
			Global.Level = i
			break
	if Global.Level > previous_level:
		max_health += Level_hp
		Global.owner_damage += 1
		health = max_health
		
func movement():
	var direction = Input.get_vector("Left","Right",'Up',"Down")
	velocity = speed * direction
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
	velocity = velocity.normalized() * speed

func PistolShoot():
	$Sounds/Pistol.play()
	var bullet = bullet_scene.instantiate()
	bullet.transform = $Muzzle.global_transform
	get_tree().root.add_child(bullet)
	
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

func _on_pistol_timer_timeout():
	PistolShoot()
