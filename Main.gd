extends Control

var VectorControl : Control
var VectorLabel : Label
var V : SpinBox
var H : SpinBox

func _ready() -> void:
	NodeMapper.map_nodes(self)
	VectorLabel.text = str(Vector2.ZERO)

func _on_Vector2_value_changed(new_value: Vector2) -> void:
	VectorLabel.text = str(new_value)

func _on_IntegerProperty_value_changed(value: int) -> void:
	$Margin/Rows/IntegerProperty/Label.text = str(value)
