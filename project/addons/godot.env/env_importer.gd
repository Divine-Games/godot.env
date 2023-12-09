extends EditorImportPlugin

enum Presets { DEFAULT }

signal compiled_resource(resource: Resource)

func _get_importer_name():
	return "env_importer"

func _get_visible_name():
	return "ENV"

func _get_recognized_extensions():
	return ["env"]

func _get_save_extension():
	return "env"

func _get_resource_type():
	return "Resource"

func _get_preset_count():
	return Presets.size()

func _get_preset_name(preset_index):
	match preset_index:
		Presets.DEFAULT:
			return "Default"
		_:
			return "Unknown"

func _get_import_options(path, preset_index):
	return []

func _get_option_visibility(path, option_name, options):
	return true

func _import(source_file, save_path, options, r_platform_variants, r_gen_files):
	return OK

func _get_import_order() -> int:
	return -1000

func _get_priority() -> float:
	return 1000
