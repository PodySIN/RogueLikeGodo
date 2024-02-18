extends Control
var class_choice = 1

func _on_balanced_pressed():
	class_choice = 1
	$UI/ClassInfo/Label.text = str('+30 HP\n+5 HPRegen\n+3 atk\n+7% atk\n+3% critchance\n+10% critdmg\n+10 ms')
	$UI/ClassInfo.visible = true
	
func _on_fatty_pressed():
	class_choice = 2
	$UI/ClassInfo/Label.text = '+250 HP\n+30% HP\n+10 HPRegen\n+3 atk\n+5% atk\n+15% critdmg\n-25 ms'
	$UI/ClassInfo.visible = true

func _on_warrior_pressed():
	class_choice = 3
	$UI/ClassInfo/Label.text = '-99 HP\n-10 HPRegen\n+20 atk\n+20% atk\n+5% critchance\n+25% critdmg'
	$UI/ClassInfo.visible = true

func _on_speedy_pressed():
	class_choice = 4
	$UI/ClassInfo/Label.text = '+5 atk\n+5% atk\n+3% critchance\n+125 ms'
	$UI/ClassInfo.visible = true

func _on_kapitalist_pressed():
	class_choice = 5
	$UI/ClassInfo/Label.text = '-25 HP\n+2 atk\n+10 passive gold(+scale)'
	$UI/ClassInfo.visible = true

func _on_comander_pressed():
	class_choice = 6
	$UI/ClassInfo/Label.text = '+100 HP\n+10 HPRegen\n+7 atk\n+15% atk\n+5% critchance\n+15% critdmg\n+25 ms\n-5 passive gold(+scale)'
	$UI/ClassInfo.visible = true

func _on_killer_pressed():
	class_choice = 7
	$UI/ClassInfo/Label.text = '-25 HP\n+2 atk\n+5% atk\n+15% critchance\n+65% critdmg\n+25 ms'
	$UI/ClassInfo.visible = true

func _on_lizard_pressed():
	class_choice = 8
	$UI/ClassInfo/Label.text = '+100 HP\n+50 HPRegen\n-25 atk\n-100% atk\nвозвращает полученный урон'
	$UI/ClassInfo.visible = true

func _on_scientist_mouse_entered():
	$focus.play()

func _on_killer_mouse_entered():
	$focus.play()

func _on_comander_mouse_entered():
	$focus.play()

func _on_kapitalist_mouse_entered():
	$focus.play()

func _on_speedy_mouse_entered():
	$focus.play()

func _on_warrior_mouse_entered():
	$focus.play()

func _on_fatty_mouse_entered():
	$focus.play()

func _on_balanced_mouse_entered():
	$focus.play()

func _on_get_pressed():
	if class_choice == 1:
		Global.player_max_health += 30
		Global.player_hp_regen += 5
		Global.player_health += 30
		Global.owner_damage += 3
		Global.owner_damage_percentage += 7
		Global.player_crit_chance += 3
		Global.player_crit_damage += 0.10
		Global.player_speed += 10
	elif class_choice == 2:
		Global.player_max_health += 250
		Global.player_hp_regen += 10
		Global.player_health += 250
		Global.owner_damage += 3
		Global.owner_damage_percentage += 5
		Global.player_crit_damage += 0.15
		Global.player_speed -= 25
	elif class_choice == 3:
		Global.player_max_health -= 99
		Global.player_hp_regen -= 10
		Global.player_health -= 99
		Global.owner_damage += 15
		Global.owner_damage_percentage += 25
		Global.player_crit_chance += 5
		Global.player_crit_damage += 0.25
	elif class_choice == 4:
		Global.owner_damage += 5
		Global.owner_damage_percentage += 5
		Global.player_crit_chance += 3
		Global.player_speed += 125
	elif class_choice == 5:
		Global.player_max_health -= 25
		Global.player_health -= 25
		Global.owner_damage += 2
		Global.player_gold_per_time += 10
	elif class_choice == 6:
		Global.player_max_health += 100
		Global.player_hp_regen += 10
		Global.player_health += 100
		Global.owner_damage += 7
		Global.owner_damage_percentage += 15
		Global.player_crit_chance += 5
		Global.player_crit_damage += 0.15
		Global.player_speed += 25
		Global.player_gol_per_time -= 5
	elif class_choice == 7:
		Global.player_max_health -= 25
		Global.player_health -= 25
		Global.owner_damage += 2
		Global.owner_damage_percentage += 5
		Global.player_crit_chance += 15
		Global.player_crit_damage += 0.65
		Global.player_speed += 25
	elif class_choice == 8:
		Global.player_max_health += 100
		Global.player_hp_regen += 50
		Global.player_health += 100
		Global.owner_damage -= 25
		Global.owner_damage_percentage -= 100
		Global.player_return_damage += 100
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
