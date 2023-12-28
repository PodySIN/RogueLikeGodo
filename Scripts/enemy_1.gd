extends CharacterBody2D

#-----onready-------------------------
@onready var ap = $AnimatedSprite2D
@onready var player = $"../../Hero/Hero"
#-----onready-------------------------
#-----vars-------------------------
var chase = true
var attacking = false
var alive = true
var counter_of_death = 0
var player_dmg = 0
#-----vars-------------------------

#-----stats-------------------------
@export var enemy1_damage = 40
@export var speed = 100
@export var health = 100
@export var EXP_cost = 8
var GOLD_cost = randi_range(1,2)
#-----stats-------------------------
func _ready():
	Signals.connect('bullet_hit', Callable (self, 'on_damage_received'))

func _physics_process(delta):
	helth_control()
	state_control()
	move_and_slide()
	
func state_control():
	if alive:
		movement()
	else:
		velocity = Vector2.ZERO

func movement():
	var direction = (player.position - self.position).normalized()
	velocity = direction * speed
	if chase and attacking == false:
		ap.play('run')
		if direction.x < 0:
			ap.flip_h = true
		elif direction.x > 0:
			ap.flip_h = false

func helth_control():
	if health <= 0:
		health = 0
		counter_of_death+=1
		alive = false
		if counter_of_death == 1:
			get_death()

func get_death():
	$Enemy_hitbox.collision_layer = 8
	$CollisionShape2D.disabled = true
	ap.play("death")
	Global.EXP += EXP_cost
	Global.GOLD += GOLD_cost
	$death_timer.start()
	
func _on_hit_area_body_entered(body):
	if body.name == 'Hero' and alive:
		attacking = true
		if attacking:
			ap.play("attack")
			$attack_cd.start()

func _on_hit_area_body_exited(body):
	if body.name == 'Hero' and alive:
		if $attack_cd.time_left < 0.3:
			Global.player_health -= enemy1_damage / 2
		attacking = false
		$attack_cd.stop()

func _on_attack_cd_timeout():
	if alive:
		Global.player_health -= enemy1_damage

func _on_death_timer_timeout():
	queue_free()

func on_damage_received(player_damage):
	player_dmg = player_damage

func _on_enemy_hitbox_area_entered(area):
	await get_tree().create_timer(0.02).timeout
	health -= player_dmg
