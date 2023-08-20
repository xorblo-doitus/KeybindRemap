extends HBoxContainer
class_name InputDisplay


@export var input_idx: int:
	set(new):
		input_idx = new
		if input_icon:
			input_icon.input_idx = new
@export var action_name: StringName:
	set(new):
		action_name = new
		if input_icon:
			input_icon.action_name = new
@export var input_event: InputEvent:
	set(new):
		input_event = new
		if input_icon:
			input_icon.input_event = new
@export var focus_style_box: StyleBox
@export var physical_icon_modulate: Color = Color(1, 1, 1, 0.75):
	set(new):
		physical_icon_modulate = new
		if physical_icon:
			physical_icon.modulate = physical_icon_modulate

@onready var input_icon: TextureRect = $InputIcon
@onready var fallback_label: Label = $FallbackLabel
@onready var modifiers: HBoxContainer = $Modifiers
@onready var physical_icon: TextureRect = $InputIcon/PhysicalIcon


func _ready() -> void:
	input_icon.input_idx = input_idx
	input_icon.action_name = action_name
	input_icon.input_event = input_event
	input_event = input_icon.input_event # If it fetched something
	physical_icon.modulate = physical_icon_modulate


func adapt_to(event: InputEvent) -> void:
	if input_icon.texture == InputIcon.blank:
		display_fallback(event)
	else:
		display(event)
	

func display(event: InputEvent) -> void:
	input_icon.show()
	fallback_label.hide()
	
	for child in modifiers.get_children():
		child.queue_free()
		modifiers.remove_child(child)
	
	if event is InputEventWithModifiers:
		if event.ctrl_pressed:
			_new_modifier_texture_rect().texture = preload("res://addons/ActionIcon/Keyboard/Ctrl.png")
		if event.alt_pressed:
			_new_modifier_texture_rect().texture = preload("res://addons/ActionIcon/Keyboard/Alt.png")
		if event.shift_pressed:
			_new_modifier_texture_rect().texture = preload("res://addons/ActionIcon/Keyboard/Shift.png")
		if event.meta_pressed:
			_new_modifier_texture_rect().texture = preload("res://addons/ActionIcon/Keyboard/Command.png")
	
	physical_icon.visible = event is InputEventKey and event.keycode == 0 and event.physical_keycode != 0
	modifiers.visible = modifiers.get_child_count()


func display_fallback(event: InputEvent) -> void:
	input_icon.hide()
	modifiers.hide()
	fallback_label.show()
	fallback_label.text = event.as_text()


func _on_input_icon_input_changed(input_event) -> void:
	adapt_to.call_deferred(input_event)


func _new_modifier_texture_rect() -> TextureRect:
	var new_plus_label: Label = Label.new()
	new_plus_label.text = "+"
	
	var new: TextureRect = InputIcon._default_size_setup(TextureRect.new())
	
	modifiers.add_child(new)
	modifiers.add_child(new_plus_label)
	
	return new
		

func _draw() -> void:
	if has_focus():
		if focus_style_box:
			draw_style_box(focus_style_box, get_rect())


func _on_focus_entered() -> void:
	_set_focus(true)


func _on_focus_exited() -> void:
	_set_focus(false)


func _set_focus(focused: bool) -> void:
	queue_redraw()
