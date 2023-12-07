extends Node2D

func _ready():
	print("ready")

func _on_InTrigger_body_entered(body):
	print(body.name)
	if body.name == "Player":
		$Out.visible = !$Out.visible
		$Door.visible = !$Door.visible


func _on_in_trigger_body_exited(body):
	if body.name == "Player":
		$Out.visible = !$Out.visible
		$Door.visible = !$Door.visible
