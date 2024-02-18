extends CharacterBody2D

#-----onready-------------------------
@onready var ap = $AnimatedSprite2D
@onready var player = $"../../Hero/Hero"
#-----onready-------------------------
#-----vars-------------------------
var upgrade_times = 0
var chase = true
var attacking = false
var alive = true
var counter_of_death = 0
var player_dmg = 0
var playerrifle_dmg = 0
var playeruzi_dmg = 0
var playerkar_dmg = 0
var playershotgun_dmg = 0
#-----vars-------------------------
#-----stats-------------------------
var direction = Vector2(randf_range(-1,1), randf_range(-1,1))
var Bunny_speed = 210
var Bunny_health = 80
var Bunny_max_health = 80
var Bunny_EXP_cost = 10
var Bunny_left_gold = 16
var Bunny_right_gold = 36
var Bunny_GOLD_cost = randi_range(Bunny_left_gold,Bunny_right_gold)
#-----stats-------------------------

func _ready():
	Signals.connect('bullet_hit', Callable (self, 'on_damage_received'))
	Signals.connect('Riflebullet_hit', Callable(self, 'on_rifledamage_received'))
	Signals.connect('Uzibullet_hit', Callable(self, 'on_uzidamage_received'))
	Signals.connect('Karbullet_hit', Callable(self, 'on_kardamage_received'))
	Signals.connect('Upgradetime',Callable(self,'_on_main_upgrade_timer_timeout'))
	Signals.connect('Shotgunbullet_hit', Callable(self,'on_Shotgundamage_received'))
	$HealthBar.min_value = 0
	$HealthBar.max_value = Bunny_max_health
	$HealthBar.value = Bunny_health

func _physics_process(delta):
	$HealthBar.value = Bunny_health
	helth_control()
	state_control()
	move_and_slide()

func state_control():
	if alive:
		movement()
	else:
		velocity = Vector2.ZERO

func movement():
	velocity = direction * Bunny_speed
	if chase and attacking == false:
		ap.play('run')
		if direction.x < 0:
			ap.flip_h = false
		elif direction.x > 0:
			ap.flip_h = true

func _on_random_dir_timeout():
	if direction.x > 0 and direction.y > 0:
		direction = Vector2(randf_range(-1,-0.2), randf_range(-1,-0.2))
	elif direction.x < 0 and direction.y > 0:
		direction = Vector2(randf_range(0.2,1), randf_range(-1,-0.2))
	elif direction.x < 0 and direction.y < 0:
		direction = Vector2(randf_range(0.2,1), randf_range(0.2,1))
	elif direction.x > 0 and direction.y < 0:
		direction = Vector2(randf_range(-1,-0.2), randf_range(0.2,1))

func helth_control():
	if Bunny_health <= 0:
		Bunny_health = 0
		counter_of_death+=1
		alive = false
		if counter_of_death == 1:
			get_death()

func get_death():
	$Sounds/DeadSound.play()
	$Enemy_hitbox.collision_layer = 8
	$CollisionShape2D.disabled = true
	ap.play("death")
	Global.EXP += Bunny_EXP_cost
	Bunny_GOLD_cost = randi_range(Bunny_left_gold ,Bunny_right_gold)
	Global.GOLD += Bunny_GOLD_cost
	Global.ALL_KILLS_IN_GAME += 1
	$Timers/death_timer.start()

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
func on_Shotgundamage_received(playerkar_damage):
	playershotgun_dmg = playerkar_damage
	
func _on_enemy_hitbox_area_entered(area):
	if area.name == 'Bullet':
		await get_tree().create_timer(0.02).timeout
		$Damage_label.text = str(player_dmg)
		$Damage_label.visible = true
		Bunny_health -= player_dmg
		Global.ALL_DAMAGE_IN_GAME += player_dmg
		$Timers/Damage_timer.start()
	elif area.name == 'rifle_bullet':
		await get_tree().create_timer(0.02).timeout
		$Damage_label_rifle.text = str(playerrifle_dmg)
		$Damage_label_rifle.visible = true
		Bunny_health -= playerrifle_dmg
		Global.ALL_DAMAGE_IN_GAME += playerrifle_dmg
		$Timers/Damage_timer.start()
	elif area.name == 'UziBullet':
		await get_tree().create_timer(0.02).timeout
		$Damage_label_uzi.text = str(playeruzi_dmg)
		$Damage_label_uzi.visible = true
		Bunny_health -= playeruzi_dmg
		Global.ALL_DAMAGE_IN_GAME += playeruzi_dmg
		$Timers/Damage_timer.start()
	elif area.name == 'kar98k_bullet':
		await get_tree().create_timer(0.02).timeout
		$Damage_label_kar.text = str(playerkar_dmg)
		$Damage_label_kar.visible = true
		Bunny_health -= playerkar_dmg
		Global.ALL_DAMAGE_IN_GAME += playerkar_dmg
		$Timers/Damage_timer.start()
	elif area.name == 'Shotgun_bullet':
		await get_tree().create_timer(0.02).timeout
		$ShotgunBullet.visible = true
		$ShotgunBullet.play('fire')
		$Damage_label_shotgun.text = str(playershotgun_dmg)
		$Damage_label_shotgun.visible = true
		Bunny_health -= playershotgun_dmg
		Global.ALL_DAMAGE_IN_GAME += playershotgun_dmg
		$Timers/Damage_timer.start()
	
func _on_damage_timer_timeout():
	$ShotgunBullet.stop()
	$ShotgunBullet.visible = false
	$Damage_label.visible = false
	$Damage_label_rifle.visible = false
	$Damage_label_uzi.visible = false
	$Damage_label_kar.visible = false
	$Damage_label_shotgun.visible = false

func _on_main_upgrade_timer_timeout():
	upgrade_times += 1
	if upgrade_times < 4:
		Bunny_max_health = int(Bunny_max_health * 1.15)
		Bunny_health = int(Bunny_health * 1.15)
		Bunny_speed = int(Bunny_speed * 1.05)
		Bunny_EXP_cost = int(Bunny_EXP_cost * 1.2)
		Bunny_left_gold += 2
		Bunny_right_gold += 2
	elif upgrade_times > 4 and upgrade_times < 10:
		Bunny_max_health = int(Bunny_max_health * 1.4)
		Bunny_health = int(Bunny_health * 1.4)
		Bunny_speed = int(Bunny_speed * 1.15)
		Bunny_EXP_cost = int(Bunny_EXP_cost * 1.6)
		Bunny_left_gold += 6
		Bunny_right_gold += 6
	elif upgrade_times > 10 and upgrade_times < 20:
		Bunny_max_health = int(Bunny_max_health * 1.8)
		Bunny_health = int(Bunny_health * 1.8)
		Bunny_speed = int(Bunny_speed * 1.3)
		Bunny_EXP_cost = int(Bunny_EXP_cost * 2.5)
		Bunny_left_gold += 15
		Bunny_right_gold += 15
	elif upgrade_times > 20:
		Bunny_max_health = int(Bunny_max_health * 3)
		Bunny_health = int(Bunny_health * 3)
		Bunny_speed = int(Bunny_speed * 2)
		Bunny_EXP_cost = int(Bunny_EXP_cost * 5)
		Bunny_left_gold += 30
		Bunny_right_gold += 30

func _on_dissapear_timer_timeout():
	queue_free()
