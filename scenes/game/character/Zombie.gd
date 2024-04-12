class_name Zombie
extends Character

enum Triggered {VIEW, HEAR, NULL}

@export_node_path() var navmap_path: NodePath

var is_triggered = false
var how_triggered = Triggered.NULL
var reach_pos = null
var min_noise_level = 10

@onready var player = get_node("../Player")
@onready var nav = $NavigationAgent2D
@onready var view_angry_zone = $ViewAngryZone
@onready var raycasts = $RayCasts

func _ready():
	super()
	nav.set_navigation_map(get_node(navmap_path).get_node("NavigationMap"))
	
func _physics_process(delta):
	set_velocity(movement)
	move_and_slide()
	
	var is_player_found = false
	raycasts.rotation = last_direction.angle() - PI / 2
	raycasts.global_position = global_position + Vector2(1, 0).rotated(raycasts.rotation + PI / 2) * 12
	for ray in raycasts.get_children():
		if ray.get_collider() and ray.get_collider().name == "Player":
			how_triggered = Triggered.VIEW
			is_player_found = true
	if not is_player_found:
		how_triggered = Triggered.NULL
		last_direction = movement
		movement = Vector2(0, 0)

func upd(delta):
	choose_direction()
	rotate_attack_zone(choose_goal())
	if delta_time_near >= wait_time and len(entered_body) > 0:
		delta_time_near = 0
		attack_animation()
		enemy_hit(['player'], dmg)

func choose_goal() -> float:
	if player != null:
		return self.position.direction_to(player.position).angle()
	return 0.0

func choose_direction():
	movement = Vector2()
	if not nav.is_navigation_finished():
		movement = speed * global_position.direction_to(nav.get_next_path_position())#speed * position.direction_to(player.position)
		var angle = round(rad_to_deg(movement.angle()))
		if angle < -45 and angle > -135:
			state = State.RUN_FORWARD
		elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
			state = State.RUN_LEFT
		elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
			state = State.RUN_RIGHT
		else:
			state = State.RUN_BACK
		view_angry_zone.rotation_degrees = angle
		last_direction = movement
	else:
		var angle = round(rad_to_deg(last_direction.angle()))
		if angle < -45 and angle > -135:
			state = State.IDLE_FORWARD
		elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
			state = State.IDLE_LEFT
		elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
			state = State.IDLE_RIGHT
		else:
			state = State.IDLE_BACK

func attack_animation():
	last_state = state
	var angle = int(rad_to_deg(attack_zone.rotation) + 90)
	if angle < -45 and angle > -135:
		state = State.NEAR_ATTACK_FORWARD
	elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
		state = State.NEAR_ATTACK_LEFT
	elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
		state = State.NEAR_ATTACK_RIGHT
	else:
		state = State.NEAR_ATTACK_BACK
	block = true
	animation.play(animation_and_states[state])

func calculate_noise_level() -> bool:
	var dst = player.position.distance_to(position)
	return (player.noise_level / dst * 100 > min_noise_level) if dst >= 1 else (player.noise_level > min_noise_level)
	
func _on_PathFind_timeout():
	if how_triggered == Triggered.VIEW:
		nav.target_position = player.position - position.direction_to(player.position) * 16
	elif calculate_noise_level():
		var x = randf_range(player.position.x - 20, player.position.x - 20)
		var y = randf_range(player.position.y - 20, player.position.y - 20)
		nav.target_position = Vector2(x, y)
	else:
		if nav.is_navigation_finished():
			var x = randf_range(position.x - 50, position.x + 50)
			var y = randf_range(position.y - 50, position.y + 50)
			nav.target_position = Vector2(x, y)
		
