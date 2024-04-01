extends Node2D

func _ready():
	for spawn in $ItemsSpawnPositions.get_children():
		var item = preload("res://scenes/game/item_in_world/item.tscn").instantiate()
		item.position = spawn.position
		item.arr.append_array(["5.45x39;0.3;Ammo;40", "axe;0.2;HandWeapon;1", "ak74;0.2;WeaponFire;1", "gorka_pants;0.3;Dress;pants;1"])
		add_child(item)

func _on_in_trigger_body_entered(body):
	if body.name == "Player":
		$Out.visible = !$Out.visible
		$Door.visible = !$Door.visible


func _on_in_trigger_body_exited(body):
	if body.name == "Player":
		$Out.visible = !$Out.visible
		$Door.visible = !$Door.visible

