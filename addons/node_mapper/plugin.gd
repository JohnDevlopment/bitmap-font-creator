tool
extends EditorPlugin

const PLUGIN_NAME: String = "NodeMapper"


func enable_plugin():
	add_autoload_singleton(PLUGIN_NAME, "res://addons/node_mapper/NodeMapper.gd")
	print(PLUGIN_NAME, " enabled.")
	pass


func disable_plugin():
	remove_autoload_singleton(PLUGIN_NAME)
	print(PLUGIN_NAME, " disabled.")
