extends Character

class_name Zombie

enum Triggered{
	VIEW,
	HEAR,
	NULL
}

var is_triggered = false
var reach_pos = null
var min_noise_level = 10
@onready var player = get_node("../Player")

var how_triggered = Triggered.NULL

@onready var nav = $NavigationAgent2D
@onready var view_angry_zone = $ViewAngryZone
@onready var raycasts = $RayCasts

@export_node_path() var navmap_path: NodePath

func _attack():
	delta_time_near = 0
	last_state = state
	var min_dst = 9999
	var angle = int(rad_to_deg(attack_zone.rotation) + 90)
	if angle < -45 and angle > -135:
		state = State.Near_attack_forward
	elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
		state = State.Near_attack_left
	elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
		state = State.Near_attack_right
	else:
		state = State.Near_attack_back
	block = true
	animation.play(animation_d[state])

	for body in entered_body:
		if body.name == "Player":
			body.health -= dmg


func choose_goal() -> float:
	if player != null:
		return self.position.direction_to(player.position).angle()
	return 0.0
func _choose_direction():
	movement = Vector2()
	if not nav.is_navigation_finished():
		movement = speed * global_position.direction_to(nav.get_next_path_position())#speed * position.direction_to(player.position)
		var angle = round(rad_to_deg(movement.angle()))
		if angle < -45 and angle > -135:
			state = State.Run_forward
		elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
			state = State.Run_left
		elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
			state = State.Run_right
		else:
			state = State.Run_back
		view_angry_zone.rotation_degrees = angle
		last_direction = movement
	else:
		var angle = round(rad_to_deg(last_direction.angle()))
		if angle < -45 and angle > -135:
			state = State.Idle_forward
		elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
			state = State.Idle_left
		elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
			state = State.Idle_right
		else:
			state = State.Idle_back

func _upd(delta):
	_choose_direction()
	rotate_attack_zone(choose_goal())
	if delta_time_near >= wait_time and len(entered_body) > 0:
		_attack()

func _ready():
	super()
	nav.set_navigation_map(get_node(navmap_path).get_node("NavigationMap"))
func _physics_process(delta):
	set_velocity(movement)
	move_and_slide()
	var space_state = get_world_2d().direct_space_state
	var result = []
	var is_player_found = false
	raycasts.rotation = last_direction.angle() - PI / 2
	for i in raycasts.get_children():
		if i.get_collider() and i.get_collider().name == "Player":
			how_triggered = Triggered.VIEW
			is_player_found = true
	if not is_player_found:
		how_triggered = Triggered.NULL
		last_direction = movement
		movement = Vector2(0, 0)

func _on_PathFind_timeout():
	if how_triggered == Triggered.VIEW:
		nav.target_position = player.position
	elif calculate_noise_level():
		var x = randf_range(player.position.x - 20, player.position.x - 20)
		var y = randf_range(player.position.y - 20, player.position.y - 20)
		nav.target_position = Vector2(x, y)
	else:
		if nav.is_navigation_finished():
			var x = randf_range(position.x - 50, position.x + 50)
			var y = randf_range(position.y - 50, position.y + 50)
			nav.target_position = Vector2(x, y)
		
func calculate_noise_level() -> bool:
	var dst = player.position.distance_to(position)
	return (player.noise_level / dst * 100 > min_noise_level) if dst >= 1 else (player.noise_level > min_noise_level)
