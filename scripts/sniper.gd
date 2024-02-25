extends Node3D

@onready var animPlayer = $AnimationPlayer
@onready var sound = $Shot

func _ready():
	pass
	
func Shoot():
	if animPlayer.is_playing():
		pass
	else:
		animPlayer.play("Kick")
