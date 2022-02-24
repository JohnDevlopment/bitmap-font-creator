tool
extends TextureRect

var v_frames := 1.0
var h_frames := 1.0

const ALPHA := 0.3

func _draw() -> void:
	if is_instance_valid(texture):
		var size := texture.get_size()
		var width := size.x / h_frames
		var height := size.y / v_frames
		
		var end := v_frames * height
		for i in range(h_frames):
			var x := i * width
			draw_line(Vector2(x, 0), Vector2(x, end), Color(1, 1, 1, ALPHA))
			draw_line(Vector2(x + 1, 0), Vector2(x + 1, end), Color(0, 0, 0, ALPHA))
		
		end = h_frames * width
		for i in range(v_frames):
			var y := i * height
			draw_line(Vector2(0, y), Vector2(end, y), Color(1, 1, 1, ALPHA))
			draw_line(Vector2(0, y + 1), Vector2(end, y + 1), Color(0, 0, 0, ALPHA))
