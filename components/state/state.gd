class_name State
extends Node

@export var can_move: bool = true

var character: CharacterBody2D
var playback: AnimationNodeStateMachinePlayback
var next_state: State

# -------- VIRTUAL FUNCTIONS --------
func state_process(delta: float) -> void:
	pass
	
func state_input(event: InputEvent) -> void:
	pass
	
func on_enter():
	pass
	
func on_exit():
	pass
