class_name AttackState
extends State

@export var ground_state: GroundState
@export var dash_state: DashState
@export var attack_animation: String = "attack"

func on_enter():
	Events.player_attacking.emit()
	
func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("dash") and character.stats.can_dash:
		dash_cancel()
	
func dash_cancel() -> void:
	Events.player_attack_finished.emit()
	next_state = dash_state
	playback.travel("dash_start")
	
func on_exit():
	attack_animation = "attack"

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == attack_animation:
		Events.player_attack_finished.emit()
		next_state = ground_state
