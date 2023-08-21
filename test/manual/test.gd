extends Control

static var truc = 10

func _ready() -> void:
	pass
#	print(InputMap.get_actions())
	KeybindsSaver.load_keybinds()
