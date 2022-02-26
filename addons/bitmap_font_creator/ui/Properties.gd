tool
extends MarginContainer

var connected_to_dialog := false
var edited_font
var undo_redo : UndoRedo
var editor_inspector : EditorInspector
onready var Height = get_node('VBoxContainer/Height')
onready var Ascent = get_node('VBoxContainer/Ascent')
onready var DistanceField = get_node('VBoxContainer/DistanceField')

func _ready() -> void:
	if not Engine.editor_hint or not connected_to_dialog: return
	
	var hbox := HBoxContainer.new()
	$VBoxContainer.add_child(hbox)
	
	var label := Label.new()
	label.text = 'Fallback Font'
	var resource_picker := EditorResourcePicker.new()
	resource_picker.add_child(label)
	resource_picker.move_child(label, 0)
	resource_picker.rect_min_size.x = 200
	resource_picker.base_type = 'BitmapFont'
	resource_picker.name = 'FallbackFont'
	resource_picker.size_flags_horizontal = SIZE_SHRINK_CENTER
	hbox.add_child(resource_picker, true)

func edit(font: BitmapFont, _undo_redo: UndoRedo):
	set_meta('_lock_signals', true)
	edited_font = font
	undo_redo = _undo_redo
	Height.value = font.get_height()
	Ascent.value = font.get_ascent()
	DistanceField.set_pressed_no_signal(font.is_distance_field_hint())
	set_meta('_lock_signals', false)

func save(font: BitmapFont) -> void:
	font.height = Height.value
	font.ascent = Ascent.value
	font.distance_field = DistanceField.is_pressed()

func _on_integer_value_changed(old_value: int, value: int, _name: String) -> void:
	if get_meta('_lock_signals'): return
	undo_redo.create_action('Set font %s' % _name)
	match _name:
		'height':
			undo_redo.add_do_property(Height, 'value', value)
			undo_redo.add_undo_property(Height, 'value', old_value)
		'ascent':
			undo_redo.add_do_property(Ascent, 'value', value)
			undo_redo.add_undo_property(Ascent, 'value', old_value)
	undo_redo.commit_action()

func _on_DistanceField_toggled(button_pressed: bool) -> void:
	if get_meta('_lock_signals'): return
	undo_redo.create_action('Set font distance field')
	undo_redo.add_do_property(DistanceField, 'pressed', button_pressed)
	undo_redo.add_undo_property(DistanceField, 'pressed', !button_pressed)
	undo_redo.commit_action()
