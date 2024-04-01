extends ItemPattern
class_name DressPattern

@export var dress_type: Enums.DressType
@export_range(0, 3, 1) var slots_count: int
@export_range(0, 8, 1) var cold_resistance: int
@export_range(0, 10, 1) var armoring: int
@export_range(0, 20, 1) var max_carry_weight: int
