extends Node

#--------------------global-----------------------------------
var game_paused_menu: bool = false
var game_paused_shop: bool = false
var Game_Time: int = 0

var exp_brackers: Array = [0,16,41,77,126,190,271,371,492,636,805,1001,1226,1482,1771,
2095,2456,2856,3297,3781,4310,4886,5511,6187,6916,7700,8636,9572,10508,11444,12515,
13984,15453,16922,18391,19860,21329,22798,24267,25736,27420,29749 ,32078 ,34407 ,
36736 ,39065 ,41394 ,43723 ,46052 ,48381,51025,369550]

var array_of_items: Array = ["res://Assets/Other/Guns/GlockImage.png",
"res://Assets/Other/Guns/M4A4Image.png",
"res://Assets/Other/Guns/UZI.png",
"res://Assets/Other/Guns/Kar98kImage.png" ,
"res://Assets/Other/Items/Items/Item__25.png",
"res://Assets/Other/Items/Items/Item__28.png",
"res://Assets/Other/Items/Items/Item__34.png",
"res://Assets/Other/Guns/Shotgun/ShotgunImage.png"]

##-----------------------------level_stats--------------------------------------
##var array_level_statss = [1,2,4,9, 3,6,10,16, 10,20,40,75, 1,3,5,9, 15,25,50,90, 3,6,10,16]
##                    atk(flat) |  atk%   |     hp    |  crch |     ms    | crit_dmg |
##var chances_on_lvl_stat_common = 60
##var chances_on_lvl_stat_rare = 25
##var chances_on_lvl_stat_epic = 10
##var chances_on_lvl_stat_legendary = 4
##var chances_on_lvl_stat_mythic = 1
##60,25,10,4,1
var array_level_stats: Array = [1,2,5,1,10,2, 2,5,10,2,20,4, 4,10,20,5,50,7, 7,16,40,9,90,12, 12,25,75,15,150,20]
var array_level_stats_info = [
'+1 atk','+2% atk','+5 hp','+1% crit.ch','+5 ms','+2% crit.dmg',
'+2 atk','+5% atk','+10 hp','+2% crit.ch','+10 ms','+4% crit.dmg',
'+4 atk','+10% atk','+20 hp','+5% crit.ch','+25 ms','+7% crit.dmg',
'+7 atk','+16% atk','+40 hp','+9% crit.ch','+45 ms','+12% crit.dmg',
'+12 atk','+25% atk','+75 hp','+15% crit.ch','+75 ms','+20% crit.dmg']

var array_level_stats_upgrade =[
 1,0.02,5,1,10,0.02,
 2,0.05,10,2,20,0.04,
 4,0.1,20,5,50,0.07,
 7,0.16,40,9,90,0.12,
 12,0.25,75,15,150,0.2,
]

var array_level_stats_textures = [
"res://Assets/Other/Items/Items/Item__02.png","res://Assets/Other/Items/Items/Item__12.png","res://Assets/Other/Items/Items/Item__56.png","res://Assets/Other/Items/Items/Item__40.png","res://Assets/Other/Items/Items/Item__48.png","res://Assets/Other/Items/Items/Item__67.png",
"res://Assets/Other/Items/Items/Item__00.png","res://Assets/Other/Items/Items/Item__14.png","res://Assets/Other/Items/Items/Item__24.png","res://Assets/Other/Items/Items/Item__41.png","res://Assets/Other/Items/Items/Item__51.png","res://Assets/Other/Items/Items/Item__60.png",
"res://Assets/Other/Items/Items/Item__03.png","res://Assets/Other/Items/Items/Item__15.png","res://Assets/Other/Items/Items/Item__58.png","res://Assets/Other/Items/Items/Item__42.png","res://Assets/Other/Items/Items/Item__49.png","res://Assets/Other/Items/Items/Item__63.png",
"res://Assets/Other/Items/Items/Item__06.png","res://Assets/Other/Items/Items/Item__22.png","res://Assets/Other/Items/Items/Item__25.png","res://Assets/Other/Items/Items/Item__54.png","res://Assets/Other/Items/Items/Item__49.png","res://Assets/Other/Items/Items/Item__69.png",
"res://Assets/Other/Items/Items/Item__07.png","res://Assets/Other/Items/Items/Item__23.png","res://Assets/Other/Items/Items/Item__27.png","res://Assets/Other/Items/Items/Item__43.png","res://Assets/Other/Items/Items/Item__50.png","res://Assets/Other/Items/Items/Item__71.png",
]
var level_stats: Array = [0,0,0,0]
var chances_on_lvl: Array = [0,0,0,0]

var HP_gained_from_lvl: int = 10
var DMG_gained_from_lvl: int = 1
##-----------------------------level_stats--------------------------------------
var player_get_random_crit: int = 100
var ALL_DAMAGE_IN_GAME: int = 0
var ALL_KILLS_IN_GAME: int = 0
#--------------------global-----------------------------------

#--------------------global_stats-------------------------------
var EXP: int = 0
var GOLD: int = 10
var Level: int = 1
var owner_damage_percentage: float = 1
var owner_damage: int = 0
var UpgradesCounter: int = 0
#--------------------global_stats-------------------------------

#--------------------guns_stats_and_afrtifacts-------------------------------
var counter_guns: int = 1
var Pistol_damage: int = (20 + owner_damage) * owner_damage_percentage
var Rifle_damage: int = (40 + owner_damage) * owner_damage_percentage
var Uzi_damage: int = (10 + owner_damage) * owner_damage_percentage
var Kar_damage: int = (100 + owner_damage) * owner_damage_percentage
var Shotgun_damage: int = (60 + owner_damage) * owner_damage_percentage
var Pistol_damage_crit: int = Pistol_damage
var Rifle_damage_crit: int = Rifle_damage
var Uzi_damage_crit: int = Uzi_damage
var Kar_damage_crit: int = Kar_damage
var Shotgun_damage_crit: int = Shotgun_damage
var array_players_guns: Array = ['Pistol']
var weapon_instances: Array = [0,1,2,3,4,5]
#--------------------guns_stats-------------------------------

#--------------------player_stats-------------------------------
var player_max_health: int = 100
var player_health: int = 100
var player_speed: int = 200
var player_hp_regen: int = 10
var player_crit_chance: int = 17
var player_crit_damage: float = 1.5
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
var array_of_costs: Array = [20,35,25,40,15,30,20,30]
var array_of_names_items: Array = ['Pistol','Rifle','Uzi','Kar',
'Shield','StrenghtPotion','SharkOmulet','Shotgun']
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

'Щит героя
Здоровье +25
Скорость -10',

'Зелье силы
Урон +5
Урон% +5%
Здоровье -5',

'Омулет из зубов
Крит.Шанс +2%
Крит.Дмг +4%
Урон% -1%',

'Saved off
Урон 60
Перезарядка 2,75',

]
#--------------------shop-----------------------------------------------

#--------------------enemy-----------------------------------------------

var Sheep_damage: int = 30

var Stump_damage: int = 50

var Hameleon_damage: int = 70
#--------------------enemy-----------------------------------------------

#------------------------funcs-----------------------------------
func _process(delta):
	Pistol_damage = (20 + owner_damage) * owner_damage_percentage
	Rifle_damage = (40 + owner_damage) * owner_damage_percentage
	Uzi_damage = (10 + owner_damage) * owner_damage_percentage
	Kar_damage = (100 + owner_damage) * owner_damage_percentage
	Shotgun_damage = (60 + owner_damage) * owner_damage_percentage

func zero_stats():
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
	array_players_guns = ['Pistol']
	player_crit_chance = 17
	player_max_health = 100
	player_health = 100
	player_hp_regen = 10
	player_speed = 200
	player_crit_damage = 1.5
	Sheep_damage = 30
	Stump_damage = 60
	Hameleon_damage = 40
#------------------------funcs-----------------------------------
