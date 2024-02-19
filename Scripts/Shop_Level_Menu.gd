extends Control
var on_information_window_mouse_entered = false
@onready var player = preload("res://Scenes/Hero.tscn")
@export var Rifle_scene: PackedScene
@export var Uzi_scene: PackedScene
@export var Kar_scene: PackedScene
@export var Pistol_scene: PackedScene
@onready var Shotgun_scene = preload("res://Scenes/shotgun.tscn")
var array_of_WeaponTextures = ['%WeaponTexture1','%WeaponTexture2','%WeaponTexture3','%WeaponTexture4','%WeaponTexture5','%WeaponTexture6']

var buy_oportunity_number = 0

func _process(delta):
	$InformationWindow/InformationWindowLabel.text = str('HP: ',Global.player_max_health,'\n','Attack: ',Global.owner_damage,'\n','Attack%: ',Global.owner_damage_percentage,'%','\n','MS: ',Global.player_speed,'\n','Crit.chance: ',Global.player_crit_chance,'%','\n','Crit.dmg: ',Global.player_crit_damage * 100,'%','\n','HP Regen: ',Global.player_hp_regen)
	print('Hp_max: ',Global.player_max_health,'\n','HP: ',Global.player_health,'\n','Atck: ',Global.owner_damage,'\n','Attck%: ',Global.owner_damage_percentage,
	'\n','Crit.chn: ',Global.player_crit_chance,'\n','Crit.dmg: ',Global.player_crit_damage,'\n','Ms: ',Global.player_speed)
	visible_UpgradesCounter()
	visible_texture_and_texts()
	visible_level_system()

func visible_level_system():
	$LevelStatInfo.text = str(Global.array_level_stats_info[Global.level_stats[0]])
	$LevelStatInfo2.text = str(Global.array_level_stats_info[Global.level_stats[1]])
	$LevelStatInfo3.text = str(Global.array_level_stats_info[Global.level_stats[2]])
	$LevelStatInfo4.text = str(Global.array_level_stats_info[Global.level_stats[3]])
	$LevelIcon1.texture = load(Global.array_level_stats_textures[Global.level_stats[0]])
	$LevelIcon2.texture = load(Global.array_level_stats_textures[Global.level_stats[1]])
	$LevelIcon3.texture = load(Global.array_level_stats_textures[Global.level_stats[2]])
	$LevelIcon4.texture = load(Global.array_level_stats_textures[Global.level_stats[3]])

func visible_UpgradesCounter():
	if Global.UpgradesCounter == 1:
		$UpgradesCounter.text = str('You have: ' + str(Global.UpgradesCounter) + ' point','
		 (max 5)')
	else:
		$UpgradesCounter.text = str('You have: ' + str(Global.UpgradesCounter) + ' points','
		 (max 5)')

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
	for i in range(len(Global.array_players_guns)):
		for j in range(len(Global.array_of_names_items)):
			if Global.array_players_guns[i] == Global.array_of_names_items[j]:
				get_node(array_of_WeaponTextures[i]).texture = load(Global.array_of_items[j])

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

func instantiate_weapons(weapon_name):
	for i in range(len(Global.array_players_guns)):
		if Global.array_players_guns[i] == 'Pistol':
			Global.weapon_instances[i] = Pistol_scene.instantiate()
			position_for_gun(Global.weapon_instances[i], i)
			$"../../Hero/Hero/Weapons".add_child(Global.weapon_instances[i])
		elif Global.array_players_guns[i] == 'Rifle':
			Global.weapon_instances[i] = Rifle_scene.instantiate()
			position_for_gun(Global.weapon_instances[i],i)
			$"../../Hero/Hero/Weapons".add_child(Global.weapon_instances[i])
		elif Global.array_players_guns[i] == 'Kar':
			Global.weapon_instances[i] = Kar_scene.instantiate()
			position_for_gun(Global.weapon_instances[i],i)
			$"../../Hero/Hero/Weapons".add_child(Global.weapon_instances[i])
		elif Global.array_players_guns[i] == 'Shotgun':
			Global.weapon_instances[i] = Shotgun_scene.instantiate()
			position_for_gun(Global.weapon_instances[i],i)
			$"../../Hero/Hero/Weapons".add_child(Global.weapon_instances[i])
		elif Global.array_players_guns[i] == 'Uzi':
			Global.weapon_instances[i] = Uzi_scene.instantiate()
			position_for_gun(Global.weapon_instances[i],i)
			$"../../Hero/Hero/Weapons".add_child(Global.weapon_instances[i])

func weapon_free():
	for i in range(len(Global.array_players_guns)):
		if Global.array_players_guns[i] != 'Empty':
			print(Global.array_players_guns)
			print(Global.weapon_instances)
			Global.weapon_instances[i].queue_free()

func buy_items(buy_oportunity_number, item):
	if Global.Class_select != 8 and Global.array_players_guns.count('Pistol') < 2 and Global.buy_oportunity[buy_oportunity_number] == true and item == 0 and Global.counter_guns < 6 and Global.array_of_costs[item] <= Global.GOLD:
		#$"../../Hero/Hero/Weapons"
		Global.GOLD -= Global.array_of_costs[item]
		if len(Global.array_players_guns) < 6:
			weapon_free()
			Global.array_players_guns.append('Pistol')
			instantiate_weapons('Pistol')
		elif len(Global.array_players_guns) == 6:
			for i in range(len(Global.array_players_guns)):
				if Global.array_players_guns[i] == 'Empty':
					Global.array_players_guns[i] = 'Pistol'
					Global.weapon_instances[i] = Pistol_scene.instantiate()
					position_for_gun(Global.weapon_instances[i], i)
					$"../../Hero/Hero/Weapons".add_child(Global.weapon_instances[i])
					break
		Global.counter_guns += 1
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.Class_select != 8 and Global.array_players_guns.count('Rifle') < 2 and Global.buy_oportunity[buy_oportunity_number] == true and item == 1 and Global.counter_guns < 6 and Global.array_of_costs[item] <= Global.GOLD:
		Global.GOLD -= Global.array_of_costs[item]
		if len(Global.array_players_guns) < 6:
			weapon_free()
			Global.array_players_guns.append('Rifle')
			instantiate_weapons('Rifle')
		elif len(Global.array_players_guns) == 6:
			for i in range(len(Global.array_players_guns)):
				if Global.array_players_guns[i] == 'Empty':
					Global.array_players_guns[i] = 'Rifle'
					Global.weapon_instances[i] = Rifle_scene.instantiate()
					position_for_gun(Global.weapon_instances[i], i)
					$"../../Hero/Hero/Weapons".add_child(Global.weapon_instances[i])
					break
		Global.counter_guns += 1
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.Class_select != 8 and Global.array_players_guns.count('Uzi') < 2 and Global.buy_oportunity[buy_oportunity_number] == true and item == 2 and Global.counter_guns < 6 and Global.array_of_costs[item] <= Global.GOLD:
		Global.GOLD -= Global.array_of_costs[item]
		if len(Global.array_players_guns) < 6:
			weapon_free()
			Global.array_players_guns.append('Uzi')
			instantiate_weapons('Uzi')
		elif len(Global.array_players_guns) == 6:
			for i in range(len(Global.array_players_guns)):
				if Global.array_players_guns[i] == 'Empty':
					Global.array_players_guns[i] = 'Uzi'
					Global.weapon_instances[i] = Uzi_scene.instantiate()
					position_for_gun(Global.weapon_instances[i], i)
					$"../../Hero/Hero/Weapons".add_child(Global.weapon_instances[i])
					break
		Global.counter_guns += 1
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.Class_select != 8 and Global.array_players_guns.count('Kar') < 2 and Global.buy_oportunity[buy_oportunity_number] == true and item == 3 and Global.counter_guns < 6 and Global.array_of_costs[item] <= Global.GOLD:
		Global.GOLD -= Global.array_of_costs[item]
		if len(Global.array_players_guns) < 6:
			weapon_free()
			Global.array_players_guns.append('Kar')
			instantiate_weapons('Kar')
		elif len(Global.array_players_guns) == 6:
			for i in range(len(Global.array_players_guns)):
				if Global.array_players_guns[i] == 'Empty':
					Global.array_players_guns[i] = 'Kar'
					Global.weapon_instances[i] = Kar_scene.instantiate()
					position_for_gun(Global.weapon_instances[i], i)
					$"../../Hero/Hero/Weapons".add_child(Global.weapon_instances[i])
					break
		Global.counter_guns += 1
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.Class_select != 8 and Global.array_players_guns.count('Shotgun') < 2 and Global.buy_oportunity[buy_oportunity_number] == true and item == 4 and Global.counter_guns < 6 and Global.array_of_costs[Global.item1] <= Global.GOLD:
		Global.GOLD -= Global.array_of_costs[item]
		if len(Global.array_players_guns) < 6:
			weapon_free()
			Global.array_players_guns.append('Shotgun')
			instantiate_weapons('Shotgun')
		elif len(Global.array_players_guns) == 6:
			for i in range(len(Global.array_players_guns)):
				if Global.array_players_guns[i] == 'Empty':
					Global.array_players_guns[i] = 'Shotgun'
					Global.weapon_instances[i] = Shotgun_scene.instantiate()
					position_for_gun(Global.weapon_instances[i], i)
					$"../../Hero/Hero/Weapons".add_child(Global.weapon_instances[i])
					break
		Global.counter_guns += 1
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.buy_oportunity[buy_oportunity_number] == true and item == 5 and Global.array_of_costs[item] <= Global.GOLD:
		Global.player_max_health += 25
		Global.player_speed -= 10
		Global.player_health = Global.player_max_health
		Global.GOLD -= Global.array_of_costs[item]
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.buy_oportunity[buy_oportunity_number] == true and item == 6 and Global.array_of_costs[item] <= Global.GOLD:
		Global.owner_damage += 5
		Global.owner_damage_percentage += 0.05
		Global.player_max_health -= 5
		Global.GOLD -= Global.array_of_costs[item]
		Global.buy_oportunity[buy_oportunity_number] = false
	elif Global.buy_oportunity[buy_oportunity_number] == true and item == 7 and Global.array_of_costs[item] <= Global.GOLD:
		Global.player_crit_chance += 2
		Global.player_crit_damage += 0.04
		Global.owner_damage_percentage -= 0.01
		Global.GOLD -= Global.array_of_costs[item]
		Global.buy_oportunity[buy_oportunity_number] = false
	

func position_for_gun(weapon, i):
	if i == 0:
		weapon.position = Vector2(13,-23)
	if i == 1:
		weapon.position = Vector2(-15,-25)
	elif i == 2:
		weapon.position = Vector2(15,-15)
	elif i == 3:
		weapon.position = Vector2(-15,-15)
	elif i == 4:
		weapon.position = Vector2(15,-7)
	elif i == 5:
		weapon.position = Vector2(-15,-7)

func _on_itemtexture_1_mouse_entered():
	var a = $Item1Info/Label1Info
	var item = Global.item1
	text_for_items(a,item)
	$Item1Info.visible = true
func _on_itemtexture_1_mouse_exited():
	$Item1Info.visible = false

func _on_itemtexture_2_mouse_entered():
	var a = $Item2Info/Label2Info
	var item = Global.item2
	text_for_items(a,item)
	$Item2Info.visible = true

func _on_itemtexture_2_mouse_exited():
	$Item2Info.visible = false

func _on_itemtexture_3_mouse_entered():
	var a = $Item3Info/Label3Info
	var item = Global.item3
	text_for_items(a,item)
	$Item3Info.visible = true

func _on_itemtexture_3_mouse_exited():
	$Item3Info.visible = false

func _on_itemtexture_4_mouse_entered():
	var a = $Item4Info/Label4Info
	var item = Global.item4
	text_for_items(a,item)
	$Item4Info.visible = true

func _on_itemtexture_4_mouse_exited():
	$Item4Info.visible = false

func text_for_items(a,item):
	for i in range(len(Global.array_of_names_items)):
		if Global.array_of_names_items[item] == Global.array_of_names_items[i]:
			a.text = Global.array_of_texts_items[i]

func _on_weapon_texture_1_mouse_entered():
	$WeaponInfo1.visible = true

func _on_weapon_texture_2_mouse_entered():
	if len(Global.array_players_guns) > 1:
		$WeaponInfo2.visible = true

func _on_weapon_texture_3_mouse_entered():
	if len(Global.array_players_guns) > 2:
		$WeaponInfo3.visible = true

func _on_weapon_texture_4_mouse_entered():
	if len(Global.array_players_guns) > 3:
		$WeaponInfo4.visible = true

func _on_weapon_texture_5_mouse_entered():
	if len(Global.array_players_guns) > 4:
		$WeaponInfo5.visible = true

func _on_weapon_texture_6_mouse_entered():
	if len(Global.array_players_guns) > 5:
		$WeaponInfo6.visible = true

func _on_close_button_6_pressed():
	$WeaponInfo6.visible = false

func _on_close_button_5_pressed():
	$WeaponInfo5.visible = false

func _on_close_button_4_pressed():
	$WeaponInfo4.visible = false

func _on_close_button_3_pressed():
	$WeaponInfo3.visible = false

func _on_close_button_2_pressed():
	$WeaponInfo2.visible = false

func _on_close_button_1_pressed():
	$WeaponInfo1.visible = false

func _on_sell_button_1_pressed():
	if Global.can_sell and Global.array_players_guns[0] != 'Empty' and len(Global.array_players_guns) >= 1:
		Global.counter_guns -= 1
		var a = Global.array_players_guns[0]
		sell_for_money(a)
		Global.weapon_instances[0].queue_free()
		
		Global.array_players_guns[0] = 'Empty'
		Global.can_sell = false
		%WeaponTexture1.texture = null

func _on_sell_button_2_pressed():
	if Global.can_sell and Global.array_players_guns[1] != 'Empty' and len(Global.array_players_guns) >= 2:
		Global.counter_guns -= 1
		var a = Global.array_players_guns[1]
		sell_for_money(a)
		Global.weapon_instances[1].queue_free()
		Global.array_players_guns[1] = 'Empty'
		Global.can_sell = false
		%WeaponTexture2.texture = null

func _on_sell_button_3_pressed():
	if Global.can_sell and Global.array_players_guns[2] != 'Empty' and len(Global.array_players_guns) >= 3:
		Global.counter_guns -= 1
		var a = Global.array_players_guns[2]
		sell_for_money(a)
		Global.weapon_instances[2].queue_free()
		Global.array_players_guns[2] = 'Empty'
		Global.can_sell = false
		%WeaponTexture3.texture = null

func _on_sell_button_4_pressed():
	if Global.can_sell and Global.array_players_guns[3] != 'Empty' and len(Global.array_players_guns) >= 4:
		Global.counter_guns -= 1
		var a = Global.array_players_guns[3]
		sell_for_money(a)
		Global.weapon_instances[3].queue_free()
		Global.array_players_guns[3] = 'Empty'
		Global.can_sell = false
		%WeaponTexture4.texture = null

func _on_sell_button_5_pressed():
	if Global.can_sell and Global.array_players_guns[4] != 'Empty' and len(Global.array_players_guns) >= 5:
		Global.counter_guns -= 1
		var a = Global.array_players_guns[4]
		sell_for_money(a)
		Global.weapon_instances[4].queue_free()
		Global.array_players_guns[4] = 'Empty'
		Global.can_sell = false
		%WeaponTexture5.texture = null

func _on_sell_button_6_pressed():
	if Global.can_sell and Global.array_players_guns[5] != 'Empty' and len(Global.array_players_guns) == 6:
		Global.counter_guns -= 1
		var a = Global.array_players_guns[5]
		sell_for_money(a)
		Global.weapon_instances[5].queue_free()
		Global.array_players_guns[5] = 'Empty'
		Global.can_sell = false
		%WeaponTexture6.texture = null

func sell_for_money(a):
	for i in range(len(Global.array_of_names_items)):
		if Global.array_of_names_items[i] == a:
			Global.GOLD += int(Global.array_of_costs[i] / 2)

func queue_weapon(weapon_number_for_queue):
	pass

func _on_weapon_texture_1_mouse_exited():
	await get_tree().create_timer(12).timeout
	$WeaponInfo1.visible = false

func _on_weapon_texture_2_mouse_exited():
	await get_tree().create_timer(12).timeout
	$WeaponInfo2.visible = false

func _on_weapon_texture_3_mouse_exited():
	await get_tree().create_timer(12).timeout
	$WeaponInfo3.visible = false

func _on_weapon_texture_4_mouse_exited():
	await get_tree().create_timer(12).timeout
	$WeaponInfo4.visible = false

func _on_weapon_texture_5_mouse_exited():
	await get_tree().create_timer(12).timeout
	$WeaponInfo5.visible = false

func _on_weapon_texture_6_mouse_exited():
	await get_tree().create_timer(12).timeout
	$WeaponInfo6.visible = false

func _on_button_level_pressed():
	if Global.level_buy_oportunity[0] == true:
		var a = Global.level_stats[0]
		Global.level_buy_oportunity[0] == false
		buy(a)

func _on_button_level_1_pressed():
	if Global.level_buy_oportunity[1] == true:
		var a = Global.level_stats[1]
		Global.level_buy_oportunity[1] == false
		buy(a)

func _on_button_level_2_pressed():
	if Global.level_buy_oportunity[2] == true:
		var a = Global.level_stats[2]
		Global.level_buy_oportunity[2] == false
		buy(a)

func _on_button_level_3_pressed():
	if Global.level_buy_oportunity[3] == true:
		var a = Global.level_stats[3]
		Global.level_buy_oportunity[3] == false
		buy(a)

func buy(a):
	if Global.UpgradesCounter > 0:
		if a == 0 or a == 6 or a == 12 or a == 18 or a == 24:
			Global.owner_damage += Global.array_level_stats_upgrade[a]
		elif a == 1 or a == 7 or a == 13 or a == 19 or a == 25:
			Global.owner_damage_percentage += Global.array_level_stats_upgrade[a]
		elif a == 2 or a == 8 or a == 14 or a == 20 or a == 26:
			Global.player_max_health += Global.array_level_stats_upgrade[a]
			Global.player_health = Global.player_max_health
			Signals.emit_signal("health_upgraded", Global.player_health)
		elif a == 3 or a == 9 or a == 15 or a == 21 or a == 27:
			Global.player_crit_chance += Global.array_level_stats_upgrade[a]
		elif a == 4 or a == 10 or a == 16 or a == 22 or a == 28:
			Global.player_speed += Global.array_level_stats_upgrade[a]
		elif a == 5 or a == 11 or a == 17 or a == 23 or a == 29:
			Global.player_crit_damage += Global.array_level_stats_upgrade[a]
		Global.UpgradesCounter -= 1

func _on_information_window_button_pressed():
	if on_information_window_mouse_entered == true:
		$InformationWindow.visible = true

func _on_information_window_button_mouse_entered():
	on_information_window_mouse_entered = true

func _on_information_window_button_mouse_exited():
	$InformationWindow.visible = false
