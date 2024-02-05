class_name AirState
extends State

@export var landing_state: LandingState
@export var wall_slide_state: WallSlideState
@export var wall_grab_state: WallGrabState
@export var falling_animation: String = "fall"

var has_double_jumped: bool = false

func state_process(delta) -> void:
	if character.is_on_floor():
		next_state = landing_state
		
	if character.ledge_grab and character.is_on_wall():
		next_state = wall_grab_state
	
	if character.is_on_wall() and !character.ledge_grab and character.velocity.y >= 0:
		next_state = wall_slide_state
		
	if character.velocity.y >= 0:
		playback.travel("fall")

func state_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and !has_double_jumped:
		double_jump()
	
func on_exit() -> void:
	if next_state == landing_state:
		playback.travel("landing")
	
	has_double_jumped = false
		
func double_jump() -> void:
	character.velocity.y = -character.stats.jump_force
	playback.start("jump")
	has_double_jumped = true
	
