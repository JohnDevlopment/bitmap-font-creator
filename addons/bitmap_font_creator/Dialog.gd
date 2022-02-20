tool
extends MarginContainer

var edited_font
var edited_font_path : String
var texture_count := 0
var undo_redo : UndoRedo

func _init_font(font: Object):
	set_meta_default(font, 'char_mappings', {})
	set_meta_default(font, 'vframes', {})
	set_meta_default(font, 'hframes', {})

func apply() -> void:
	pass

func edit(font: BitmapFont) -> void:
	clear_state()
	edited_font = font
	edited_font_path = font.resource_path
	texture_count = 0
	_init_font(font)
	$Tabs/Textures.edit(font, undo_redo)
	$'Tabs/Character Mappings'.edit(font, undo_redo)
	#(edited_font as Resource).connect('changed', self, '_on_resource_changed')

func save() -> void:
	if edited_font:
		(edited_font as BitmapFont).clear()
		$Tabs/Textures.save(edited_font)
		$'Tabs/Character Mappings'.save(edited_font)
		(edited_font as BitmapFont).emit_changed()

func set_meta_default(object: Object, meta: String, value) -> void:
	if not object.has_meta(meta):
		object.set_meta(meta, value)

func clear_state() -> void:
	# If current edited font has a signal connection, disconnect it
#	if is_instance_valid(edited_font):
#		if (edited_font as Resource).is_connected('changed', self, '_on_resource_changed'):
#			(edited_font as Resource).disconnect('changed', self, '_on_resource_changed')
	$Tabs/Textures._clear_state()
	$'Tabs/Character Mappings'._clear_state()

func _on_Textures_texture_count_changed(new_count: int) -> void:
	texture_count = new_count
	$'Tabs/Character Mappings'.set_texture_count(new_count)

func _on_Character_Mappings_mapping_added(node: Node) -> void:
	node.call('set_texture_count', texture_count)

#func _on_resource_changed():
#	print('resource has changed')
