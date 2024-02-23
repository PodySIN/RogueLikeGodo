extends Melee_Enemy

func _ready():
	$HealthBar.min_value = 0
	$HealthBar.max_value = Melee_Enemy_max_health
	Melee_Enemy_speed = 180
	Melee_Enemy_health = 250
	Melee_Enemy_max_health = 250
	Melee_Enemy_EXP_cost = 8
	Melee_Enemy_left_gold = 4
	Melee_Enemy_right_gold = 5
	Melee_Enemy_GOLD_cost = randi_range(Melee_Enemy_left_gold,Melee_Enemy_right_gold)

func _process(delta):
	helth_control()
	state_control()
	move_and_slide()
	$HealthBar.value = Melee_Enemy_health

func state_control():
	if alive:
		movement()
	else:
		velocity = Vector2.ZERO

func movement():
	var direction = (player.position - self.position).normalized()
	if chase and attacking == false and attacking_area == false:
		velocity = direction * Melee_Enemy_speed
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
	if Melee_Enemy_health <= 0:
		Melee_Enemy_health = 0
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
	Global.EXP += Melee_Enemy_EXP_cost
	Melee_Enemy_GOLD_cost = randi_range(Melee_Enemy_left_gold,Melee_Enemy_right_gold)
	Global.GOLD += Melee_Enemy_GOLD_cost
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
		if Global.can_return_damage:
			Melee_Enemy_health -= Global.Hameleon_damage

func _on_death_timer_timeout():
	queue_free()
