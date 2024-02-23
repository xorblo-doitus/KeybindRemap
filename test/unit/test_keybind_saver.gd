extends GutTest



func assert_event_list_equal(a: Array[InputEvent], b: Array[InputEvent], msg: String) -> void:
	assert_eq(len(a), len(b), msg)
	
	for i in len(a):
		var event_a: InputEvent = a[i]
		var event_b: InputEvent = b[i]
		
		if not event_a.is_match(event_b):
			fail_test(msg + (" (failed on item #%d: %s != %s)" % [i, event_a, event_b]))



func test_saving_keybinds() -> void:
	# Verify later that recalling it will work.
	KeybindsSaver.set_current_mapping_as_default()
	
	# Create testing action
	InputMap.add_action(&"unit_test")
	var default_event: InputEventKey = InputEventKey.new()
	default_event.unicode = 87
	default_event.physical_keycode = KEY_Z
	InputMap.action_add_event(&"unit_test", default_event)
	
	KeybindsSaver.set_current_mapping_as_default()
	
	
	InputMap.action_erase_event(&"unit_test", default_event)
	KeybindsSaver.set_action_as_modified(&"unit_test")
	KeybindsSaver.reset_all()
	assert_event_list_equal(
		InputMap.action_get_events(&"unit_test"),
		[default_event],
		"`KeybindsSaver.reset_all()` don't work."
	)
	
	
	InputMap.action_erase_event(&"unit_test", default_event)
	KeybindsSaver.set_action_as_modified(&"unit_test")
	KeybindsSaver.reset(&"unit_test")
	assert_event_list_equal(
		InputMap.action_get_events(&"unit_test"),
		[default_event],
		"`KeybindsSaver.reset()` don't work."
	)
	
	
	var new_event: InputEventKey = InputEventKey.new()
	new_event.unicode = 106
	new_event.physical_keycode = KEY_J
	InputMap.action_erase_event(&"unit_test", default_event)
	InputMap.action_add_event(&"unit_test", new_event)
	KeybindsSaver.set_action_as_modified(&"unit_test")
	KeybindsSaver.save_keybinds()
	
	assert_event_list_equal(
		InputMap.action_get_events(&"unit_test"),
		[new_event],
		"Test preparation failed."
	)
	
	KeybindsSaver.reset_all()
	KeybindsSaver.load_keybinds()
	assert_event_list_equal(
		InputMap.action_get_events(&"unit_test"),
		[new_event],
		"`KeybindsSaver.load_keybinds()` don't work."
	)

