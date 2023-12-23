extends Node

@export_file('*.png') var anim

var frames = SpriteFrames.new()

func get_r(x: int, y: int):
	var txr = AtlasTexture.new()
	txr.atlas = anim
	txr.region = Rect2.new(x * 32, y * 32, 32, 32)
	return txr

func _ready():
	frames.add_animation("idle_forward")
	frames.add_animation("idle_back")
	frames.add_animation("run_forward")
	frames.add_animation("run_back")
	frames.add_animation("idle_left")
	frames.add_animation("run_left")
	frames.add_animation("idle_right")
	frames.add_animation("run_right")
	frames.add_animation("near_attack_back")
	frames.add_animation("near_attack_left")
	frames.add_animation("near_attack_right")
	frames.add_animation("near_attack_forward")
	frames.add_animation("fire_attack_back")
	frames.add_animation("fire_attack_left")
	frames.add_animation("fire_attack_right")
	frames.add_animation("fire_attack_forward")
	frames.animations[8]["loop"] = false
	frames.animations[9]["loop"] = false
	frames.animations[10]["loop"] = false
	frames.animations[11]["loop"] = false
	
	frames.add_frame("fire_attack_back", get_r())
