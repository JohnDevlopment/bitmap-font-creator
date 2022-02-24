tool
extends Control

var character := 'A' setget set_character
var cell : Vector2 setget set_cell
var max_cell : Vector2
var texture := 0 setget set_texture

onready var Character: LineEdit = get_node("GridContainer/Character")
onready var TextureID: SpinBox = get_node("GridContainer/TextureID")
onready var Cell: Control = get_node('GridContainer/Cell')

func _on_Character_text_changed(new_text: String) -> void:
	character = new_text

func set_cell(v: Vector2) -> void:
	cell = v
	Cell.value = v

func set_character(v: String) -> void:
	character = v
	$GridContainer/Character.text = character

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

func _on_Cell_value_changed(new_value: Vector2) -> void:
	cell = new_value

#func _update_controls():
#	Character.text = character
#	TextureID.value = texture
#	Cell.value = cell
