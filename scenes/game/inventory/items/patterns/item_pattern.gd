extends Resource

class_name ItemPattern
@export_category("General Params")
@export var name : String
@export_multiline var description
@export var type: Enums.ItemType
@export var stackable: bool
@export_range(1, 60) var count: int = 1
@export_range(1, 60) var max_count:int = 1
@export_range(0, 100) var weight_per_one: float
@export_range(0, 1) var destroying: float = 0
@export var destrouble: bool
@export_range(0.001, 5) var destroying_value:float = 0.001
@export var icon_inventory: AtlasTexture
@export var icon_world: AtlasTexture
@export var animation: SpriteFrames

#func _init(name: String = "", description: String = "", type: Enums.ItemType = Enums.ItemType.AMMO, 
#stackable: bool = false, count: int = 1, max_count: int = 1, destroying: float = 0, destrouble: bool = false,
#destroying_value: float = 0, icon_inventory: AtlasTexture = null, icon_world: AtlasTexture = null, animation: SpriteFrames = null):
	#self.name = name
	#self.description = description
	#self.type = type
	#self.stackable = stackable
	#self.count = count
	#self.max_count = max_count
	#self.destroying = destroying
	#self.destrouble = destrouble
	#self.destroying_value = destroying_value
	#self.icon_inventory = icon_inventory
	#self.icon_inventory = icon_inventory
	#self.animation = animation
