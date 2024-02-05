class_name LandingState
extends State

@export var landing_animation: String = "landing"
@export var ground_state: GroundState

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == landing_animation:
		next_state = ground_state
