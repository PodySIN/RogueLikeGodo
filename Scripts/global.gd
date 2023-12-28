extends Node

var game_paused_menu: bool = false
var game_paused_shop: bool = false
var Game_Time: int = 0
var exp_brackers: Array = [0,16,41,77,126,190,271,371,492,636,805,1001,1226,1482,1771,2095,2456,2856,3297,3781,4310,4886,5511,6187,6916,7700,8636,9572,10508,11444,12515,13984,15453,16922,18391,19860,21329,22798,24267,25736,27420,29749 ,32078 ,34407 ,36736 ,39065 ,41394 ,43723 ,46052 ,48381,51025,369550]
var HP_gained_from_lvl = 10
var DMG_gained_from_lvl = 1
var UpgradesCounter: int = 0

var EXP: int = 0
var GOLD: int = 0
var Level: int = 1
var owner_damage: int = 0

var Pistol_damage: int = 200 + owner_damage

var player_max_health = 100
var player_health = 100
var player_speed = 300
var player_hp_regen = 10
