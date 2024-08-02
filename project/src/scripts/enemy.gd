extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var attackCooldownTimer = $AttackCooldown
const SPEED = 60.0
var playerChased=false
var player = null
var maxDistance= Vector2(10,10)
var damage = 5
var attackCooldown=true
var playerInAtackRange=false
var health= 50
var alive = true
enum {
	RIGHT_WALKING,
	LEFT_WALKING,
	ATTACKING,
	STANDING
}
@onready var animation_timer = $AnimationTimer
var state=STANDING

func _physics_process(delta):
	if alive:
		if playerChased:
			position += (player.position - position)/SPEED
			if (player.position.x - position.x)<0:
				state =LEFT_WALKING
			else:
				state= RIGHT_WALKING
			attackPlayer()
		else:
			state=STANDING
		animate()
		if health<=0:
			print("Emeny died!")
			anim.play("dead")
			animation_timer.start()
			alive=false
				


	
	
func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		if body.isAlive():
			player=body
			playerChased = true
		else:
			playerChased=false

func _on_detection_area_body_exited(body):
		player = null
		playerChased=false
	
func enemy():
	pass

func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		if body.isAlive():
			playerInAtackRange=true
			player = body
		else:
			playerInAtackRange=false

func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		playerInAtackRange=false

func attackPlayer():
	print("atacking player!")
	print("enemy health: ",health)
	if player.isAlive():
		if playerInAtackRange and attackCooldown:
			player.attacked(damage)
			attackCooldown=false
			attackCooldownTimer.start()
		if playerInAtackRange:
			state = ATTACKING
	else:
		state=STANDING
	
	
func attacked(damage):
	health-= damage
	
func isAlive():
	return alive

func animate():
	match(state):
		ATTACKING:
			anim.play("attaking")
		LEFT_WALKING:
			anim.flip_h=true
			anim.play("side_walk")
		RIGHT_WALKING:
			anim.flip_h=false
			anim.play("side_walk")
		STANDING:
			anim.play("idle")

func _on_attack_cooldown_timeout():
	attackCooldown=true 


func _on_animation_timer_timeout():
	animation_timer.stop()
	anim.stop()
	self.queue_free()
