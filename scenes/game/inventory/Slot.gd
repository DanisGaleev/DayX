class_name Slot
extends TextureRect

onready var count_label = $Count
onready var description = $Description

var inventory: Array
var one_time = true

var dragging = false
var drag_offset = Vector2.ZERO
var id: int

var item: ItemInfo setget set_item, get_item

onready var icon = $Icon

signal dropped

func set_item(n_item: ItemInfo) -> void:
	item = n_item
	
func get_item() -> ItemInfo:
	return item
	
func is_empty() -> bool:
	return self.item == null

func _ready():
	connect("dropped", self, "set_position_by_id")
	set_process_input(true)
	inventory = get_parent().get_parent().inventory
	id = 0 if self.name.substr(4) == "" else int(self.name.substr(4)) - 1
#	if id % 2 == 0:
#		self.item = Ammo.new()
#		self.item.create(preload("res://assets/item_patterns/5_45x39_ammo.tres"), 25, 0)
#		icon.texture = item.icon_inventory
#		count_label.text = str(item.count)
#		description.text = item.description
#	print(rect_position)

func _input(event):
	pass


func get_id_by_position(position=rect_position + rect_size / 2) -> int:
	return int(position.x) / 68 + int(position.y / 68) * 4

func upd():
	if item:
		icon.texture = item.icon_inventory
		count_label.text = str(item.count)
	else:
		icon.texture = null
		count_label.text = ""
		

func set_position_by_id():
	#rect_position = Vector2(self.id % 4 * 68, self.id / 4 * 68)
	set_global_position(Vector2(197 + self.id % 4 * 68, 54 + self.id / 4 * 68))

func _process(delta):
#	if id == 0 or id == 1:
#		print(get_global_rect(), id)
	if dragging:
		#rect_position = get_viewport().get_mouse_position() - drag_offset
		set_global_position(get_viewport().get_mouse_position() - drag_offset)
		one_time = false
	elif get_parent().get_parent().visible and not one_time:
		one_time = true
		var middle = rect_position + rect_size / 2

		if middle.x <= 306 and middle.x >= -34 and middle.y <= 238 and middle.y >= -34: # check if in inventory
			var swap_id = get_id_by_position()
			if inventory[swap_id].item != null:
				var swap_item = inventory[swap_id].item
				#print(swap_item.name, item.name, item.stackable)
				if swap_item.name == self.item.name and self.item.stackable: #check if can stack

					var diff = swap_item.max_count - swap_item.count
					if diff >= self.item.count: # check if can fetch
						swap_item.count += diff #swap normalisation
						inventory[swap_id].upd()
						inventory[swap_id].set_position_by_id()

						self.item = null #self normalisation
						upd()
						set_position_by_id()
					else: # if can't fetch
						swap_item.count = swap_item.max_count #swap normalisation
						inventory[swap_id].upd()
						inventory[swap_id].set_position_by_id()

						self.item.count -= diff #self normalisation
						upd()
						set_position_by_id()
				else: # if diffenent names or can't stack
					inventory[swap_id].item = self.item
					#inventory[swap_id].id = self.id
					inventory[swap_id].upd()
					inventory[swap_id].set_position_by_id()
					#self.id = swap_id
					self.item = swap_item

					upd()
					set_position_by_id()
					#emit_signal("dropped")
			else: #if swap-item is null
				#print(swap_id)
				inventory[swap_id].item = self.item
				inventory[swap_id].upd()
				inventory[swap_id].set_position_by_id()

				self.item = null
				upd()
				set_position_by_id()
			var e = ""
			for i in range(inventory.size()):
				if inventory[i].item == null:
					e += " 0"
				else:
					e += " 1"
				if i > 0 and i % 4 == 3:
					print(e)
					e = ""
			print()
				#emit_signal("dropped")
			#inventory[swap_id].set_postion_by_id()
		else: # if swap_item doesn't exist
			set_position_by_id()


func _on_Slot_mouse_entered():
	description.visible = true

func _on_Slot_mouse_exited():
	description.visible = false


func _on_Slot_gui_input(event: InputEvent):
	if event.is_action_pressed("left_click") and item:
		print(get_global_rect(), (event as InputEventMouseButton).global_position)
		if get_global_rect().has_point(event.global_position):
			dragging = true
			drag_offset = event.global_position - get_global_rect().position

	if event.is_action_released("left_click") and dragging and item:
		dragging = false
