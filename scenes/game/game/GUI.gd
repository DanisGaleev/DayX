extends Control

@onready var health_bar = $CanvasLayer/Bars/HealthBar/ProgressBar
@onready var hunger_bar = $CanvasLayer/Bars/HungerBar/ProgressBar
@onready var thirst_bar = $CanvasLayer/Bars/ThirstBar/ProgressBar

func _process(delta):
	health_bar.value = get_parent().get_node("World/Player").health
	hunger_bar.value = get_parent().get_node("World/Player").hunger
	thirst_bar.value = get_parent().get_node("World/Player").thirst
	
