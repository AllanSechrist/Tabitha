class_name WallSlideState
extends State

@export var landing_state: LandingState
@export var air_state: AirState
@export var wall_grab_state: WallGrabState


func state_process(delta):
	if character.is_on_floor():
		next_state = landing_state
	if !character.is_on_floor() and !character.is_on_wall():
		next_state = air_state
		
	if character.ledge_grab and character.is_on_wall():
		next_state = wall_grab_state

func on_enter():
	Events.player_wall_slide.emit()
	playback.travel("wall_slide")

func on_exit() -> void:
	if next_state == landing_state:
		playback.travel("landing")
	Events.player_wall_slide_finished.emit()
