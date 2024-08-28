extends CharacterBody2D


var normal_speed :float = 350.0
var max_speed := normal_speed
#var velocity := Vector2(0,0)
@onready var _animated_sprite = $AnimatedSprite2D
@onready var _laser_beam = $LaserBeam2D
signal laser_fired(fire_laser:bool)
const ENEMY_ADVANCE: float = -1469
const ENEMY_RETREAT: float = 1300
const ATTACK_PLAYER: float = -1.0
const RETREAT_FROM_PLAYER: float = 1.0
var cosnt
var direction := Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	# Super big cat ability
	if Input.is_action_just_pressed("spacebar"):
		fire_laser(true)
	elif Input.is_action_just_released("spacebar"):
		fire_laser(false)
	
	#Flip cat sprits
	if (direction.x < 0):
		_animated_sprite.play("walk_backward")
	elif (direction.x > 0):
		_animated_sprite.play("walk_forward")
	elif (direction.y < 0):
		_animated_sprite.play("walk_upward")
	elif (direction.y > 0):
		_animated_sprite.play("walk_downward")
	else:
		_animated_sprite.stop()
	
	
	# Normalize later
	
	velocity = direction * max_speed
	position += velocity * delta
	
	if direction.length() > 0.0:
		pass
		#rotation = velocity.angle_to(Vector2(velocity.x, 0.0))

func fire_laser(laser_fired_by_user:bool) -> void:
	laser_fired.emit(laser_fired_by_user)
	
