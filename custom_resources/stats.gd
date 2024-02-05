class_name Stats
extends Resource

signal stats_changed



@export_category("Combat Stats")
@export var max_health := 1
@export var attack := 1
@export var defence := 1

@export var move_speed := 1
@export var move_speed_reduction := 1.0
@export var wall_slide_gravity := 100
@export var gravity := 200
@export var jump_force := 130

var health: int : set = set_health

func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	stats_changed.emit()
	
func take_damage(damage: int) -> void:
	if damage <= 0:
		return
	self.health -= damage
	
func heal(amount: int) -> void:
	self.health += amount
	
func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	return instance
