class_name DotENV extends Node
## [b][color=#34ebde]Class Description:[/color][/b]
## [codeblock]
## The DotENV class is designed for handling the loading and parsing of .env files in Godot projects.
## It provides functionality to read environment variables from .env files, allowing for a
## structured and secure way to manage configurations. The class supports reading single or multiple .env files,
## refreshing environment variables, and accessing or modifying these variables during runtime.
## It also includes signal emissions for loaded and cleared environment variables, aiding in
## synchronizing environment-dependent processes. This class is marked as experimental and is intended
## for use in Godot projects where environmental configuration management is necessary.
## [/codeblock]
## [b][color=#e1eb34]Public Methods:[/color][/b]
## [codeblock]
## - f_loadEnv: Loads environment variables from a specified .env file.
## - f_loadEnvs: Loads multiple .env files.
## - f_clearEnv: Clears all loaded environment variables.
## - f_refreshEnv: Refreshes environment variables from the currently set .env file.
## - f_getEnv: Retrieves the value of an environment variable.
## - f_hasEnv: Checks if an environment variable exists.
## - f_setEnv: Sets the value of an environment variable.
## [/codeblock]
## [b][color=#42f55d]Signals:[/color][/b]
## [codeblock]
## - s_env_loaded: Emitted when an environment file has been loaded.
## - s_env_cleared: Emitted when the environment has been cleared using f_clearEnv.
## [/codeblock]
## @experimental

## When a env file has been loaded it is loaded here, with the file_path passed.
signal s_env_loaded(env_file)

## This is to help notify when f_clearEnv() has been triggered.
signal s_env_cleared()

## This is to store a copy of the loaded .env's variables.
var v_env: Dictionary = {}

## This is to keep a record of the loaded path.
## NOTE: Does not take into account for the multiple loading of envs only the initial env.
var v_env_file_path: String

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Initializes the DotENV class, sets up the environment file path, reads the file,
## parses its contents, and emits a signal indicating the environment file has been loaded.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## file_path: String : Path or filename of the .env file to be loaded.
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## None
## [/codeblock]
func _init(file_path: String = ".env") -> void:
	var env_path = f_getEnvFilePath(file_path)
	if env_path == "":
		print("Invalid File (%s) path not found." % env_path)
		return
	v_env_file_path = env_path
	var env_data = f_readFile(v_env_file_path)
	if env_data == "":
		print("Invalid File (%s) contained no data," % v_env_file_path)
		return
	f_parseEnv(env_data)
	emit_signal("s_env_loaded", v_env_file_path)

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Loads environment variables from a specified .env file, parses the file, and emits a signal
## indicating the environment file has been loaded.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## file_path: String : Path or filename of the .env file to be loaded.
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## None
## [/codeblock]
func f_loadEnv(file_path: String = ".env") -> void:
	var env_path = f_getEnvFilePath(file_path)
	if env_path == "":
		print("Invalid File (%s) path not found." % env_path)
		return
	v_env_file_path = env_path
	var env_data = f_readFile(v_env_file_path)
	if env_data == "":
		print("Invalid File (%s) contained no data," % v_env_file_path)
		return
	f_parseEnv(env_data)
	emit_signal("s_env_loaded", v_env_file_path)

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Loads multiple .env files specified in an array and parses each file sequentially.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## file_paths: Array : Array of file paths or filenames of .env files to be loaded.
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## None
## [/codeblock]
func f_loadEnvs(file_paths: Array) -> void:
	for file_path in file_paths:
		f_loadEnv(file_path)

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Clears all loaded environment variables and emits a signal indicating the environment has been cleared.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## None
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## None
## [/codeblock]
func f_clearEnv() -> void:
	v_env = {}
	emit_signal("s_env_cleared")

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Refreshes the environment variables from the currently set .env file path.
## Emits a signal indicating the environment file has been reloaded.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## None
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## None
## [/codeblock]
func f_refreshEnv() -> void:
	if v_env_file_path == "":
		print("Unable to get ENV do .loadEnv() you can include a filename or filepath")
		return
	if !f_fileExist(v_env_file_path):
		print("Unable to Refresh Env, Invalid File (%s) path not found." % v_env_file_path)
		return
	var env_data = f_readFile(v_env_file_path)
	if env_data == "":
		print("Invalid File (%s) contained no data," % v_env_file_path)
		return
	f_parseEnv(env_data)
	emit_signal("s_env_loaded", v_env_file_path)

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Determines the full path of the .env file based on the provided file path.
## Supports both resource paths and absolute paths.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## file_path: String : The path or filename of the .env file.
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## env_path: String : The full path of the .env file.
## [/codeblock]
func f_getEnvFilePath(file_path: String) -> String:
	if !file_path.begins_with("res://"):
		var env_path: String = ""
		if file_path.contains("//"):
			env_path = file_path
		else:
			var executable_path = OS.get_executable_path().get_base_dir()
			env_path = "%s/%s" % [executable_path, file_path]
		if !f_fileExist(env_path):
			print("Invalid File (%s) path not found." % env_path)
			return ""
		return env_path
	else:
		if !f_fileExist(file_path):
			print("Invalid File (%s) path not found." % file_path)
			return ""
		return file_path
	return ""

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Retrieves the value of an environment variable. Checks both the OS environment
## and the script's internal dictionary.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## name: String : The name of the environment variable to retrieve.
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## value: String : The value of the specified environment variable.
## [/codeblock]
func f_getEnv(name) -> String:
	if OS.has_environment(name):
		return OS.get_environment(name)
	if v_env.has(name):
		return v_env[name]
	return ""

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Checks if an environment variable exists in either the OS environment or the script's internal dictionary.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## name: String : The name of the environment variable to check.
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## exists: bool : True if the variable exists, false otherwise.
## [/codeblock]
func f_hasEnv(name) -> bool:
	if OS.has_environment(name):
		return true
	if v_env.has(name):
		return true
	return false

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Sets the value of an environment variable in both the script's internal dictionary and the OS environment.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## key: String : The name of the environment variable to set.
## value: String : The value to assign to the environment variable.
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## None
## [/codeblock]
func f_setEnv(key, value) -> void:
	v_env[key] = value
	OS.set_environment(key, value)

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Reads the contents of a file at the given file path and returns it as a string.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## file_path: String : The path of the file to be read.
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## content: String : The contents of the file as a string.
## [/codeblock]
func f_readFile(file_path: String) -> String:
	var file =  FileAccess.open(file_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Parses the contents of a .env file, extracting key-value pairs and setting them in the script's dictionary
## and the OS environment.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## file_contents: String : The contents of the .env file to be parsed.
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## None
## [/codeblock]
func f_parseEnv(file_contents: String) -> void:
	var env_data = file_contents.split("\n")
	var concatenated_line = ""
	for line in env_data:
		line = line.strip_edges()
		if line == "" or line.begins_with("#"):
			continue

		if line.ends_with("\\"):
			concatenated_line += line.substr(0, line.length() - 1).strip_edges()
			continue
		else:
			concatenated_line += line
			line = concatenated_line
			concatenated_line = ""

		var key_value = line.split("=", false, 1)
		if key_value.size() == 2:
			var key = key_value[0].strip_edges()
			var value = f_parseValue(key_value[1])
			v_env[key] = value
			OS.set_environment(key, value)

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Parses a value from the .env file, handling quoted values and escape sequences.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## value: String : The value to be parsed.
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## parsed_value: String : The parsed value.
## [/codeblock]
func f_parseValue(value: String) -> String:
	value = value.strip_edges()
	if value.begins_with("\"") and value.ends_with("\""):
		return f_parseQuotedValue(value)
	return value

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Parses a quoted value from the .env file, handling escape sequences within the quotes.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## value: String : The quoted value to be parsed.
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## result: String : The parsed value with escape sequences handled.
## [/codeblock]
func f_parseQuotedValue(value: String) -> String:
	value = value.substr(1, value.length() - 2) # Remove the surrounding quotes
	var escaped = false
	var result = ""
	for i in range(value.length()):
		var char = value[i]
		if escaped:
			if char in ["n", "r", "\"", "\\"]:
				match char:
					"n": result += "\n"
					"r": result += "\r"
					"\\": result += "\\"
					"\"": result += "\""
			else:
				result += "\\" + char
			escaped = false
		else:
			if char == "\\":
				escaped = true
			else:
				result += char
	return result

## [b][color=#34ebde]Description:[/color][/b]
## [codeblock]
## Checks if a file exists at the given file path.
## [/codeblock]
## [b][color=#e1eb34]Input Variables:[/color][/b]
## [codeblock]
## file_path: String : The path of the file to check.
## [/codeblock]
## [b][color=#42f55d]Output Variables:[/color][/b]
## [codeblock]
## exists: bool : True if the file exists, false otherwise.
## [/codeblock]
func f_fileExist(file_path: String) -> bool:
	if !FileAccess.file_exists(file_path):
		return false
	return true
