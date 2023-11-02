class_name ItemInfo
extends Node

var nname: String
var description: String
var icon_inventory: Texture
var icon_world: Texture
var count: int
var max_count: int
var stackable: bool
var destrouble: bool
var destroying_value: float
var destroying: float

func create(item_pattern, _count=1, _destroying=0):
	self.nname = item_pattern.name
	self.description = item_pattern.description
	self.icon_inventory = item_pattern.icon_inventory
	self.icon_world = item_pattern.icon_world
	self.count = _count
	self.max_count = item_pattern.max_count
	self.stackable = item_pattern.stackable
	self.destrouble = item_pattern.destrouble
	self.destroying_value = item_pattern.destroying_value
	self.destroying = _destroying
	
func use(args) -> void:
	if destroying:
		destroying += destroying_value

func destroy() -> void:
	pass

func upd(delta, delta_time):
	if destroying >= 1:
		return null
	return delta + delta_time
func copy():
	pass

func update(delta):
	pass
