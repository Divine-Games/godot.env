extends EditorImportPlugin

enum Presets { DEFAULT }

func _get_importer_name():
	return "env_importer"

func _get_visible_name():
	return "ENV"

func _get_recognized_extensions():
	return ["env"]

func _get_save_extension():
	return ".env"

func _get_resource_type():
	return "TextFile"

func _get_preset_count():
	return Presets.size()

func _get_preset_name(preset_index):
	match preset_index:
		Presets.DEFAULT:
			return "Default"
		_:
			return "Unknown"

func _get_import_options(path, preset_index):
	match preset_index:
		Presets.DEFAULT:
			return []
		_:
			return []

func _get_option_visibility(path, option_name, options):
	return true

func _import(source_file, save_path, options, r_platform_variants, r_gen_files):
	var file = FileAccess.open(source_file, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()
	
	var content = file.get_as_text()
	file.close()
	
	var save_file = FileAccess.open("%s.%s" % [save_path, _get_save_extension()], FileAccess.WRITE)
	if save_file == null:
		return "Failed to create the file."
	
	save_file.store_string(content)
	save_file.close()
	
	return OK

func _get_import_order():
	return 1
