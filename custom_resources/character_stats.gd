class_name CharacterStats
extends Stats

@export var job: String
@export var max_mana: int

@export_category("Dash Stats")
@export var dash_speed = 375
@export var dash_duration = 0.275
@export var dash_delay = 0.4
@export var is_dashing = false
@export var can_dash = true
@export var attacking = false
@export var is_wall_sliding = false

var mana: int: set = set_mana

func set_mana(value: int) -> void:
	mana = value
	stats_changed.emit()
	
func restore_mana(value: int) -> void:
	self.mana += value
	stats_changed.emit()
	
func take_damage(damage: int) -> void:
	var initial_health := health
	super.take_damage(damage)
	if initial_health > health:
		Events.player_hit.emit()
		
#func can_use_skill(skill: Skill) -> bool:
	#pass

func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.mana = max_mana
	return instance
