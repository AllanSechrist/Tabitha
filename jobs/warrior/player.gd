extends CharacterBody2D

@export var stats: CharacterStats

@onready var sprite: Sprite2D = $Sprite2D
@onready var animator: AnimationTree = $AnimationTree
@onready var state_machine: CharacterStateMachine = $CharacterStateMachine
@onready var top_ledge_grab_cast: RayCast2D = $TopLedgeGrabCast
@onready var bottom_ledge_grab_cast: RayCast2D = $BottomLedgeGrabCast

var direction : Vector2 = Vector2.ZERO
var speed: int
var gravity_force: int
var ledge_grab := false

func _ready() -> void:
	animator.active = true
	#DEBUG
	stats.stats_changed.connect(_on_stats_changed)
	#END DEBUG
	Events.player_attacking.connect(_on_attack)
	Events.player_attack_finished.connect(_on_attack_finished)
	Events.player_dashing.connect(_on_dash)
	Events.player_dash_finished.connect(_on_dash_finished)
	Events.player_wall_slide.connect(_on_wall_slide)
	Events.player_wall_slide_finished.connect(_on_wall_slide_finished)
	Events.player_wall_grab_finished.connect(_on_wall_grab_finished)
	
func _physics_process(delta: float) -> void:
	check_for_ledge_grab()
	apply_gravity(delta)
	direction = Input.get_vector("left", "right", "up", "down")
	
	if stats.is_dashing:
		speed = stats.dash_speed
	else:
		speed = stats.move_speed if !stats.attacking else stats.move_speed * stats.move_speed_reduction
	
	if direction.x != 0 and state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	

	move_and_slide()
	play_moving_animation()	
	update_facing_direction()

func apply_gravity(delta) -> void:
	if not is_on_floor():
		if !stats.is_wall_sliding:
			gravity_force = stats.gravity
		else:
			gravity_force = stats.wall_slide_gravity
			
		if ledge_grab:
			velocity.y = 0
		else:
			velocity.y = move_toward(velocity.y, 400, gravity_force * delta)

func check_for_ledge_grab() -> void:
	if !top_ledge_grab_cast.is_colliding() and bottom_ledge_grab_cast.is_colliding():
		ledge_grab = true
	else:
		ledge_grab = false
# ---------- ANIMATIONS --------

func play_moving_animation() -> void:
	animator.set("parameters/move/blend_position", direction.x)
	
func update_facing_direction():
	if direction.x > 0:
		sprite.flip_h = false
		sprite.offset.x = 0
	elif direction.x < 0:
		sprite.flip_h = true
		sprite.offset.x = -16
# --------- END ANIMATIONS -----------


func _on_attack() -> void:
	stats.attacking = true
	
func _on_attack_finished() -> void:
	stats.attacking = false
	
func _on_dash() -> void:
	stats.is_dashing = true
	stats.can_dash = false
	
func _on_dash_finished() -> void:
	stats.is_dashing = false
	await get_tree().create_timer(stats.dash_delay).timeout
	stats.can_dash = true
# DEBUG

func _on_wall_slide() -> void:
	velocity.y = 0
	stats.is_wall_sliding = true
	
func _on_wall_slide_finished() -> void:
	stats.is_wall_sliding = false
	
func _on_wall_grab_finished() -> void:
	ledge_grab = false
	top_ledge_grab_cast.enabled = false
	bottom_ledge_grab_cast.enabled = false
	await get_tree().create_timer(0.5).timeout
	top_ledge_grab_cast.enabled = true
	bottom_ledge_grab_cast.enabled = true

func _on_stats_changed() -> void:
	print(stats.health)
# END DEBUG
func _on_hurt_box_hurt(hitbox: Variant, damage: Variant) -> void:
	stats.take_damage(damage)
