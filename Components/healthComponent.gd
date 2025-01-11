extends Node2D
class_name healthComponent

# creates both the max health changing variable and the health variable
@export var max_health: int = 4
var health: int

# sets the health to the maximum value
func _ready():
	health = max_health

# allows for damage to be taken
func damage(attack: Attack):
	health -= attack.attackDamage
	
	if health <= 0:
		get_parent().queue_free()
