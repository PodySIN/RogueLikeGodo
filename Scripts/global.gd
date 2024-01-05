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

var HP_gained_from_lvl: int = 10
var DMG_gained_from_lvl: int = 1
var player_get_random_crit: int = 100
var ALL_DAMAGE_IN_GAME: int = 0
var ALL_KILLS_IN_GAME: int = 0
#--------------------global-----------------------------------

#--------------------global_stats-------------------------------
var EXP: int = 0
var GOLD: int = 10
var Level: int = 1
var owner_damage: int = 0
var UpgradesCounter: int = 0
#--------------------global_stats-------------------------------

#--------------------guns_stats_and_afrtifacts-------------------------------
var counter_guns: int = 1
var Pistol_damage: int = 20 + owner_damage
var Rifle_damage: int = 40 + owner_damage
var Uzi_damage: int = 10 + owner_damage
var Kar_damage: int = 100 + owner_damage
var Shotgun_damage: int = 60 + owner_damage
var Pistol_damage_crit: int = Pistol_damage
var Rifle_damage_crit: int = Rifle_damage
var Uzi_damage_crit: int = Uzi_damage
var Kar_damage_crit: int = Kar_damage
var Shotgun_damage_crit: int = Shotgun_damage
var array_players_guns: Array = ['Pistol']
#--------------------guns_stats-------------------------------

#--------------------player_stats-------------------------------
var player_max_health: int = 100
var player_health: int = 100
var player_speed: int = 225
var player_hp_regen: int = 10
var player_crit_chance: int = 17
var player_crit_damage: float = 1.5
#--------------------player_stats-------------------------------

#--------------------shop-----------------------------------------------
var item1: int = 0
var item2: int = 0
var item3: int = 0
var item4: int = 0
var buy_oportunity: Array = [true,true,true,true]
var buying_item_array = [item1 ,item2 ,item3 ,item4]
var array_of_costs: Array = [20,35,25,40,15,30,20,30]
var array_of_names_items: Array = ['Glock','M4A4','Uzi','Kar98k',
'Shield','StrenghtPotion','SharkOmulet','Shotgun']
#--------------------shop-----------------------------------------------

#--------------------enemy-----------------------------------------------

var Sheep_damage = 30

var Stump_damage = 50

var Hameleon_damage = 70
#--------------------enemy-----------------------------------------------

#------------------------funcs-----------------------------------
func _process(delta):
	Pistol_damage = 20 + owner_damage
	Rifle_damage = 40 + owner_damage
	Uzi_damage = 10 + owner_damage
	Kar_damage = 100 + owner_damage
	Shotgun_damage = 60 + owner_damage

func zero_stats():
	GOLD = 10
	EXP = 0
	owner_damage = 0
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
	player_speed = 225
	player_crit_damage = 1.5
	Sheep_damage = 30
	Stump_damage = 60
	Hameleon_damage = 40
#------------------------funcs-----------------------------------
