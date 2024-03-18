extends CharacterBody2D
#------------------------------------vars--------------------
@onready var ap = $Animations
@onready var player = $"../../Hero/Hero"
@onready var BG_music = $"../../Sounds/BGMUSIC"
var player_dmg = Global.Pistol_damage
var playerrifle_dmg = 0
var playeruzi_dmg = 0
var playerkar_dmg = 0
var playershotgun_dmg = 0
var Player_in_Roar = false
var Raptor_can_pounce = false
var Player_in_ponce_range = false
var Pounce_can_hit = false
var direction
var Pounce_hit = false
var Raptor_can_ROAR = true
var armor
var Raptor_can_bite = false
#------------------------------------stats--------------------
var Raptor_health: int = 2000
var Raptor_max_health: int = 2000
var Raptor_speed: int = 100
var Raptor_health_regen: int = 50
var Raptor_armor: float = 0.4
var Raptor_EXP_cost: int = 250
var Raptor_GOLD_cost: int = 300
var Raptor_ROAR_damage: int = 20
var Raptor_Pounce_damage: int = 200
var Raptor_Bite_damage: int = 150
#------------------------------------stats--------------------------
enum {
	RUN,
	DEATH,
	SCAN,
	BITE,
	CLAWATTACK,
	POUNCE,
	ROAR,
}
var state: int = 0:
	set(value):
		state = value
		match state:
			RUN:
				run_state()
			DEATH:
				death_state()
			SCAN:
				scan_state()
			BITE:
				bite_state()
			POUNCE:
				pounce_state()
			ROAR:
				roar_state()

func _ready():
	BG_music.stop()
	$UI/BossSpawnedLabel.visible = true
	$UI/BossDiedLabel.visible = false
	$UI/AnimationPlayer.play('BossSpawned')
	for i in range(Global.Raptor_kill_times):
		Raptor_armor *= 1.1
		Raptor_Bite_damage *= 1.3
		Raptor_max_health *= 1.2
		Raptor_health *= 1.2
		Raptor_health_regen *= 1.2
		Raptor_ROAR_damage *= 1.25
		Raptor_Pounce_damage *= 1.3
		Raptor_speed *= 1.2
		Raptor_GOLD_cost *= 1.1
		Raptor_armor = int(Raptor_armor)
		Raptor_Bite_damage = int(Raptor_Bite_damage)
		Raptor_max_health = int(Raptor_max_health)
		Raptor_health = int(Raptor_health)
		Raptor_health_regen = int(Raptor_health_regen)
		Raptor_ROAR_damage = int(Raptor_ROAR_damage)
		Raptor_Pounce_damage = int(Raptor_Pounce_damage)
		Raptor_speed = int(Raptor_speed)
		Raptor_GOLD_cost = int(Raptor_GOLD_cost)
	if Raptor_armor >= 0.9:
		Raptor_armor = 0.9
	state = SCAN
	Signals.connect('bullet_hit', Callable (self, 'on_damage_received'))
	Signals.connect('Riflebullet_hit', Callable(self, 'on_rifledamage_received'))
	Signals.connect('Uzibullet_hit', Callable(self, 'on_uzidamage_received'))
	Signals.connect('Karbullet_hit', Callable(self, 'on_kardamage_received'))
	Signals.connect('Upgradetime',Callable(self,'_on_main_upgrade_timer_timeout'))
	Signals.connect('Shotgunbullet_hit', Callable(self,'on_Shotgundamage_received'))
	$UI/HealthBar.min_value = 0
	$UI/HealthBar.max_value = Raptor_max_health
	$UI/HealthBar.value = Raptor_health

func _physics_process(delta):
	armor = Global.armor_calculating()
	direction = (player.position - self.position).normalized()
	if direction.x < 0:
		ap.flip_h = true
		$"Pounce_hit area/CollisionShape2D".position.x = -31
		$Bite_hit_area/CollisionShape2D.position.x = -39
		$Enemy_hitbox/RightColision.disabled = true
		$Enemy_hitbox/LeftCollision.disabled = false
	elif direction.x > 0:
		ap.flip_h = false
		$"Pounce_hit area/CollisionShape2D".position.x = 31
		$Bite_hit_area/CollisionShape2D.position.x = 39
		$Enemy_hitbox/LeftCollision.disabled = true
		$Enemy_hitbox/RightColision.disabled = false
	$UI/HealthBar.value = Raptor_health
	if Raptor_can_pounce and Player_in_ponce_range:
		state = POUNCE
		Raptor_can_pounce = false
	if Raptor_health <= 0:
		state = DEATH
	if state == RUN:
		velocity = direction * Raptor_speed
	if state == POUNCE:
		if Pounce_can_hit:
			var player_prev_speed = Global.player_speed
			ap.play('PounceAttack')
			$Sounds/PounceSound.play()
			velocity = Vector2.ZERO
			Global.player_health -= (Raptor_Pounce_damage - (Raptor_Pounce_damage * armor))
			if Global.can_return_damage:
				Raptor_health -= Raptor_Pounce_damage
			Global.player_speed = 0
			Pounce_can_hit = false
			Pounce_hit = true
			await get_tree().create_timer(2).timeout
			Pounce_hit = false
			Global.player_speed = player_prev_speed
			if Raptor_can_ROAR:
				state = ROAR
			elif Raptor_can_bite:
				state = BITE
			else:
				state = RUN
	move_and_slide()

func run_state():
	ap.play('Run')
	$Sounds/StepSound.play()

func death_state():
	velocity = Vector2.ZERO
	ap.play('Death')
	$RaptorCollision.disabled = true
	$Enemy_hitbox.collision_layer = 8
	if $Sounds/DeathSound.playing == false:
		BG_music.play()
		$Sounds/FightThemeMusic.stop()
		$UI/BossDiedLabel.visible = true
		$UI/AnimationPlayer.play('WinAnimation')
		$Timers/WinTimer.start()
		$Sounds/DeathSound.play()
		Global.GOLD += Raptor_GOLD_cost
		Global.Raptor_kill_times += 1
		Global.ALL_KILLS_IN_GAME += 1
		Global.UpgradesCounter += 5 - Global.UpgradesCounter
	await get_tree().create_timer(1.8).timeout
	queue_free()

func scan_state():
	velocity = Vector2.ZERO
	ap.play('Scan')
	if $Sounds/ScanSound.playing == false:
		$Sounds/ScanSound.play()
	await get_tree().create_timer(2.3).timeout
	state = ROAR

func bite_state():
	ap.play('Bite')
	if $Sounds/PounceSound.playing == false:
		$Sounds/PounceSound.play()
	velocity = Vector2.ZERO
	Global.player_health -= (Raptor_Bite_damage - (Raptor_Bite_damage * armor))
	if Global.can_return_damage:
		Raptor_health -= Raptor_Bite_damage
	await get_tree().create_timer(1.8).timeout
	if Raptor_can_ROAR:
		state = ROAR
	elif Raptor_can_pounce:
		state = POUNCE
	else:
		state = RUN

func pounce_state():
	if Raptor_can_pounce:
		ap.play('Pounce')
		velocity = direction * 700
		await get_tree().create_timer(1.2).timeout
		if Pounce_hit == false:
			Pounce_can_hit = false
			if Raptor_can_ROAR:
				state = ROAR
			elif Raptor_can_bite:
				state = BITE
			else:
				state = RUN

func roar_state():
	if Raptor_can_ROAR:
		ap.play('ROAR')
		$Sounds/RoarSound.play()
		velocity = Vector2.ZERO
		var prev_speed = Global.player_speed
		if Player_in_Roar:
			Global.player_speed = 0
		await get_tree().create_timer(1).timeout
		Global.player_health -= int(Raptor_ROAR_damage - (Raptor_ROAR_damage * armor))
		if Global.can_return_damage:
			Raptor_health -= Raptor_ROAR_damage
		for i in range(8):
			await get_tree().create_timer(0.25).timeout
			Global.player_health -= int(Raptor_ROAR_damage - (Raptor_ROAR_damage * armor))
			if Global.can_return_damage:
				Raptor_health -= Raptor_ROAR_damage
		await get_tree().create_timer(0.25).timeout
		Global.player_health -= int(Raptor_ROAR_damage - (Raptor_ROAR_damage * armor))
		if Global.can_return_damage:
			Raptor_health -= Raptor_ROAR_damage
		Global.player_speed = prev_speed
		Raptor_can_ROAR = false
		await get_tree().create_timer(0.75).timeout
		if Raptor_can_pounce and Player_in_ponce_range:
			state = POUNCE
		elif Raptor_can_bite:
			state = BITE
		else:
			state = RUN

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
		$Labels/Damage_label.text = str(int(player_dmg - (player_dmg * Raptor_armor)))
		$Labels/Damage_label.visible = true
		Raptor_health -= int(player_dmg - (player_dmg * Raptor_armor))
		Global.ALL_DAMAGE_IN_GAME += int(player_dmg - (player_dmg * Raptor_armor))
		$Timers/Damage_label_timer.start()
	elif area.name == 'rifle_bullet':
		await get_tree().create_timer(0.02).timeout
		$Labels/Damage_label_rifle.text = str(int(playerrifle_dmg - (playerrifle_dmg * Raptor_armor)))
		$Labels/Damage_label_rifle.visible = true
		Raptor_health -= int(playerrifle_dmg - (playerrifle_dmg * Raptor_armor))
		Global.ALL_DAMAGE_IN_GAME += int(playerrifle_dmg - (playerrifle_dmg * Raptor_armor))
		$Timers/Damage_label_timer.start()
	elif area.name == 'UziBullet':
		await get_tree().create_timer(0.02).timeout
		$Labels/Damage_label_uzi.text = str(int(playeruzi_dmg - (playeruzi_dmg * Raptor_armor)))
		$Labels/Damage_label_uzi.visible = true
		Raptor_health -= int(playeruzi_dmg - (playeruzi_dmg * Raptor_armor))
		Global.ALL_DAMAGE_IN_GAME += int(playeruzi_dmg - (playeruzi_dmg * Raptor_armor))
		$Timers/Damage_label_timer.start()
	elif area.name == 'kar98k_bullet':
		await get_tree().create_timer(0.02).timeout
		$Labels/Damage_label_kar.text = str(int(playerkar_dmg - (playerkar_dmg * Raptor_armor)))
		$Labels/Damage_label_kar.visible = true
		Raptor_health -= int(playerkar_dmg - (playerkar_dmg * Raptor_armor))
		Global.ALL_DAMAGE_IN_GAME += int(playerkar_dmg - (playerkar_dmg * Raptor_armor))
		$Timers/Damage_label_timer.start()
	elif area.name == 'Shotgun_bullet':
		await get_tree().create_timer(0.02).timeout
		$Labels/ShotgunBullet.visible = true
		$Labels/ShotgunBullet.play('fire')
		$Labels/Damage_label_shotgun.text = str(int(playershotgun_dmg - (playershotgun_dmg * Raptor_armor)))
		$Labels/Damage_label_shotgun.visible = true
		Raptor_health -= int(playershotgun_dmg - (playershotgun_dmg * Raptor_armor))
		Global.ALL_DAMAGE_IN_GAME += int(playershotgun_dmg - (playershotgun_dmg * Raptor_armor))
		$Timers/Damage_label_timer.start()

func _on_damage_label_timer_timeout():
	$Labels/ShotgunBullet.stop()
	$Labels/ShotgunBullet.visible = false
	$Labels/Damage_label.visible = false
	$Labels/Damage_label_rifle.visible = false
	$Labels/Damage_label_uzi.visible = false
	$Labels/Damage_label_kar.visible = false
	$Labels/Damage_label_shotgun.visible = false

func _on_hp_regen_timer_timeout():
	if Raptor_health > 0:
		Raptor_health += Raptor_health_regen

func _on_roar_c_dtimer_timeout():
	$Timers/RoarCDtimer.start()
	Raptor_can_ROAR = true
	if state != POUNCE and state != DEATH and state != BITE:
		state = ROAR

func _on_roar_body_entered(body):
	if body.name == 'Hero':
		Player_in_Roar = true

func _on_roar_body_exited(body):
	if body.name == 'Hero':
		Player_in_Roar = false

func _on_step_sound_finished():
	if state == RUN:
		$Sounds/StepSound.play()

func _on_pounce_cd_timer_timeout():
	Raptor_can_pounce = true

func _on_pounce_body_entered(body):
	if body.name == 'Hero':
		Player_in_ponce_range = true

func _on_pounce_body_exited(body):
	if body.name == 'Hero':
		Player_in_ponce_range = false

func _on_pounce_hit_area_body_entered(body):
	if body.name == 'Hero':
		Pounce_can_hit = true

func _on_pounce_hit_area_body_exited(body):
	if body.name == 'Hero':
		Pounce_can_hit = false

func _on_bite_hit_area_body_entered(body):
	if body.name == 'Hero':
		Raptor_can_bite = true
		if state != POUNCE and state != ROAR and state != DEATH:
			state = BITE

func _on_bite_hit_area_body_exited(body):
	if body.name == 'Hero':
		Raptor_can_bite = false

func _on_boss_spawned_label_timeout():
	$UI/BossSpawnedLabel.visible = false
	

func _on_win_timer_timeout():
	$UI/BossDiedLabel.visible = false
