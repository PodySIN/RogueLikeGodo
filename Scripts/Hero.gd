extends CharacterBody2D

#-----подгрузка-------------------------
@onready var ap = $AnimatedSprite2D
var array_of_muzzles: Array = ['%Muzzle1','%Muzzle2','%Muzzle3','%Muzzle4','%Muzzle5','%Muzzle6']
@export var bullet_scene: PackedScene
@export var riflebullet_scene: PackedScene
@export var uzibullet_scene: PackedScene
@export var karbullet_scene: PackedScene
@export var Shotgunbullet_scene: PackedScene
@onready var pistol_preload = preload("res://Scenes/pistol.tscn")
#-----подгрузка-------------------------

#-----vars-------------------------
var alive = true
var run = 0
var Stump_dmg = 60
var Worm_dmg = 90
var Flower_dmg = 30
var counter_of_death = 0
#-----vars-------------------------


func _ready():
	if Global.Class_select == 8:
		Global.array_players_guns =['']
	if Global.Class_select != 8:
		Global.array_players_guns = ['Pistol']
		Global.weapon_instances[0] = pistol_preload.instantiate()
		if Global.array_players_guns[0] == 'Pistol':
			Global.weapon_instances[0].position = Vector2(13,-23)
			$Weapons.add_child(Global.weapon_instances[0])
	if Global.Class_select == 2:
		Global.player_previous_health = Global.player_max_health
		Global.player_previous_owner_damage = Global.owner_damage
		Global.player_previous_owner_damage_percentage = Global.owner_damage_percentage
		Global.player_max_health = Global.player_previous_health * (1.0 + (Global.player_hp_percentage / 100))
		Global.owner_damage_percentage = int(Global.player_previous_health * 0.05) + Global.player_previous_owner_damage_percentage
		Global.owner_damage = (int(Global.player_previous_health * 0.05)) + Global.player_previous_owner_damage
	Signals.connect('Stump_hit', Callable(self, 'on_stump_bullet_damage_received'))
	Signals.connect('Worm_hit', Callable(self, 'on_worm_bullet_damage_received'))
	Signals.connect('Flower_hit', Callable(self, 'on_Flower_bullet_damage_received'))
	Signals.connect('MISS', Callable(self, 'on_miss_received'))
	Global.player_health = Global.player_max_health

func _physics_process(delta):
	mousepos_andETC() # set mouse pos for guns
	helth_control() # control live of character
	control_state() # for movement of character
	move_and_slide()

func mousepos_andETC():
	var mouse_pos = get_global_mouse_position()
	$Muzzles/Muzzle1.look_at(mouse_pos)
	$Muzzles/Muzzle2.look_at(mouse_pos)
	$Muzzles/Muzzle3.look_at(mouse_pos)
	$Muzzles/Muzzle4.look_at(mouse_pos)
	$Muzzles/Muzzle5.look_at(mouse_pos)
	$Muzzles/Muzzle6.look_at(mouse_pos)

func control_state():
	var direction = Input.get_vector("Left","Right",'Up',"Down")
	if alive:
		velocity = Global.player_speed * direction
		if direction:
			run += 1
			ap.play('run')
			if run == 1:
				$Sounds/Steps.play()
		else:
			run = 0
			$Sounds/Steps.play()
			ap.play('idle')
		if direction.x < 0:
			ap.flip_h = true
		elif direction.x > 0:
			ap.flip_h = false
		velocity = velocity.normalized() * Global.player_speed
	else:
		$Sounds/Steps.stop()
		direction = Vector2(0,0)
		velocity = Vector2.ZERO

func PistolShoot(MuzzleNumber):
	$Sounds/Pistol.play()
	Signals.emit_signal('pistol_fire')
	var bullet = bullet_scene.instantiate()
	bullet.transform = get_node(array_of_muzzles[MuzzleNumber]).global_transform
	get_tree().root.add_child(bullet)

func RifleShoot(MuzzleNumber):
	$Sounds/RiffleSound.play()
	Signals.emit_signal('rifle_fire')
	var rifle_bullet = riflebullet_scene.instantiate()
	rifle_bullet.transform = get_node(array_of_muzzles[MuzzleNumber]).global_transform
	get_tree().root.add_child(rifle_bullet)

func UziShoot(MuzzleNumber):
	$Sounds/UziSound.play()
	var uzi_bullet = uzibullet_scene.instantiate()
	uzi_bullet.transform = get_node(array_of_muzzles[MuzzleNumber]).global_transform
	get_tree().root.add_child(uzi_bullet)

func KarShoot(MuzzleNumber):
	$Sounds/KarSound.play()
	Signals.emit_signal('kar98k_fire')
	var Kar_bullet = karbullet_scene.instantiate()
	Kar_bullet.transform = get_node(array_of_muzzles[MuzzleNumber]).global_transform
	get_tree().root.add_child(Kar_bullet)

func ShotgunShoot(MuzzleNumber):
	$Sounds/ShotgunSound.play()
	Signals.emit_signal('shotgun_fire')
	var Shotgun_bullet = Shotgunbullet_scene.instantiate()
	Shotgun_bullet.transform = get_node(array_of_muzzles[MuzzleNumber]).global_transform
	get_tree().root.add_child(Shotgun_bullet)

func _on_pistol_timer_timeout():
	var coll = 0
	var arr_of_muzzle_numbers = []
	for i in range(len(Global.array_players_guns)):
		if Global.array_players_guns[i] == 'Pistol':
			coll+=1
			arr_of_muzzle_numbers.append(i)
	for i in range(coll):
		PistolShoot(arr_of_muzzle_numbers[i])
		await get_tree().create_timer(0.6).timeout
	coll = 0
	arr_of_muzzle_numbers = []

func _on_shotgun_timer_timeout():
	var coll = 0
	var arr_of_muzzle_numbers = []
	for i in range(len(Global.array_players_guns)):
		if Global.array_players_guns[i] == 'Shotgun':
			coll+=1
			arr_of_muzzle_numbers.append(i)
	for i in range(coll):
		ShotgunShoot(arr_of_muzzle_numbers[i])
		await get_tree().create_timer(0.6).timeout
	coll = 0
	arr_of_muzzle_numbers = []

func _on_rifle_timer_timeout():
	var coll = 0
	var arr_of_muzzle_numbers = []
	for i in range(len(Global.array_players_guns)):
		if Global.array_players_guns[i] == 'Rifle':
			coll+=1
			arr_of_muzzle_numbers.append(i)
	for i in range(coll):
		RifleShoot(arr_of_muzzle_numbers[i])
		await get_tree().create_timer(0.6).timeout
	coll = 0
	arr_of_muzzle_numbers = []

func _on_uzi_timer_timeout():
	var coll = 0
	var arr_of_muzzle_numbers = []
	for i in range(len(Global.array_players_guns)):
		if Global.array_players_guns[i] == 'Uzi':
			coll+=1
			arr_of_muzzle_numbers.append(i)
	for i in range(coll):
		UziShoot(arr_of_muzzle_numbers[i])
		await get_tree().create_timer(0.6).timeout
	coll = 0
	arr_of_muzzle_numbers = []

func _on_kar_timer_timeout():
	var coll = 0
	var arr_of_muzzle_numbers = []
	for i in range(len(Global.array_players_guns)):
		if Global.array_players_guns[i] == 'Kar':
			coll+=1
			arr_of_muzzle_numbers.append(i)
	for i in range(coll):
		KarShoot(arr_of_muzzle_numbers[i])
		await get_tree().create_timer(0.6).timeout
	coll = 0
	arr_of_muzzle_numbers = []

func on_stump_bullet_damage_received(Stump_damage):
	Stump_dmg = Stump_damage

func on_worm_bullet_damage_received(Worm_damage):
	Worm_dmg = Worm_damage
	
func on_flower_bullet_damage_received(Flower_damage):
	Flower_dmg = Flower_damage

func _on_hitbox_area_entered(area):
	var armor = Global.armor_calculating()
	if area.name == 'StumpBullet':
		$Sounds/GetHit.play()
		var random_miss = randi_range(0,100)
		if random_miss >= Global.player_miss_chance:
			Global.player_health -= (Global.Stump_damage - (Global.Stump_damage * armor))
		else:
			Global.player_health -= 0
			Signals.emit_signal('MISS')
			Signals.emit_signal('Return_damage_flower', Stump_dmg)
		if Global.can_return_damage:
			Signals.emit_signal('Return_damage_stump', Stump_dmg)
	if area.name == 'worm_bullet':
		Signals.emit_signal('WormBulletHit')
		$Sounds/GetHit.play()
		var random_miss = randi_range(0,100)
		if random_miss >= Global.player_miss_chance:
			Global.player_health -= (Global.Worm_damage - (Global.Worm_damage * armor))
		else:
			Global.player_health -= 0
			Signals.emit_signal('MISS')
			Signals.emit_signal('Return_damage_flower', Worm_dmg)
		if Global.can_return_damage:
			Signals.emit_signal('Return_damage_worm', Worm_dmg)
	if area.name == 'flower_bullet':
		Signals.emit_signal('FlowerBulletHit')
		$Sounds/GetHit.play()
		var random_miss = randi_range(0,100)
		if random_miss >= Global.player_miss_chance:
			Global.player_health -= (Global.Flower_damage - (Global.Flower_counter * armor))
		else:
			Global.player_health -= 0
			Signals.emit_signal('MISS')
			Signals.emit_signal('Return_damage_flower', Flower_dmg)
		if Global.can_return_damage:
			Signals.emit_signal('Return_damage_flower', Flower_dmg)
func helth_control():
	if Global.player_health > Global.player_max_health:
		Global.player_health = Global.player_max_health
	if Global.player_health <= 0:
		Global.player_health = 0
		counter_of_death+=1
		alive = false
		if counter_of_death == 1:
			get_death()
	Signals.emit_signal("health_changed", Global.player_health)

func get_death():
	ap.play("death")
	$death_timer.start()

func _on_death_timer_timeout():
	queue_free()
	get_tree().change_scene_to_file('res://Scenes/end_screen.tscn')

func _on_hp_regen_timeout():
	if Global.player_hp_regen > 0:
		Global.player_health += Global.player_hp_regen

func on_miss_received():
	var miss_label = randi_range(0,2)
	if miss_label == 0:
		$MissLabel1.visible = true
	elif miss_label == 1:
		$MissLabel2.visible = true
	else:
		$MissLabel3.visible = true
	await get_tree().create_timer(1).timeout
	$MissLabel1.visible = false
	$MissLabel2.visible = false
	$MissLabel3.visible = false
