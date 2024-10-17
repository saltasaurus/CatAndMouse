extends Node2D

var current_speed = 500
var max_speed = 1000

var stop_dist = 10
var slow_distance = 250

var mouse_pos = Vector2.ZERO
var distance = Vector2.ZERO
var direction = Vector2.ZERO

var max_turn_angle_deg = 3

func calc_angle(A: Vector2, B: Vector2) -> float:
	"""Calculates the angle between two vectors in radians"""
	
	var a_tan = atan2(A.y, A.x)
	var b_tan = atan2(B.y, B.x)

	return wrapf(b_tan - a_tan, -PI, PI)

func rotate_by_radians(v, rads) -> Vector2:
	var x = v.x * cos(rads) - v.y * sin(rads)
	var y = v.x * sin(rads) + v.y * cos(rads)
	return Vector2(x, y)

func rotate_vec2(vec: Vector2) -> Vector2:
	"""Creates an orthogonal vector"""
	return Vector2(-vec.y, vec.x)

func rotate_custom(angle) -> void:
	"""
	[[ cos	-sin  ]	* [ x	= [ U * x.x + W * y.x
	 [ sin	cos ]]		y ] 	U * x.y + W * y.y ]

	[[cos(x), -sin(x)]	* [ 3 	= [ 3cos(x) + -2sin(x)
	 [sin(x),  cos(x)]]     2 ] 	3sin(x) + 2cos(x) ]
	"""
	print(angle * 180/PI)
	transform.x = rotate_by_radians(transform.x, angle)
	transform.y = rotate_by_radians(transform.y, angle)

func move(delta, dir) -> void:
	if dir.length() > stop_dist:
		position += dir.normalized() * current_speed * delta

func look(delta) -> void:
	mouse_pos = get_global_mouse_position()
	direction = mouse_pos - position
	# direction = distance.normalized()
	print("Mouse:", mouse_pos, "Dir:", direction, "Trans Pos:", transform.x)

	var angle = calc_angle(transform.x, direction)
	var max_turn_radians = deg_to_rad(max_turn_angle_deg)
	angle = clamp(angle, -max_turn_radians, max_turn_radians)
	
	if direction.length() < stop_dist:
		return

	rotate_custom(angle)
	move(delta, direction)
	# position += direction.normalized() * delta * current_speed
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(400, 300)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look(delta)
	
