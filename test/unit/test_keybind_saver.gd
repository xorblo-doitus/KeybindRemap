extends GutTest



func assert_event_list_equal(a: Array[InputEvent], b: Array[InputEvent], msg: String) -> void:
	assert_eq(len(a), len(b), msg)
	
	for i in len(a):
		var event_a: InputEvent = a[i]
		var event_b: InputEvent = b[i]
		
		if not event_a.is_match(event_b):
			fail_test(msg + (" (failed on item #%d: %s != %s)" % [i, event_a, event_b]))


func assert_action_is_events(action: StringName, events: Array[InputEvent], msg: String) -> void:
	assert_event_list_equal(
		InputMap.action_get_events(action),
		events,
		msg
	)


func test_saving_keybinds() -> void:
	# Verify later that recalling it will work.
	KeybindsSaver.shared.set_current_mapping_as_default()
	
	# Create testing action
	InputMap.add_action(&"unit_test")
	var default_event: InputEventKey = InputEventKey.new()
	default_event.unicode = 87
	default_event.physical_keycode = KEY_Z
	InputMap.action_add_event(&"unit_test", default_event)
	
	KeybindsSaver.shared.set_current_mapping_as_default()
	
	
	InputMap.action_erase_event(&"unit_test", default_event)
	KeybindsSaver.shared.set_action_as_modified(&"unit_test")
	KeybindsSaver.shared.reset_all()
	assert_action_is_events(
		&"unit_test",
		[default_event],
		"`KeybindsSaver.shared.reset_all()` don't work."
	)
	
	
	InputMap.action_erase_event(&"unit_test", default_event)
	KeybindsSaver.shared.set_action_as_modified(&"unit_test")
	KeybindsSaver.shared.reset(&"unit_test")
	assert_action_is_events(
		&"unit_test",
		[default_event],
		"`KeybindsSaver.shared.reset()` don't work."
	)
	
	
	var new_event: InputEventKey = InputEventKey.new()
	new_event.unicode = 106
	new_event.physical_keycode = KEY_J
	InputMap.action_erase_event(&"unit_test", default_event)
	InputMap.action_add_event(&"unit_test", new_event)
	KeybindsSaver.shared.set_action_as_modified(&"unit_test")
	KeybindsSaver.shared.save_keybinds()
	
	assert_action_is_events(
		&"unit_test",
		[new_event],
		"Test preparation failed."
	)
	
	KeybindsSaver.shared.reset_all()
	KeybindsSaver.shared.load_keybinds()
	assert_action_is_events(
		&"unit_test",
		[new_event],
		"`KeybindsSaver.shared.load_keybinds()` don't work."
	)
	
	# Test bulk remapping
	KeybindsSaver.shared.reset_all()
	KeybindsSaver.shared.save_keybinds()
	KeybindsSaver.shared.begin_bulk_remap()
	InputMap.action_erase_event(&"unit_test", default_event)
	InputMap.action_add_event(&"unit_test", new_event)
	KeybindsSaver.shared.set_action_as_modified(&"unit_test")
	KeybindsSaver.shared.save_keybinds() # Should no nothing
	
	#KeybindsSaver.shared.reset_all() # Pas besoin car load_keybinds le fait
	KeybindsSaver.shared.load_keybinds()
	assert_action_is_events(
		&"unit_test",
		[default_event],
		"`KeybindsSaver.shared.begin_bulk_remap()` don't disable `KeybindsSaver.shared.begin_bulk_remap()`."
	)
	
	KeybindsSaver.shared.reset_all()
	InputMap.action_erase_event(&"unit_test", default_event)
	InputMap.action_add_event(&"unit_test", new_event)
	KeybindsSaver.shared.set_action_as_modified(&"unit_test")
	KeybindsSaver.shared.validate_bulk_remap()
	KeybindsSaver.shared.load_keybinds()
	assert_action_is_events(
		&"unit_test",
		[new_event],
		"`KeybindsSaver.shared.begin_bulk_remap()` don't disable `KeybindsSaver.shared.begin_bulk_remap()`."
	)
	
	KeybindsSaver.shared.reset_all()
	KeybindsSaver.shared.save_keybinds()
	InputMap.action_erase_event(&"unit_test", default_event)
	InputMap.action_add_event(&"unit_test", new_event)
	KeybindsSaver.shared.set_action_as_modified(&"unit_test")
	KeybindsSaver.shared.cancel_bulk_remap()
	assert_action_is_events(
		&"unit_test",
		[default_event],
		"`KeybindsSaver.shared.begin_bulk_remap()` don't disable `KeybindsSaver.shared.begin_bulk_remap()`."
	)
	KeybindsSaver.shared.load_keybinds()
	assert_action_is_events(
		&"unit_test",
		[default_event],
		"`KeybindsSaver.shared.begin_bulk_remap()` don't disable `KeybindsSaver.shared.begin_bulk_remap()`."
	)


func test_default_input_map() -> void:
	KeybindsSaver.shared.clear_input_map()
	
	# Create testing action
	InputMap.add_action(&"unit_test")
	var default_event: InputEventKey = InputEventKey.new()
	default_event.unicode = 87
	default_event.physical_keycode = KEY_Z
	InputMap.action_add_event(&"unit_test", default_event)
	
	KeybindsSaver.shared.set_current_mapping_as_default()
	
	assert_true(
		default_event.is_match(KeybindsSaver.shared.get_default_event(&"unit_test", 0)),
		"KeybindsSaver.get_default_event() don't work."
	)
