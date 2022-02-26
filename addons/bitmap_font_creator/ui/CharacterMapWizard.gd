tool
extends WindowDialog

export var in_edit := false

onready var TextureCountLabel: Label = get_node("MarginContainer/VBoxContainer/TextureCountLabel")
onready var StartChar: VBoxContainer = get_node("MarginContainer/VBoxContainer/Inputs/StartChar")
onready var EndChar: VBoxContainer = get_node("MarginContainer/VBoxContainer/Inputs/EndChar")
onready var TextureID: VBoxContainer = get_node("MarginContainer/VBoxContainer/Inputs/TextureID")
onready var Cell: VBoxContainer = get_node("MarginContainer/VBoxContainer/Inputs/Cell")
onready var Confirm: ConfirmationDialog = get_node("MarginContainer/Confirm")
onready var AlertDialog: AcceptDialog = get_node("MarginContainer/AlertDialog")

var edited_font
var edited_font_path
var texture_count : int

func _enter_tree() -> void:
	if in_edit and Engine.editor_hint:
		show()

func _ready() -> void:
	if in_edit and not Engine.editor_hint:
		call_deferred('popup_centered_ratio')

func _on_CancelButton_pressed() -> void:
	queue_free()

func edit(font: BitmapFont, font_res_path: String, _texture_count: int):
	texture_count = _texture_count
	TextureCountLabel.text = "Textures Loaded: %d" % texture_count
	edited_font = font
	edited_font_path = font_res_path

func _on_ConfirmButton_pressed() -> void:
	var start : String = StartChar.value
	var end : String = EndChar.value
	
	# missing characters
	if start.empty():
		AlertDialog.dialog_text = "No start character specified."
		AlertDialog.popup_centered()
		return
	if end.empty():
		AlertDialog.dialog_text = "No end character specified."
		AlertDialog.popup_centered()
		return
	
	# errors with range
	if ord(start) > ord(end):
		AlertDialog.dialog_text \
			= "Invalid range [%s, %s]: starting character is greater than end character."
		AlertDialog.popup_centered()
		return
	elif ord(start) == ord(end):
		AlertDialog.dialog_text \
			= "Invalid range [%s, %s]: starting and end characters are the same."
		AlertDialog.popup_centered()
		return
	
	# force cell vector to be positive
	if (Cell.value as Vector2).x < 0:
		Cell.value.x = 0
	if (Cell.value as Vector2).y < 0:
		Cell.value.y = 0
	
	if true:
		var text := "Inserting characters %s-%s beginning from cell %s. Texture index is %d. Is all this correct?"
		Confirm.dialog_text = text % [StartChar.value, EndChar.value, Cell.value, TextureID.value]
	Confirm.popup_centered(Vector2(475, 150))

func _insert_characters() -> void:
	var start : String = StartChar.value
	var texid : int = TextureID.value
	
	# get the start and ending cells
	var cells := PoolVector2Array()
	var start_cell : Vector2 = Cell.value
	if true:
		# make list of cells
		var end : String = EndChar.value
		var hframes : int = (edited_font as BitmapFont).get_meta('hframes')[texid]
		var end_cell := start_cell
		for i in range(ord(end) - ord(start) + 1):
			if int(end_cell.x) == hframes:
				end_cell.x = 0
				end_cell.y += 1
			cells.push_back(end_cell)
			BFCHelpers.debug_print("Cell %s: %s" % [end_cell, char(ord(start) + i)])
			end_cell.x += 1
		BFCHelpers.debug_print("%s %s to %s %s, cell size: %s"
			% [start, start_cell, end, end_cell, BFCHelpers.get_cell_size(edited_font, texid)])
	
	# add characters to font
	if true:
		var cell_size : Vector2 = BFCHelpers.get_cell_size(edited_font, texid)
		var char_mappings : Dictionary = edited_font.get_meta('char_mappings')
		for i in cells.size():
			var ch : int = ord(start) + i
			(edited_font as BitmapFont).add_char(ch, texid,
				Rect2(cells[i] * cell_size, cell_size))
			char_mappings[char(ch)] = {
				cell = cells[i],
				texture = texid
			}
		(edited_font as BitmapFont).set_meta('char_mappings', char_mappings)

	ResourceSaver.save(edited_font_path, edited_font)
	BFCHelpers.debug_print("Saved %s to '%s'" % [edited_font, edited_font_path])
	
	queue_free()
