tool
extends VBoxContainer

signal property_changed(index, property, new_value)
signal debug_print(text)

var vframes := 1 setget set_vframes
var hframes := 1 setget set_hframes

func _on_TrashButton_pressed() -> void:
	_debug_print("Delete texture ID %d" % get_index())
	queue_free()

func get_texture() -> Texture: return $TextureRect.texture

func load_texture(path: String) -> int:
	var tex = load(path)
	if not tex:
		return ERR_CANT_ACQUIRE_RESOURCE
	elif not tex is Texture:
		return ERR_INVALID_PARAMETER
	set_texture(tex)
	
	return OK

func set_hframes(value: int):
	hframes = value
	$Actions/HFrames.value = value

func set_texture(tex: Texture) -> void:
	$TextureRect.texture = tex
	
	var tex_size : Vector2 = (tex as Texture).get_size()
	$Actions/HFrames.max_value = tex_size.x / 2
	$Actions/VFrames.max_value = tex_size.y / 2

func set_vframes(value: int):
	vframes = value
	$Actions/VFrames.value = value

func _on_HFrames_value_changed(value: float) -> void:
	hframes = value
	emit_signal('property_changed', get_index(), 'hframes', value)

func _on_VFrames_value_changed(value: float) -> void:
	vframes = value
	emit_signal('property_changed', get_index(), 'vframes', value)

func _update_texture_id() -> void:
	$IDLabel.text = "ID: %d" % get_index()

func _debug_print(text: String) -> void:
	emit_signal('debug_print', text)
