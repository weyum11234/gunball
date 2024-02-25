extends Node3D

@onready var animPlayer = $AnimationPlayer
@onready var sound = $Shot

func _ready():
	pass

@rpc("call_local")
func Shoot():
	if animPlayer.is_playing():
		pass
	else:
		animPlayer.play("Kick")
		sound.set_pitch_scale(randf_range(0.7, 0.9))
