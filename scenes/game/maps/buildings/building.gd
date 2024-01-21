extends Node2D

func _ready():
	for spawn in $ItemsSpawnPositions.get_children():
		var item = preload("res://scenes/game/item_in_world/item.tscn").instantiate()
		item.position = spawn.position
		item.arr.append_array(["ak74;0.5;WeaponFire", "gorka_pants;0.5;Dress;pants"])
		add_child(item)

func _on_in_trigger_body_entered(body):
	if body.name == "Player":
		$Out.visible = !$Out.visible
		$Door.visible = !$Door.visible


func _on_in_trigger_body_exited(body):
	if body.name == "Player":
		$Out.visible = !$Out.visible
		$Door.visible = !$Door.visible

