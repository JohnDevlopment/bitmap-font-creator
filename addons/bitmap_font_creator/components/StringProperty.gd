tool
extends VBoxContainer

signal value_changed(old_value, new_value)

export var max_length := 0 setget set_max_length
export var label := '' setget set_label
export var value := '' setget set_value

onready var entry_bar = $LineEdit

func set_max_length(ml: int) -> void:
	max_length = int(max(ml, 0))
	$LineEdit.max_length = ml

func set_label(_label: String) -> void:
	label = _label
	$Label.text = label

func set_value(_value: String) -> void:
	if max_length and _value.length() > max_length:
		value = _value.substr(0, max_length)
	else:
		value = _value
	$LineEdit.text = value

func _accept_text_change(new_text: String) -> void:
	if entry_bar.has_focus():
		entry_bar.release_focus()
	var old_value = value
	value = new_text
	emit_signal('value_changed', old_value, new_text)

func _on_LineEdit_focus_exited() -> void:
	_accept_text_change(entry_bar.text)
