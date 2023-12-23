extends Resource

class_name ItemPattern
@export_category("General Params")
@export var name : String
@export_multiline var description
@export var type: Enums.ItemType
@export var stackable: bool
@export_range(1, 60) var count: int
@export_range(1, 60) var max_count:int
@export_range(0, 1) var destroying: float
@export var destrouble: bool
@export_range(0.001, 5) var destroying_value:float
@export var icon_inventory: AtlasTexture
@export var icon_world: AtlasTexture
@export var animation: SpriteFrames
