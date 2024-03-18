extends Node

#--------------------global-----------------------------------
var game_paused_menu: bool = false
var game_paused_shop: bool = false
var Game_Time: int = 0
var Raptor_kill_times = 0
var exp_brackers: Array = [0,16,41,77,126,190,271,371,492,636,805,1001,1226,1482,1771,
2095,2456,2856,3297,3781,4310,4886,5511,6187,6916,7700,8636,9572,10508,11444,12515,
13984,15453,16922,18391,19860,21329,22798,24267,25736,27420,29749 ,32078 ,34407 ,
36736 ,39065 ,41394 ,43723 ,46052 ,48381,51025,369550, 690000, 1300000, 2000000, 3000000, 4000000, 10000000, 100000000]

var array_of_items: Array = ["res://Assets/Other/Guns/GlockImage.png",
"res://Assets/Other/Guns/M4A4Image.png",
"res://Assets/Other/Guns/UZI.png",
"res://Assets/Other/Guns/Kar98kImage.png" ,
"res://Assets/Other/Guns/Shotgun/ShotgunImage.png",
"res://Assets/Other/Items/Items/Item__25.png",
"res://Assets/Other/Items/Items/Item__28.png",
"res://Assets/Other/Items/Items/Item__34.png",
"res://Assets/Other/Items3(weapons)/book13.png",
"res://Assets/Other/Items3(weapons)/book14.png",
"res://Assets/Other/Items3(weapons)/book15.png",
"res://Assets/Other/Items3(weapons)/book16.png",
"res://Assets/Other/Items3(weapons)/book17.png",
"res://Assets/Other/Items3(weapons)/book18.png",
"res://Assets/Other/Items3(weapons)/book19.png",
"res://Assets/Other/Items3(weapons)/book25.png",
"res://Assets/Other/Items3(weapons)/orb2.png",
"res://Assets/Other/Items3(weapons)/orb6.png",]

var array_level_stats: Array = [1,2,5,1,10,2,1,1, 2,5,10,2,20,4,2,2, 4,10,20,5,50,7,3,3, 7,16,40,9,90,12,5,5, 12,25,75,15,150,20,8,8]
var array_level_stats_info = [
'+1 atk','+2% atk','+5 hp','+1% crit.ch','+5 ms','+2% crit.dmg','+1 armor','+1% evasive',
'+2 atk','+5% atk','+10 hp','+2% crit.ch','+10 ms','+4% crit.dmg','+2 armor','+2% evasive',
'+4 atk','+10% atk','+20 hp','+5% crit.ch','+15 ms','+7% crit.dmg','+3 armor','+3% evasive',
'+7 atk','+16% atk','+40 hp','+9% crit.ch','+25 ms','+12% crit.dmg','+5 armor','+5% evasive',
'+12 atk','+25% atk','+75 hp','+15% crit.ch','+50 ms','+20% crit.dmg','+8 armor','+8% evasive',]

var array_level_stats_upgrade =[
 1,2,5,1,5,0.02,1,1,
 2,5,10,2,10,0.04,2,2,
 4,10,20,5,15,0.07,3,3,
 7,16,40,9,25,0.12,5,5,
 12,25,75,15,50,0.2,8,8,
]

var array_level_stats_textures = [
"res://Assets/Other/Items3(weapons)/sword2.png", "res://Assets/Other/Items3(weapons)/staff8.png", "res://Assets/Other/Items2(clothes)/quilted_armor.png", "res://Assets/Other/Items2(clothes)/cloth_hood.png", "res://Assets/Other/Items2(clothes)/cloth_shoes.png", "res://Assets/Other/Items2(clothes)/copper_ring.png", "res://Assets/Other/Items2(clothes)/wood_kite_shield.png","res://Assets/Other/Items2(clothes)/cloth_pants.png",
"res://Assets/Other/Items3(weapons)/sword4.png", "res://Assets/Other/Items3(weapons)/staff5.png", "res://Assets/Other/Items2(clothes)/leather_jacket_alt.png", "res://Assets/Other/Items2(clothes)/leather_cap.png", "res://Assets/Other/Items2(clothes)/leather_boots.png", "res://Assets/Other/Items2(clothes)/iron_ring.png", "res://Assets/Other/Items2(clothes)/wood_kite_shield_alt.png","res://Assets/Other/Items2(clothes)/leather_pants.png",
"res://Assets/Other/Items3(weapons)/sword6.png", "res://Assets/Other/Items3(weapons)/staff10.png", "res://Assets/Other/Items2(clothes)/studded_jacket_alt.png", "res://Assets/Other/Items2(clothes)/horned_helmet.png", "res://Assets/Other/Items2(clothes)/studded_boots.png", "res://Assets/Other/Items2(clothes)/silver_ring.png", "res://Assets/Other/Items2(clothes)/iron_buckler.png","res://Assets/Other/Items2(clothes)/studded_pants.png",
"res://Assets/Other/Items3(weapons)/sword15.png", "res://Assets/Other/Items3(weapons)/staff16.png", "res://Assets/Other/Items2(clothes)/chainmail_alt.png", "res://Assets/Other/Items2(clothes)/chainmail_coif.png", "res://Assets/Other/Items2(clothes)/chainmail_boots.png", "res://Assets/Other/Items2(clothes)/gold_ring.png", "res://Assets/Other/Items2(clothes)/kite_shield.png","res://Assets/Other/Items2(clothes)/chainmail_pants.png",
"res://Assets/Other/Items3(weapons)/sword25.png", "res://Assets/Other/Items3(weapons)/staff32.png", "res://Assets/Other/Items2(clothes)/breastplate.png", "res://Assets/Other/Items2(clothes)/platemail_helmet.png", "res://Assets/Other/Items2(clothes)/greaves.png", "res://Assets/Other/Items2(clothes)/tile049.png", "res://Assets/Other/Items2(clothes)/tower_shield.png","res://Assets/Other/Items2(clothes)/platemail_pants.png",
]
var level_stats: Array = [0,0,0,0]
var chances_on_lvl: Array = [0,0,0,0]

var HP_gained_from_lvl: int = 10
var DMG_gained_from_lvl: int = 3
##-----------------------------level_stats--------------------------------------
var player_get_random_crit: int = 100
var ALL_DAMAGE_IN_GAME: int = 0
var ALL_KILLS_IN_GAME: int = 0
#--------------------global-----------------------------------

#--------------------global_stats-------------------------------
var EXP: int = 0
var GOLD: int = 0
var Level: int = 1
var UpgradesCounter: int = 0
var Class_select: int = 1
#--------------------global_stats-------------------------------

#--------------------guns_stats_and_afrtifacts-------------------------------
var counter_guns: int = 1
var Pistol_damage: int = (20 + owner_damage) * ((owner_damage_percentage + 100) / 100)
var Rifle_damage: int = (40 + owner_damage) * ((owner_damage_percentage + 100) / 100)
var Uzi_damage: int = (10 + owner_damage) * ((owner_damage_percentage + 100) / 100)
var Kar_damage: int = (100 + owner_damage) * ((owner_damage_percentage + 100) / 100)
var Shotgun_damage: int = (60 + owner_damage) * ((owner_damage_percentage + 100) / 100)
var Pistol_damage_crit: int = Pistol_damage
var Rifle_damage_crit: int = Rifle_damage
var Uzi_damage_crit: int = Uzi_damage
var Kar_damage_crit: int = Kar_damage
var Shotgun_damage_crit: int = Shotgun_damage
var array_players_guns: Array = []
var weapon_instances: Array = [0,1,2,3,4,5]
#--------------------guns_stats-------------------------------

#--------------------player_stats-------------------------------
var player_hp_percentage: float = 0.0
var owner_damage_percentage: float = 1
var owner_damage: int = 0
var player_max_health: int = 100
var player_health: int = 100
var player_previous_health: int = player_max_health
var player_previous_owner_damage: int = owner_damage
var player_previous_owner_damage_percentage: float = owner_damage_percentage
var player_speed: int = 200
var player_hp_regen: int = 10
var player_crit_chance: int = 5
var player_crit_damage: float = 1.3
var player_gold_per_time: int = 0
var player_miss_chance: int = 0
var player_armor: int = 0
var can_return_damage: bool = false
#--------------------player_stats-------------------------------

#--------------------shop-----------------------------------------------
var can_sell: bool = true
var item1: int = 0
var item2: int = 0
var item3: int = 0
var item4: int = 0
var buy_oportunity: Array = [true,true,true,true]
var level_buy_oportunity: Array = [true,true,true,true]
var buying_item_array = [item1 ,item2 ,item3 ,item4]
var array_of_costs: Array = [26,32,28,37,28,20,24,27,36,40,37,51,48,51,44,66,74,83]
var array_of_names_items: Array = ['Pistol','Rifle','Uzi','Kar','Shotgun',
'Shield','StrenghtPotion','SharkOmulet',
'Book of Stone','Book fo blood','Book of fate',
'Book of money','Book of track','Book of shadows','Book of sky','Book of hell',
'Orb of Thunder power','Orb of Vimpire King']
var array_of_texts_items: Array = [
'Deagle
Урон 20
Перезарядка 1,25',

'M4A4
Урон 40
Перезарядка 2',

'Mac10
Урон 10
Перезарядка 0,75',

'Kar98k
Урон 100
Перезарядка 3,25',

'Saved off
Урон 60
Перезарядка 2,75',

'Щит героя
Здоровье +25
Скорость -5',

'Зелье силы
Урон +5
Урон% +5%
Здоровье -5',

'Омулет из зубов
Крит.Шанс +2%
Крит.Дмг +4%
Урон% -1%',

'Книга камня
Броня +3
мс -5',

'Книга крови
Хп + 10
Хп реген +5',

'Книга судьбы
Увороты +10%',

'Книга богатсва
Золото в минуту +10',

'Книга преследования
Крит. шанс +3%
Крит. Урон +7%',

'Книга теней
Атк +5
Атк% +5',

'Книга неба
Мс +10
Увороты + 5%',

'Адская  книга
Атк +10
Атк +15%
Крит. Шанс +5%
Крит. Урон +20%
Хп -50
Хп реген -10',

'Сфера силы молнии
Мс +25
Уклонение +10%
Крит. Шанс +5%
Крит. Урон +10%
Атк +5%
Броня -10',

'Сфера короля вампиров
Хп +50
ХпРеген +25
Броня +3
Атк +10
Мс -20
Уклонение -10%',

]
#--------------------shop-----------------------------------------------

#--------------------enemy-----------------------------------------------
var Flower_end_counter: int = 0
var Flower_counter: int = 0

var Sheep_damage: int = 45

var Stump_damage: int = 75

var Hameleon_damage: int = 90

var Worm_damage: int = 150

var Flower_damage: int = 35

var Raptor_damage: int = 250
#--------------------enemy-----------------------------------------------

#------------------------funcs-----------------------------------
func _process(delta):
	Pistol_damage = (20 + owner_damage) * ((owner_damage_percentage + 100) / 100)
	Rifle_damage = (40 + owner_damage) * ((owner_damage_percentage + 100) / 100)
	Uzi_damage = (10 + owner_damage) * ((owner_damage_percentage + 100) / 100)
	Kar_damage = (100 + owner_damage) * ((owner_damage_percentage + 100) / 100)
	Shotgun_damage = (60 + owner_damage) * ((owner_damage_percentage + 100) / 100)
	if player_miss_chance >= 70:
		player_miss_chance = 70
	if player_speed >= 350:
		player_speed = 350

func armor_calculating():
	var armor_calculate = 0.0
	if player_armor > 0:
		for i in range(player_armor):
			if i == 0:
				armor_calculate += 1
			elif i == 1:
				armor_calculate += 9
			elif i <= 4 and i > 1:
				armor_calculate += 6
			elif i <= 7 and i > 4:
				armor_calculate += 4
			elif i <= 10 and i > 7:
				armor_calculate += 3
			elif i <= 15 and i > 10:
				armor_calculate += 2
			elif i <= 31 and i > 15:
				armor_calculate += 1
			elif i > 31:
				break
	elif player_armor < 0:
		for i in range(player_armor,0):
			if i == -1:
				armor_calculate -= 9
			elif i >= -4 and i < -1:
				armor_calculate -= 6
			elif i >= -7 and i < -4:
				armor_calculate -= 4
			elif i >= -10 and i < -7:
				armor_calculate -= 3
			elif i >= -15 and i < -10:
				armor_calculate -= 2
			elif i >= -31 and i < -15:
				armor_calculate -= 1
			elif i < -31:
				break
	armor_calculate /= 100
	return armor_calculate
	
func zero_stats():
	array_of_costs = [26,32,28,37,28,20,24,27,36,40,37,51,48,51,44,66,74,83]
	player_hp_percentage = 0
	GOLD = 10
	EXP = 0
	owner_damage = 0
	owner_damage_percentage = 1
	Game_Time = 0
	ALL_DAMAGE_IN_GAME = 0
	ALL_KILLS_IN_GAME = 0
	Level = 1
	UpgradesCounter = 0
	counter_guns = 1
	if Class_select != 8:
		array_players_guns = ['Pistol']
	if Class_select == 8:
		array_players_guns = ['']
	player_crit_chance = 5
	player_max_health = 100
	player_health = 100
	player_hp_regen = 10
	player_speed = 200
	player_crit_damage = 1.3
	Sheep_damage = 30
	player_gold_per_time = 0
	Stump_damage = 60
	player_miss_chance = 0
	Hameleon_damage = 40
	Flower_damage = 35
	Worm_damage = 150
	player_armor = 0
	can_return_damage = false
	Flower_counter = 0
#------------------------funcs-----------------------------------
