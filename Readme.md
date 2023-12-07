# DotENV Plugin for Godot

## Overview
The DotENV plugin for Godot provides a robust and convenient way to manage environment variables in your Godot projects. This GDScript-based tool allows for the structured and secure handling of configurations via `.env` files, making it an essential utility for both development and production environments in Godot.

## Features
- **Load Environment Variables**: Easily load variables from `.env` files.
- **Support for Multiple Files**: Ability to handle multiple `.env` files for different environments.
- **Refresh Variables**: Quickly refresh environment variables from the currently loaded `.env` file.
- **Access and Modify Variables**: Retrieve, check, and set environment variables during runtime.
- **Signals**: Emit signals when environment variables are loaded or cleared.
- **Robust Parsing**: Handles comments and line concatenation in `.env` files.

## Installation
1. Place the `godot.env` folder in your project's `addons/` directory.
2. In the Godot editor, go to `Project` > `Project Settings` > `Plugins`.
3. Find `DotENV` in the list and click on the `Enable` checkbox.

## Usage
### Initialization
```gdscript
var dotenv = DotENV.new()
```
Optionally, specify a custom path for the `.env` file during initialization:
```gdscript
var dotenv = DotENV.new("path/to/your/.env")
```

### Loading Environment Variables
Load variables from the default or specified `.env` file:
```gdscript
dotenv.f_loadEnv()
```
For multiple files:
```gdscript
dotenv.f_loadEnvs([".env", "another.env"])
```

### Accessing Variables
Retrieve a variable's value:
```gdscript
var value = dotenv.f_getEnv("VARIABLE_NAME")
```
Check if a variable exists:
```gdscript
var exists = dotenv.f_hasEnv("VARIABLE_NAME")
```

### Modifying Variables
Set a new or existing variable:
```gdscript
dotenv.f_setEnv("VARIABLE_NAME", "value")
```

### Refreshing Variables
Refresh variables from the currently loaded `.env` file:
```gdscript
dotenv.f_refreshEnv()
```

### Clearing Variables
Clear all loaded variables:
```gdscript
dotenv.f_clearEnv()
```

## Signals
- `s_env_loaded`: Emitted when an `.env` file is loaded.
- `s_env_cleared`: Emitted when the environment is cleared.

## Compatibility
- Godot 3.x

## License
This plugin is distributed under the [MIT license](LICENSE.md).

---

**Note**: This plugin is marked as experimental. As with any configuration management tool, it's important to use it wisely, especially in production environments.