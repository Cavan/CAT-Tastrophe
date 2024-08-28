## Casts a laser along a raycast, emitting particles on the impact point.
## Use [member is_casting] to make the laser fire and stop.
## You can attach it to a weapon or a ship; the laser will rotate with its parent.
#ANCHOR: extends
extends RayCast2D
#END: extends

# ANCHOR: exports
# Speed at which the laser extends when first fired, in pixels per seconds.
@export var cast_speed := 7000.0
## Maximum length of the laser in pixels.
@export var max_length := 1400.0
# END: exports
## Base duration of the tween animation in seconds.
@export var growth_time := 0.1

## If [code]true[/code], the laser is firing.
## It plays appearing and disappearing animations when it's not animating.
## See [method _appear] and [method _disappear] for more information.
var is_casting := false: set = set_is_casting
var target_mouse_position :Vector2 = Vector2.ZERO
# ANCHOR: onready
@onready var _fill_line: Line2D = %FillLine2D
@onready var _collision_particles: GPUParticles2D = %CollisionGPUParticles2D
# END: onready
@onready var _casting_particles: GPUParticles2D = %CastingGPUParticles2D
@onready var _beam_particles: GPUParticles2D = %BeamGPUParticles2D

@onready var _line_width: float = _fill_line.width
@onready var _tween: Tween = null


func _ready() -> void:
	set_physics_process(false)
	_fill_line.points[1] = Vector2.ZERO
	


# ANCHOR: physics_process
func _physics_process(delta: float) -> void:
	# Increase the length of the ray every frame until it reaches a max length.
	target_position = (target_position + Vector2.RIGHT * cast_speed * delta).limit_length(max_length)
	# Test Code
	#target_mouse_position = get_global_mouse_position()
	#print(target_mouse_position)

	# Cast beam is responsible for checking for collisions up to the length we have set.
	_cast_beam()
	
		
	
# END: physics_process


## Controls the emission of particles and extends the [Line2D] to [member RayCast2D.target_position]
## or the ray's collision point, whichever is closest.
# ANCHOR: cast_beam
func _cast_beam() -> void:
	var cast_point := target_position
	if is_colliding():
		# Convert the global collision point to local coordinates.
		cast_point = to_local(get_collision_point())
		# Align the collision particles with the surface using its collision
		# normal.
		_collision_particles.global_rotation = get_collision_normal().angle()
		_collision_particles.position = cast_point
	# Only emit collision particles if there is a collision.
	_collision_particles.emitting = is_colliding()
	# Extend the laser up to the collision point or the target position.
	_fill_line.points[1] = cast_point
# END: cast_beam	_
	_beam_particles.position = cast_point * 0.5
	_beam_particles.process_material.emission_box_extents.x = cast_point.length() * 0.5


func _appear() -> void:
	if _tween != null:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_fill_line, "width", _line_width, growth_time * 2).from(0)


func _disappear() -> void:
	if _tween != null:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(_fill_line, "width", 0.0, growth_time)


func set_is_casting(new_is_casting: bool) -> void:
	is_casting = new_is_casting
	target_position = Vector2.ZERO

	if is_casting:
		_fill_line.points[1] = target_position
		_appear()
	else:
		_collision_particles.emitting = false
		_disappear()

	set_physics_process(is_casting)
	_beam_particles.emitting = is_casting
	_casting_particles.emitting = is_casting


func _on_cat_body_2d_laser_fired(fire_laser):
	set_is_casting(fire_laser)
