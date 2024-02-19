extends CharacterBody2D

#-----onready-------------------------
@onready var ap = $AnimatedSprite2D
@onready var player = $"../../Hero/Hero"
@export var Wormbullet_preload: PackedScene
#-----onready-------------------------
#-----vars-------------------------
var upgrade_times = 0
var in_area = false
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
var Worm_speed = 20
var Worm_health = 600
var Worm_max_health = 600
var Worm_EXP_cost = 40
var Worm_left_gold = 15
var Worm_right_gold = 25
var Worm_GOLD_cost = randi_range(Worm_left_gold,Worm_right_gold)
#-----stats-------------------------

func _ready():
	Signals.connect('bullet_hit', Callable (self, 'on_damage_received'))
	Signals.connect('Riflebullet_hit', Callable(self, 'on_rifledamage_received'))
	Signals.connect('Uzibullet_hit', Callable(self, 'on_uzidamage_received'))
	Signals.connect('Karbullet_hit', Callable(self, 'on_kardamage_received'))
	Signals.connect('Upgradetime',Callable(self,'_on_main_upgrade_timer_timeout'))
	Signals.connect('Shotgunbullet_hit', Callable(self,'on_Shotgundamage_received'))
	Signals.connect('Return_damage_worm', Callable(self,'on_return_damage_received'))
	$HealthBar.min_value = 0
	$HealthBar.max_value = Worm_max_health
	$HealthBar.value = Worm_health

func _physics_process(delta):
	$Muzzle.look_at(player.position)
	$HealthBar.value = Worm_health
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
		velocity = direction * Worm_speed
	elif in_area == true:
		velocity = -1 * direction * (Worm_speed / 1.5)
	if direction.x < 0:
		ap.flip_h = true
	elif direction.x > 0:
		ap.flip_h = false
	if chase and attacking == false:
		ap.play('run')

func helth_control():
	if Worm_health <= 0:
		Worm_health = 0
		counter_of_death+=1
		alive = false
		if counter_of_death == 1:
			get_death()

func get_death():
	$Sounds/WormDeath.play()
	$Enemy_hitbox.collision_layer = 8
	$CollisionShape2D.disabled = true
	ap.play("death")
	Global.EXP += Worm_EXP_cost
	Worm_GOLD_cost = randi_range(Worm_left_gold,Worm_right_gold)
	Global.GOLD += Worm_GOLD_cost
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

func on_Shotgundamage_received(player_damage):
	playershotgun_dmg = player_damage

func _on_enemy_hitbox_area_entered(area):
	if area.name == 'Bullet':
		await get_tree().create_timer(0.02).timeout
		$Sounds/WormHit.play()
		$Damage_label.text = str(player_dmg)
		$Damage_label.visible = true
		Worm_health -= player_dmg
		Global.ALL_DAMAGE_IN_GAME += player_dmg
		$damage_timer.start()
	elif area.name == 'rifle_bullet':
		await get_tree().create_timer(0.02).timeout
		$Sounds/WormHit.play()
		$Damage_label_rifle.text = str(playerrifle_dmg)
		$Damage_label_rifle.visible = true
		Worm_health -= playerrifle_dmg
		Global.ALL_DAMAGE_IN_GAME += playerrifle_dmg
		$damage_timer.start()
	elif area.name == 'UziBullet':
		$Sounds/WormHit.play()
		await get_tree().create_timer(0.02).timeout
		$Damage_label_uzi.text = str(playeruzi_dmg)
		$Damage_label_uzi.visible = true
		Worm_health -= playeruzi_dmg
		Global.ALL_DAMAGE_IN_GAME += playeruzi_dmg
		$damage_timer.start()
	elif area.name == 'kar98k_bullet':
		$Sounds/WormHit.play()
		await get_tree().create_timer(0.02).timeout
		$Damage_label_kar.text = str(playerkar_dmg)
		$Damage_label_kar.visible = true
		Worm_health -= playerkar_dmg
		Global.ALL_DAMAGE_IN_GAME += playerkar_dmg
		$damage_timer.start()
	elif area.name == 'Shotgun_bullet':
		await get_tree().create_timer(0.02).timeout
		$ShotgunBullet.visible = true
		$ShotgunBullet.play('fire')
		$Damage_label_shotgun.text = str(playershotgun_dmg)
		$Damage_label_shotgun.visible = true
		Worm_health -= playershotgun_dmg
		Global.ALL_DAMAGE_IN_GAME += playershotgun_dmg
		$damage_timer.start()

func on_return_damage_received(received_damage):
	Worm_health -= received_damage

func _on_damage_timer_timeout():
	$ShotgunBullet.stop()
	$ShotgunBullet.visible = false
	$Damage_label.visible = false
	$Damage_label_rifle.visible = false
	$Damage_label_uzi.visible = false
	$Damage_label_kar.visible = false
	$Damage_label_shotgun.visible = false

func _on_attack_cd_timeout():
	attacking = true
	if attacking:
		ap.play("attack")
		await get_tree().create_timer(1.1).timeout
		$Sounds/WormAttack.play()
		var Worm_bullet = Wormbullet_preload.instantiate()
		Worm_bullet.transform = $Muzzle.global_transform
		get_tree().root.add_child(Worm_bullet)
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
	upgrade_times += 1
	if upgrade_times < 4:
		Global.Worm_damage = int(Global.Worm_damage * 1.2)
		Worm_max_health = int(Worm_max_health * 1.15)
		Worm_speed = int(Worm_speed * 1.05)
		Worm_EXP_cost = int(Worm_EXP_cost * 1.2)
		Worm_left_gold += 1
		Worm_right_gold += 1
	elif upgrade_times > 4 and upgrade_times < 10:
		Global.Worm_damage = int(Global.Worm_damage * 1.5)
		Worm_max_health = int(Worm_max_health * 1.4)
		Worm_speed = int(Worm_speed * 1.15)
		Worm_EXP_cost = int(Worm_EXP_cost * 1.6)
		Worm_left_gold += 3
		Worm_right_gold += 3
	elif upgrade_times > 10 and upgrade_times < 20:
		Global.Worm_damage = int(Global.Worm_damage * 2)
		Worm_max_health = int(Worm_max_health * 1.8)
		Worm_speed = int(Worm_speed * 1.3)
		Worm_EXP_cost = int(Worm_EXP_cost * 2.5)
		Worm_left_gold += 6
		Worm_right_gold += 6
	elif upgrade_times > 20:
		Global.Worm_damage = int(Global.Worm_damage * 4)
		Worm_max_health = int(Worm_max_health * 3)
		Worm_speed = int(Worm_speed * 2)
		Worm_EXP_cost = int(Worm_EXP_cost * 5)
		Worm_left_gold += 15
		Worm_right_gold += 15
