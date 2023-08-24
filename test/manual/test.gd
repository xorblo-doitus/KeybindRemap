extends Control

static var truc = 10

func _ready() -> void:
	pass
#	print(InputMap.get_actions())
#	OS.open_midi_inputs()
#	print(OS.get_connected_midi_inputs())
	KeybindsSaver.set_current_mapping_as_default()
	KeybindsSaver.load_keybinds()


#func _input(event: InputEvent) -> void:
#	if event is InputEventMIDI:
#		print(event)
