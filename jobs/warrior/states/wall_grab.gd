class_name WallGrabState
extends State

@export var air_state: AirState
@export var wall_slide_state: WallSlideState
@export var jump_animation: String = "jump"


func on_enter():
	playback.travel("wall_grab_start")

func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump()
	if event.is_action_pressed("down"):
		drop()

func jump() -> void:
	Events.player_wall_grab_finished.emit()
	character.velocity.y = -character.stats.jump_force
	next_state = air_state
	playback.travel(jump_animation)
	
func drop() -> void:
	Events.player_wall_grab_finished.emit()
	next_state = air_state
	playback.travel("fall")
	
