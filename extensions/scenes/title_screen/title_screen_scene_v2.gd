extends "res://scenes/title_screen/title_screen_scene_v2.gd"

const MOD_ID = "ZackeryRSmith-VineBoom"
const LOG_NAME = "ZackeryRSmith-VineBoom:TitleScreen"

var mod_node = null

func _ready() -> void:
	var node = get_node("/root/ModLoader/" + MOD_ID)
	if not is_instance_valid(node):
		return
	mod_node = node
	
	node.stop_playing.emit()
	super()

func _start_playing():
	if is_instance_valid(mod_node):
		mod_node.start_playing.emit()

func start_game() -> void:
	_start_playing()
	super()

func start_hardmode() -> void :
	_start_playing()
	super()

func start_challenge_mode() -> void:
	_start_playing()
	super()
