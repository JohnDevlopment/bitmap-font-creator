tool
extends ScrollContainer

signal mapping_added(node)

const CharMapping = preload('res://addons/bitmap_font_creator/CharMapping.tscn')

var undo_redo : UndoRedo

func _on_AddMappingButton_pressed() -> void:
	var node = CharMapping.instance()
	$VBoxContainer/MappingsGrid.add_child(node)
	emit_signal('mapping_added', node)

func edit(font: BitmapFont, _undo_redo: UndoRedo) -> void:
	undo_redo = _undo_redo
	var mappings : Dictionary = font.get_meta('char_mappings')
	for ch in mappings:
		var node = CharMapping.instance()
		$VBoxContainer/MappingsGrid.add_child(node)
		emit_signal('mapping_added', node)
		node.character = ch
		node.index = mappings[ch].index
		node.texture = mappings[ch].texture

func save(font: BitmapFont) -> void:
	var mappings_grid = $VBoxContainer/MappingsGrid
	var mappings := {}
	for i in mappings_grid.get_child_count():
		var node = mappings_grid.get_child(i)
		var ch : String = node.character
		var index : int = node.index
		mappings[ch] = {
			index = index,
			texture = node.texture
		}
		_add_char_to_font(font, ch, index, node.texture)
	font.set_meta('char_mappings', mappings)

func set_texture_count(count: int) -> void:
	for node in $VBoxContainer/MappingsGrid.get_children():
		node.set_texture_count(count)

func _add_char_to_font(font: BitmapFont, ch: String, index: int, texture: int) -> void:
	var cell_size := _get_cell_size(font)
	var hframes : int = font.get_meta('hframes')[texture]
	var position := Vector2(index % hframes, index / hframes) * cell_size
	#print("Texture %d, index %d <%s>" % [texture, index, position])
	font.add_char(ord(ch), texture, Rect2(position, cell_size))

func _get_cell_size(font: BitmapFont) -> Vector2:
	var vframes = font.get_meta('vframes')[0]
	var hframes = font.get_meta('hframes')[0]
	var tex_size : Vector2 = font.get_texture(0).get_size()
	return tex_size / Vector2(hframes, vframes)

func _clear_state() -> void:
	for node in $VBoxContainer/MappingsGrid.get_children():
		(node as Node).queue_free()
