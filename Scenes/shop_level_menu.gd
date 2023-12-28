extends Control
@onready var player = preload("res://Scenes/Hero.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.UpgradesCounter == 1:
		$UpgradesCounter.text = str('You have: ' + str(Global.UpgradesCounter) + ' point')
	else:
		$UpgradesCounter.text = str('You have: ' + str(Global.UpgradesCounter) + ' points')


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
		Global.player_speed += 25
	
