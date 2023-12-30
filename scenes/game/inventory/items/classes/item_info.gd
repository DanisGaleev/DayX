class_name ItemInfo

var name: String
var description: String
var icon_inventory: Texture2D
var icon_world: Texture2D
var type: int
var count: int
var max_count: int
var stackable: bool
var destrouble: bool
var destroying_value: float
var destroying: float
var animation: SpriteFrames

func create(item_pattern, _count=1, _destroying=0):
	self.name = item_pattern.name
	self.description = item_pattern.description
	self.icon_inventory = item_pattern.icon_inventory
	self.icon_world = item_pattern.icon_world
	self.type = item_pattern.type
	self.count = _count
	self.max_count = item_pattern.max_count
	self.stackable = item_pattern.stackable
	self.destrouble = item_pattern.destrouble
	self.destroying_value = item_pattern.destroying_value
	self.destroying = _destroying
	self.animation = animation
	
func use(args) -> void:
	pass

func destroy(args) -> void:
	if destrouble:
		destroying += destroying_value
	if destroying >= 1:
		if args[1] == 1:
			args[0].weapon_fire_1 = null
		else:
			args[0].weapon_fire_2 = null

#func upd(delta, delta_time):
#	if destroying >= 1:
#		return null
#	return delta + delta_time

func update(delta):
	pass
