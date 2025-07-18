extends Node

#region signals
signal start_playing
signal play_meme(hold_time: float)
signal stop_playing
#endregion

const MOD_DIR := "ZackeryRSmith-Brainrot"
const LOG_NAME := "ZackeryRSmith-Brainrot:Main"

var mod_dir_path := ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)
var extensions_dir_path = mod_dir_path.path_join("extensions")

func _init() -> void:
	ModLoaderMod.install_script_extension(
		extensions_dir_path.path_join("scenes/title_screen/title_screen_scene_v2.gd")
	)

func _ready() -> void:
	var overlay_path = mod_dir_path.path_join("content/brainrot_overlay.tscn")
	var overlay_instance: Control = load(overlay_path).instantiate()
	overlay_instance.process_mode = Node.PROCESS_MODE_ALWAYS

	get_tree().root.call_deferred("add_child", overlay_instance)
	ModLoaderLog.info("Ready!", LOG_NAME)
