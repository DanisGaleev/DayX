extends Node2D

@export_group("World")
@export var nav_node_path: NodePath
var zombie = preload("res://scenes/game/character/Zombie.tscn")

func _ready():
	#get_tree().set_debug_collisions_hint(true) 
	randomize()


func _on_ZombieSpawnerTimer_timeout():
	var zombie_node = zombie.instantiate()
	zombie_node.navmap_path = nav_node_path
	zombie_node.position = Vector2(randf_range(0, 100), randf_range(0, 100))
	add_child(zombie_node)
