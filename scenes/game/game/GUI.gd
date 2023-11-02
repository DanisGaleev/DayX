extends Control

onready var health_bar = $CanvasLayer/HealthBar/ProgressBar

func _process(delta):
	health_bar.value = get_parent().get_node("World/Player").health
