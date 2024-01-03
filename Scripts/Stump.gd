extends CharacterBody2D

#-----onready-------------------------
@onready var ap = $AnimatedSprite2D
@onready var player = $"../../Hero/Hero"
@export var Stumpbullet_preload: PackedScene
#-----onready-------------------------
#-----vars-------------------------
var in_area = false
var chase = true
var attacking = false
var alive = true
var counter_of_death = 0
var player_dmg = 0
var playerrifle_dmg = 0
var playeruzi_dmg = 0
var playerkar_dmg = 0
#-----vars-------------------------

#-----stats-------------------------
var Stump_speed = 60
var Stump_health = 170
var Stump_max_health = 170
var Stump_EXP_cost = 10
var Stump_left_gold = 4
var Stump_right_gold = 7
var Stump_GOLD_cost = randi_range(Stump_left_gold,Stump_right_gold)
#-----stats-------------------------

func _ready():
	Signals.connect('bullet_hit', Callable (self, 'on_damage_received'))
	Signals.connect('Riflebullet_hit', Callable(self, 'on_rifledamage_received'))
	Signals.connect('Uzibullet_hit', Callable(self, 'on_uzidamage_received'))
	Signals.connect('Karbullet_hit', Callable(self, 'on_kardamage_received'))
	Signals.connect('Upgradetime',Callable(self,'_on_main_upgrade_timer_timeout'))
	$HealthBar.min_value = 0
	$HealthBar.max_value = Stump_max_health
	$HealthBar.value = Stump_health

func _physics_process(delta):
	$Muzzle.look_at(player.position)
	$HealthBar.value = Stump_health
	helth_control()
	state_control()
	move_and_slide()

func state_control():
	if alive:
		movement()
	else:
		velocity = Vector2.ZERO

func movement():
	var direction = (player.position - global_position).normalized()
	if in_area == false:
		velocity = direction * Stump_speed
	elif in_area == true:
		velocity = -1 * direction * (Stump_speed / 1.5)
	if direction.x < 0:
		ap.flip_h = false
	elif direction.x > 0:
		ap.flip_h = true
	if chase and attacking == false:
		ap.play('run')

func helth_control():
	if Stump_health <= 0:
		Stump_health = 0
		counter_of_death+=1
		alive = false
		if counter_of_death == 1:
			get_death()

func get_death():
	var random_death = randi_range(0,1)
	if random_death == 0:
		$Sounds/DeadSound.play()
	elif random_death == 1:
		$Sounds/DeadSound2.play()
	$Enemy_hitbox.collision_layer = 8
	$CollisionShape2D.disabled = true
	ap.play("death")
	Global.EXP += Stump_EXP_cost
	Stump_GOLD_cost = randi_range(4,7)
	Global.GOLD += Stump_GOLD_cost
	Global.ALL_KILLS_IN_GAME += 1
	$death_timer.start()
	
func attack():
	pass

func _on_death_timer_timeout():
	queue_free()

func on_damage_received(player_damage):
	player_dmg = player_damage

func on_rifledamage_received(playerrifle_damage):
	playerrifle_dmg = playerrifle_damage

func on_uzidamage_received(playeruzi_damage):
	playeruzi_dmg = playeruzi_damage

func on_kardamage_received(playerkar_damage):
	playerkar_dmg = playerkar_damage

func _on_enemy_hitbox_area_entered(area):
	if area.name == 'Bullet':
		await get_tree().create_timer(0.02).timeout
		$Sounds/StumpHit.play()
		$Damage_label.text = str(player_dmg)
		$Damage_label.visible = true
		Stump_health -= player_dmg
		Global.ALL_DAMAGE_IN_GAME += player_dmg
		$damage_timer.start()
	elif area.name == 'rifle_bullet':
		await get_tree().create_timer(0.02).timeout
		$Sounds/StumpHit.play()
		$Damage_label_rifle.text = str(playerrifle_dmg)
		$Damage_label_rifle.visible = true
		Stump_health -= playerrifle_dmg
		Global.ALL_DAMAGE_IN_GAME += playerrifle_dmg
		$damage_timer.start()
	elif area.name == 'UziBullet':
		$Sounds/StumpHit.play()
		await get_tree().create_timer(0.02).timeout
		$Damage_label_uzi.text = str(playeruzi_dmg)
		$Damage_label_uzi.visible = true
		Stump_health -= playeruzi_dmg
		Global.ALL_DAMAGE_IN_GAME += playeruzi_dmg
		$damage_timer.start()
	elif area.name == 'kar98k_bullet':
		$Sounds/StumpHit.play()
		await get_tree().create_timer(0.02).timeout
		$Damage_label_kar.text = str(playerkar_dmg)
		$Damage_label_kar.visible = true
		Stump_health -= playerkar_dmg
		Global.ALL_DAMAGE_IN_GAME += playerkar_dmg
		$damage_timer.start()

func _on_damage_timer_timeout():
	$Damage_label.visible = false
	$Damage_label_rifle.visible = false
	$Damage_label_uzi.visible = false
	$Damage_label_kar.visible = false

func _on_attack_cd_timeout():
	attacking = true
	if attacking:
		ap.play("attack")
		await get_tree().create_timer(0.6).timeout
		$Sounds/ShootSound.play()
		var Stump_bullet = Stumpbullet_preload.instantiate()
		Stump_bullet.transform = $Muzzle.global_transform
		get_tree().root.add_child(Stump_bullet)
		$attack_anim_cd.start()

func _on_attack_anim_cd_timeout():
	attacking = false
	$attack_anim_cd.stop()

func _on_player_in_area_body_entered(body):
	if body.name == 'Hero' and alive:
		in_area = true

func _on_player_in_area_body_exited(body):
	if body.name == 'Hero' and alive:
		await get_tree().create_timer(0.4).timeout
		in_area = false

func _on_main_upgrade_timer_timeout():
	Global.Stump_damage = int(Global.Stump_damage * 1.15)
	Stump_max_health = int(Stump_max_health * 1.15)
	Stump_health = int(Stump_health * 1.15)
	Stump_speed = int(Stump_speed * 1.05)
	Stump_EXP_cost = int(Stump_EXP_cost * 1.2)
	Stump_left_gold += 1
	Stump_right_gold += 1
