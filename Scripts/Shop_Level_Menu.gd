extends Control
@onready var player = preload("res://Scenes/Hero.tscn")
@export var Rifle_scene: PackedScene
@export var Uzi_scene: PackedScene
@export var Kar_scene: PackedScene
@export var Pistol_scene: PackedScene
@onready var Shotgun_scene = preload("res://Scenes/shotgun.tscn")
var weapon
var buy_oportunity_number = 0
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
		Global.player_speed += 15

func _on_buy_item_1_pressed():
	buy_oportunity_number = 0
	buy_items(buy_oportunity_number, Global.buying_item_array[0])

func _on_buy_item_2_pressed():
	buy_oportunity_number = 1
	buy_items(buy_oportunity_number, Global.buying_item_array[1])

func _on_buy_item_3_pressed():
	buy_oportunity_number = 2
	buy_items(buy_oportunity_number, Global.buying_item_array[2])

func _on_buy_item_4_pressed():
	buy_oportunity_number = 3
	buy_items(buy_oportunity_number, Global.buying_item_array[3])

func buy_items(buy_oportunity_number, item):
	if Global.buy_oportunity[buy_oportunity_number] == true and item == 0 and Global.counter_guns < 6 and Global.array_of_costs[item] <= Global.GOLD:
		#$"../../Hero/Hero/Weapons"
		weapon = Pistol_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[item]
		Global.counter_guns += 1
		Global.array_players_guns.append('Pistol')
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.buy_oportunity[buy_oportunity_number] == true and item == 1 and Global.counter_guns < 6 and Global.array_of_costs[item] <= Global.GOLD:
		weapon = Rifle_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[item]
		Global.counter_guns += 1
		Global.array_players_guns.append('Rifle')
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.buy_oportunity[buy_oportunity_number] == true and item == 2 and Global.counter_guns < 6 and Global.array_of_costs[item] <= Global.GOLD:
		weapon = Uzi_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[item]
		Global.counter_guns += 1
		Global.array_players_guns.append('Uzi')
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.buy_oportunity[buy_oportunity_number] == true and item == 3 and Global.counter_guns < 6 and Global.array_of_costs[item] <= Global.GOLD:
		weapon = Kar_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[item]
		Global.counter_guns += 1
		Global.array_players_guns.append('Kar')
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.buy_oportunity[buy_oportunity_number] == true and item == 4 and Global.array_of_costs[item] <= Global.GOLD:
		Global.player_max_health += 25
		Global.player_health = Global.player_max_health
		Global.GOLD -= Global.array_of_costs[item]
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.buy_oportunity[buy_oportunity_number] == true and item == 5 and Global.array_of_costs[item] <= Global.GOLD:
		Global.owner_damage += 15
		Global.GOLD -= Global.array_of_costs[item]
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.buy_oportunity[buy_oportunity_number] == true and item == 6 and Global.array_of_costs[item] <= Global.GOLD:
		Global.player_crit_chance += 2
		Global.GOLD -= Global.array_of_costs[item]
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.buy_oportunity[buy_oportunity_number] == true and item == 7 and Global.counter_guns < 6 and Global.array_of_costs[Global.item1] <= Global.GOLD:
		weapon = Shotgun_scene.instantiate()
		position_for_gun()
		$"../../Hero/Hero/Weapons".add_child(weapon)
		Global.GOLD -= Global.array_of_costs[item]
		Global.counter_guns += 1
		Global.array_players_guns.append('Shotgun')
		Global.buy_oportunity[buy_oportunity_number] = false

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
