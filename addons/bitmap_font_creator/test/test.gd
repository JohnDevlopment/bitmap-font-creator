extends Control

const PATH := 'user://font.tres'

var font : BitmapFont

func _ready() -> void:
	if not ResourceLoader.exists(PATH):
		print("Create %s" % PATH)
		create_font(PATH)
	font = load(PATH)
	$Dialog.edit(font)

func _exit_tree() -> void:
	$Dialog.save()

func create_font(path) -> void:
	font = BitmapFont.new()
	font.ascent = 12
	font.height = 16
	ResourceSaver.save(path, font)
