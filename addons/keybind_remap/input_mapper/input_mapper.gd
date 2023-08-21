extends InputDisplay
class_name InputMapper


static var _default_input_chooser: InputChooser



@export var input_chooser: InputChooser:
	get:
		if input_chooser == null:
			return _get_default_input_chooser()
		
		return input_chooser


var _pressed: bool = false
func _gui_input(event: InputEvent) -> void:
	if _is_click(event):
		if _pressed:
			if not event.pressed:
				_pressed = false
				if get_global_rect().has_point(event.global_position):
					if input_chooser.request_remap(input_event):
						input_chooser.choosed.connect(_on_choosed, CONNECT_ONE_SHOT)
				
		elif event.pressed:
			_pressed = true


func _is_click(event: InputEvent) -> bool:
	return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT


func _get_default_input_chooser() -> InputChooser:
	if _default_input_chooser == null or not is_instance_valid(_default_input_chooser):
		print("create mapper gui")
		_default_input_chooser = preload("res://addons/keybind_remap/input_chooser/default_input_chooser.tscn").instantiate()
		get_tree().root.add_child(_default_input_chooser)
	return _default_input_chooser


func _on_choosed(event: InputEvent) -> void:
	if event == null:
		return
	
	if input_icon.fetch_input_event() == null:
		input_event = event
	
	if Engine.is_editor_hint() or !InputMap.has_action(action_name):
		return
	
	var events: Array[InputEvent] = InputMap.action_get_events(action_name)
	if -len(events) > input_idx or input_idx >= len(events):
		return
	
	events[input_idx] = event
	
	InputMap.action_erase_events(action_name)
	for action_event in events:
		InputMap.action_add_event(action_name, action_event)
	
	if is_inside_tree():
		get_tree().call_group(&"action_icons", &"refresh")
	elif input_chooser.is_inside_tree():
		input_chooser.get_tree().call_group(&"action_icons", &"refresh")
	
	KeybindsSaver.save_keybinds()
	
	


