extends CharacterBody2D


const SPEED = 250
const JUMP_VELOCITY = -400.0
var enemiesInAtackRange=[]
var health=100
var alive =true
var atacking=false
var damage=10
var attackCooldown= true
@onready var attack_cooldown = $AttackCooldown

enum {
	RIGHT_WALKING,
	LEFT_WALKING,
	FRONT_WALKING,
	BACK_WALKING,
	ATTACKING,
	STANDING
}
var state = STANDING
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	if alive:
		player_movement(delta)
		if health <=0:
			print("you died! :(")
			health =0
			alive=false
			anim.play("die")
		
	
	
func player_movement(delta):
	if Input.is_action_pressed("left"):
		velocity.x=-SPEED
		velocity.y=0
		state=LEFT_WALKING
	elif Input.is_action_pressed("right"):
		velocity.x=SPEED
		velocity.y=0
		state = RIGHT_WALKING

	elif Input.is_action_pressed("up"):
		velocity.x=-0
		velocity.y=-SPEED
		state = BACK_WALKING
	elif Input.is_action_pressed("down"):
		velocity.x=0
		velocity.y=SPEED
		state = FRONT_WALKING
	elif Input.is_action_just_pressed("atack"):
		atack()
	else:
		velocity.x=0
		velocity.y=0
		state=STANDING
	animate()
	move_and_slide()

func animate():
	if atacking:
		anim.play("attacking")
	else:
		match(state):
			LEFT_WALKING:
				anim.flip_h=true
				anim.play("side_walk")
			RIGHT_WALKING:
				anim.flip_h=false
				anim.play("side_walk")
			STANDING:
				anim.play("idle")
			FRONT_WALKING:
				anim.play("front_walk")
			BACK_WALKING:
				anim.play("idle")
	
func attacked(damage):
	health-= damage
	
func isAlive():
	return alive

func player():
	pass
	
func _on_hitbox_body_entered(body):
	if(body.has_method("enemy")):
		enemiesInAtackRange.append(body)

func _on_hitbox_body_exited(body):
	if(body.has_method("enemy")):
		enemiesInAtackRange.erase(body)

func atack():
	if attackCooldown:
		print("player health: ",health)
		state=ATTACKING
		atacking=true
		attackCooldown=false
		attack_cooldown.start()
		print("atacking!")
		if !enemiesInAtackRange.is_empty():
			for enemy in enemiesInAtackRange:
				enemy.attacked(damage)
			

func _on_attack_cooldown_timeout():
	attack_cooldown.stop()
	attackCooldown=true
	atacking=false
	state= STANDING

