extends Control

func _on_balanced_pressed():
	Global.Class_select = 1
	$UI/ClassInfo/Label.text = str('+50 HP\n+5 HPRegen\n+5 atk\n+10% atk\n+5% critchance\n+15% critdmg\n+25 ms\n+10 Start gold')
	$UI/ClassInfo.visible = true
	
func _on_fatty_pressed():
	Global.Class_select = 2
	$UI/ClassInfo/Label.text = '+250 HP\n+30% HP\n+10 HPRegen\n+5Armor\n-50 ms\n-5% critchance\n-10% critdmg\nУвеличивает урон за хп'
	$UI/ClassInfo.visible = true

func _on_warrior_pressed():
	Global.Class_select = 3
	$UI/ClassInfo/Label.text = '-99 HP\n-10 HPRegen\n+20 atk\n+20% atk\n+5% critchance\n+25% critdmg\nУвеличивает атаку за время игры'
	$UI/ClassInfo.visible = true

func _on_speedy_pressed():
	Global.Class_select = 4
	$UI/ClassInfo/Label.text = '+5 atk\n+5% atk\n+3% critchance\n+50 ms\n+15% уклонения\n С каждой минутой все быстрее'
	$UI/ClassInfo.visible = true

func _on_kapitalist_pressed():
	Global.Class_select = 5
	$UI/ClassInfo/Label.text = '-75 HP\n-5 atk\n+10 passive gold(+scale)\n+50 start gold'
	$UI/ClassInfo.visible = true

func _on_comander_pressed():
	Global.Class_select = 6
	$UI/ClassInfo/Label.text = '+100 HP\n+10 HPRegen\n+7 atk\n+15% atk\n+5% critchance\n+15% critdmg\n+25 ms\n-5 passive gold(+scale)\nС каждой минутой бафаются статы'
	$UI/ClassInfo.visible = true

func _on_killer_pressed():
	Global.Class_select = 7
	$UI/ClassInfo/Label.text = '-25 HP\n+2 atk\n+5% atk\n+15% critchance\n+65% critdmg\n+25 ms\nС каждой минутой криты становятся сильнее'
	$UI/ClassInfo.visible = true

func _on_lizard_pressed():
	Global.Class_select = 8
	$UI/ClassInfo/Label.text = '+200 HP\n+75 HPRegen\n+10 armor\nБольше не может атаковать\nвозвращает урон (все враги 1 типа дальнего боя получают урон)'
	$UI/ClassInfo.visible = true

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

func _on_lizard_mouse_entered():
	$focus.play()

func _on_get_pressed():
	if Global.Class_select == 1:
		Global.player_max_health += 50
		Global.player_hp_regen += 5
		Global.player_health += 50
		Global.owner_damage += 5
		Global.owner_damage_percentage += 10
		Global.player_crit_chance += 5
		Global.player_crit_damage += 0.15
		Global.player_speed += 25
		Global.GOLD += 10
	elif Global.Class_select == 2:
		Global.player_max_health += 250
		Global.player_hp_percentage += 30
		Global.player_armor += 5
		Global.player_hp_regen += 10
		Global.player_health += 250
		Global.player_speed -= 50
		Global.player_crit_chance -= 5
		Global.player_crit_damage -= 10
	elif Global.Class_select == 3:
		Global.player_max_health -= 99
		Global.player_hp_regen -= 10
		Global.player_health -= 99
		Global.owner_damage += 15
		Global.owner_damage_percentage += 25
		Global.player_crit_chance += 5
		Global.player_crit_damage += 0.25
	elif Global.Class_select == 4:
		Global.owner_damage += 5
		Global.owner_damage_percentage += 5
		Global.player_crit_chance += 3
		Global.player_speed += 50
		Global.player_miss_chance += 15
	elif Global.Class_select == 5:
		Global.player_max_health -= 75
		Global.player_health -= 75
		Global.owner_damage -= 5
		Global.player_gold_per_time += 10
		Global.GOLD += 50
	elif Global.Class_select == 6:
		Global.player_max_health += 100
		Global.player_hp_regen += 10
		Global.player_health += 100
		Global.owner_damage += 7
		Global.owner_damage_percentage += 15
		Global.player_crit_chance += 5
		Global.player_crit_damage += 0.15
		Global.player_speed += 25
		Global.player_gold_per_time -= 5
	elif Global.Class_select == 7:
		Global.player_max_health -= 25
		Global.player_health -= 25
		Global.owner_damage += 2
		Global.owner_damage_percentage += 5
		Global.player_crit_chance += 15
		Global.player_crit_damage += 0.65
		Global.player_speed += 25
	elif Global.Class_select == 8:
		Global.player_max_health += 200
		Global.player_armor += 10
		Global.player_hp_regen += 75
		Global.player_health += 200
		Global.owner_damage -= 100
		Global.owner_damage_percentage -= 100
		Global.can_return_damage = true
	get_tree().change_scene_to_file("res://Scenes/world.tscn")

func _on_back_from_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_back_pressed():
	$UI/ClassInfo.visible = false
