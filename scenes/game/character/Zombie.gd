extends Character

class_name Zombie

enum Triggered{
	VIEW,
	HEAR,
	NULL
}

var is_triggered = false
var reach_pos = null
var player = null

var how_triggered = Triggered.NULL

onready var nav = $NavigationAgent2D
onready var view_angry_zone = $ViewAngryZone

export (NodePath) var navmap_path: NodePath

func attack():
	delta_time = 0
	last_state  = state
	var min_dst = 9999
	var angle = int(rad2deg(attack_zone.rotation) + 90)
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

	yield(animation, "animation_finished")
	last_animation()
	
	for body in entered_body:
		if body is Player:
			body.health -= attack


func choose_goal() -> float:
	if how_triggered == Triggered.VIEW:
		return self.position.direction_to(player.position).angle()
	elif how_triggered == Triggered.HEAR:
		return self.position.direction_to(reach_pos).angle()
	return 0.0
	
func choose_target():
	if how_triggered == Triggered.VIEW:
		nav.set_target_location(player.position)
	elif how_triggered == Triggered.HEAR:
		nav.set_target_location(reach_pos)

func choose_direction():
	movement = Vector2()
	if how_triggered == Triggered.HEAR and not nav.is_navigation_finished():
		movement = speed * global_position.direction_to(nav.get_next_location())
		var angle = round(rad2deg(movement.angle()))
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
	elif is_triggered and position.distance_to(player.position) > 27:
		movement = speed * global_position.direction_to(nav.get_next_location())#speed * position.direction_to(player.position)
		var angle = round(rad2deg(movement.angle()))
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
		var angle = round(rad2deg(last_direction.angle()))
		if angle < -45 and angle > -135:
			state = State.Idle_forward
		elif (angle >= -180 and angle < -135) or (angle <= 180 and angle > 135):
			state = State.Idle_left
		elif (angle >= 0 and angle <= 45) or (angle >= -45 and angle <= 0):
			state = State.Idle_right
		else:
			state = State.Idle_back

func upd(delta):
	choose_direction()
	rotate_attack_zone(choose_goal())
	if delta_time >= wait_time and len(entered_body) > 0:
		print(delta_time, "  ", wait_time)
		attack()

func _ready():
	._ready()
	nav.set_navigation(get_node(navmap_path))
func _physics_process(delta):
	move_and_slide(movement)

func _on_PathFind_timeout():
	if player != null:
		choose_target()
	else:
		nav.set_target_location(Vector2(125, 84))

func _on_ViewAngryZone_body_entered(body):
	if body.is_in_group("player"):
		is_triggered = true
		player = body.position
		reach_pos = body.position


func _on_ViewAngryZone_body_exited(body):
	if body.is_in_group("player"):
		player = null
		is_triggered = false
		last_direction = movement
		movement = Vector2(0, 0)


func _on_HearAngryZone_body_entered(body):
	if body.is_in_group("player"):
		is_triggered = true
		var x = rand_range(body.position.x - 20, body.position.x + 20)
		var y = rand_range(body.position.y - 20, body.position.y + 20)
		reach_pos = Vector2(x, y)


func _on_HearAngryZone_body_exited(body):
	if body.is_in_group("player"):
		reach_pos = null
		is_triggered = false
		last_direction = movement
		movement = Vector2(0, 0)
