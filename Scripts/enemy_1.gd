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
var playerrifle_dmg = 0
var playeruzi_dmg = 0
var playerkar_dmg = 0
#-----vars-------------------------
#-----stats-------------------------
var Sheep_speed = 140
var Sheep_health = 110
var Sheep_max_health = 110
var Sheep_EXP_cost = 4
var Sheep_left_gold = 2
var Sheep_right_gold = 3
var Sheep_GOLD_cost = randi_range(Sheep_left_gold,Sheep_right_gold)
#-----stats-------------------------

func _ready():
	Signals.connect('bullet_hit', Callable (self, 'on_damage_received'))
	Signals.connect('Riflebullet_hit', Callable(self, 'on_rifledamage_received'))
	Signals.connect('Uzibullet_hit', Callable(self, 'on_uzidamage_received'))
	Signals.connect('Karbullet_hit', Callable(self, 'on_kardamage_received'))
	Signals.connect('Upgradetime',Callable(self,'_on_main_upgrade_timer_timeout'))
	$HealthBar.min_value = 0
	$HealthBar.max_value = Sheep_max_health
	$HealthBar.value = Sheep_health

func _physics_process(delta):
	$HealthBar.value = Sheep_health
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
	velocity = direction * Sheep_speed
	if chase and attacking == false:
		ap.play('run')
		if direction.x < 0:
			ap.flip_h = true
		elif direction.x > 0:
			ap.flip_h = false

func helth_control():
	if Sheep_health <= 0:
		Sheep_health = 0
		counter_of_death+=1
		alive = false
		if counter_of_death == 1:
			get_death()

func get_death():
	var random_death = randi_range(0,2)
	if random_death == 0:
		$Music/Dead1.play()
	elif random_death == 1:
		$Music/Dead2.play()
	elif random_death == 2:
		$Music/Dead3.play()
	$Enemy_hitbox.collision_layer = 8
	$CollisionShape2D.disabled = true
	ap.play("death")
	Global.EXP += Sheep_EXP_cost
	Sheep_GOLD_cost = randi_range(Sheep_left_gold,Sheep_right_gold)
	Global.GOLD += Sheep_GOLD_cost
	Global.ALL_KILLS_IN_GAME += 1
	$death_timer.start()
	
func _on_hit_area_body_entered(body):
	if body.name == 'Hero' and alive:
		attacking = true
		if attacking:
			ap.play("attack")
			$attack_cd.start()

func _on_hit_area_body_exited(body):
	if body.name == 'Hero' and alive:
		if $attack_cd.time_left < 0.15:
			$Music/HitSound.play()
			Global.player_health -= Global.Sheep_damage / 2
		attacking = false
		$attack_cd.stop()

func _on_attack_cd_timeout():
	if alive:
		$Music/HitSound.play()
		Global.player_health -= Global.Sheep_damage

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
		$Damage_label.text = str(player_dmg)
		$Damage_label.visible = true
		Sheep_health -= player_dmg
		Global.ALL_DAMAGE_IN_GAME += player_dmg
		$Damage_timer.start()
	elif area.name == 'rifle_bullet':
		await get_tree().create_timer(0.02).timeout
		$Damage_label_rifle.text = str(playerrifle_dmg)
		$Damage_label_rifle.visible = true
		Sheep_health -= playerrifle_dmg
		Global.ALL_DAMAGE_IN_GAME += playerrifle_dmg
		$Damage_timer.start()
	elif area.name == 'UziBullet':
		await get_tree().create_timer(0.02).timeout
		$Damage_label_uzi.text = str(playeruzi_dmg)
		$Damage_label_uzi.visible = true
		Sheep_health -= playeruzi_dmg
		Global.ALL_DAMAGE_IN_GAME += playeruzi_dmg
		$Damage_timer.start()
	elif area.name == 'kar98k_bullet':
		await get_tree().create_timer(0.02).timeout
		$Damage_label_kar.text = str(playerkar_dmg)
		$Damage_label_kar.visible = true
		Sheep_health -= playerkar_dmg
		Global.ALL_DAMAGE_IN_GAME += playerkar_dmg
		$Damage_timer.start()

func _on_damage_timer_timeout():
	$Damage_label.visible = false
	$Damage_label_rifle.visible = false
	$Damage_label_uzi.visible = false
	$Damage_label_kar.visible = false

func _on_main_upgrade_timer_timeout():
	Global.Sheep_damage = int(Global.Sheep_damage * 1.15)
	Sheep_max_health = int(Sheep_max_health * 1.15)
	Sheep_health = int(Sheep_health * 1.15)
	Sheep_speed = int(Sheep_speed * 1.05)
	Sheep_EXP_cost = int(Sheep_EXP_cost * 1.2)
	Sheep_left_gold += 1
	Sheep_right_gold += 1
