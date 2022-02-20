tool
extends MarginContainer

signal texture_count_changed(new_count)

const TextureBlock = preload('res://addons/bitmap_font_creator/TextureBlock.tscn')

onready var OpenFileDialog: FileDialog = get_node("OpenFileDialog")
onready var TexturesGrid: GridContainer = get_node("ScrollContainer/VBoxContainer/TexturesGrid")
var edited_font
var undo_redo : UndoRedo

func _on_AddTextureButton_pressed() -> void:
	OpenFileDialog.popup_centered()
	OpenFileDialog.grab_focus()

func _add_texture(tex):
	# Add node to scene tree
	var node = TextureBlock.instance()
	TexturesGrid.add_child(node)
	node.connect('property_changed', self, '_on_texture_property_changed')
	
	if tex is String:
		if node.load_texture(tex):
			push_error("Unable to load '%s'" % tex)
			node.queue_free()
			return
		emit_texture_count_changed()
	elif tex is Texture:
		node.set_texture(tex)
	else:
		push_error("Invalid resource '%s', neither a string nor a texture." % tex)
		node.queue_free()
		return
	
	return node

func _clear_state() -> void:
	edited_font = null
	for node in TexturesGrid.get_children():
		(node as Node).queue_free()

func _on_texture_property_changed(index: int, property: String, new_value):
	match property:
		'vframes':
			var vframes : Dictionary = edited_font.get_meta('vframes')
			vframes[index] = new_value
			(edited_font as BitmapFont).set_meta('vframes', vframes)
			(edited_font as BitmapFont).emit_changed()
		'hframes':
			var hframes : Dictionary = edited_font.get_meta('hframes')
			hframes[index] = new_value
			(edited_font as BitmapFont).set_meta('hframes', hframes)
			(edited_font as BitmapFont).emit_changed()

func edit(font: BitmapFont, _undo_redo: UndoRedo) -> void:
	edited_font = font
	undo_redo = _undo_redo
	var vframes : Dictionary = font.get_meta('vframes')
	var hframes : Dictionary = font.get_meta('hframes')
	for i in font.get_texture_count():
		var tex = font.get_texture(i)
		var node = _add_texture(tex)
		if i in vframes:
			node.vframes = vframes[i]
		if i in hframes:
			node.hframes = hframes[i]
	emit_texture_count_changed()

func emit_texture_count_changed() -> void:
	emit_signal('texture_count_changed', TexturesGrid.get_child_count())

func save(font: BitmapFont):
	var vframes := {}
	var hframes := {}
	for i in TexturesGrid.get_child_count():
		var node = TexturesGrid.get_child(i)
		vframes[i] = node.vframes
		hframes[i] = node.hframes
		font.add_texture(node.get_texture())
	font.set_meta('vframes', vframes)
	font.set_meta('hframes', hframes)
