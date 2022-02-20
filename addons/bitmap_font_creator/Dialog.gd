tool
extends MarginContainer

var edited_font
var edited_font_path : String
var texture_count := 0

func _init_font(font: Object):
	set_meta_default(font, 'char_mappings', {})
	set_meta_default(font, 'vframes', {})
	set_meta_default(font, 'hframes', {})

func apply() -> void:
	pass
#	if edited_font:
#		(edited_font as BitmapFont).emit_changed()

func edit(font: BitmapFont) -> void:
	_clear_state()
	edited_font = font
	edited_font_path = font.resource_path
	texture_count = 0
	_init_font(font)
	$Tabs/Textures.edit(font)
	$'Tabs/Character Mappings'.edit(font)

func save() -> void:
	if edited_font:
		(edited_font as BitmapFont).clear()
		$Tabs/Textures.save(edited_font)
		$'Tabs/Character Mappings'.save(edited_font)
		(edited_font as BitmapFont).emit_changed()
		#ResourceSaver.save(edited_font_path, edited_font)

func set_meta_default(object: Object, meta: String, value) -> void:
	if not object.has_meta(meta):
		object.set_meta(meta, value)

func _clear_state() -> void:
	$Tabs/Textures._clear_state()
	$'Tabs/Character Mappings'._clear_state()

func _on_Textures_texture_count_changed(new_count: int) -> void:
	texture_count = new_count
	$'Tabs/Character Mappings'.set_texture_count(new_count)

func _on_Character_Mappings_mapping_added(node: Node) -> void:
	node.call('set_texture_count', texture_count)
