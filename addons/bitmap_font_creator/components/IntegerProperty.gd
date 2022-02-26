tool
extends Container

signal value_changed(old_value, value)

export var label := 'Label' setget set_label
export var min_value := 0 setget set_min_value
export var max_value := 1 setget set_max_value
export(String, MULTILINE) var property_hint := '' setget set_property_hint

var value := 0 setget set_value

func set_label(_label: String) -> void:
	label = _label
	$NameLabel.text = label

func set_min_value(_min: int) -> void:
	min_value = _min
	_update_controls()

func set_max_value(_max: int) -> void:
	max_value = int(max(_max, min_value + 1))
	_update_controls()

func set_property_hint(hint: String) -> void:
	property_hint = hint
	hint_tooltip = "Property: %s\n\n%s" % [label.to_lower(), property_hint]

func set_value(_value: int) -> void:
	value = int(clamp(_value, min_value, max_value))
	$IntegerValue.value = value

func _on_IntegerValue_value_changed(_value: float) -> void:
	var old_value := value
	value = int(_value)
	$IntegerValue.release_focus()
	emit_signal('value_changed', old_value, value)

func _update_controls():
	var integer_value = $IntegerValue
	integer_value.min_value = min_value
	integer_value.max_value = max_value

func _ready() -> void:
	if value < min_value:
		set_value(min_value)
	elif value > max_value:
		set_value(max_value)

