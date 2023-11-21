extends Node2D



func _on_InTrigger_body_entered(body):
	print(body.name)
	if body.name == "Player":
		$Out.visible = !$Out.visible
