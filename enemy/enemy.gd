extends Node2D


var normal_speed :float = 600.0
var max_speed := normal_speed
var velocity := Vector2(0,0)
@onready var boss_cat = $Chonky_Cat
const ENEMY_ADVANCE: float = -1469
const ENEMY_RETREAT: float = 1300
const ATTACK_PLAYER: float = -1.0
const RETREAT_FROM_PLAYER: float = 1.0
var cosnt
var direction := Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	direction.x = -1.0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#direction.x = Input.get_axis("move_left", "move_right")
	#direction.y = Input.get_axis("move_up", "move_down")
	#Flip cat sprits
	if (direction.x < 0):
		boss_cat.flip_h = true
	elif (direction.x > 0):
		boss_cat.flip_h = false
	
	
	# Normalize later
	
	velocity = direction * max_speed
	position += velocity * delta
	
	if direction.length() > 0.0:
		rotation = velocity.angle_to(Vector2(velocity.x, 0.0))
		
	if position.x <= ENEMY_ADVANCE:
		direction.x = RETREAT_FROM_PLAYER
		print('Enemy advances')
	elif position.x >= ENEMY_RETREAT:
		direction.x = ATTACK_PLAYER
		print('Enemy retreats')
	print(direction)
	print(position)
	
