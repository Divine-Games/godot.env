@tool
extends EditorPlugin

var import_plugin: EditorImportPlugin = preload("res://addons/godot.env/env_importer.gd").new()

func _enter_tree():
#	if FileAccess.file_exists(ProjectSettings.globalize_path("res://") + "addons/godot.env/src/.gdignore"):
#		DirAccess.remove_absolute(ProjectSettings.globalize_path("res://") + "addons/godot.env/src/.gdignore")
	add_import_plugin(import_plugin)

func _exit_tree():
#	FileAccess.open("res://addons/godot.env/src/.gdignore",FileAccess.WRITE)
	remove_import_plugin(import_plugin)
	print("Godot.ENV got disabled. To fully disable it restart the editor.")

func _get_plugin_name():
	return "Godot.ENV"
