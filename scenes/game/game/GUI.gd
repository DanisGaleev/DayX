extends Control

@onready var health_bar = $CanvasLayer/MarginContainer/Bars/HealthBar/ProgressBar
@onready var hunger_bar = $CanvasLayer/MarginContainer/Bars/HungerBar/ProgressBar
@onready var thirst_bar = $CanvasLayer/MarginContainer/Bars/ThirstBar/ProgressBar
@onready var stamina_bar = $CanvasLayer/MarginContainer/Bars/StaminaBar/ProgressBar
@onready var weight_field = $CanvasLayer/MarginContainer/HBoxContainer/VBoxContainer/Weight
@onready var ammo1_field = $CanvasLayer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Ammo1
@onready var ammo2_field = $CanvasLayer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/Ammo2


var player: Player

func _ready():
	player = get_node("../World/Player")

func _process(delta):
	health_bar.value = get_parent().get_node("World/Player").health
	hunger_bar.value = get_parent().get_node("World/Player").hunger
	thirst_bar.value = get_parent().get_node("World/Player").thirst
	stamina_bar.value = player.current_stamina
	
	var weight = str(player.weight) + "/" + str(player.max_weight) + "kg"
	var ammo1 = "0/0"
	var ammo2 = "0/0"
	if player.weapon_fire_1:
		ammo1 =  str(player.weapon_fire_1.ammo_in_magazine) + "/" + str(player.weapon_fire_1.magazine)
	if player.weapon_fire_2:
		ammo2 = str(player.weapon_fire_2.ammo_in_magazine) + "/" + str(player.weapon_fire_2.magazine)
	
	weight_field.text = weight
	ammo1_field.text = ammo1
	ammo2_field.text = ammo2
	
