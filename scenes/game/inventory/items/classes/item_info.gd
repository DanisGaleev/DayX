class_name ItemInfo

var name: String
var description: String
var icon_inventory: Texture2D
var icon_world: Texture2D
var type: int
var count: int
var max_count: int
var weight: float
var weight_per_one: float
var stackable: bool
var destrouble: bool
var destroying_value: float
var destroying: float
var animation: SpriteFrames
var item_pattern: ItemPattern

func _init(item_pattern=null, _count=1, _destroying=0):
	if item_pattern:
		self.name = item_pattern.name
		self.description = item_pattern.description
		self.icon_inventory = item_pattern.icon_inventory
		self.icon_world = item_pattern.icon_world
		self.type = item_pattern.type
		self.count = _count
		self.max_count = item_pattern.max_count
		self.weight_per_one = item_pattern.weight_per_one
		self.weight = item_pattern.weight_per_one * self.count
		self.stackable = item_pattern.stackable
		self.destrouble = item_pattern.destrouble
		self.destroying_value = item_pattern.destroying_value
		self.destroying = _destroying
		self.animation = item_pattern.animation
		self.item_pattern = item_pattern
func _use(_args) -> void:
	pass
func destroy(args) -> void:
	if destrouble:
		destroying += destroying_value
	if destroying >= 1:
		if args[1] == 1:
			args[0].weapon_fire_1 = null
		else:
			args[0].weapon_fire_2 = null

func _update(_delta):
	pass
	
func _get_info():
	var desc = "Name: %s\nDescription: %s\nStackable: %s\nCount: %s\n"
	desc += "Max count: %s\nWeight per one: %s\nWeight: %s\nDestrouble: %s\nDestroying: %s\nDestroying value: %s\n"
	desc = desc % [name, description, stackable, count, 
		max_count, weight_per_one, weight_per_one * count, destrouble, destroying, destroying_value]
	return desc

func dublicate():
	pass
