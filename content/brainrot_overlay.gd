extends Control

const MOD_ID := "ZackeryRSmith-Brainrot"
const LOG_NAME := "ZackeryRSmith-Brainrot:Main"
var mod_dir_path := ModLoaderMod.get_unpacked_dir().path_join(MOD_ID)

@onready var texture_rect = %TextureRect
@onready var audio_player = %AudioStreamPlayer
@onready var anim_player = %AnimationPlayer
@onready var hold_timer = %HoldTimer
@onready var random_interval_timer = %RandomIntervalTimer

var allowed_to_play: bool = false

func _ready() -> void:
	var mod = get_node("/root/ModLoader/" + MOD_ID)
	if not is_instance_valid(mod):
		return

	mod.play_meme.connect(play)
	mod.start_playing.connect(func():
		allowed_to_play = true
		visible = true
	)
	mod.stop_playing.connect(func():
		allowed_to_play = false
		visible = false
	)

func _on_hold_timer_timeout() -> void:
	anim_player.play("fade_out")

func play(hold_time: float = 1.5) -> void:
	if not allowed_to_play:
		return

	var texture: CompressedTexture2D = _get_random_image()
	if !is_instance_valid(texture):
		return

	texture_rect.texture = texture
	texture_rect.position = _get_random_position(texture)
	anim_player.play("fade_in")
	
	var sound = _get_random_sound()
	if sound:
		audio_player.stream = sound
		audio_player.play()

	hold_timer.start(hold_time)

func _get_random_image() -> CompressedTexture2D:
	var images_dir_path := mod_dir_path.path_join("content/images")

	var dir := DirAccess.open(images_dir_path)
	var file_names: PackedStringArray = dir.get_files()
	var resources: Array[String] = []
	for file_name in file_names:
		if file_name.ends_with(".import"):
			continue
		resources.append(file_name)

	return load(images_dir_path.path_join(resources.pick_random()))

func _get_random_sound() -> AudioStream:
	var sounds_dir_path = mod_dir_path.path_join("content/audio")
	var dir = DirAccess.open(sounds_dir_path)
	if not is_instance_valid(dir):
		ModLoaderLog.error("Could not open audio directory: %s" % sounds_dir_path, LOG_NAME)
		return null

	var file_names: PackedStringArray = dir.get_files()
	var sounds: Array[String] = []
	for file_name in file_names:
		if not file_name.ends_with(".import"):
			if file_name.get_extension() in ["ogg", "wav", "mp3"]:
				sounds.append(file_name)

	if sounds.is_empty():
		ModLoaderLog.warning("No sound files found.", LOG_NAME)
		return null

	var chosen_file = sounds.pick_random()
	var full_path = sounds_dir_path.path_join(chosen_file)
	return load(full_path)

func _get_random_position(texture: CompressedTexture2D) -> Vector2:
	var image_size = texture.get_size()
	var screen_size = get_viewport_rect().size

	# Scale down if needed
	var scale_factor = min(screen_size.x / image_size.x, screen_size.y / image_size.y, 1.0)
	var final_size = image_size * scale_factor

	# Return a random position that keeps it fully on screen
	return Vector2(
		randf_range(0, screen_size.x - final_size.x),
		randf_range(0, screen_size.y - final_size.y)
	)


func _on_random_interval_timer_timeout() -> void:
	play()
	var next_time = randf_range(2.0, 5.0)  # random time between 1s and 5s
	random_interval_timer.start(next_time)
