extends RigidBody3D
class_name Fuel

const CLANK_SOUND_IMPULSE_THRESHOLD = 10.0
const CLANK_SOUND_COOLDOWN = 0.1

var parent_generator: FuelGenerator = null
var carrier: FactoryPlayer = null
var being_carried: bool = false
var is_dangerous: bool = false # check for if a fuel cell can stun a player

var clank_sound_timer = 0.0


func _ready():
	set_contact_monitor(true)
	max_contacts_reported = 8


func _physics_process(delta: float) -> void:
	clank_sound_timer = move_toward(clank_sound_timer, 0.0, delta)


func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if clank_sound_timer != 0.0:
		return
	
	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)
		if collider:
			var impulse = state.get_contact_impulse(i).length()
			if impulse >= CLANK_SOUND_IMPULSE_THRESHOLD:
				var impulse_clamped = clamp(impulse, CLANK_SOUND_IMPULSE_THRESHOLD, 50.0)
				$SFX/Clank.pitch_scale = remap(impulse, CLANK_SOUND_IMPULSE_THRESHOLD, 50.0, 0.75, 1.5)
				$SFX/Clank.play()
				clank_sound_timer = CLANK_SOUND_COOLDOWN
				break
