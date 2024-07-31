extends CharacterBody2D


const SPEED = 250
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = $AnimatedSprite2D

func _physics_process(delta):
	player_movement(delta)
	
	
func player_movement(delta):
	if Input.is_action_pressed("left"):
		velocity.x=-SPEED
		velocity.y=0
		anim.flip_h=true
		anim.play("side_walk")
	elif Input.is_action_pressed("right"):
		velocity.x=SPEED
		velocity.y=0
		anim.flip_h=false
		anim.play("side_walk")
	elif Input.is_action_pressed("up"):
		velocity.x=-0
		velocity.y=-SPEED
		anim.play("idle")
	elif Input.is_action_pressed("down"):
		velocity.x=0
		velocity.y=SPEED
		anim.play("idle")
	else:
		velocity.x=0
		velocity.y=0
		anim.play("idle")
	move_and_slide()
