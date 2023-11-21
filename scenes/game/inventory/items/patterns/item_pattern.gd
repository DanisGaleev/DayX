extends Resource

class_name ItemPattern

export var name : String
export (String, MULTILINE) var description
export var icon_inventory: Texture
export var icon_world: Texture
export (Enums.ItemType) var type
export (int, 1, 60) var count
export (int, 1, 60) var max_count
export var stackable: bool
export var destrouble: bool
export (float, 0.001, 5) var destroying_value
export (float, 0, 1) var destroying
