extends CharacterBody2D

#-----onready-------------------------
@onready var ap = $AnimatedSprite2D
@onready var player = $"../../Hero/Hero"
@export var Flowerbullet_preload: PackedScene
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
var direction
#-----vars-------------------------

#-----stats-------------------------
var Flower_health = 120
var Flower_max_health = 120
var Flower_EXP_cost = 4
var Flower_left_gold = 3
var Flower_right_gold = 4
var Flower_GOLD_cost = randi_range(Flower_left_gold,Flower_right_gold)
#-----stats-------------------------

func _ready():
	Signals.connect('bullet_hit', Callable (self, 'on_damage_received'))
	Signals.connect('Riflebullet_hit', Callable(self, 'on_rifledamage_received'))
	Signals.connect('Uzibullet_hit', Callable(self, 'on_uzidamage_received'))
	Signals.connect('Karbullet_hit', Callable(self, 'on_kardamage_received'))
	Signals.connect('Upgradetime',Callable(self,'_on_main_upgrade_timer_timeout'))
	Signals.connect('Shotgunbullet_hit', Callable(self,'on_Shotgundamage_received'))
	Signals.connect('Return_damage_flower', Callable(self,'on_return_damage_received'))
	$HealthBar.min_value = 0
	$HealthBar.max_value = Flower_max_health
	$HealthBar.value = Flower_health

func _physics_process(delta):
	$Muzzle.look_at(player.position)
	$HealthBar.value = Flower_health
	helth_control()
	state_control()
	move_and_slide()

func state_control():
	if alive:
		movement()
	else:
		velocity = Vector2.ZERO

func movement():
	direction = (player.position - global_position).normalized()
	if direction.x < 0:
		ap.flip_h = false
	elif direction.x > 0:
		ap.flip_h = true

func helth_control():
	if Flower_health <= 0:
		Flower_health = 0
		counter_of_death+=1
		alive = false
		if counter_of_death == 1:
			get_death()

func get_death():
	$Sounds/DeadSound.play()
	$Enemy_hitbox.collision_layer = 8
	$CollisionShape2D.disabled = true
	ap.play("Down_anim")
	Global.Flower_counter -=1
	Global.EXP += Flower_EXP_cost
	Flower_GOLD_cost = randi_range(Flower_left_gold,Flower_right_gold)
	Global.GOLD += Flower_GOLD_cost
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
		$Sounds/FlowerHit.play()
		$Damage_label.text = str(player_dmg)
		$Damage_label.visible = true
		Flower_health -= player_dmg
		Global.ALL_DAMAGE_IN_GAME += player_dmg
		$damage_timer.start()
	elif area.name == 'rifle_bullet':
		await get_tree().create_timer(0.02).timeout
		$Sounds/FlowerHit.play()
		$Damage_label_rifle.text = str(playerrifle_dmg)
		$Damage_label_rifle.visible = true
		Flower_health -= playerrifle_dmg
		Global.ALL_DAMAGE_IN_GAME += playerrifle_dmg
		$damage_timer.start()
	elif area.name == 'UziBullet':
		$Sounds/FlowerHit.play()
		await get_tree().create_timer(0.02).timeout
		$Damage_label_uzi.text = str(playeruzi_dmg)
		$Damage_label_uzi.visible = true
		Flower_health -= playeruzi_dmg
		Global.ALL_DAMAGE_IN_GAME += playeruzi_dmg
		$damage_timer.start()
	elif area.name == 'kar98k_bullet':
		$Sounds/FlowerHit.play()
		await get_tree().create_timer(0.02).timeout
		$Damage_label_kar.text = str(playerkar_dmg)
		$Damage_label_kar.visible = true
		Flower_health -= playerkar_dmg
		Global.ALL_DAMAGE_IN_GAME += playerkar_dmg
		$damage_timer.start()
	elif area.name == 'Shotgun_bullet':
		await get_tree().create_timer(0.02).timeout
		$ShotgunBullet.visible = true
		$ShotgunBullet.play('fire')
		$Damage_label_shotgun.text = str(playershotgun_dmg)
		$Damage_label_shotgun.visible = true
		Flower_health -= playershotgun_dmg
		Global.ALL_DAMAGE_IN_GAME += playershotgun_dmg
		$damage_timer.start()

func on_return_damage_received(received_damage):
	Flower_health -= Global.Flower_damage

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
		if direction.x > 0:
			ap.flip_h = true
			ap.play("Side_anim")
		else:
			ap.play("Side_anim")
		await get_tree().create_timer(1).timeout
		$Sounds/ShootSound.play()
		var Flower_bullet = Flowerbullet_preload.instantiate()
		Flower_bullet.transform = $Muzzle.global_transform
		get_tree().root.add_child(Flower_bullet)
		$attack_anim_cd.start()

func _on_attack_anim_cd_timeout():
	attacking = false
	$attack_anim_cd.stop()

func _on_main_upgrade_timer_timeout():
	if upgrade_times <= 4:
		Global.Flower_damage = int(Global.Flower_damage * 1.07)
		Flower_max_health = int(Flower_max_health * 1.1)
		Flower_EXP_cost = int(Flower_EXP_cost * 1.2)
		Flower_left_gold += 1
		Flower_right_gold += 1
	elif upgrade_times > 4 and upgrade_times <= 10:
		Global.Flower_damage = int(Global.Flower_damage * 1.13)
		Flower_max_health = int(Flower_max_health * 1.15)
		Flower_EXP_cost = int(Flower_EXP_cost * 1.3)
		Flower_left_gold += 2
		Flower_right_gold += 2
	elif upgrade_times > 10 and upgrade_times <= 20:
		Global.Flower_damage = int(Global.Flower_damage * 1.19)
		Flower_max_health = int(Flower_max_health * 1.19)
		Flower_EXP_cost = int(Flower_EXP_cost * 1.7)
		Flower_left_gold += 5
		Flower_right_gold += 5
	elif upgrade_times > 20:
		Global.Flower_damage = int(Global.Flower_damage * 1.4)
		Flower_max_health = int(Flower_max_health * 1.3)
		Flower_EXP_cost = int(Flower_EXP_cost * 2)
		Flower_left_gold += 10
		Flower_right_gold += 10
	upgrade_times += 1
