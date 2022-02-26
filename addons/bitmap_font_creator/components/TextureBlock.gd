tool
extends VBoxContainer

signal property_changed(index, property, new_value)

onready var TextureDisplay : TextureRect = $TextureDisplay
var vframes := 1 setget set_vframes
var hframes := 1 setget set_hframes

func _on_TrashButton_pressed() -> void:
	BFCHelpers.debug_print("Delete texture ID %d" % get_index())
	queue_free()

func get_texture() -> Texture: return TextureDisplay.texture

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
	TextureDisplay.h_frames = value
	_update_grid()

func set_texture(tex: Texture) -> void:
	TextureDisplay.texture = tex
	
	var tex_size : Vector2 = (tex as Texture).get_size()
	$Actions/HFrames.max_value = tex_size.x / 2
	$Actions/VFrames.max_value = tex_size.y / 2

func set_vframes(value: int):
	vframes = value
	$Actions/VFrames.value = value
	TextureDisplay.v_frames = value
	_update_grid()

func _on_HFrames_value_changed(value: float) -> void:
	hframes = value
	_update_grid()
	emit_signal('property_changed', get_index(), 'hframes', value)

func _on_VFrames_value_changed(value: float) -> void:
	vframes = value
	_update_grid()
	emit_signal('property_changed', get_index(), 'vframes', value)

func _update_texture_id() -> void:
	$IDLabel.text = "ID: %d" % get_index()

func _update_grid() -> void:
	TextureDisplay.v_frames = vframes
	TextureDisplay.h_frames = hframes
	TextureDisplay.update()
