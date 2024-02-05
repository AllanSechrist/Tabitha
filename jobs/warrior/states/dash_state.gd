class_name DashState
extends State

@export var ground_state: GroundState
@onready var duration_timer: Timer = $DurationTimer

#var attacking: bool = false

func on_enter():
	Events.player_dashing.emit()
	duration_timer.wait_time = character.stats.dash_duration
	duration_timer.start()
	
func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		Events.player_attacking.emit()
		dash_attack()
	
func dash_attack() -> void:
	character.stats.attacking = true
	playback.travel("dash_attack")
	
func on_exit() -> void:
	if character.stats.attacking:
		Events.player_attack_finished.emit()
	elif next_state == ground_state:
		playback.travel("dash_end")

func _on_duration_timer_timeout() -> void:
	Events.player_dash_finished.emit()
	next_state = ground_state
	
