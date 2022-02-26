tool
extends EditorPlugin

const Window = preload('res://addons/bitmap_font_creator/Dialog.tscn')
const DebugSetting := 'BitmapFontPlugin/debug/print_messages'

var _dialog : Control
var _show_button
var _inspector_plugin

func _enter_tree() -> void:
	if not ProjectSettings.has_setting(DebugSetting):
		ProjectSettings.set_setting(DebugSetting, false)
		ProjectSettings.set_initial_value(DebugSetting, false)
		ProjectSettings.save()
	add_autoload_singleton('BFCHelpers', 'res://addons/bitmap_font_creator/BFCHelpers.gd')
	# Add dialog to bottom window
	_dialog = Window.instance()
	_dialog.inspector = get_editor_interface().get_inspector()
	_dialog.undo_redo = get_undo_redo()
	_show_button = add_control_to_bottom_panel(_dialog, 'Bitmap Font')
	_show_button.hide()
	_dialog.connect('launch_charmap_wizard', self, '_launch_charmap_wizard')
	_dialog.init()
	# Inspector plugin
	_inspector_plugin = preload('res://addons/bitmap_font_creator/inspector_plugin.gd').new()
	add_inspector_plugin(_inspector_plugin)

func _exit_tree() -> void:
	if is_instance_valid(_dialog):
		remove_control_from_bottom_panel(_dialog)
		_dialog.queue_free()
		_dialog = null
		_show_button = null
	if _inspector_plugin:
		remove_inspector_plugin(_inspector_plugin)
	#remove_autoload_singleton('BFCHelpers')

func apply_changes() -> void:
	if is_instance_valid(_dialog) and (_dialog as Control).is_visible_in_tree():
		_dialog.apply()

func clear() -> void:
	if is_instance_valid(_dialog):
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

#func save_external_data() -> void:
#	if is_instance_valid(_dialog) and (_dialog as Control).is_visible_in_tree():
#		print('save_external_data')
#		_dialog.save()

func _launch_charmap_wizard(font: BitmapFont, font_res_path: String, texture_count: int):
	var dlg = preload('res://addons/bitmap_font_creator/ui/CharacterMapWizard.tscn').instance()
	get_editor_interface().get_base_control().add_child(dlg)
	(dlg as Popup).popup_centered_ratio(0.5)
	clear()
	make_visible(false)
	dlg.edit(font, font_res_path, texture_count)
