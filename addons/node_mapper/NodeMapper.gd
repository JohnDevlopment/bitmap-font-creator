extends Node

const VERSION: String = "1.0"


func map_children(host: Node, node: Node, vars: Dictionary) -> void:
	for child_node in node.get_children():
		var var_name = child_node.name
		if (var_name[0] == '$'): var_name = var_name.substr(1)
		else: map_children(host, child_node, vars)
		if (var_name in host):
			if (vars.has(var_name)):
				push_error("Var for " + str(child_node.get_path()) + 
					" already assigned to " + str(vars[var_name].get_path()))
				continue
			vars[var_name] = child_node
			host.set(var_name, child_node)


func map_nodes(host: Node) -> Dictionary:
	var variables : Dictionary
	map_children(host, host, variables)
	return variables


func export_vars(path: String, host: Node, vars: Dictionary = {}) -> void:
	var file: File = File.new()
	if (file.open(path, File.WRITE) != OK):
		push_error('Error exporting variables to "' + path + '"')
		return
	if (!vars): vars = map_nodes(host)
	var host_path = str(host.get_path())
	file.store_line("extends " + host.get_class())
	file.store_line("")
	for var_name in vars:
		var node = vars[var_name]
		var node_type = node.get_class()
		var node_path = str(node.get_path())
		if (node_path.begins_with(host_path)):
			node_path = node_path.substr(host_path.length() + 1)
		file.store_line("onready var " + var_name + ": " + node_type +
			' = get_node("' + node_path + '")')
	file.close()
