extends RigidBody3D

var shoot = false

const DAMAGE = 50
const SPEED = 20

func _ready():
	set_as_top_level(true)

func _physics_process(delta):
	if shoot:
		apply_impulse(-transform.basis.z * SPEED, transform.basis.z)

@rpc("any_peer")
func _on_area_3d_body_entered(body):
	if body.is_in_group("Enemy"):
		print("Hit")
		body.damage += DAMAGE
		body.damageChanged.emit(body.damage)
		queue_free()
	else:
		queue_free()
