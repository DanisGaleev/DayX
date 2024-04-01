class_name Dress
extends ItemInfo

var dress_type: Enums.DressType
var slots_count: int
var cold_resistance: int
var armoring: int
var max_carry_weight

func _init(item_pattern=null, count=1, destroying=0):
	super._init(item_pattern, count, 0)
	if item_pattern:
		self.dress_type = item_pattern.dress_type
		self.slots_count = item_pattern.slots_count
		self.cold_resistance = item_pattern.cold_resistance
		self.armoring = item_pattern.armoring
		self.max_carry_weight = item_pattern.max_carry_weight
	
func equip(args): #equip
	if args[0].inventory.equip[dress_type + 1].item == null:
		match dress_type:
			Enums.DressType.HEADDRESS:
				args[0].animations_dictionary["HeaddressAnimation"].sprite_frames = animation 
			Enums.DressType.ARMOR:
				args[0].animations_dictionary["ArmorAnimation"].sprite_frames = animation 
			Enums.DressType.SHIRT:
				args[0].animations_dictionary["ShirtAnimation"].sprite_frames = animation 
			Enums.DressType.PANTS:
				args[0].animations_dictionary["PantsAnimation"].sprite_frames = animation 
			Enums.DressType.BACKPACK:
				args[0].animations_dictionary["BackpackAnimation"].sprite_frames = animation 
		args[0].inventory.equip[dress_type + 1].item = self
		args[0].inventory.equip[dress_type + 1].upd()
		args[1].item = null
		args[1].upd()

		args[0].armoring += self.armoring
		args[0].cold_resistance += self.cold_resistance
		args[0].max_weight += self.max_carry_weight

func get_info():
	var desc = "Number of slots: %s\nCold resistance: %s\nArmoring: %s\nCarry weight: %s"
	desc = desc % [slots_count, cold_resistance, armoring,
		max_carry_weight]
	return "%s" % super.get_info() + desc
