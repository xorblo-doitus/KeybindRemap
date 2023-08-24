extends Control

static var truc = 10

func _ready() -> void:
	pass
#	print(InputMap.get_actions())
#	OS.open_midi_inputs()
#	print(OS.get_connected_midi_inputs())
	KeybindsSaver.set_current_mapping_as_default()
	KeybindsSaver.load_keybinds()
#	add_child(preload("res://addons/keybind_remap/input_chooser/default_input_chooser.tscn").instantiate())


#func _input(event: InputEvent) -> void:
#	if event is InputEventMIDI:
#		print(event)
