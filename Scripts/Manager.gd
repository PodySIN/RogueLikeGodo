extends Node

@onready var pause_menu = $"../UI/PauseMenu"
@onready var ShopMenu =  $"../UI/Shop_Level_Menu"
var LVLED_UP = false

func _process(delta):
	MenuControl()
	update_player_level()
	Level_Control()
	if ((Global.game_paused_menu == true) or (Global.game_paused_shop == true)):
		get_tree().paused = true
	else:
		get_tree().paused = false

func Level_Control():
	if LVLED_UP:
		Global.game_paused_shop = true
		ShopMenu.show()
	if Global.game_paused_shop == false:
		ShopMenu.hide()

func MenuControl():
	if Input.is_action_just_pressed('ui_cancel'):
		Global.game_paused_menu = !Global.game_paused_menu
		pause_menu.show()
	if Global.game_paused_menu == false:
		pause_menu.hide()


func _on_resume_pressed():
	$"../UI/PauseMenu/PressButtonSound".play()
	await $"../UI/PauseMenu/PressButtonSound".finished
	Global.game_paused_menu = !Global.game_paused_menu


func _on_quit_pressed():
	$"../UI/PauseMenu/PressButtonSound".play()
	await $"../UI/PauseMenu/PressButtonSound".finished
	get_tree().quit()

func _on_menu_button_pressed():
	Global.game_paused_menu = !Global.game_paused_menu
	pause_menu.show()

func _on_quit_shop_pressed():
	$"../UI/Shop_Level_Menu/ButtonSound".play()
	await $"../UI/Shop_Level_Menu/ButtonSound".finished
	LVLED_UP = false
	Global.game_paused_shop = !Global.game_paused_shop


func update_player_level():

	var previous_level = Global.Level
	for i in range(len(Global.exp_brackers)):
		if Global.EXP < Global.exp_brackers[i]:
			Global.Level = i
			break
	if Global.Level > previous_level:
		Global.UpgradesCounter += 1
		if Global.UpgradesCounter >= 5:
			Global.UpgradesCounter = 5
		Global.player_max_health += Global.HP_gained_from_lvl
		Global.owner_damage += Global.DMG_gained_from_lvl
		if Global.Class_select == 2:
			Global.player_previous_owner_damage += 3
			Global.player_previous_health += 10
			Global.player_max_health = Global.player_previous_health * (1.0 + (Global.player_hp_percentage / 100))
			Global.owner_damage_percentage = int(Global.player_previous_health * 0.05) + Global.player_previous_owner_damage_percentage
			Global.owner_damage = (int(Global.player_previous_health * 0.05)) + Global.player_previous_owner_damage
		Global.player_health = Global.player_max_health
		if Global.Class_select != 8:
			Global.item1 = randi_range(0,4)
			Global.item2 = randi_range(5,14)
			Global.item3 = randi_range(5,14)
			Global.item4 = randi_range(5,17)
		else:
			Global.item1 = randi_range(5,14)
			Global.item2 = randi_range(5,14)
			Global.item3 = randi_range(5,17)
			Global.item4 = randi_range(5,17)
		Global.chances_on_lvl = [randi_range(0,100),randi_range(0,100),randi_range(0,100),randi_range(0,100)]
		for i in range(len(Global.chances_on_lvl)):
			if Global.chances_on_lvl[i] <= 60:
				Global.level_stats[i] = randi_range(0,7)
			elif Global.chances_on_lvl[i] > 60 and Global.chances_on_lvl[i] <= 85:
				Global.level_stats[i] = randi_range(8,15)
			elif Global.chances_on_lvl[i] > 85 and Global.chances_on_lvl[i] <= 95:
				Global.level_stats[i] = randi_range(16,23)
			elif Global.chances_on_lvl[i] > 95 and Global.chances_on_lvl[i] <= 99:
				Global.level_stats[i] = randi_range(24,31)
			elif Global.chances_on_lvl[i] == 100:
				Global.level_stats[i] = randi_range(32,39)
		for i in range(len(Global.array_of_costs)):
			if Global.Game_Time <= 90 and Global.Game_Time >= 45:
				Global.array_of_costs[i] = int(Global.array_of_costs[i] * 1.05)
			elif Global.Game_Time > 90 and Global.Game_Time <= 240:
				Global.array_of_costs[i] = int(Global.array_of_costs[i] * 1.1)
			elif Global.Game_Time > 240 and Global.Game_Time <= 600:
				Global.array_of_costs[i] = int(Global.array_of_costs[i] * 1.2)
			elif Global.Game_Time > 600:
				Global.array_of_costs[i] = int(Global.array_of_costs[i] * 1.35)
			elif Global.Game_Time > 900:
				Global.array_of_costs[i] = int(Global.array_of_costs[i] * 1.6)
		Global.can_sell = true
		Global.buying_item_array = [Global.item1 ,Global.item2 ,Global.item3 ,Global.item4]
		Global.buy_oportunity = [true,true,true,true]
		Global.level_buy_oportunity = [true,true,true,true]
		LVLED_UP = true

func _on_exit_menu_pressed():
	Global.zero_stats()
	$"../UI/PauseMenu/PressButtonSound".play()
	await $"../UI/PauseMenu/PressButtonSound".finished
	Global.game_paused_menu = false
	Global.game_paused_shop = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
