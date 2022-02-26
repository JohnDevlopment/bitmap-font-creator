tool
extends Control

var character := 'A' setget set_character
var cell : Vector2 setget set_cell
var max_cell : Vector2
var texture := 0 setget set_texture
var texture_count := 0

onready var Character: VBoxContainer = get_node("HBoxContainer/Character")
onready var Cell: VBoxContainer = get_node("HBoxContainer/Cell")
onready var TextureID: VBoxContainer = get_node("HBoxContainer/TextureID")

func set_cell(v: Vector2) -> void:
	cell = v
	call_deferred('_update_control', Cell, 'Cell', 'value', cell)

func set_character(v: String) -> void:
	character = v
	call_deferred('_update_control', Character, 'Character', 'value', character)

func set_texture(v: int) -> void:
	texture = v
	call_deferred('_update_control', TextureID, 'TextureID', 'value', texture)

func set_texture_count(count: int) -> void:
	texture_count = count - 1
	var node = TextureID
	if not node:
		node = get_node(@'HBoxContainer/TextureID')
		assert(node, "%s not found" % 'TextureID')
	node.max_value = texture_count
	if node.max_value > 0:
		node.value = clamp(node.value, 0, node.max_value)
	else:
		node.value = 0
		node.max_value = 0

func _update_control(node, _name: String, property: String, value) -> void:
	if not node:
		node = get_node('HBoxContainer/' + _name)
	(node as Object).set(property, value)

func _on_TrashButton_pressed() -> void:
	queue_free()

func _on_TextureID_value_changed(value: float) -> void:
	texture = int(value)

func _on_Cell_value_changed(new_value: Vector2) -> void:
	cell = new_value

func _on_Character_value_changed(_old_value, new_value: String) -> void:
	character = new_value
