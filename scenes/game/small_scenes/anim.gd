extends  Node
enum ANIMATION_TYPE{
	WEAPON_NEAR,
	WEAPON_FIRE,
	SHIRT,
	ARMOR,
	HEADDRESS,
	PANTS,
	BACKPACK,
}
var animations_dictionary = {
	ANIMATION_TYPE.WEAPON_NEAR : {"fire_attack_back": [29], "fire_attack_forward": [28], "fire_attack_left": [30], "fire_attack_right": [31], "idle_back" : [0], "idle_forward": [1], "idle_left": [3], "idle_right": [2], "near_attack_back": [14, 15], "near_attack_forward": [12, 13], "near_attack_left": [20, 21], "near_attack_right": [22, 23], "run_back" : [8, 9, 10, 11], "run_forward": [16, 17, 18, 19], "run_left": [4, 5, 6, 7], "run_right": [24, 25, 26, 27]},
	ANIMATION_TYPE.WEAPON_FIRE : {"fire_attack_back": [41], "fire_attack_forward": [40], "fire_attack_left": [42], "fire_attack_right": [43], "idle_back" : [0], "idle_forward": [1], "idle_left": [3], "idle_right": [2], "near_attack_back": [18, 19], "near_attack_forward": [16, 17], "near_attack_left": [28, 29], "near_attack_right": [30, 31], "run_back" : [12, 13, 14, 15], "run_forward": [24, 25, 26, 27], "run_left": [4, 5, 6, 7], "run_right": [36, 37, 38, 39]},
	ANIMATION_TYPE.ARMOR : {"fire_attack_back": [41], "fire_attack_forward": [40], "fire_attack_left": [42], "fire_attack_right": [43], "idle_back" : [0], "idle_forward": [1], "idle_left": [3], "idle_right": [2], "near_attack_back": [18, 19], "near_attack_forward": [16, 17], "near_attack_left": [28, 29], "near_attack_right": [30, 31], "run_back" : [12, 13, 14, 15], "run_forward": [24, 25, 26, 27], "run_left": [4, 5, 6, 7], "run_right": [36, 37, 38, 39]},
	ANIMATION_TYPE.PANTS : {"fire_attack_back": [41], "fire_attack_forward": [40], "fire_attack_left": [42], "fire_attack_right": [43], "idle_back" : [0], "idle_forward": [1], "idle_left": [3], "idle_right": [2], "near_attack_back": [18, 19], "near_attack_forward": [16, 17], "near_attack_left": [28, 29], "near_attack_right": [30, 31], "run_back" : [12, 13, 14, 15], "run_forward": [24, 25, 26, 27], "run_left": [4, 5, 6, 7], "run_right": [36, 37, 38, 39]},
	ANIMATION_TYPE.SHIRT : {"fire_attack_back": [41], "fire_attack_forward": [40], "fire_attack_left": [42], "fire_attack_right": [43], "idle_back" : [0], "idle_forward": [1], "idle_left": [3], "idle_right": [2], "near_attack_back": [18, 19], "near_attack_forward": [16, 17], "near_attack_left": [28, 29], "near_attack_right": [30, 31], "run_back" : [12, 13, 14, 15], "run_forward": [24, 25, 26, 27], "run_left": [4, 5, 6, 7], "run_right": [36, 37, 38, 39]},
	ANIMATION_TYPE.BACKPACK : {"fire_attack_back": [41], "fire_attack_forward": [40], "fire_attack_left": [42], "fire_attack_right": [43], "idle_back" : [0], "idle_forward": [1], "idle_left": [3], "idle_right": [2], "near_attack_back": [18, 19], "near_attack_forward": [16, 17], "near_attack_left": [28, 29], "near_attack_right": [30, 31], "run_back" : [12, 13, 14, 15], "run_forward": [24, 25, 26, 27], "run_left": [4, 5, 6, 7], "run_right": [36, 37, 38, 39]},
}
var sprite_frame = SpriteFrames.new()
@export_file("*.png") var texture_path
var texture
@export var type: ANIMATION_TYPE
@onready var a = $AnimatedSprite2D
func add_frames(animation_name: String, frames_id: Array):
	sprite_frame.add_animation(animation_name)
	var idx = 0
	for id in frames_id:
		var position = Vector2i(id % (texture.get_width() / 32), id / (texture.get_width() / 32)) * 32
		var frame = texture.get_image().get_region(Rect2i(position, Vector2i(32, 32)))
		sprite_frame.add_frame(animation_name, ImageTexture.create_from_image(frame), 1, idx)
		idx+=1
func _ready():
	#texture = load("res://assets/images/game/animation/character/player_vereran_animation.png")
	#sprite.texture= ImageTexture.create_from_image(texture.get_image().get_region(rect))
	var a_type = animations_dictionary[type]
	texture = load(texture_path)
	for key in a_type:
		add_frames(key, a_type[key])
	#add_frames("idle_back", [12, 13, 14, 15])
	ResourceSaver.save(sprite_frame, "animation.tres")
	
	
