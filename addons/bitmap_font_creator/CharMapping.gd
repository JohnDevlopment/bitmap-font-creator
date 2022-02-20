tool
extends Control

var character := 'A' setget set_character
var index := 0 setget set_index
var texture := 0 setget set_texture

onready var Character: LineEdit = get_node("GridContainer/Character")
onready var Index: SpinBox = get_node("GridContainer/Index")
onready var TextureID: SpinBox = get_node("GridContainer/TextureID")

func _on_Character_text_changed(new_text: String) -> void:
	character = new_text

func _on_Index_value_changed(value: float) -> void:
	index = value

func set_character(v: String) -> void:
	character = v
	$GridContainer/Character.text = character

func set_index(v: int) -> void:
	index = v
	Index.value = v

func set_max_value(v: int) -> void:
	var node = Index
	node.max_value = v
	node.value = int(clamp(node.value, node.min_value, node.max_value))

func set_texture(v: int) -> void:
	texture = v
	TextureID.value = v

func set_texture_count(count: int) -> void:
	TextureID.max_value = count - 1
	if TextureID.max_value > 0:
		TextureID.value = clamp(TextureID.value, 0, TextureID.max_value)
	else:
		TextureID.value = 0
		TextureID.max_value = 0

func _on_TrashButton_pressed() -> void:
	queue_free()

func _on_Texture_value_changed(value: float) -> void:
	texture = value
