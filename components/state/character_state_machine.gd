class_name CharacterStateMachine
extends Node

@export var current_state: State
@export var character: CharacterBody2D
@export var animator: AnimationTree

var states: Array[State]

func _ready() -> void:
	for child in get_children():
		if child is State:
			states.append(child)
			
			child.character = character
			child.playback = animator["parameters/playback"]
		else:
			push_warning("Child" + child.name + " is not a state.")
			
func _physics_process(delta: float) -> void:
	if current_state.next_state != null:
		switch_states(current_state.next_state)
		
	current_state.state_process(delta)
	
func check_if_can_move() -> bool:
	return current_state.can_move
	
func switch_states(new_state: State) -> void:
	if current_state != null:
		current_state.on_exit()
		current_state.next_state = null
		
	current_state = new_state
	
	current_state.on_enter()
	
func _input(event: InputEvent) -> void:
	current_state.state_input(event)
