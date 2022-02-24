tool
extends EditorPlugin

const Window = preload('res://addons/bitmap_font_creator/Dialog.tscn')
const DebugSetting := 'BitmapFontPlugin/debug/print_messages'

var _dialog : Control
var _show_button

func _enter_tree() -> void:
	if not ProjectSettings.has_setting(DebugSetting):
		ProjectSettings.set_setting(DebugSetting, false)
		ProjectSettings.set_initial_value(DebugSetting, false)
	ProjectSettings.save()
	_dialog = Window.instance()
	_dialog.undo_redo = get_undo_redo()
	_dialog.init()
	_show_button = add_control_to_bottom_panel(_dialog, 'Bitmap Font')
	_show_button.hide()

func _exit_tree() -> void:
	remove_control_from_bottom_panel(_dialog)
	_dialog.queue_free()
	_dialog = null
	_show_button = null

func apply_changes() -> void:
	if is_instance_valid(_dialog) and (_dialog as Control).is_visible_in_tree():
		_dialog.apply()

func clear() -> void:
	_dialog.clear_state()

func edit(object: Object) -> void:
	if is_instance_valid(_dialog):
		_dialog.edit(object)

func get_plugin_icon() -> Texture:
	return load('res://addons/bitmap_font_creator/icon.png') as Texture

func get_plugin_name() -> String: return 'Bitmap Font Creator'

func handles(object: Object) -> bool: return object is BitmapFont

func make_visible(visible: bool) -> void:
	if not is_instance_valid(_dialog):
		printerr('_dialog is not valid')
		return
	elif not _show_button:
		printerr('_show_button is null')
		return
	
	if visible:
		_show_button.show()
		make_bottom_panel_item_visible(_dialog)
	else:
		_show_button.hide()
		if (_dialog as Control).is_visible_in_tree():
			hide_bottom_panel()

func save_external_data() -> void:
	if is_instance_valid(_dialog) and (_dialog as Control).is_visible_in_tree():
		print('save_external_data')
		_dialog.save()
