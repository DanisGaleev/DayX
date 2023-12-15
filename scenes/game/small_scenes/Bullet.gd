extends RigidBody2D

@onready var alive_timer = $AliveTimer

@export var speed:float
@export var damage: int
@export var distance: float
@export var direction: Vector2

func _ready():
	alive_timer.wait_time = distance / speed
	alive_timer.start()
	
	rotation = direction.angle()
	apply_central_impulse(direction * speed)
	
	await alive_timer.timeout
	queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("zombie"):
		body.health -= damage
	queue_free()
