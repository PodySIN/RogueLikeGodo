extends CharacterBody2D

#-----onready-------------------------
@onready var ap = $AnimatedSprite2D
@onready var player = $"../../Hero/Hero"
#-----onready-------------------------
#-----vars-------------------------
var upgrade_times = 0
var chase = true
var attacking = false
var attacking_area = false
var alive = true
var counter_of_death = 0
var player_dmg = 0
var playerrifle_dmg = 0
var playeruzi_dmg = 0
var playerkar_dmg = 0
var playershotgun_dmg = 0
#-----vars-------------------------
#-----stats-------------------------
var Hameleon_speed = 170
var Hameleon_health = 210
var Hameleon_max_health = 210
var Hameleon_EXP_cost = 9
var Hameleon_left_gold = 5
var Hameleon_right_gold = 7
var Hameleon_GOLD_cost = randi_range(Hameleon_left_gold,Hameleon_right_gold)
#-----stats-------------------------

func _ready():
	Signals.connect('bullet_hit', Callable (self, 'on_damage_received'))
	Signals.connect('Riflebullet_hit', Callable(self, 'on_rifledamage_received'))
	Signals.connect('Uzibullet_hit', Callable(self, 'on_uzidamage_received'))
	Signals.connect('Karbullet_hit', Callable(self, 'on_kardamage_received'))
	Signals.connect('Upgradetime',Callable(self,'_on_main_upgrade_timer_timeout'))
	Signals.connect('Shotgunbullet_hit', Callable(self,'on_Shotgundamage_received'))
	$HealthBar.min_value = 0
	$HealthBar.max_value = Hameleon_max_health
	$HealthBar.value = Hameleon_health

func _physics_process(delta):
	$HealthBar.value = Hameleon_health
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
	if chase and attacking == false and attacking_area == false:
		velocity = direction * Hameleon_speed
		ap.play('run')
		if direction.x < 0:
			ap.flip_h = false
			$AnimatedSprite2D.offset = Vector2(-20,-19)
			$hit_area/CollisionShape2D.position = Vector2(-41,-15)
		elif direction.x > 0:
			ap.flip_h = true
			$AnimatedSprite2D.offset = Vector2(20,-19)
			$hit_area/CollisionShape2D.position = Vector2(41,-15)


func helth_control():
	if Hameleon_health <= 0:
		Hameleon_health = 0
		counter_of_death+=1
		alive = false
		if counter_of_death == 1:
			get_death()

func get_death():
	var random_death = randi_range(0,1)
	if random_death == 0:
		$Sounds/Death_sound.play()
	elif random_death == 1:
		$Sounds/Death_sound2.play()
	$Enemy_hitbox.collision_layer = 8
	$CollisionShape2D.disabled = true
	ap.play("death")
	Global.EXP += Hameleon_EXP_cost
	Hameleon_GOLD_cost = randi_range(Hameleon_left_gold,Hameleon_right_gold)
	Global.GOLD += Hameleon_GOLD_cost
	Global.ALL_KILLS_IN_GAME += 1
	$Timers/death_timer.start()

func _on_hero_area_body_entered(body):
	if body.name == 'Hero' and alive:
		attacking_area = true
		velocity /= 4

func _on_hero_area_body_exited(body):
	if body.name == 'Hero' and alive:
		attacking_area = false

func _on_hit_area_body_entered(body):
	if body.name == 'Hero' and alive and attacking_area == true:
		attacking = true
		if attacking:
			ap.play("attack")
			$Timers/attack_cd.start()


func _on_hit_area_body_exited(body):
	if body.name == 'Hero' and alive:
		attacking = false
		$Timers/attack_cd.stop()

func _on_attack_cd_timeout():
	if alive:
		$Sounds/AttackSound.play()
		$Sounds/HitSound.play()
		var random_miss = randi_range(0,100)
		var armor = Global.armor_calculating()
		if random_miss >= Global.player_miss_chance:
			Global.player_health -= (Global.Hameleon_damage - (Global.Hameleon_damage * armor))
		else:
			Global.player_health -= 0
			Signals.emit_signal('MISS')
			Hameleon_health -= Global.Hameleon_damage
		if Global.can_return_damage:
			Hameleon_health -= Global.Hameleon_damage

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

func _on_damage_timer_timeout():
	$ShotgunBullet.stop()
	$ShotgunBullet.visible = false
	$Damage_label.visible = false
	$Damage_label_rifle.visible = false
	$Damage_label_uzi.visible = false
	$Damage_label_kar.visible = false
	$Damage_label_shotgun.visible = false

func _on_main_upgrade_timer_timeout():
	if upgrade_times <= 4:
		Global.Hameleon_damage = int(Global.Hameleon_damage * 1.07)
		Hameleon_max_health = int(Hameleon_max_health * 1.07)
		Hameleon_speed = int(Hameleon_speed * 1.05)
		Hameleon_EXP_cost = int(Hameleon_EXP_cost * 1.2)
		Hameleon_left_gold += 1
		Hameleon_right_gold += 1
	elif upgrade_times > 4 and upgrade_times < 10:
		Global.Hameleon_damage = int(Global.Hameleon_damage * 1.13)
		Hameleon_max_health = int(Hameleon_max_health * 1.13)
		Hameleon_speed = int(Hameleon_speed * 1.15)
		Hameleon_EXP_cost = int(Hameleon_EXP_cost * 1.6)
		Hameleon_left_gold += 3
		Hameleon_right_gold += 3
	elif upgrade_times > 10 and upgrade_times < 20:
		Global.Hameleon_damage = int(Global.Hameleon_damage * 1.19)
		Hameleon_max_health = int(Hameleon_max_health * 1.19)
		Hameleon_speed = int(Hameleon_speed * 1.3)
		Hameleon_EXP_cost = int(Hameleon_EXP_cost * 2.5)
		Hameleon_left_gold += 6
		Hameleon_right_gold += 6
	elif upgrade_times > 20:
		Global.Hameleon_damage = int(Global.Hameleon_damage * 1.4)
		Hameleon_max_health = int(Hameleon_max_health * 1.4)
		Hameleon_speed = int(Hameleon_speed * 2)
		Hameleon_EXP_cost = int(Hameleon_EXP_cost * 5)
		Hameleon_left_gold += 15
		Hameleon_right_gold += 15
	upgrade_times += 1

func _on_enemy_hitbox_area_entered(area):
	if area.name == 'Bullet':
		await get_tree().create_timer(0.02).timeout
		$Damage_label.text = str(player_dmg)
		$Damage_label.visible = true
		Hameleon_health -= player_dmg
		Global.ALL_DAMAGE_IN_GAME += player_dmg
		$Timers/Damage_timer.start()
	elif area.name == 'rifle_bullet':
		await get_tree().create_timer(0.02).timeout
		$Damage_label_rifle.text = str(playerrifle_dmg)
		$Damage_label_rifle.visible = true
		Hameleon_health -= playerrifle_dmg
		Global.ALL_DAMAGE_IN_GAME += playerrifle_dmg
		$Timers/Damage_timer.start()
	elif area.name == 'UziBullet':
		await get_tree().create_timer(0.02).timeout
		$Damage_label_uzi.text = str(playeruzi_dmg)
		$Damage_label_uzi.visible = true
		Hameleon_health -= playeruzi_dmg
		Global.ALL_DAMAGE_IN_GAME += playeruzi_dmg
		$Timers/Damage_timer.start()
	elif area.name == 'kar98k_bullet':
		await get_tree().create_timer(0.02).timeout
		$Damage_label_kar.text = str(playerkar_dmg)
		$Damage_label_kar.visible = true
		Hameleon_health -= playerkar_dmg
		Global.ALL_DAMAGE_IN_GAME += playerkar_dmg
		$Timers/Damage_timer.start()
	elif area.name == 'Shotgun_bullet':
		await get_tree().create_timer(0.02).timeout
		$ShotgunBullet.visible = true
		$ShotgunBullet.play('fire')
		$Damage_label_shotgun.text = str(playershotgun_dmg)
		$Damage_label_shotgun.visible = true
		Hameleon_health -= playershotgun_dmg
		Global.ALL_DAMAGE_IN_GAME += playershotgun_dmg
		$Timers/Damage_timer.start()
