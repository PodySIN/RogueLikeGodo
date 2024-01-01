extends Control
@onready var player = preload("res://Scenes/Hero.tscn")
@export var Rifle_scene: PackedScene
@export var Uzi_scene: PackedScene
@export var Kar_scene: PackedScene
@export var Pistol_scene: PackedScene
var weapon
func _process(delta):
	visible_UpgradesCounter()
	visible_texture_and_texts()

func visible_UpgradesCounter():
	if Global.UpgradesCounter == 1:
		$UpgradesCounter.text = str('You have: ' + str(Global.UpgradesCounter) + ' point')
	else:
		$UpgradesCounter.text = str('You have: ' + str(Global.UpgradesCounter) + ' points')

func visible_texture_and_texts():
	$Gold.text = str(Global.GOLD)
	$Itemtexture1.texture = load(Global.array_of_items[Global.item1])
	$Itemtexture2.texture = load(Global.array_of_items[Global.item2])
	$Itemtexture3.texture = load(Global.array_of_items[Global.item3])
	$Itemtexture4.texture = load(Global.array_of_items[Global.item4])
	$CostItem1.text = str('$') + str(Global.array_of_costs[Global.item1])
	$CostItem2.text = str('$') + str(Global.array_of_costs[Global.item2])
	$CostItem3.text = str('$') + str(Global.array_of_costs[Global.item3])
	$CostItem4.text = str('$') + str(Global.array_of_costs[Global.item4])

func _on_health_pressed():
	if Global.UpgradesCounter > 0:
		Global.UpgradesCounter -= 1
		Global.player_max_health += 10
		Global.player_health = Global.player_max_health
		Signals.emit_signal("health_upgraded", Global.player_health)
	elif Global.UpgradesCounter == 0:
		pass

func _on_attack_pressed():
	if Global.UpgradesCounter > 0:
		Global.UpgradesCounter -= 1
		Global.owner_damage += 5

func _on_speed_pressed():
	if Global.UpgradesCounter > 0:
		Global.UpgradesCounter -= 1
		Global.player_speed += 25



func _on_buy_item_1_pressed():
	if Global.item1 == 0 and Global.counter_guns < 6 and Global.array_of_costs[Global.item1] <= Global.GOLD:
		#$"../../Hero/Hero/Weapons"
		weapon = Pistol_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item1]
		Global.counter_guns += 1
		Global.array_players_guns.append('Pistol')
	elif Global.item1 == 1 and Global.counter_guns < 6 and Global.array_of_costs[Global.item1] <= Global.GOLD:
		weapon = Rifle_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item1]
		Global.counter_guns += 1
		Global.array_players_guns.append('Rifle')
	elif Global.item1 == 2 and Global.counter_guns < 6 and Global.array_of_costs[Global.item1] <= Global.GOLD:
		weapon = Uzi_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item1]
		Global.counter_guns += 1
		Global.array_players_guns.append('Uzi')
	elif Global.item1 == 3 and Global.counter_guns < 6 and Global.array_of_costs[Global.item1] <= Global.GOLD:
		weapon = Kar_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item1]
		Global.counter_guns += 1
		Global.array_players_guns.append('Kar')
	elif Global.item1 == 4 and Global.array_of_costs[Global.item1] <= Global.GOLD:
		Global.player_max_health += 25
		Global.player_health = Global.player_max_health
		Global.GOLD -= Global.array_of_costs[Global.item1]
	elif Global.item1 == 5 and Global.array_of_costs[Global.item1] <= Global.GOLD:
		Global.owner_damage += 15
		Global.GOLD -= Global.array_of_costs[Global.item1]
	elif Global.item1 == 6 and Global.array_of_costs[Global.item1] <= Global.GOLD:
		Global.player_crit_chance += 2
		Global.GOLD -= Global.array_of_costs[Global.item1]



func _on_buy_item_2_pressed():
	if Global.item2 == 0 and Global.counter_guns < 6 and Global.array_of_costs[Global.item2] <= Global.GOLD:
		#$"../../Hero/Hero/Weapons"
		weapon = Pistol_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item2]
		Global.counter_guns += 1
		Global.array_players_guns.append('Pistol')
	elif Global.item2 == 1 and Global.counter_guns < 6 and Global.array_of_costs[Global.item2] <= Global.GOLD:
		weapon = Rifle_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item2]
		Global.counter_guns += 1
		Global.array_players_guns.append('Rifle')
	elif Global.item2 == 2 and Global.counter_guns < 6 and Global.array_of_costs[Global.item2] <= Global.GOLD:
		weapon = Uzi_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item2]
		Global.counter_guns += 1
		Global.array_players_guns.append('Uzi')
	elif Global.item2 == 3 and Global.counter_guns < 6 and Global.array_of_costs[Global.item2] <= Global.GOLD:
		weapon = Kar_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item2]
		Global.counter_guns += 1
		Global.array_players_guns.append('Kar')
	elif Global.item2 == 4 and Global.array_of_costs[Global.item2] <= Global.GOLD:
		Global.player_max_health += 25
		Global.player_health = Global.player_max_health
		Global.GOLD -= Global.array_of_costs[Global.item2]
	elif Global.item2 == 5 and Global.array_of_costs[Global.item2] <= Global.GOLD:
		Global.owner_damage += 15
		Global.GOLD -= Global.array_of_costs[Global.item2]
	elif Global.item2 == 6 and Global.array_of_costs[Global.item2] <= Global.GOLD:
		Global.player_crit_chance += 2
		Global.GOLD -= Global.array_of_costs[Global.item2]


func _on_buy_item_3_pressed():
	if Global.item3 == 0 and Global.counter_guns < 6 and Global.array_of_costs[Global.item3] <= Global.GOLD:
		#$"../../Hero/Hero/Weapons"
		weapon = Pistol_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item3]
		Global.counter_guns += 1
		Global.array_players_guns.append('Pistol')
	elif Global.item3 == 1 and Global.counter_guns < 6 and Global.array_of_costs[Global.item3] <= Global.GOLD:
		weapon = Rifle_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -=  Global.array_of_costs[Global.item3]
		Global.counter_guns += 1
		Global.array_players_guns.append('Rifle')
	elif Global.item3 == 2 and Global.counter_guns < 6 and Global.array_of_costs[Global.item3] <= Global.GOLD:
		weapon =Uzi_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -=  Global.array_of_costs[Global.item3]
		Global.counter_guns += 1
		Global.array_players_guns.append('Uzi')
	elif Global.item3 == 3 and Global.counter_guns < 6 and Global.array_of_costs[Global.item3] <= Global.GOLD:
		weapon = Kar_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item3]
		Global.counter_guns += 1
		Global.array_players_guns.append('Kar')
	elif Global.item3 == 4 and Global.array_of_costs[Global.item3] <= Global.GOLD:
		Global.player_max_health += 25
		Global.player_health = Global.player_max_health
		Global.GOLD -= Global.array_of_costs[Global.item3]
	elif Global.item3 == 5 and Global.array_of_costs[Global.item3] <= Global.GOLD:
		Global.owner_damage += 15
		Global.GOLD -= Global.array_of_costs[Global.item3]
	elif Global.item3 == 6 and Global.array_of_costs[Global.item3] <= Global.GOLD:
		Global.player_crit_chance += 2
		Global.GOLD -= Global.array_of_costs[Global.item3]


func _on_buy_item_4_pressed():
	if Global.item4 == 0 and Global.counter_guns < 6 and Global.array_of_costs[Global.item4] <= Global.GOLD:
		#$"../../Hero/Hero/Weapons"
		weapon = Pistol_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item4]
		Global.counter_guns += 1
		Global.array_players_guns.append('Pistol')
	elif Global.item4 == 1 and Global.counter_guns < 6 and Global.array_of_costs[Global.item4] <= Global.GOLD:
		weapon = Rifle_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item4]
		Global.counter_guns += 1
		Global.array_players_guns.append('Rifle')
	elif Global.item4 == 2 and Global.counter_guns < 6 and Global.array_of_costs[Global.item4] <= Global.GOLD:
		weapon =Uzi_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item4]
		Global.counter_guns += 1
		Global.array_players_guns.append('Uzi')
	elif Global.item4 == 3 and Global.counter_guns < 6 and Global.array_of_costs[Global.item4] <= Global.GOLD:
		weapon = Kar_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[Global.item4]
		Global.counter_guns += 1
		Global.array_players_guns.append('Kar')
	elif Global.item4 == 4 and Global.array_of_costs[Global.item4] <= Global.GOLD:
		Global.player_max_health += 25
		Global.player_health = Global.player_max_health
		Global.GOLD -= Global.array_of_costs[Global.item4]
	elif Global.item4 == 5 and Global.array_of_costs[Global.item4] <= Global.GOLD:
		Global.owner_damage += 15
		Global.GOLD -= Global.array_of_costs[Global.item4]
	elif Global.item4 == 6 and Global.array_of_costs[Global.item4] <= Global.GOLD:
		Global.player_crit_chance += 2
		Global.GOLD -= Global.array_of_costs[Global.item4]

func position_for_gun():
	if Global.counter_guns == 1:
		weapon.position = Vector2(-15,-25)
	elif Global.counter_guns == 2:
		weapon.position = Vector2(15,-15)
	elif Global.counter_guns == 3:
		weapon.position = Vector2(-15,-15)
	elif Global.counter_guns == 4:
		weapon.position = Vector2(15,-7)
	elif Global.counter_guns == 5:
		weapon.position = Vector2(-15,-7)
