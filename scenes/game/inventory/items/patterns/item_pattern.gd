extends Resource

class_name ItemPattern

@export var name : String
@export_multiline var description
@export var icon_inventory: Texture2D
@export var icon_world: Texture2D
@export var type: Enums.ItemType
@export_range(1, 60) var count: int
@export_range(1, 60) var max_count:int
@export var stackable: bool
@export var destrouble: bool
@export_range(0.001, 5) var destroying_value:float
@export_range(0, 1) var destroying: float
