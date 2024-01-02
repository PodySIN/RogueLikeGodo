extends CharacterBody2D

#-----подгрузка-------------------------
@onready var ap = $AnimatedSprite2D
var array_of_muzzles: Array = ['%Muzzle1','%Muzzle2','%Muzzle3','%Muzzle4','%Muzzle5','%Muzzle6']
@export var bullet_scene: PackedScene
@export var riflebullet_scene: PackedScene
@export var uzibullet_scene: PackedScene
@export var karbullet_scene: PackedScene
#-----подгрузка-------------------------

#-----vars-------------------------
var alive = true
var Stump_dmg = 40
var counter_of_death = 0
#-----vars-------------------------


func _ready():
	Signals.connect('Stump_hit', Callable(self, 'on_stump_bullet_damage_received'))
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
	if alive:
		var direction = Input.get_vector("Left","Right",'Up',"Down")
		velocity = Global.player_speed * direction
		if direction:
			ap.play('run')
		else:
			ap.play('idle')
			if alive:
				$Sounds/Steps.play()
		if direction.x < 0:
			ap.flip_h = true
		elif direction.x > 0:
			ap.flip_h = false
		velocity = velocity.normalized() * Global.player_speed
	else:
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

func _on_hitbox_area_entered(area):
	if area.name == 'StumpBullet':
		$Sounds/GetHit.play()
		Global.player_health -= Stump_dmg

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
	Global.player_health += Global.player_hp_regen

