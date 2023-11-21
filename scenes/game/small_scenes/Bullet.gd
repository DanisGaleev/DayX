extends RigidBody2D

onready var queue_free_timer = $QueueFreeTimer

export var speed:float
export var damage: int
export var distance: float
export var direction: Vector2

func _ready():
	queue_free_timer.wait_time = distance / speed
	queue_free_timer.start()
	
	rotation = direction.angle()
	apply_central_impulse(direction * speed)
	
	yield(queue_free_timer, "timeout")
	queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("zombie"):
		print(body.health)
		body.health -= damage
		print(body.health)
	queue_free()
