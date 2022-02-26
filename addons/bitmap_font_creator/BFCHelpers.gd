tool
extends Node

const DebugSetting := 'BitmapFontPlugin/debug/print_messages'

func debug_print(text: String) -> void:
	if ProjectSettings.get_setting(DebugSetting):
		print('[DEBUG] ', text)

func get_cell_size(font: BitmapFont, texture: int) -> Vector2:
	var vframes = font.get_meta('vframes')[texture]
	var hframes = font.get_meta('hframes')[texture]
	var tex_size : Vector2 = font.get_texture(texture).get_size()
	return tex_size / Vector2(hframes, vframes)
