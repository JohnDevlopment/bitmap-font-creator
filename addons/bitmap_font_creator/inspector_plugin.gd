extends EditorInspectorPlugin

const PROPERTIES_NO_CONTROLS := PoolStringArray(['height', 'fallback', 'distance_field', 'fallback', 'ascent'])

func can_handle(object: Object) -> bool:
	return object is BitmapFont

func parse_category(object: Object, category: String) -> void:
	if category == 'BitmapFont':
		var lb := Label.new()
		lb.text = 'Properties moved to the bottom panel'
		add_custom_control(lb)

func parse_property(object: Object, type: int, path: String, hint: int, hint_text: String, usage: int) -> bool:
	if path in PROPERTIES_NO_CONTROLS:
		return true
	return false
