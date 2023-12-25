extends CharacterBody2D

#-----onready-------------------------
@onready var ap = $AnimatedSprite2D
@onready var player = $"../../Hero/Hero"
#-----onready-------------------------

#-----vars-------------------------
var chase = true
var attacking = false
#-----vars-------------------------

#-----stats-------------------------
@export var damage = 40
@export var speed = 100
#-----stats-------------------------

func _physics_process(delta):
	movement()
	
func movement():
	var direction = (player.position - self.position).normalized()
	velocity = direction * speed
	if chase and attacking == false:
		ap.play('run')
		if direction.x < 0:
			ap.flip_h = true
		elif direction.x > 0:
			ap.flip_h = false
	move_and_slide()


func _on_hit_area_body_entered(body):
	if body.name == 'Hero':
		attacking = true
		if attacking:
			ap.play("attack")
			$attack_cd.start()
func _on_hit_area_body_exited(body):
	if body.name == 'Hero':
		if $attack_cd.time_left < 0.3:
			player.health -= damage / 2
		attacking = false
		$attack_cd.stop()
func _on_attack_cd_timeout():
	player.health -= damage
