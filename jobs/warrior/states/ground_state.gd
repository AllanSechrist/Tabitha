class_name GroundState
extends State

@export var air_state: AirState
@export var attack_state: AttackState
@export var dash_state: DashState
@export var attack_animation: String = "attack"
@export var jump_animation: String = "jump"
@export var dash_animation: String = "dash_start"

func state_process(delta):
	if !character.is_on_floor():
		next_state = air_state
		
func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump()
	elif event.is_action_pressed("attack"):
		attack()
	elif event.is_action_pressed("dash") and character.stats.can_dash and !character.stats.is_dashing:
		dash()
		
func jump() -> void:
	character.velocity.y = -character.stats.jump_force
	next_state = air_state
	playback.travel(jump_animation)

func attack() -> void:
	next_state = attack_state
	playback.travel(attack_animation)
	
func dash() -> void:
	next_state = dash_state
	playback.travel(dash_animation)

#func on_exit() -> void:
	#if next_state == attack_state:
		#playback.travel(attack_animation)
