tool
extends Container

signal value_changed(new_value)

var value : Vector2 setget set_value

onready var X = $HBoxContainer/X
onready var Y = $HBoxContainer2/Y

export var label := '' setget set_label

func _ready() -> void:
	call_deferred('_update_controls')

func set_label(_label: String) -> void:
	label = _label
	$Label.text = label

func set_value(v: Vector2) -> void:
	value = v
	call_deferred('_update_controls')

func _vector_changed(new_text: String, extra_arg_0: String) -> void:
	var _value : float
	
	call_deferred('_update_controls')
	call_deferred('_unfocus_controls')
	
	if not new_text.is_valid_integer() and not new_text.is_valid_float(): return
	_value = float(new_text)
	if extra_arg_0 == 'x':
		value.x = _value
	else:
		value.y = _value
	emit_signal('value_changed', value)

func _on_focus_exited(component: String) -> void:
	var new_text : String
	var control
	var data := {
		'x': {
			control = X,
			old_value = value.x
		},
		'y': {
			control = Y,
			old_value = value.y
		}
	}
	
	control = data[component].control
	new_text = (control as LineEdit).text
	
	# If the new value and the current value are the same
	if new_text == str(data[component].old_value): return
	
	if _is_valid_change(new_text):
		call_deferred('_update_controls')
		if component == 'x':
			value.x = float(new_text)
		else:
			value.y = float(new_text)
		emit_signal('value_changed', value)
	else:
		control.text = str(data[component].old_value)

func _update_controls() -> void:
	X.text = str(value.x)
	Y.text = str(value.y)

func _unfocus_controls() -> void:
	for node in [X, Y]:
		if (node as Control).has_focus():
			(node as Control).release_focus()

func _is_valid_change(new_text: String) -> bool:
	return new_text.is_valid_integer() or new_text.is_valid_float()
