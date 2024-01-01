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
		Global.player_max_health += Global.HP_gained_from_lvl
		Global.owner_damage += Global.DMG_gained_from_lvl
		Global.player_health = Global.player_max_health
		Global.item1 = randi_range(0,6)
		Global.item2 = randi_range(0,6)
		Global.item3 = randi_range(0,6)
		Global.item4 = randi_range(0,6)
		LVLED_UP = true




func _on_exit_menu_pressed():
	$"../UI/PauseMenu/PressButtonSound".play()
	await $"../UI/PauseMenu/PressButtonSound".finished
	Global.game_paused_menu = false
	Global.game_paused_shop = false
	get_tree().paused = false
	Global.zero_stats()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
